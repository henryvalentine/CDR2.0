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

export default class LineList extends React.Component 
{

    constructor(props)
    {
        super(props);
        this.state =
            {
                data: { id: '', name: '', groups: [], isSiteAggregates: false, totalResult: 0, lineList: [], search: { from: '', to: '' }, site: { id: '', name: '' }, getLineList: false, pagination: { current: 1, total: 0, pageSize: 20 } },
                lineList: [],
                stateList: [],
                siteList: [],
                activeKey: 1,
                txNewData: [],
                txNewLineList: [],
                txNew: [],
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
                regimens: [],
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
        this.groupBy = this.groupBy.bind(this);
        this.countGroups = this.countGroups.bind(this);
        this.dateRangeChange = this.dateRangeChange.bind(this);
        this.mapResult = this.mapResult.bind(this);
        this.goBack = this.goBack.bind(this);
        this.export = this.export.bind(this);
        this.aggregate = this.aggregate.bind(this);
        this.getAggregates = this.getAggregates.bind(this);
        this.ddl = this.ddl.bind(this);
        this.deleteFile = this.deleteFile.bind(this);
        this.tabChanged = this.tabChanged.bind(this);
    }    

    goBack(stateId)
    {
        const { data } = this.state;
        data.getLineList = false;
        this.setState({ data });
    }

    tabChanged(activeKey)
    {
        console.log(activeKey);
        this.setState({ activeKey });
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

        let aSGg = localStorage.getItem("ageSexAggregations");

        let ageSexAggregations = aSGg ? JSON.parse(aSGg) : [];

        if (ageSexAggregations.length > 0)
        {
            this.mapResult(ageSexAggregations);
        }    

        let res = await fetchData(`/api/regimen/getAllRegimens`);
        if (res.length > 0)
        {
            this.setState({regimens: res})
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

        if (!state.site || state.site.id === '')
        {
            message.error('Please Select a Site')
            return;
        }

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

    aggregate(state)
    {
        if (!state) {
            message.error('An unknown error was encountered. Please refresh the page and try again')
            return;
        }

        const { pagination } = this.state;
        
        if (!state.search || (!state.search.to || state.search.to.length < 1) && (!state.search.from || state.search.from.length < 1))
        {
            message.error('Please select a Date Range');
        }
        else
        {
            this.getAggregates({
                results: pagination.pageSize,
                page: pagination.current,
                from: state.search.from,
                to: state.search.to,
                siteId: (!state.site || state.site.id === '') ? 0 : state.site.id,
                stateId: (!state.id || state.id === '') ? 0 : state.id
            });
        }

    }

    async getAggregates(params = {})
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

        let res = await postQuery('/api/Stats/getTxCurrBandsByPeriod', s);

        el.setState({ loading: false });

        if (res.groupCounts.length > 0)
        {
            let data = el.state.data;
            data.groups = res.groupCounts;
            data.isSiteAggregates = params.siteId > 0 ? true : false;
            el.setState({ data: data });
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

        let res = await postQuery('/api/Stats/getLineList', s);

        el.setState({ loading: false });    
        
        if (res.lineList.length > 0)
        {    
            let data = el.state.data;            
            let regimens = el.state.regimens;
            res.lineList.forEach(function (l)
            {
                if (l.arvRegimenCode && l.arvRegimenCode.length > 0)
                {
                    let rr = regimens.filter(function (f) { return f.combination.toLowerCase() === l.arvRegimenCode.toLowerCase() });
                    if (rr.length > 0)
                    {
                        l.regimenLine = rr[0].line;
                    }
                    else
                    {
                        l.regimenLine = '';
                    }
                }
                else
                {
                    l.regimenLine = '';
                }

                if (l.firstRegimenCode && l.firstRegimenCode.length > 0)
                {
                    let fr = regimens.filter(function (f) { return f.combination.toLowerCase() === l.firstRegimenCode.toLowerCase() });
                    if (fr.length > 0)
                    {
                        l.firstRegimenLine = fr[0].line;
                    }
                    else
                    {
                        l.firstRegimenLine = '';
                    }
                }
                else
                {
                    l.firstRegimenLine = '';
                }

                
            });
            //pagination.total = targetList.length;
            data.lineList = res.lineList;
            data.getLineList = true;
            data.totalResult = res.lineList[0].totalResult;
            el.setState({ data: data });
            
        }
    }

    async mapResult(result)
    {
        let el = this;

        //group the aggregations by state
        let stateGroups = await el.groupBy(result, 'stateId');

        const { pagination } = el.state;

        pagination.total = 0;

        let ageGroups = await el.countGroups(stateGroups);
        
        el.setState({ stateList: ageGroups, pagination });
    }

    async countGroups(stateGroups)
    {         
        let mapped = [];
        let el = this;

       Object.keys(stateGroups).forEach(key =>
       {
           
           let ageGroups = [];
           let states = el.state.states.filter(function (s) { return parseInt(s.id) === parseInt(key) });
      
           if (states.length > 0)
           {
               let ll = stateGroups[key];

               ll.forEach(a =>
               {
                   var lines = ageGroups.filter(function (l)
                   {
                       return l.groupName === a.groupName;
                   });

                   if (lines.length > 0) {
                       let line = lines[0];
                       if (a.gender.trim().toLowerCase() == "male") line.maleCount += a.ageCount;
                       if (a.gender.trim().toLowerCase() == "female") line.femaleCount += a.ageCount;
                       line.total += a.ageCount;
                   }
                   else {
                       ageGroups.push({
                           maleCount: (a.gender.trim().toLowerCase() == "male") ? a.ageCount : 0,
                           femaleCount: (a.gender.trim().toLowerCase() == "female") ? a.ageCount : 0,
                           groupName: a.groupName,
                           total: a.ageCount
                       });
                   }

               });               
               
               mapped.push({ id: key, name: states[0].name, groups: ageGroups, isSiteAggregates: false, totalResult: 0, lineList: [], search: { from: '', to: '' }, site: { id: '', name: '' }, getLineList: false, pagination: { current: 1, total: 0, pageSize: 20 } });               
           }            
       });   

       return mapped;
    }

    async groupBy(array, property)
    {
        return array.reduce(function (accumulator, object)
        {
            // get the value of the object(gender in this case) to use to group the array as the array key   
            const key = object[property];
            // if the current value is similar to the key(gender) don't accumulate the transformed array and leave it empty  
            if (!accumulator[key])
            {
                accumulator[key] = [];
            }
            // add the value to the array
            accumulator[key].push(object);
            // return the transformed array
            return accumulator;
            // Also we also set the initial value of reduce() to an empty object
        }, {});
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

        let data = { id: '', name: '', groups: [], isSiteAggregates: false, totalResult: 0, lineList: [], search: { from: '', to: '' }, site: { id: '', name: '' }, getLineList: false, pagination: { current: 1, total: 0, pageSize: 20 } };
        let sites = [];
        if (value)
        {
            let val = value.key;
            let states = this.state.stateList.filter(function (s) { return parseInt(s.id) === parseInt(val) });  
            if (states.length > 0)
            {
                data = states[0];
                data.id = parseInt(data.id);
                sites = this.state.siteList.filter(function (o) { return parseInt(o.stateId) === data.id && o.hasClients > 0 });              
            }            
        }
        this.setState({ data: data, sites: sites });
    }

    async export(state)
    {
        let el = this;
        if (!state)
        {
            message.error('An error was encountered on the page. Please rfresh the page and try again');
            return;
        }
        let header = state.site.name + ', ' + state.name;
        header = parseInt(el.state.activeKey) === 1 ? 'Tx_Curr for ' + header : 'Tx_New for ' + header
        let payload =
        {
            from: state.search.from,
            to: state.search.to,
            itemsPerPage: 1000,
            pageNumber: 1,
            siteId: state.site.id,
            stateId: state.id,
            header: header
        }

        let s = JSON.stringify(payload);

        this.setState({ loading: true });

        let res = await postQuery('/api/Stats/exportLineList', s);

        el.setState({ loading: false });    

        if (res.code < 1)
        {
            message.error(res.message);
        }
        else
        {
            await this.ddl(res.asset);
            this.deleteFile(res.fileName);
                    
            //fetchData('/api/Stats/deleteFile?p=' + res.fileName);
        }
    }

    ddl(path)
    {
        window.location = path;
    }

    deleteFile(fileName)
    {
        fetchData('/api/Stats/deleteFile?p=' + fileName)
    }

    render() 
    {        
        const { sites, data, loading, txNew, statesLoaded, states } = this.state;
        let d = data;
        if (!statesLoaded)
        {
            return <Redirect to="/home" />;
        }

        const columns =
            [
                {
                    title: 'Age Band(years)',
                    dataIndex: 'groupName',
                    key: 'groupName'
                },
                {
                    title: 'Males',
                    dataIndex: 'maleCount',
                    key: 'maleCount',
                    render: (value, row, index) => <span className="tb-span" key={row.id}>{String(value).replace(/(.)(?=(\d{3})+$)/g, '$1,')}</span>
                },
                {
                    title: 'Females',
                    dataIndex: 'femaleCount',
                    key: 'femaleCount',
                    render: (value, row, index) => <span className="tb-span" key={row.id}>{String(value).replace(/(.)(?=(\d{3})+$)/g, '$1,')}</span>
                },
                {
                    title: 'Total',
                    dataIndex: 'total',
                    key: 'total',
                    render: (value, row, index) => <span className="tb-span" key={row.id}>{String(value).replace(/(.)(?=(\d{3})+$)/g, '$1,')}</span>
                }
            ];

        const lineColumns =
            [
                {
                    title: 'Client Id',
                    dataIndex: 'enrolmentId',
                    key: 'enrolmentId'
                },
                {
                    title: 'Gender',
                    dataIndex: 'gender',
                    key: 'gender'
                }, 
                { 
                    title: 'Age(yrs)',
                    dataIndex: 'age',
                    key: 'age'
                },
                {
                    title: 'Preg.',
                    dataIndex: 'pregnant',
                    key: 'pregnant'
                },
                {
                    title: 'Art Date',
                    dataIndex: 'artDateStr',
                    key: 'artDateStr'
                },
                {
                    title: 'First Regimen',
                    dataIndex: 'firstRegimenCode',
                    key: 'firstRegimenCode'
                },
                {
                    title: 'First Regimen Line',
                    dataIndex: 'firstRegimenLine',
                    key: 'firstRegimenLine'
                },
                {
                    title: 'Current Visit Date',
                    dataIndex: 'visitDateStr',
                    key: 'visitDateStr'
                },                
                {
                    title: 'Current VL Date',
                    dataIndex: 'testDateStr',
                    key: 'testDateStr'
                },
                {                    
                    title: 'Current VL Result',
                    dataIndex: 'testResult',
                    key: 'testResult'
                },
                {
                    title: 'Current Regimen',
                    dataIndex: 'arvRegimenCode',
                    key: 'arvRegimenCode'
                },
                {
                    title: 'Current Regimen Line',
                    dataIndex: 'regimenLine',
                    key: 'regimenLine'
                }

            ];
                
        const txNewColumns =
            [
                {
                    title: 'Age Band(years)',
                    dataIndex: 'groupName',
                    key: 'groupName'
                },
                {
                    title: 'Males',
                    dataIndex: 'maleCount',
                    key: 'maleCount'
                },
                {
                    title: 'Females',
                    dataIndex: 'femaleCount',
                    key: 'femaleCount'
                },
                {
                    title: 'Total',
                    dataIndex: 'total',
                    key: 'totla'
                }
            ];
                
        let el = this;
    
        const footerColumns =
            [
                {
                    key: 'maleCount',
                    footerContent: 'Males: ',
                    footerSum: true,
                },
                {
                    key: 'femaleCount',
                    footerContent: 'Females: ',
                    footerSum: true,
                },
                {
                    key: 'total',
                    footerContent: 'Grand Total: ',
                    footerSum: true,
                }
                
            ];               

        return (
            <div style={{marginTop: '15px', padding: '20px'}}>
                <Helmet>
                    <title>CDR :: Age band aggregations</title>
                </Helmet>           
                <div className="custom-filter-dropdown">
                    <Row style={{ marginTop: '2px' }}>
                        <Col span={24}>
                            <h4 style={{fontWeight: 'bold', fontSize: '18px'}}>Age band aggregations </h4>
                        </Col>
                    </Row>
                    <br />
                    <Row>
                        <Col span={24} className="ant-modal-footer si-ant">
                            <Tabs defaultActiveKey="1" onChange={this.tabChanged}>
                                <TabPane tab="TX_CURR" key="1">                                       
                                    <Row key={d.id} style={{ marginTop: '20px', borderBottom: 'dotted thin', marginBottom: '40px' }}>
                                        <Row style={{ display: d.getLineList? 'none' : 'block' }}>                                            
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
                                                <RangePicker onChange={(a,b) => this.dateRangeChange(a,b,d.id)} disabled={loading}/>
                                            </Col>
                                            <Col xs={3} sm={3} md={3} lg={3} style={{ marginLeft: '15px' }}>
                                                <Button style={{ marginBottom: '8px' }} icon="diff" size="large" disabled={loading} className="float-left" onClick={() => el.aggregate(d)}>Get Aggregates</Button>
                                            </Col>
                                            <Col xs={3} sm={3} md={3} lg={3} style={{ marginLeft: '15px' }}>
                                                <Button style={{ marginBottom: '8px' }} icon="ordered-list" size="large" disabled={loading} className="float-left" onClick={() => el.filter(d)}>Get Linelist</Button>
                                            </Col>
                                            {d.isSiteAggregates && 
                                                <Col xs={24}>
                                                    <h4 style={{ marginBottom: '8px', marginTop: '8px', textAlign: 'left' }}>
                                                        Age band aggregates for: {d.site.name}, {d.name}
                                                    </h4>
                                                </Col>
                                            }
                                            <br />
                                            <Table columns={columns} rowKey={record => record.groupName} footer={() => { return (<TableFooter dataSource={d.groups} columns={footerColumns} />) }} dataSource={d.groups} pagination={false} loading={loading} bordered type="flex" align="middle" />
                                            <br />
                                        </Row>
                                        {d.lineList && <Row style={{ display: d.getLineList ? 'block' : 'none' }}>
                                            <Row>
                                                <Col xs={18}>
                                                    <h4 style={{ marginBottom: '8px', textAlign: 'left' }}>
                                                        {d.site.name}, {d.name} &nbsp;&nbsp;| &nbsp;<small>showing <span className="tb-span">{String(d.lineList.length).replace(/(.)(?=(\d{3})+$)/g, '$1,')}</span> of <span className="tb-span">{String(d.totalResult).replace(/(.)(?=(\d{3})+$)/g, '$1,')}</span> records</small>
                                                    </h4>
                                                </Col>
                                                <Col xs={3} sm={2} md={2} lg={2}>
                                                    <Button disabled={loading} style={{ marginBottom: '8px', float: 'right', marginRight: '5px' }} icon="close-circle" size="default" className="float-left" onClick={() => el.goBack(d.id)}>Close</Button>
                                                </Col>
                                                <Col xs={3} sm={3} md={3} lg={3}>
                                                    <Button disabled={loading} icon={loading ? '' : "download"} onClick={() => this.export(d)} style={{ float: 'right' }}>
                                                        {loading ? 'Please wait...' : 'Export to Excel'}
                                                    </Button>
                                                </Col>
                                            </Row>                                           
                                            <Table  columns={lineColumns} rowKey={r => r.enrolmentId} dataSource={d.lineList} pagination={false} bordered type="flex" align="middle" />
                                            <br />
                                        </Row>}                                     
                                        
                                    </Row>                                    
                                   
                                </TabPane>                               
                            </Tabs>
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