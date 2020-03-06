// @ts-nocheck
/* eslint-disable no-console */
// import "@Styles/main.css";
import * as React from "react";
import { Helmet } from "react-helmet";
import { fetchData, postQuery } from '../utils';
import TableFooter from "@Components/shared/TableFooter";
import Loader from "@Components/shared/Loader";
import { Redirect } from "react-router-dom";
import { connect } from "react-redux";
import { Table, Input, Button, Select, DatePicker, message, Tabs, Form, Row, Col, Icon, Menu } from 'antd';
const { Option, OptGroup } = Select;
const { TabPane } = Tabs;
const { Item } = Form;
const { RangePicker } = DatePicker;

export default class SiteUpload extends React.Component 
{

    constructor(props)
    {
        super(props);
        this.state =
            {
            data: { id: '', name: '', totalResult: 0,  search: { from: '', to: '' }, site: { id: '', name: '' }, pagination: { current: 1, total: 0, pageSize: 20 } },
                siteUploads: [],
                stateList: [],
                siteList: [],
                pagination:
                {
                    current: 1,
                    total: 0,
                    pageSize: 100,
                    sorter: {
                        field: "name",
                        order: "asc"
                    }
                },
                clientSite: false,
                statesLoaded: true,
                siteId: 0,
                loading: false,
                confirmLoading: false,
                site: 
                {
                    id: 0, name: '', stateName: '', stateCode: '', stateId: ''
                },
                searchText: "",
                visible: false,
                selected: false,
                states: [],
                sites: [],
                searchObj:
                {
                    from: '',
                    to: '',
                    stateId: '',
                    siteId: '',
                    itemsPerPage: 0,
                    pageNumber: 0
                }
            };

        this.onInputChange = this.onInputChange.bind(this);
        this.handleChange = this.handleChange.bind(this);
        this.handleTableChange = this.handleTableChange.bind(this);
        this.getItems = this.getItems.bind(this);
        this.selectState = this.selectState.bind(this);
        this.selectSite = this.selectSite.bind(this);
        this.filter = this.filter.bind(this);
        this.dateRangeChange = this.dateRangeChange.bind(this);
    }    

    async componentDidMount()
    {    
        //Retrieve list of data stored in cache
        let sts = localStorage.getItem("states");
        let states = [];
        if (sts) states = JSON.parse(sts);

        let sitesList = localStorage.getItem("sites");
        let sites = [];
        if (sitesList) sites = JSON.parse(sitesList);

        let statesLoaded = true;
        if (!states || states.length < 1) statesLoaded = false;
        this.setState({ states: states, siteList: sites, statesLoaded });
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

    dateRangeChange(date, dateString, stateId)
    {       
        let from = '';
        let to = '';

        if (dateString && dateString[0])
        {
            from = dateString[0];
        }
        else
        {
            from = '';
        }

        if (dateString && dateString[1])
        {
            to = dateString[1];
        }
        else
        {
            from = '';
        }

        const { data } = this.state;
        data.search = { from, to };
        this.setState({ data });        
    }

    filter(state)
    {
        if (!state)
        {
            message.error('An unknown error was encountered. Please refresh the page and try again')
            return;
        }

        const { pagination } = this.state;

        //if (!state.site || state.site.id === '')
        //{
        //    message.error('Please Select a Site')
        //    return;
        //}

        if (!state.search || (!state.search.to || state.search.to.length < 1) && (!state.search.from || state.search.from.length < 1))
        {
            message.error('Please select a Date Range');
        }
        else
        {
            this.getItems({
                results: pagination.pageSize,
                page: pagination.current,
                from: state.search.from,
                to: state.search.to,
                siteId: (!state.site || state.site.id === '') ? 0 : state.site.id,
                stateId: (!state.id || state.id === '') ? 0 : state.id
            });
        }

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
            siteId: params.siteId,
            stateId: params.stateId
        }

        let s = JSON.stringify(payload);

        this.setState({ loading: true });

        let res = await postQuery('/api/Stats/getTestDetailsByPeriod', s);

        el.setState({ loading: false });    
        
        el.setState({ siteUploads: res });
    }

    handleChange(value) {
        const { pagination } = this.state;
        pagination.pageSize = parseInt(value);

        this.setState({
            pagination: pagination
        });

        this.getItems({
            results: pagination.pageSize,
            page: pagination.current
        });
    }
    
    onInputChange(e)
    {
        const { pagination } = this.state;
        this.getItems({
            results: pagination.pageSize,
            page: pagination.current
        });
    }

    async selectSite(stateId, value)
    {
        const { data } = this.state;
        let site = {id: '', name: ''};
        if (value)
        {
            site = { id: value.key, name: value.label };
        }               

        data.site = site;
        this.setState({ data });        
    }

    async selectState(value)
    {
        if (!value)
        {
            message.error('Please Select a State');
            return;
        }

        let data = { id: '', name: '', totalResult: 0, search: { from: '', to: '' }, site: { id: '', name: '' }, pagination: { current: 1, total: 0, pageSize: 20 } };
        let sites = [];
        if (value)
        {
            let val = value.key;
            let states = this.state.states.filter(function (s) { return parseInt(s.id) === parseInt(val) });  
          
            if (states.length > 0)
            {
                data = states[0];
                data.id = parseInt(data.id);
                data.totalResult = 0;
                data.search = { from: '', to: '' };
                data.site = { id: '', name: '' };
                data.pagination = { current: 1, total: 0, pageSize: 100 };
                sites = this.state.siteList.filter(function (o) { return parseInt(o.stateId) === data.id && o.hasClients > 0 });              
            }            
        }
        this.setState({ data: data, sites: sites, siteUploads: [] });
    }
    
    render() 
    {        
        const { sites, data, loading, statesLoaded, states, siteUploads } = this.state;
        let d = data;
        if (!statesLoaded)
        {
            return <Redirect to="/home" />;
        }
        
        const columns =
            [
                {
                    title: 'Facility',
                    dataIndex: 'name',
                    key: 'name'
                },
                {
                    title: 'Pregnant',
                    dataIndex: 'pregnant',
                    key: 'pregnant'
                },
                {
                    title: 'Test Type',
                    dataIndex: 'description',
                    key: 'description'
                },
                {
                    title: 'Sample Date',
                    dataIndex: 'testDate',
                    key: 'testDate'
                },
                {
                    title: 'Result Date',
                    dataIndex: 'dateReported',
                    key: 'dateReported'
                },
                {
                    title: 'Test Result',
                    dataIndex: 'testResult',
                    key: 'testResult'
                },                
                {
                    title: 'Facility',
                    dataIndex: 'siteName',
                    key: 'siteName'
                }
            ];
                        
        let el = this;
           

        return (
            <div style={{marginTop: '15px', padding: '20px'}}>
                <Helmet>
                    <title>CDR :: Lab Results</title>
                </Helmet>           
                <div className="custom-filter-dropdown">
                    <Row style={{ marginTop: '2px' }}>
                        <Col span={24}>
                            <h4 style={{fontWeight: 'bold', fontSize: '18px'}}>Facility Data Upload Tracker </h4>
                        </Col>
                    </Row>
                    <br />
                    <Row>
                        <Col span={24} className="ant-modal-footer si-ant">
                            <Row key={d.id} style={{ marginTop: '20px', borderBottom: 'dotted thin', marginBottom: '40px' }}>
                                <Row style={{ display: d.getLineList ? 'none' : 'block' }}>
                                    <Col xs={12} sm={4} md={4} lg={4}>
                                        <Select
                                            labelInValue
                                            showSearch
                                            optionFilterProp="children"
                                            value={{ key: d.id }}
                                            disabled={loading}
                                            style={{ width: '100%' }}
                                            placeholder="Select Site"
                                            filterOption={(input, option) =>
                                                option.props.children.toLowerCase().indexOf(input.toLowerCase()) >= 0
                                            }
                                            onChange={(value) => this.selectState(value)}
                                        >
                                            <Option key="" value="">-- Select State --</Option>
                                            {states && states.map(s => <Option key={s.id} value={s.id}>{s.name}</Option>)}
                                        </Select>
                                    </Col>
                                    <Col xs={12} sm={4} md={4} lg={4}>
                                        <Select
                                            labelInValue
                                            showSearch
                                            optionFilterProp="children"
                                            value={{ key: d.site.id }}
                                            disabled={loading}
                                            style={{ width: '100%', marginBottom: '8px', float: 'left', marginLeft: '7px' }}
                                            placeholder="Select Site"
                                            filterOption={(input, option) =>
                                                option.props.children.toLowerCase().indexOf(input.toLowerCase()) >= 0
                                            }
                                            onChange={(value) => el.selectSite(d.id, value)}
                                        >
                                            <Option key="" value="">-- Select Site --</Option>
                                            {sites.map(s => <Option key={s.id} value={s.id}>{s.name}</Option>)}
                                        </Select>
                                    </Col>
                                    <Col xs={12} sm={5} md={4} lg={4} style={{ marginLeft: '12px' }}>
                                        <RangePicker onChange={(a, b) => this.dateRangeChange(a, b, d.id)} disabled={loading} />
                                    </Col>                                   
                                    <Col xs={3} sm={3} md={3} lg={3} style={{ marginLeft: '15px' }}>
                                        <Button style={{ marginBottom: '8px' }} icon="ordered-list" size="large" disabled={loading} className="float-left" onClick={() => el.filter(d)}>Filter</Button>
                                    </Col>
                                    <br />
                                    <Table columns={columns} rowKey={record => record.id} dataSource={siteUploads} pagination={false} loading={loading} bordered type="flex" align="middle" />
                                    <br />
                                </Row>

                            </Row>
                        </Col>
                    </Row>
                </div>
                            
            </div>
        ) 
    }
}


//<TabPane tab="TX_NEW" key="2">
//    <Table columns={txNewColumns} rowKey={record => record.id} dataSource={txNew} pagination={this.state.txNewPagination} loading={this.state.txNewloading} onChange={this.handleTxNewTableChange} bordered type="flex" align="middle" />
//</TabPane>