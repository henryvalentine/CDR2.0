/* eslint-disable no-console */
// import "@Styles/main.css";
import * as React from "react";
import { Helmet } from "react-helmet";
import { withRouter } from "react-router";
import { fetchData, postQuery, uploadFile } from '../utils'
import { NavLink, Redirect } from "react-router-dom";
import * as SiteQueryStore from "@Store/SiteQueryStore";
import Loader from "@Components/shared/Loader";
import { connect } from "react-redux";
import { Table, Input, Button, Select, DatePicker, Tabs, Popconfirm, Upload, message, Form, Row, Col, Icon, Menu, Modal } from 'antd';
const { Option } = Select;
const { TabPane } = Tabs;
const { Item } = Form;
const { RangePicker } = DatePicker;

class SiteQuery extends React.Component 
{
    constructor(props)
    {
        super(props);
        this.state =
            {
                buttonText: 'Add',
                data: [],
                pagination:
                {
                    current: 1,
                    total: 0,
                    pageSize: 10,
                    sorter: {
                        field: "name",
                        order: "asc"
                    }
                },
                loading: false,
                txNewloading: false,
                vlLoading: false,
                confirmLoading: false,
                title: 'New Site',
                site: { Id: '', name: '', stateCode: '', lga: '', siteId: '', state: '' },
                searchText: "",
                visible: false,
                hideUpload: false,
                states: [],
                searchObj:
                {
                    from: '',
                    to: '',
                    siteId: '',
                    itemsPerPage: 0,
                    pageNumber: 0
                },
                viralLoads: [],
                txNew: [],
                txNewPagination:
                {
                    current: 1,
                    total: 0,
                    pageSize: 10,
                    sorter: {
                        field: "name",
                        order: "asc"
                    }
                },
                vlPagination:
                {
                    current: 1,
                    total: 0,
                    pageSize: 10,
                    sorter: {
                        field: "name",
                        order: "asc"
                    }
            }
            
        };         

        this.selectSite = this.selectSite.bind(this);
        this.handleChange = this.handleChange.bind(this);
        this.handleTableChange = this.handleTableChange.bind(this);
        this.handleTxNewTableChange = this.handleTxNewTableChange.bind(this);
        this.handleVLTableChange = this.handleVLTableChange.bind(this);
        this.getItems = this.getItems.bind(this);
        this.export = this.export.bind(this);
        this.filter = this.filter.bind(this);
        this.dateRangeChange = this.dateRangeChange.bind(this);
    }

    async componentDidMount()
    {
        let res = await fetchData('/api/Site/getAllSites');
        this.setState({ states: res });
    }

    dateRangeChange(date, dateString)
    {
        var searchObj = this.state.searchObj;
        if (dateString && dateString[0])
        {
            searchObj.from = dateString[0];
        }
        else
        {
            searchObj.from = '';
        }

        if (dateString && dateString[1])
        {
            searchObj.to = dateString[1];
        }
        else
        {
            searchObj.from = '';
        }

        this.setState({ searchObj })
    }

    filter()
    {
        const { pagination, searchObj } = this.state;
        this.getItems({
            results: pagination.pageSize,
            searchText: this.state.searchText,
            page: pagination.current,
            sortField: pagination.sorter.field,
            sortOrder: pagination.sorter.order,
            from: searchObj.from,
            to: searchObj.to,
            siteId: (searchObj.siteId === '' || !searchObj.siteId)? 0: searchObj.siteId
        });
    }
    
    handleTableChange(pagination, filters, sorter)
    {
        const pager = this.state.pagination;
        pager.current = pagination.current;

        this.setState({
            pagination: pager
        });
        this.getItems({
            results: pager.pageSize,
            searchText: this.state.searchText,
            page: pager.current,
            sortField: pager.sorter.field,
            sortOrder: pager.sorter.order
        });
    }  

    handleTxNewTableChange(pagination, filters, sorter)
    {
        const pager = this.state.txNewPagination;
        pager.current = pagination.current;

        this.setState({
            txNewPagination: pager
        });
        this.getItems({
            results: pager.pageSize,
            searchText: this.state.searchText,
            page: pager.current,
            sortField: pager.sorter.field,
            sortOrder: pager.sorter.order
        });
    }  

    handleVLTableChange(pagination, filters, sorter) {
        const pager = this.state.txNewPagination;
        pager.current = pagination.current;

        this.setState({
            txNewPagination: pager
        });
        this.getItems({
            results: pager.pageSize,
            searchText: this.state.searchText,
            page: pager.current,
            sortField: pager.sorter.field,
            sortOrder: pager.sorter.order
        });
    }  

    async getItems(params = {})
    {
        var searchText = params.searchText;
        var results = params.results;
        var page = params.page;
        let el = this;

        let payload =
        {
            from: params.from,
            to: params.to,
            itemsPerPage: results,
            pageNumber: page,
            siteId: params.siteId
        }
        let s = JSON.stringify(payload);
        this.setState({ loading: true });
       
        let res = await postQuery('/api/Stats/getTxCurrByPeriod', s);
        const { pagination } = el.state;
            pagination.total = res.totalItems;           
            el.setState({
                data: res.sites,
                pagination,
                loading: false 
            }); 

        const { txNewPagination, searchObj } = this.state;
        this.getTxNew({
            results: txNewPagination.pageSize,
            page: txNewPagination.current,
            from: searchObj.from,
            to: searchObj.to,
            siteId: (searchObj.siteId === '' || !searchObj.siteId) ? 0 : searchObj.siteId
        });
    }

    async getTxNew(params = {})
    {
        var searchText = params.searchText;
        var results = params.results;
        var page = params.page;

        let el = this;

        let payload =
        {
            from: params.from,
            to: params.to,
            itemsPerPage: results,
            pageNumber: page,
            siteId: params.siteId
        }

        let s = JSON.stringify(payload);
        this.setState({ txNewloading: true });
       
        let res = await postQuery('/api/Stats/getTxNewByPeriod', s);
        
        const { txNewPagination } = el.state;
        txNewPagination.total = res.totalItems;
        el.setState({
            txNew: res.sites,
            txNewPagination,
            txNewloading: false
        });

        const { vlPagination, searchObj } = this.state;
        this.getVL({
            results: vlPagination.pageSize,
            page: vlPagination.current,
            from: searchObj.from,
            to: searchObj.to,
            siteId: (searchObj.siteId === '' || !searchObj.siteId) ? 0 : searchObj.siteId
        });
        
    }

    async getVL(params = {}) {
        var searchText = params.searchText;
        var results = params.results;
        var page = params.page;

        let el = this;

        let payload =
        {
            from: params.from,
            to: params.to,
            itemsPerPage: results,
            pageNumber: page,
            siteId: params.siteId
        }
        
        let s = JSON.stringify(payload);
        this.setState({ vlLoading: true });

        let res = await postQuery('/api/Stats/getVLByPeriod', s);

        const { vlPagination } = el.state;
        vlPagination.total = res.totalItems;
        el.setState({
            viralLoads: res.sites,
            vlPagination,
            vlLoading: false
        });
    }

    handleChange(value) {
        const { pagination } = this.state;
        pagination.pageSize = parseInt(value);

        this.setState({
            pagination: pagination
        });
    }
                     
    async selectSite(feature, value)
    {
        var searchObj = this.state.searchObj;
        if (value)
        {
            let val = value.key;
            searchObj.siteId = val;
        }
        else
        {
            searchObj.siteId = '';
        }

        this.setState({ searchObj: searchObj })
    }

    async export()
    {
        this.setState({ confirmLoading: true });
        let res = await fetchData('/api/Site/exportSites');
        this.setState({ confirmLoading: false });  
        if (res.code < 1) 
        {
            alert(res.message);
        }
        else
        {
            console.log(res.asset);
            window.location = res.asset;
        }
    }

    render()
    {
        const columns =
            [
                {
                title: 'Site',
                dataIndex: 'name',
                key: 'name'
                // sorter: true
                },
                {
                    title: 'State Code',
                    dataIndex: 'stateCode',
                    key: 'stateCode'
                    // sorter: true
                },
                {
                    title: 'Clients Enroled on ART',
                    dataIndex: 'totalClients',
                    key: 'totalClients',
                    render: (value, row, index) => <span className="tb-span" key={row.id}>{String(value).replace(/(.)(?=(\d{3})+$)/g,'$1,')}</span>
                    // sorter: true
                },
                {
                    title: 'Tx_curr Target',
                    dataIndex: 'txCurr',
                    key: 'txCurr',
                    render: (value, row, index) => <span className="tb-span" key={row.id}>{String(value).replace(/(.)(?=(\d{3})+$)/g, '$1,')}</span>
                    // sorter: true
                },
                {
                    title: 'Tx_curr',
                    dataIndex: 'active',
                    key: 'active',
                    render: (value, row, index) => <span className="tb-span" key={row.id}>{String(value).replace(/(.)(?=(\d{3})+$)/g,'$1,')}</span>
                    // sorter: true
                },
                {
                    title: 'Difference',
                    dataIndex: 'difference',
                    key: 'difference',
                    render: (value, row, index) => <span className="tb-span" key={row.id}>{String(value).replace(/(.)(?=(\d{3})+$)/g, '$1,')}</span>
                    // sorter: true
                },
                {
                    title: 'Concurrence (%)',
                    dataIndex: 'concurrence',
                    key: 'concurrence',
                    render: (value, row, index) => <span className={`tb-span pp ${row.txCurr > 0 && (value >= 100)? 'db-b-g white-font': row.totalClients > 0 && (value < 100)?'db-b-r white-font' : ''}`} key={row.id}>{value}</span>
                },
                {
                    title: 'Fiscal Year',
                    dataIndex: 'fiscalYear',
                    key: 'fiscalYear'
                 }

            ];

        const txNewColumns =
            [
                {
                    title: 'Site',
                    dataIndex: 'name',
                    key: 'name'
                    // sorter: true
                },
                {
                    title: 'State Code',
                    dataIndex: 'stateCode',
                    key: 'stateCode'
                    // sorter: true
                },
                {
                    title: 'Clients Enroled on ART',
                    dataIndex: 'totalClients',
                    key: 'totalClients',
                    render: (value, row, index) => <span className="tb-span" key={row.id}>{String(value).replace(/(.)(?=(\d{3})+$)/g, '$1,')}</span>
                    // sorter: true
                },
                {
                    title: 'Tx_New Target',
                    dataIndex: 'txNewTarget',
                    key: 'txNewTarget',
                    render: (value, row, index) => <span className="tb-span" key={row.id}>{String(value).replace(/(.)(?=(\d{3})+$)/g, '$1,')}</span>
                    // sorter: true
                },
                {
                    title: 'Tx_New',
                    dataIndex: 'txNew',
                    key: 'txNew',
                    render: (value, row, index) => <span className="tb-span" key={row.id}>{String(value).replace(/(.)(?=(\d{3})+$)/g, '$1,')}</span>
                    // sorter: true
                },
                {
                    title: 'Difference',
                    dataIndex: 'difference',
                    key: 'difference',
                    render: (value, row, index) => <span className="tb-span" key={row.id}>{String(value).replace(/(.)(?=(\d{3})+$)/g, '$1,')}</span>
                    // sorter: true
                },
                {
                    title: 'Concurrence (%)',
                    dataIndex: 'concurrence',
                    key: 'concurrence',
                    render: (value, row, index) => <span className={`tb-span pp ${row.txNewTarget > 0 && (value >= 100) ? 'db-b-g white-font' : row.totalClients > 0 && (value < 100) ? 'db-b-r white-font' : ''}`} key={row.id}>{value}</span>
                },
                {
                    title: 'Fiscal Year',
                    dataIndex: 'fiscalYear',
                    key: 'fiscalYear'
                }

            ];

        const viralColumns =
            [
                {
                    title: 'Site',
                    dataIndex: 'name',
                    key: 'name'
                    // sorter: true
                },
                {
                    title: 'State Code',
                    dataIndex: 'stateCode',
                    key: 'stateCode'
                    // sorter: true
                },
                {
                    title: 'Active Clients',
                    dataIndex: 'active',
                    key: 'active',
                    render: (value, row, index) => <span className="tb-span" key={row.id}>{String(value).replace(/(.)(?=(\d{3})+$)/g, '$1,')}</span>
                    // sorter: true
                },
                {
                    title: 'Virally Suppressed',
                    dataIndex: 'suppressed',
                    key: 'suppressed',
                    render: (value, row, index) => <span className="tb-span" key={row.id}>{String(value).replace(/(.)(?=(\d{3})+$)/g, '$1,')}</span>
                    // sorter: true
                },
                {
                    title: 'Difference',
                    dataIndex: 'difference',
                    key: 'difference',
                    render: (value, row, index) => <span className="tb-span" key={row.id}>{String(value).replace(/(.)(?=(\d{3})+$)/g, '$1,')}</span>
                    // sorter: true
                },
                {
                    title: 'Concurrence (%)',
                    dataIndex: 'concurrence',
                    key: 'concurrence',
                    render: (value, row, index) => <span className={`tb-span pp ${row.active > 0 && (value >= 100) ? 'db-b-g white-font' : row.active > 0 && (value < 100) ? 'db-b-r white-font' : ''}`} key={row.id}>{value}</span>
                },
                {
                    title: 'Fiscal Year',
                    dataIndex: 'fiscalYear',
                    key: 'fiscalYear'
                }
            ];

        const { buttonText, site, searchText, visible, confirmLoading, searchObj, states, viralLoads, txNew} = this.state;

        let el = this;
        const exporter = <Button icon={confirmLoading ? '' : "download"} onClick={this.export} style={{ float: 'right' }}>
            {confirmLoading ? 'Please wait...' : 'Export to Excel'}
        </Button>;

        return (
            <div className="site-top">
                <Helmet>
                    <title>CDR - Site Queries</title>
                </Helmet>
                <div className="custom-filter-dropdown">
                    <br />
                    <Row style={{ marginTop: '2px' }}>
                        <Col span={24}>
                            <h4 style={{ fontWeight: 'bold', fontSize: '18px' }}>Site Queries</h4>
                        </Col>
                    </Row>
                    <br />
                    <Row gutter={2}>
                        <Col xs={12} sm={3} md={3} lg={3}>
                            <Select defaultValue="10" id="pageSize" onChange={this.handleChange} style={{ width: '100%' }}>
                                <Option value="10">10</Option>
                                <Option value="25">25</Option>
                                <Option value="50">50</Option>
                                <Option value="100">100</Option>
                            </Select>
                        </Col>
                        <Col xs={12} sm={5} md={5} lg={5}>
                            <Select
                                labelInValue
                                showSearch
                                optionFilterProp="children"
                                value={{ key: searchObj.siteId }}
                                disabled={confirmLoading}
                                style={{ width: '100%' }}
                                placeholder="Select Site"
                                filterOption={(input, option) =>
                                    option.props.children.toLowerCase().indexOf(input.toLowerCase()) >= 0
                                }
                                onChange={(value) => this.selectSite('siteId', value)}
                            >
                                <Option key="" value="">-- Select Site --</Option>
                                {states.map(s => <Option key={s.id} value={s.id}>{s.name}</Option>)}
                            </Select>
                        </Col>
                        <Col xs={12} sm={5} md={5} lg={5}>
                            <RangePicker onChange={this.dateRangeChange} />
                        </Col>
                        <Col xs={2} sm={1} md={1} lg={1}>
                            <Button type="primary" shape="circle" icon="search" className="float-right" onClick={this.filter}/>
                        </Col>
                    </Row>
                    <br />
                    <Row>
                        <Col span={24} className="ant-modal-footer si-ant">
                            <Tabs defaultActiveKey="1" tabBarExtraContent={exporter}>
                                <TabPane tab="TX_CURR" key="1">                                  
                                    <Table columns={columns} rowKey={record => record.id} dataSource={this.state.data} pagination={this.state.pagination} loading={this.state.loading} onChange={this.handleTableChange} bordered type="flex" align="middle" />
                                </TabPane>
                                <TabPane tab="TX_NEW" key="2">
                                    <Table columns={txNewColumns} rowKey={record => record.id} dataSource={txNew} pagination={this.state.txNewPagination} loading={this.state.txNewloading} onChange={this.handleTxNewTableChange} bordered type="flex" align="middle" />
                                </TabPane>
                                <TabPane tab="Viral Suppression" key="3">
                                    <Table columns={viralColumns} rowKey={record => record.id} dataSource={viralLoads} pagination={this.state.vlPagination} loading={this.state.vlLoading} onChange={this.handleVLTableChange} bordered type="flex" align="middle" />
                                </TabPane>
                            </Tabs>
                        </Col>
                    </Row>                    
                </div>                
            </div>
        )
    }
}

var component = connect(
    // @ts-ignore
    state => state.site, // Selects which state properties are merged into the component's props.
    SiteQueryStore.actionCreators // Selects which action creators are merged into the component's props.
)(SiteQuery);

// @ts-ignore
export default (withRouter(component));