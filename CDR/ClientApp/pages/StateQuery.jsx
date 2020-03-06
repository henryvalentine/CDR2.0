/* eslint-disable no-console */
// import "@Styles/main.css";
import * as React from "react";
import { Helmet } from "react-helmet";
import { withRouter } from "react-router";
import { fetchData, postQuery } from '../utils'
import { Redirect } from "react-router-dom";
import * as StateQueryStore from "@Store/StateQueryStore";
import { connect } from "react-redux";
import { Table, Button, Select, DatePicker, Tabs, message, Row, Col } from 'antd';
const { Option } = Select;
const { TabPane } = Tabs;
const { RangePicker } = DatePicker;

class StateQuery extends React.Component 
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
                searchText: "",
                statesLoaded: true,
                visible: false,
                hideUpload: false,
                states: [],
                searchObj:
                {
                    from: '',
                    to: '',
                    stateId: '',
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

        this.selectState = this.selectState.bind(this);
        this.handleChange = this.handleChange.bind(this);
        this.handleTableChange = this.handleTableChange.bind(this);
        this.handleTxNewTableChange = this.handleTxNewTableChange.bind(this);
        this.handleVLTableChange = this.handleVLTableChange.bind(this);
        this.getItems = this.getItems.bind(this);
        this.export = this.export.bind(this);
        this.filter = this.filter.bind(this);
        this.dateRangeChange = this.dateRangeChange.bind(this);
        this.matchStateName = this.matchStateName.bind(this);
    }
    
    async componentDidMount()
    {
        let sts = localStorage.getItem("states");
        let states = [];
        if (sts) states = JSON.parse(sts);
        let statesLoaded = true;
        if (!states || states.length < 1) statesLoaded = false;
        this.setState({ states: states, statesLoaded: statesLoaded });
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

        if ((!searchObj.to || searchObj.to.length < 1) && (!searchObj.from || searchObj.from.length < 1)) {
            message.error('Please select a Date Range');
        }
        else
        {            
            this.getItems({
                page: pagination.current,
                from: searchObj.from,
                to: searchObj.to,
                stateId: (searchObj.stateId === '' || !searchObj.stateId) ? 0 : searchObj.stateId
            });
        }       
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
            page: pager.current
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
            page: pager.current
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
            page: pager.current
        });
    }  

    async getItems(params = {})
    {
        var results = params.results;
        var page = params.page;
        let el = this;

        let payload =
        {
            from: params.from,
            to: params.to,
            itemsPerPage: results,
            pageNumber: page,
            siteId: 0,
            stateId: params.stateId
        }
        let s = JSON.stringify(payload);
        this.setState({ loading: true });
       
        let res = await postQuery('/api/Stats/getStateTxCurrByPeriod', s);
        const { pagination } = el.state;
        res.sites.map(s =>
        {
            s.name = el.matchStateName(s.stateId);
        });
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
            stateId: (searchObj.stateId === '' || !searchObj.stateId) ? 0 : searchObj.stateId
        });
    }

    async getTxNew(params = {})
    {
        var results = params.results;
        var page = params.page;

        let el = this;

        let payload =
        {
            from: params.from,
            to: params.to,
            itemsPerPage: results,
            pageNumber: page,
            siteId: 0,
            stateId: params.stateId
        }

        let s = JSON.stringify(payload);
        this.setState({ txNewloading: true });
       
        let res = await postQuery('/api/Stats/getStateTxNewByPeriod', s);
        
        const { txNewPagination } = el.state;
        txNewPagination.total = res.totalItems;
        res.sites.map(s => {
            s.name = el.matchStateName(s.stateId);
        });
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
            stateId: (searchObj.stateId === '' || !searchObj.stateId) ? 0 : searchObj.stateId
        });
        
    }

    async getVL(params = {})
    {
        var results = params.results;
        var page = params.page;

        let el = this;

        let payload =
        {
            from: params.from,
            to: params.to,
            itemsPerPage: results,
            pageNumber: page,
            siteId: 0,
            stateId: params.stateId
        }
        
        let s = JSON.stringify(payload);
        this.setState({ vlLoading: true });

        let res = await postQuery('/api/Stats/getStateVLByPeriod', s);

        const { vlPagination } = el.state;
        vlPagination.total = res.totalItems;

        res.sites.map(s =>
        {
            s.name = el.matchStateName(s.stateId);
        });

        el.setState({
            viralLoads: res.sites,
            vlPagination,
            vlLoading: false
        });
    }

    handleChange(value)
    {
        const { pagination } = this.state;
        pagination.pageSize = parseInt(value);

        this.setState({
            pagination: pagination
        });
    }

    matchStateName(stateId)
    {
        let states = this.state.states.filter(s =>
        {
            return s.id === stateId;
        });

        return states.length > 0 ? states[0].name : '';
    }
                     
    async selectState(feature, value)
    {
        var searchObj = this.state.searchObj;
        if (value)
        {
            let val = value.key;
            searchObj.stateId = val;
        }
        else
        {
            searchObj.stateId = '';
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
        const { confirmLoading, searchObj, states, viralLoads, txNew, statesLoaded } = this.state;
        
        if (!statesLoaded) {
            return <Redirect to="/home" />;
        }

        const columns =
            [
                {
                    title: 'State',
                    dataIndex: 'name',
                    key: 'name'
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
                    title: 'Coverage (%)',
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
                    title: 'State',
                    dataIndex: 'name',
                    key: 'name'
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
                    title: 'Coverage (%)',
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
                    title: 'State',
                    dataIndex: 'name',
                    key: 'name'
                    // sorter: true
                },
                {
                    title: 'Active Clients',
                    dataIndex: 'active',
                    key: 'active',
                    render: (value, row, index) => <span className="tb-span" key={row.stateId}>{String(value).replace(/(.)(?=(\d{3})+$)/g, '$1,')}</span>
                    // sorter: true
                },
                {
                    title: 'Total Tested',
                    dataIndex: 'tested',
                    key: 'tested',
                    render: (value, row, index) => <span className="tb-span" key={row.stateId}>{String(value).replace(/(.)(?=(\d{3})+$)/g, '$1,')}</span>
                    // sorter: true
                },
                {
                    title: 'Suppressed',
                    dataIndex: 'suppressed',
                    key: 'suppressed',
                    render: (value, row, index) => <span className="tb-span" key={row.stateId}>{String(value).replace(/(.)(?=(\d{3})+$)/g, '$1,')}</span>
                    // sorter: true
                },
                {
                    title: 'Unsuppressed',
                    dataIndex: 'unsuppressed',
                    key: 'unsuppressed',
                    render: (value, row, index) => <span className="tb-span" key={row.stateId}>{String(value).replace(/(.)(?=(\d{3})+$)/g, '$1,')}</span>
                    // sorter: true
                },
                {
                    title: 'Difference',
                    dataIndex: 'difference',
                    key: 'difference',
                    render: (value, row, index) => <span className="tb-span" key={row.stateId}>{String(value).replace(/(.)(?=(\d{3})+$)/g, '$1,')}</span>
                    // sorter: true
                },
                {
                    title: 'Coverage (%)',
                    dataIndex: 'concurrence',
                    key: 'concurrence',
                    render: (value, row, index) => <span className={`tb-span pp ${row.active > 0 && (value >= 100) ? 'db-b-g white-font' : row.active > 0 && (value < 100) ? 'db-b-r white-font' : ''}`} key={row.stateId}>{value}</span>
                }
            ];               
        
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
                            <h4 style={{ fontWeight: 'bold', fontSize: '18px' }}>State Performances</h4>
                        </Col>
                    </Row>
                    <br />
                    <Row gutter={2}>                        
                        <Col xs={12} sm={5} md={5} lg={5}>
                            <Select
                                labelInValue
                                showSearch
                                optionFilterProp="children"
                                value={{ key: searchObj.stateId }}
                                disabled={confirmLoading}
                                style={{ width: '100%' }}
                                placeholder="Select Site"
                                filterOption={(input, option) =>
                                    option.props.children.toLowerCase().indexOf(input.toLowerCase()) >= 0
                                }
                                onChange={(value) => this.selectState('stateId', value)}
                            >
                                <Option key="" value="">-- Select State --</Option>
                                {states && states.map(s => <Option key={s.id} value={s.id}>{s.name}</Option>)}
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
                            <Tabs defaultActiveKey="1">
                                <TabPane tab="TX_CURR" key="1">                                  
                                    <Table columns={columns} rowKey={record => record.stateId} dataSource={this.state.data} pagination={this.state.pagination} loading={this.state.loading} onChange={this.handleTableChange} bordered type="flex" align="middle" />
                                </TabPane>
                                <TabPane tab="TX_NEW" key="2">
                                    <Table columns={txNewColumns} rowKey={record => record.stateId} dataSource={txNew} pagination={this.state.txNewPagination} loading={this.state.txNewloading} onChange={this.handleTxNewTableChange} bordered type="flex" align="middle" />
                                </TabPane>
                                <TabPane tab="Viral Suppression" key="3">
                                    <Table columns={viralColumns} rowKey={record => record.stateId} dataSource={viralLoads} pagination={this.state.vlPagination} loading={this.state.vlLoading} onChange={this.handleVLTableChange} bordered type="flex" align="middle" />
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
    StateQueryStore.actionCreators // Selects which action creators are merged into the component's props.
)(StateQuery);

// @ts-ignore
export default (withRouter(component));
