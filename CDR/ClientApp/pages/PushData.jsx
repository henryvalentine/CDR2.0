/* eslint-disable no-console */
import * as React from "react";
import { Helmet } from "react-helmet";
import { withRouter } from "react-router";
import { Redirect } from "react-router-dom";
import { fetchData, postQuery, uploadFile } from '../utils';
import * as PushDataStore from "@Store/PushDataStore";
//import DropZ from "@Components/shared/dropz";
import { connect } from "react-redux";
import { Input, Button, Select, Upload, Form, message, Icon, Row, Col } from 'antd';
const { Option } = Select;
const { Item } = Form;
const { Dragger } = Upload;


class PushData extends React.Component 
{
    constructor(props)
    {
        super(props);
        this.state =
            {
                loading: false,
                statesLoaded: true,
                allSites: [],
                pushdata: 
                { 
                    server: '', userName: '', password: '', uploadExisted: false, stateCode: '', id: '', siteId: '', siteCode: '', ItemsPerPage: 20,
                    LastAdultArvVistPage: 1, LastPaediatricArvVisitPage: 1, LastAdultArtBaselinePage: 1, sourceId: 0,
                    LastPaediatricArtBaselinePage: 1, LastPatientPage: 1, LastLabResultPage: 1, Target: 1, conn: '', ipAddress: ''
            },
            confirmLoading: false,

                sites: [],
                sources: [{ id: 1, name: 'MSSQL Server' }, {id: 2, name: 'MySQL'}],
                states: [],
                result: {patients: 0, adultBaseline: 0, paediatricBaseline: 0, adultVisits: 0, paediatricVisits: 0, labresults: 0}
            };

        this.textChange = this.textChange.bind(this);
        this.pushdata = this.pushdata.bind(this);
        this.selectSite = this.selectSite.bind(this);
        this.selectState = this.selectState.bind(this);      
        this.push = this.push.bind(this);    
        this.reset = this.reset.bind(this);   
        this.startUpload = this.startUpload.bind(this);
        this.upload = this.upload.bind(this);
        this.fileControlClicked = this.fileControlClicked.bind(this);
        this.processdata = this.processdata.bind(this);
    }    

    fileControlClicked()
    {
        document.getElementById("txSel").click();
    }

    async upload(file)
    {
        //let file = e.target.files[0];
        let form = new FormData();
        form.append('file', file);
        form.append('fileName', file.name);
        console.log(form);
        this.setState({ confirmLoading: true });
        let res = await uploadFile('/api/Site/processeTxNew', form);
        this.setState({ confirmLoading: false });

        if (res.code < 1) {
            message.error(res.message);
        }
        else {
            message.success(res.message);
            const { pagination } = this.state;
            this.setState({ hideUpload: false });
            this.getItems({
                results: pagination.pageSize,
                searchText: this.state.searchText,
                page: pagination.current,
                sortField: pagination.sorter.field,
                sortOrder: pagination.sorter.order
            });
        }
    }

    startUpload() {
        this.setState({ hideUpload: true });
    }

    async componentDidMount()
    {
        var pushForm = document.getElementById("push-form");
        if (pushForm)
        {
            pushForm.addEventListener("keyup", function (event)
            {
                if (event.keyCode === 13) {
                    event.preventDefault();
                    document.getElementById("push-btn").click();
                }
            });
        }        

        let sts = localStorage.getItem("states");
        let states = [];
        if (sts) states = JSON.parse(sts);
        let statesLoaded = true;
        if (!states || states.length < 1) statesLoaded = false;

        let sitesList = localStorage.getItem("sites");
        let sites = [];
        if (sitesList) sites = JSON.parse(sitesList);

        this.setState({ states: states, allSites: sites, statesLoaded: statesLoaded });
        
    }
    
    textChange(feture, e)
    {
        const { pushdata } = this.state;
        pushdata[feture] = e.target.value;
        this.setState({ pushdata });
    }

    async selectSite(feature, value) 
    {        
        if(!value)
        {
            message.error('Please Select a Site')
            return;
        }
        let val = value.key;
        let el = this;
        if(parseInt(val) < 1)
        {
            message.error('Please Select a Site')
            return;
        } 
        let pushdata = el.state.pushdata;
        pushdata[feature] = val;
        el.setState({pushdata});         
       
        el.setState({pushdata, confirmLoading: true});
        let url = '/api/Patient/getLastTrack?siteId=' + val
        let tracker = await fetchData(url);
        el.setState({ confirmLoading: false });
        let pushd = el.state.pushdata;
        
        pushd.LastAdultArvVistPage = tracker.lastAdultArvVistPage + 1;
        pushd.LastPaediatricArvVisitPage = tracker.lastPaediatricArvVisitPage + 1;
        pushd.LastAdultArtBaselinePage = tracker.lastAdultArtBaselinePage + 1; 
        pushd.LastPaediatricArtBaselinePage = tracker.lastPaediatricArtBaselinePage + 1;
        pushd.LastPatientPage = tracker.lastPatientPage + 1;
        pushd.LastLabResultPage = tracker.lastLabResultPage + 1;
        pushd.Target = 1;
        pushd.ipAddress = tracker.ipAddress;
        //pushd.server = tracker.ipAddress;
        pushd.siteCode = el.state.sites.find(s => s.id === val).siteId;
        el.setState({ pushdata: pushd, result: { patients: 0, adultBaseline: 0, paediatricBaseline: 0, adultVisits: 0, paediatricVisits: 0, labresults: 0 } }); 
        
        //pushd.LastAdultArvVistPage = tracker.lastAdultArvVistPage > 0 ? tracker.lastAdultArvVistPage + 1 : pushd.LastAdultArvVistPage;
        //pushd.LastPaediatricArvVisitPage = tracker.lastPaediatricArvVisitPage > 0 ? tracker.lastPaediatricArvVisitPage + 1 : pushd.LastPaediatricArvVisitPage;
        //pushd.LastAdultArtBaselinePage = tracker.lastAdultArtBaselinePage > 0 ? tracker.lastAdultArtBaselinePage + 1 : pushd.LastAdultArtBaselinePage;
        //pushd.LastPaediatricArtBaselinePage = tracker.lastPaediatricArtBaselinePage > 0 ? tracker.lastPaediatricArtBaselinePage + 1 : pushd.LastPaediatricArtBaselinePage;
        //pushd.LastPatientPage = tracker.lastPatientPage > 0 ? tracker.lastPatientPage + 1 : pushd.LastPatientPage;
        //pushd.LastLabResultPage = tracker.lastLabResultPage > 0 ? tracker.lastLabResultPage + 1 : pushd.LastLabResultPage;
    }

    async selectSource(feature, value)
    {
        if (!value)
        {
            message.error('Please Select a Data source type')
            return;
        }
        let val = value.key;
        let el = this;
        if (parseInt(val) < 1)
        {
            message.error('Please Select a Data source type')
            return;
        }
        let pushd = el.state.pushdata;
        pushd.sourceId = val;       
        el.setState({ pushdata: pushd });
    }
    
    async selectState(feature, value) 
    {
        if(!value)
        {
            message.error('Please Select a State')
            return;
        }

        let pushdata = this.state.pushdata;
        pushdata[feature] = value.key;
           
        let sites = [];

        if (this.state.allSites.length > 0)
        {
            sites = this.state.allSites.filter(function (s)
            {
                return s.stateId === value.key;
            });
        }         

        this.setState({ sites: sites, pushdata });
                
        if (sites.length < 1)
        {
            message.error('Site list is empty');
        }
    }

    async reset() 
    {
       this.setState({pushdata: 
                { 
                    server: '', userName: '', password: '', stateCode: '', siteId: '', ItemsPerPage: 20,
                    LastAdultArvVistPage: 1, LastPaediatricArvVisitPage: 1, LastAdultArtBaselinePage: 1, 
                    LastPaediatricArtBaselinePage: 1, LastPatientPage: 1, LastLabResultPage: 1, Target: 1
                },
                confirmLoading: false,
                result: {patients: 0, adultBaseline: 0, paediatricBaseline: 0, adultVisits: 0, paediatricVisits: 0, labresults: 0}
            });
    }

    async pushdata()
    {
        let el = this;
        if(!el.state.pushdata.server)
        {
            message.error('Please provide Source Server Address')
            return;
        }
        if (el.state.pushdata.server === "You are not connected to the internet")
        {
            message.error('Please provide Source Server Address')
            return;
        }        

        if(!el.state.pushdata.userName)
        {
            message.error('Please provide Source Server UserName')
            return;
        }
        if(!el.state.pushdata.password)
        {
            message.error('Please provide Source Server Password')
            return;
        }
        if(!el.state.pushdata.siteId)
        {
            message.error('Please Select a Site')
            return;
        }
        if(parseInt(el.state.pushdata.siteId) < 1)
        {
            message.error('Please Select a Site')
            return;
        }   

        //if (el.state.pushdata.sourceId < 1)
        //{
        //    message.error('Please Select a Data source type')
        //    return;
        //}

        //el.setState({ confirmLoading: true });
        //let res = await postQuery('/api/Patient/cleanDb', JSON.stringify(el.state.pushdata));
        //if (res.code === -1)
        //{
        //    el.setState({ confirmLoading: false });
        //    let msg = res.message || 'An unknown error was encountered. Please try again later';
        //    message.error(msg);
        //}
        //else
        //{
            let url = '/api/Patient/pushData'
            this.push(url);  
        //}
           
    }

    async push(url)
    {
        let el = this;   
        el.setState({ confirmLoading: true });
        let res = await postQuery(url, JSON.stringify(el.state.pushdata));   
        let result = el.state.result;
        if(res.code === -1)
        {
            el.setState({ confirmLoading: false });
            let msg = res.message || 'An unknown error was encountered. Please try again later';
            message.error(msg);
        }
        else
        {
            let pushdata = el.state.pushdata
            if(res.code > 0)
            {
                if(pushdata.Target === 1)
                {
                    result.patients += res.code;
                    pushdata.LastPatientPage += 1;                
                }
                if(pushdata.Target === 2)
                {
                    result.adultBaseline += res.code;
                    pushdata.LastAdultArtBaselinePage += 1;                
                }
                if(pushdata.Target === 3)
                {
                    result.paediatricBaseline += res.code; 
                    pushdata.LastPaediatricArtBaselinePage += 1;               
                }
                if(pushdata.Target === 4)
                {
                    result.adultVisits += res.code;    
                    pushdata.LastAdultArvVistPage += 1;            
                }
                if(pushdata.Target === 5)
                {
                    result.paediatricVisits += res.code;    
                    pushdata.LastPaediatricArvVisitPage += 1;            
                }
                if(pushdata.Target === 6)
                {
                    result.labresults += res.code;    
                    pushdata.LastLabResultPage += 1;            
                }
                el.setState({result: result, pushdata: pushdata});
                el.push(url);
            }
            else
            {
                let target = pushdata.Target === 1? 2 : pushdata.Target === 2? 3 : pushdata.Target === 3? 4 : pushdata.Target === 4? 5 : pushdata.Target === 5? 6 : 1;
                pushdata.Target = target;           

                if(pushdata.Target > 1)
                {
                    el.setState({pushdata: pushdata});
                    el.push(url);
                }   
                else
                {
                    el.setState({ confirmLoading: false });
                    message.success('Process has completed');
                }         
            }
        }

    }

    async processdata()
    {
        let el = this;
        el.setState({ confirmLoading: true });
        let res = await postQuery('/api/NDRProcessor/processData');
        el.setState({ confirmLoading: false });
        console.log(res);
    }
    
    render() 
    {        
        const { pushdata, confirmLoading, sites, result, states, statesLoaded, sources } = this.state;
        let el = this;
        const props =
        {
            name: 'file',
            multiple: true,
            accept: '.zip,application/octet-stream,application/zip,application/x-zip,application/x-zip-compressed',
            action: '/api/NDRProcessor/uploadNmrs',
            onChange(info)
            {
                const { status } = info.file;

                if (status !== 'uploading')
                {
                    console.log(info.file, info.fileList);
                }
                if (status === 'done')
                {
                    message.success(`${info.file.name} file uploaded successfully.`);
                } else if (status === 'error')
                {
                    message.error(`${info.file.name} file upload failed.`);
                }
            }
        };
               
        if (!statesLoaded) {
            return <Redirect to="/home" />;
        }

        return (
            <div style={{marginLeft: 'auto', marginRight: 'auto', backgroundColor: '#fff', paddingBottom: '40px'}}>
                <Helmet>
                    <title>CDR - Upload Files</title>
                </Helmet>
                <Row style={{paddingTop: '20px', marginBottom: '20px'}}>
                    <Col span={24} style={{textAlign: 'center'}}>
                        <h4 style={{ fontWeight: 'bold', fontSize: '18px' }}>Upload Files</h4>
                    </Col>
                </Row>  
                <Row style={{ paddingTop: '20px', marginBottom: '20px' }}>
                    <Col xs={24} sm={6} md={6} lg={6} xl={6}>
                    </Col>
                    <Col xs={24} sm={12} md={12} lg={12} xl={12} style={{ textAlign: 'center', height: '300px !important' }}>
                        <Dragger {...props}>
                            <p className="ant-upload-drag-icon">
                            </p>
                            <p className="ant-upload-text">Click or drag file (s) to this area to upload</p>
                        </Dragger>
                    </Col>
                    <Col xs={24} sm={6} md={6} lg={6} xl={6}>
                    </Col>

                    <Col span={12} style={{ textAlign: 'center' }}>
                        <Button className="login-button" id="push-btn" loading={confirmLoading} key="submit" type="primary" size="large" onClick={this.processdata} style={{ paddingRight: '40px', paddingLeft: '40px', float: 'left' }}>
                            <span id="buttonText">{!confirmLoading ? 'Process Data' : 'Processing...'}</span>
                        </Button>
                    </Col>
                </Row>                              
            </div>
        )
    }
}

var component = connect(
    // @ts-ignore
    state => state.patient, // Selects which state properties are merged into the component's props.
    PushDataStore.actionCreators // Selects which action creators are merged into the component's props.
)(PushData);

// @ts-ignore
export default (withRouter(component));