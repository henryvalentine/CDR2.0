// @ts-nocheck
/* eslint-disable no-console */
// import "@Styles/main.css";
import * as React from "react";
import { Helmet } from "react-helmet";
import { withRouter } from "react-router";
import { fetchData, postQuery } from '../utils';
import * as PatientStore from "@Store/PatientStore";
import Loader from "@Components/shared/Loader";
import { connect } from "react-redux";
import { Table, Input, Button, Select, DatePicker, Popconfirm, Tabs, Form, Row, Col, Icon, Menu, Modal } from 'antd';
const { Option, OptGroup } = Select;
const { TabPane } = Tabs;
const {Item} = Form;

class PatientPage extends React.Component 
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
                clientSite: false,
                siteId: 0,
                loading: false,
                confirmLoading: false,
                title: 'New Patient',
                client: { id: '', firstName: '', status: 'Unknown Status', lastName: '', enrolmentId: '', visitDate: '', DateOfBirthStr: '',
                    stateId: '', sex: '', dateOfBirth: '', age: '', village: '', town: '', lga: '', 
                    state: '', addressLine1: '', phoneNumber: '', maritalStatus: '', preferredLanguage: '',
                    baseline:
                    {
                        hivConfirmationDateStr: "NA",
                        enrolmentDateStr: "NA",
                        artDateStr: "NA"                           
                    },
                    artVisits: []
                },
                site: 
                {
                    id: 0, name: '', stateName: '', stateCode: ''
                },
                searchText: "",
                visible: false,
                selected: false
            };

        this.selectionChanged = this.selectionChanged.bind(this);
        this.textChange = this.textChange.bind(this);
        this.exit = this.exit.bind(this);
        this.process = this.process.bind(this);
        this.getPatient = this.getPatient.bind(this);
        this.onSearch = this.onSearch.bind(this);
        this.onInputChange = this.onInputChange.bind(this);
        this.handleChange = this.handleChange.bind(this);
        this.handleTableChange = this.handleTableChange.bind(this);
        this.getItems = this.getItems.bind(this);
        this.handleSelectChange = this.handleSelectChange.bind(this);

    }

    

    async componentDidMount()
    {
        const site = new URLSearchParams(window.location.search).get('site');
        let siteId = (site && parseInt(site) > 0)? site : 0;
        const { pagination } = this.state;
        this.setState({siteId: siteId, clientSite: siteId > 0? true : false});
        this.getItems({
            results: pagination.pageSize,
            searchText: this.state.searchText,
            page: pagination.current,
            sortField: pagination.sorter.field,
            sortOrder: pagination.sorter.order
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

    async getItems(params = {}) 
    {        
        var searchText = params.searchText;
        var results = params.results;
        var page = params.page;
        // var sortField = params.sortField;
        // var sortOrder = params.sortOrder;
        let el = this;
        
        // var query = searchText ? `/api/Patient/searchPatient?itemsPerPage=${results}&pageNumber=${page}&searchText=${searchText}` : `/api/Patient/getPatients?itemsPerPage=${results}&pageNumber=${page}`;
        var query = el.state.siteId > 0 ? `/api/Patient/getPatientsBySite?itemsPerPage=${results}&pageNumber=${page}&siteId=${site}` : `/api/Patient/getPatients?itemsPerPage=${results}&pageNumber=${page}`;
        
        el.setState({loading: true});
        
        let res = await fetchData(query);

        if (res.patients.length > 0)
        {
            const { pagination } = el.state;
            pagination.total = res.totalItems;           
            el.setState({
                data: res.patients,
                pagination,
                loading: false
            });
        }

        if(el.state.site.id < 1 && (el.state.clientSite || el.state.siteId > 0))
        {
            let siteQuery = `/api/Site/getSite?id=${el.state.siteId}`;
            let site = await fetchData(siteQuery);       
            if (site.id > 0)
            {         
                el.setState({ site: site });
            }
        }

        if (searchText && searchText.trim().length > 0)
        {
            const reg = new RegExp(searchText, 'gi');
            this.setState({
                filtered: !!searchText,
                data: this.state.data.map((record) =>
                {
                    const match = record.enrolmentId.toString().match(reg) || record.status.toString().match(reg) || record.firstName.toString().match(reg) || record.lastName.toString().match(reg) || record.stateId.toString().match(reg);

                    if (!match)
                    {
                        return null;
                    }
                    return {
                        ...record,
                        Name: (<span> {record.enrolmentId.split(reg).map((text, i) => (i > 0 ? [<span key={record.id} className="highlight">{match[0]}</span>, text] : text
                        ))}
                        </span>
                        )
                    };
                }).filter(record => !!record)
            });
        }
    }

    handleChange(value) {
        const { pagination } = this.state;
        pagination.pageSize = parseInt(value);

        this.setState({
            pagination: pagination
        });

        this.getItems({
            results: pagination.pageSize,
            searchText: this.state.searchText,
            page: pagination.current,
            //sortField: pagination.sorter.field,
            //sortOrder: pagination.sorter.order
        });
    }


    onInputChange(e)
    {
        let searchTerm = e.target.value.trim();
        this.setState({searchText: searchTerm});
        const { pagination } = this.state;
        this.getItems({
            results: pagination.pageSize,
            searchText: searchTerm,
            page: pagination.current,
            //sortField: pagination.sorter.field,
            //sortOrder: pagination.sorter.order
        });
    }
    
  
    onSearch() {
        const { pagination } = this.state;
        this.getItems({
            results: pagination.pageSize,
            searchText: this.state.searchText,
            page: pagination.current,
            //sortField: pagination.sorter.field,
            //sortOrder: pagination.sorter.order
        });
    }

    async getPatient(row)
    {
        let el = this;

        var query = `/api/Patient/getClient?id=${row.id}`;

        el.setState({ loading: true });

        let patient = await fetchData(query);
        el.setState({ loading: false });
      
        if (patient.id > 0)
        {          
            el.setState({
                client: patient,
                selected: true
            });
        }
        else
        {
            alert('Client information could not be retrieved');
        }
    }
      
    async process()
    {
        if (!this.state.patient.FirstName)
        {
            alert('Provide all required input and try again');
            return;
        }
        let url = '';
        let payload = {};
        if (!this.state.patient.id || this.state.patient.id.length < 1) {
            url = '/api/Patient/addPatient';
            payload =  {firstName: this.state.patient.firstName, lastName: this.state.patient.lastName, enrolmentId: this.state.patient.enrolmentId, visitDate: this.state.patient.visitDate,
                stateId: this.state.patient.stateId, sex: this.state.patient.sex, dateOfBirth: this.state.patient.dateOfBirth, age: this.state.patient.age, village: this.state.patient.village, town: this.state.patient.town, lga: this.state.patient.lga, 
                state: this.state.patient.state, addressLine1: this.state.patient.addressLine1, phoneNumber: this.state.patient.phoneNumber, maritalStatus: this.state.patient.maritalStatus, preferredLanguage: this.state.patient.preferredLanguage}
        }
        else 
        {
            url = '/api/Patient/updatePatient';
            payload =  { id: this.state.patient.id, firstName: this.state.patient.firstName, lastName: this.state.patient.lastName, enrolmentId: this.state.patient.enrolmentId, visitDate: this.state.patient.visitDate,
                stateId: this.state.patient.stateId, sex: this.state.patient.sex, dateOfBirth: this.state.patient.dateOfBirth, age: this.state.patient.age, village: this.state.patient.village, town: this.state.patient.town, lga: this.state.patient.lga, 
                state: this.state.patient.state, addressLine1: this.state.patient.addressLine1, phoneNumber: this.state.patient.phoneNumber, maritalStatus: this.state.patient.maritalStatus, preferredLanguage: this.state.patient.preferredLanguage};
        }
       

        const { pagination } = this.state;
        let params = {
            results: pagination.pageSize,
            searchText: this.state.searchText,
            page: pagination.current,
            //sortField: pagination.sorter.field,
            //sortOrder: pagination.sorter.order
        };

        this.setState({ confirmLoading: true });
        let res = await postQuery(url, JSON.stringify(payload));
        this.setState({ confirmLoading: false });
        if (res.code > 0) {
            this.getItems(params);
            this.setState({ visible: false });
        }
        alert(res.message);
    }

    
    exit() {
        this.setState({
            selected: false
        });
    }

    handleSelectChange(feature, value, target) 
    {
        console.log(value); // { key: "lucy", label: "Lucy (101)" }
        let patient = this.state.patient;
        patient[feature] = value[target];
        this.setState({patient});
    }

    textChange(feture, e)
    {
        const { patient } = this.state;
        patient[feture] = e.target.value;
        this.setState({ patient });
    }

   
    selectionChanged(prop, feature, val, innerFeature)
    {
        if (innerFeature !== undefined && innerFeature !== null && innerFeature.length > 0) {
            let stateObj = this.state[prop];
            stateObj[feature][innerFeature] = val;
            this.setState({ [prop]: stateObj });
        }
        else {
            this.setState({ [prop]: { ...this.state[prop], [feature]: val } });
        }
    }

    render() 
    {
        const {clientSite} = this.state;
        const dateFormat = 'YYYY/MM/DD';
        //render: (value, row, index) => <a key={value.id} title="view more" onClick={() => this.getPatient(value, row)} style={{cursor: 'pointer'}}><Icon type="container" /></a>
        const columns =
            [
                {
                    title: 'Enrolment Id',
                    dataIndex: 'enrolmentId',
                    key: 'enrolmentId',
                    render: (value, row, index) => <a key={value.id} title="view more" onClick={() => this.getPatient(row)} style={{ cursor: 'pointer' }}>{value}</a>
                },
                {
                    title: 'Site',
                    dataIndex: 'siteName',
                    key: 'siteName'
                    // sorter: true
                },
                {
                    title: 'State',
                    dataIndex: 'state',
                    key: 'state',
                    // sorter: true
                },
                {
                    title: 'Sex',
                    dataIndex: 'sex',
                    key: 'sex'
                    // sorter: true
                },
                {
                    title: 'Art Started',
                    dataIndex: 'artDateStr',
                    key: 'artDateStr'
                },
                {
                    title: 'Last Visit',
                    dataIndex: 'visitDateStr',
                    key: 'visitDateStr'
                    // sorter: true
                },
                {
                    title: 'Appointment',
                    dataIndex: 'appointmentDateStr',
                    key: 'appointmentDateStr',
                    // sorter: true
                },
                {
                    title: 'Status',
                    dataIndex: 'status',
                    key: 'status',
                    render: (value, row, index) => <span 
                    className={`tb-span ${row.status.toLowerCase() === 'active'? 'db-h3-g': row.status.toLowerCase() === 'inactive'? 'db-h3-n' : row.status.toLowerCase() === 'loss-to-follow up'? 'db-h3-r' : 'db-h3-u'}`} 
                    key={row.id}>{String(value).replace(/(.)(?=(\d{3})+$)/g,'$1,')}</span>
                }
        ];

        const clientSiteColumns =
        [
            {
                title: 'Enrolment Id',
                dataIndex: 'enrolmentId',
                key: 'enrolmentId',
                render: (value, row, index) => <a key={value.id} title="view more" onClick={() => this.getPatient(row)} style={{ cursor: 'pointer' }}>{value}</a>
            },
            {
                title: 'Sex',
                dataIndex: 'sex',
                key: 'sex'
                // sorter: true
            },
            {
                title: 'Art Started',
                dataIndex: 'artDateStr',
                key: 'artDateStr'
            },
            {
                title: 'Last Visit',
                dataIndex: 'visitDateStr',
                key: 'visitDateStr'
                // sorter: true
            },
            {
                title: 'Appointment',
                dataIndex: 'appointmentDateStr',
                key: 'appointmentDateStr',
                // sorter: true
            },
            {
                title: 'Status',
                dataIndex: 'status',
                key: 'status',
                render: (value, row, index) => <span 
                className={`tb-span ${row.status.toLowerCase() === 'active'? 'db-h3-g': row.status.toLowerCase() === 'inactive'? 'db-h3-n' : row.status.toLowerCase() === 'loss-to-follow up'? 'db-h3-r' : 'db-h3-u'}`} 
                key={row.id}>{String(value).replace(/(.)(?=(\d{3})+$)/g,'$1,')}</span>
            }
    ];

        const clientColumns = 
        [
            {
                title: 'Visit Date',
                dataIndex: 'visitDateStr',
                key: 'visitDateStr'
            },
            {
                title: 'Next Appointment',
                dataIndex: 'appointmentDateStr',
                key: 'appointmentDateStr'
            }
        ];
        
        const labColumns =
            [
                {
                    title: 'Test Date',
                    dataIndex: 'testDateStr',
                    key: 'testDateStr'
                },
                {
                    title: 'Date Reported',
                    dataIndex: 'dateReportedStr',
                    key: 'dateReportedStr'
                },
                {
                    title: 'Description',
                    dataIndex: 'description',
                    key: 'description'
                },
                {
                    title: 'Result',
                    dataIndex: 'testResult',
                    key: 'testResult'
                }
            ];       

        const {searchText, selected, client, site} = this.state;
        return (
            <div style={{marginTop: '15px', padding: '20px'}}>
                <Helmet>
                    <title>CDR - Clients</title>
                </Helmet>
                <div style={{display: selected? 'none':'block'}}>
                    <div className="custom-filter-dropdown">
                        <Row style={{ marginTop: '2px' }}>
                            <Col span={24}>
                                <h4 style={{fontWeight: 'bold', fontSize: '18px'}}>Clients&nbsp;&nbsp;{site.id > 0 && <span className="db-h3-g">: &nbsp;&nbsp;{site.name + ', ' + site.stateName}</span>}</h4>
                            </Col>
                        </Row>
                        <Row gutter={2} style={{ marginTop: '10px' }}>
                            <Col xs={8} sm={8} md={8} lg={8}>
                                <Select defaultValue="10" id="pageSize" onChange={this.handleChange} style={{ width: '60%' }}>
                                    <Option value="10">10</Option>
                                    <Option value="25">25</Option>
                                    <Option value="50">50</Option>
                                    <Option value="100">100</Option>
                                </Select>
                            </Col>
                            <Col xs={8} sm={8} md={8} lg={8}>
                                <Input className="ant-input-lg-2" style={{ width: '100%' }} placeholder="Search..." value={searchText} onChange={this.onInputChange} onPressEnter={this.onSearch} />
                            </Col>
                            <Col xs={6} sm={6} md={6} lg={6}>
                            {/* <Button  onClick={this.Add} type="primary" style={{float: 'right'}}>
                                    Add Patient
                            </Button>  */}
                            </Col>
                        </Row>
                        <br />
                       {!clientSite && <Table columns={columns} rowKey={record => record.id} dataSource={this.state.data} pagination={this.state.pagination} loading={this.state.loading} onChange={this.handleTableChange} bordered type="flex" align="middle"/>} 
                       {clientSite && <Table columns={clientSiteColumns} rowKey={record => record.id} dataSource={this.state.data} pagination={this.state.pagination} loading={this.state.loading} onChange={this.handleTableChange} bordered type="flex" align="middle"/>}
                    </div>
                </div>
                <div className="cli-nfo" style={{display: selected? 'block':'none'}}>
                    <div className="ant-modal-content">
                        <button title="Close" type="button" aria-label="Close" onClick={this.exit} className="ant-modal-close">
                            <span className="ant-modal-close-x">
                                <Icon type="close-circle" />
                            </span>
                        </button>
                        <div className={`ant-modal-header ${client.status.toLowerCase() === 'active'? 'db-b-g': client.status.toLowerCase() === 'inactive'? 'db-b-n' : client.status.toLowerCase() === 'loss-to-follow up'? 'db-b-r' : 'db-n-a'}`}>
                            <div className="ant-modal-title white-text">
                                {client.status} 
                            </div>
                        </div>
                        <div className="ant-modal-body c-form">
                            <form className="ant-form ant-form-horizontal">                               
                                <div className="ant-row">
                                    <div className="ant-col-8 padding-md">
                                        <label>Enrolment Id:</label>
                                    </div>
                                    <div className="ant-col-16 padding-md text-align-left">
                                        <h4>{client.enrolmentId}</h4>
                                    </div>
                                </div>
                                <div className="ant-row">
                                    <div className="ant-col-8 padding-md">
                                        <label>Date Of Birth:</label>
                                    </div>
                                    <div className="ant-col-16 padding-md text-align-left">
                                        <h4>{client.dateOfBirthStr}</h4>
                                    </div>
                                </div>
                                <div className="ant-row">
                                    <div className="ant-col-8 padding-md">
                                        <label>Age:</label>
                                    </div>
                                    <div className="ant-col-16 padding-md text-align-left">
                                        <h4>{client.age}years</h4>
                                    </div>
                                </div>
                                <div className="ant-row">
                                    <div className="ant-col-8 padding-md">
                                        <label>Sex:</label> 
                                    </div>
                                    <div className="ant-col-16 padding-md text-align-left">
                                        <h4>{client.sex}</h4>
                                    </div>
                                </div>
                                <div className="ant-row">
                                    <div className="ant-col-8 padding-md">
                                       <label> Site:</label>
                                    </div>
                                    <div className="ant-col-16 padding-md text-align-left">
                                        <h4>{client.siteName}</h4>
                                    </div>
                                </div>
                                <div className="ant-row">
                                    <div className="ant-col-8 padding-md">
                                        <label>State Code:</label>
                                    </div>
                                    <div className="ant-col-16 padding-md text-align-left">
                                        <h4>{client.stateCode}</h4>
                                    </div>
                                </div>
                                <div className="ant-row">
                                    <div className="ant-col-8 padding-md">
                                        <label>Hiv Confirmation Date:</label> 
                                    </div>
                                    <div className="ant-col-16 padding-md text-align-left">
                                        <h4>{client.baseline? client.baseline.hivConfirmationDateStr : ''}</h4>
                                    </div>
                                </div>
                                <div className="ant-row">
                                    <div className="ant-col-8 padding-md">
                                        <label>Enrolment Date:</label>
                                    </div>
                                    <div className="ant-col-16 padding-md text-align-left">
                                        <h4>{client.baseline ?  client.baseline.enrolmentDateStr : ''}</h4>
                                    </div>
                                </div>
                                <div className="ant-row">
                                    <div className="ant-col-8 padding-md">
                                        <label>Art Start Date:</label>
                                    </div>
                                    <div className="ant-col-8 padding-md text-align-left">
                                        <h4>{client.baseline ? client.baseline.artDateStr : ''}</h4>
                                    </div>
                                </div>
                            </form>
                            </div>
                        <div className="ant-modal-footer cl-ant">
                            <Tabs defaultActiveKey="1" size="small">
                                <TabPane tab="ART Visits" key="1">
                                    <Table columns={clientColumns} rowKey={record => record.id} dataSource={client.artVisit} bordered type="flex" align="middle" />
                                </TabPane>
                                <TabPane tab="Lab Tests" key="2">
                                    <Table columns={labColumns} rowKey={record => record.id} dataSource={client.labResult} bordered type="flex" align="middle" />
                                </TabPane>
                            </Tabs>
                        </div>
                    </div>                    
                </div>                
            </div>
        ) 
    }
}

var component = connect(
    // @ts-ignore
    state => state.patient, // Selects which state properties are merged into the component's props.
    PatientStore.actionCreators // Selects which action creators are merged into the component's props.
)(PatientPage);

// @ts-ignore
export default (withRouter(component));