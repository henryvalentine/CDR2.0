/* eslint-disable no-console */
// import "@Styles/main.css";
import * as React from "react";
import { Helmet } from "react-helmet";
import { withRouter } from "react-router";
import { fetchData, postQuery, uploadFile } from '.././utils'
import { NavLink } from "react-router-dom";
import * as SiteStore from "@Store/SiteStore";
import { connect } from "react-redux";
import { Table, Button, Select, Upload, message, Form, Row, Col, Icon, Modal } from 'antd';
const { Option } = Select;
const { Item } = Form;
const { Dragger } = Upload;

class SitePage extends React.Component 
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
                confirmLoading: false,
                title: 'New Site',
                site: { Id: '', name: '', stateCode: '', lga: '', siteId: '', state: '' },
                searchText: "",
                visible: false,
                hideUpload: false
            };

        this.selectionChanged = this.selectionChanged.bind(this);
        this.textChange = this.textChange.bind(this);
        this.exit = this.exit.bind(this);
        this.process = this.process.bind(this);
        this.Add = this.Add.bind(this);
        this.edit = this.edit.bind(this);
        this.onSearch = this.onSearch.bind(this);
        this.onInputChange = this.onInputChange.bind(this);
        this.handleChange = this.handleChange.bind(this);
        this.handleTableChange = this.handleTableChange.bind(this);
        this.getItems = this.getItems.bind(this);
        this.export = this.export.bind(this);
        this.startUpload = this.startUpload.bind(this);
        this.dwnTemplate = this.dwnTemplate.bind(this);
        this.upload = this.upload.bind(this);
        this.fileControlClicked = this.fileControlClicked.bind(this);
    }

    async componentDidMount()
    {
        const { pagination } = this.state;

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
        this.setState({ loading: true });
        var searchText = params.searchText;
        var results = params.results;
        var page = params.page;
        // var sortField = params.sortField;
        // var sortOrder = params.sortOrder;
        let el = this;

        var query = searchText ? `/api/Site/searchSite?itemsPerPage=${results}&pageNumber=${page}&searchText=${searchText}` : `/api/Site/getSites?itemsPerPage=${results}&pageNumber=${page}`;

        let res = await fetchData(query);

        const { pagination } = el.state;
            pagination.total = res.totalItems;           
            el.setState({
                data: res.sites,
                pagination,
                loading: false 
            });          
             

        if (searchText && searchText.trim().length > 0)
        {
            const reg = new RegExp(searchText, 'gi');
            this.setState({
                filtered: !!searchText,
                data: this.state.data.map((record) =>
                {
                    const match = record.siteId.toString().match(reg) || record.name.toString().match(reg) || record.state.toString().match(reg);

                    if (!match)
                    {
                        return null;
                    }
                    return {
                        ...record,
                        name: (<span> {record.name.split(reg).map((text, i) => (i > 0 ? [<span key={record.id} className="highlight">{match[0]}</span>, text] : text
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

    edit(data, row)
    {
        this.setState({ visible: true, title: 'Update Site', buttonText: 'Update', site: data });
    }

    Add()
    {
        this.setState({ visible: true, title: 'Add Site', buttonText: 'Add', site: { id: '', name: '', stateCode: '', lga: '', siteId: '', state: '' } });
    }

    fileControlClicked()
    {
        document.getElementById("txSel").click();
    }

    dwnTemplate()
    {
        window.location = "/templates/sitesTemplate.xlsx";
    }

    startUpload() {
        this.setState({hideUpload: true});
    }
      
    async process()
    {
        if (!this.state.site.name)
        {
            message.error('Provide all required input and try again');
            return;
        }
        let url = '';
        let payload = {};
        if (!this.state.site.id || this.state.site.id.length < 1) 
        {
            url = '/addSite';
            payload = { name: this.state.site.name, stateCode: this.state.site.stateCode, lga: this.state.site.lga, siteId: this.state.site.siteId, state: this.state.site.state };
        }
        else
        {
            url = '/updateSite';
            payload = { id: this.state.site.id, name: this.state.site.name, stateCode: this.state.site.stateCode, lga: this.state.site.lga, siteId: this.state.site.siteId, state: this.state.site.state };
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
            message.success(res.message);
        }
        else {
            message.error(res.message);
        }
    }
        
    exit() {
        this.setState({
            visible: false, hideUpload: false
        });
    }
    
    textChange(feture, e)
    {
        const { site } = this.state;
        site[feture] = e.target.value;
        this.setState({ site });
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

        if (res.code < 1)
        {
            message.error(res.message);
        }
        else
        {
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

    render() {
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
                title: 'Tx_curr',
                dataIndex: 'active',
                key: 'active',
                render: (value, row, index) => <span className="tb-span" key={row.id}>{String(value).replace(/(.)(?=(\d{3})+$)/g,'$1,')}</span>
                // sorter: true
            },
            {
                title: 'Tx_new',
                dataIndex: 'newClients',
                key: 'newClients',
                render: (value, row, index) => <span className="tb-span" key={row.id}>{String(value).replace(/(.)(?=(\d{3})+$)/g,'$1,')}</span>
            },            
            // {
            //     title: 'LTFU',
            //     dataIndex: 'LossToFollowUp',
            //     key: 'LossToFollowUp',
            //     render: (value, row, index) => <span className="tb-span db-h3-n" key={row.id}>{String(value).replace(/(.)(?=(\d{3})+$)/g,'$1,')}</span>
            //     // sorter: true
            // },            
            {
                title: 'Clients List',
                dataIndex: '', key: 'x',
                render: (value, row, index) => <NavLink exact to={`/patient?site=${row.id}`} title="view more" onClick={() => this.edit(value, row)} key={value.id} style={{ cursor: 'pointer' }}><Icon type="container" /></NavLink>
            }
        ];

        const { buttonText, site, title, visible, confirmLoading, hideUpload } = this.state;

        let el = this;

        const props =
        {
            name: 'file',
            multiple: false,
            accept: '.csv, application/vnd.openxmlformats-officedocument.spreadsheetml.sheet, application/vnd.ms-excel',
            beforeUpload: file =>
            {
                el.upload(file);
                return false;
            }
        };

        return (
            <div className="site-top">
                <Helmet>
                    <title>CDR - Manage Sites</title>
                </Helmet>
                <div className="custom-filter-dropdown">
                    <Row style={{ marginTop: '2px' }}>
                        <Col span={24}>
                            <h4 style={{ fontWeight: 'bold', fontSize: '18px' }}>Sites</h4>
                        </Col>
                    </Row>
                    <Row gutter={2}>
                        <Col xs={8} sm={8} md={8} lg={8}>
                            <Select defaultValue="10" id="pageSize" onChange={this.handleChange} style={{ width: '60%' }}>
                                <Option value="10">10</Option>
                                <Option value="25">25</Option>
                                <Option value="50">50</Option>
                                <Option value="100">100</Option>
                            </Select>
                        </Col>
                        <Col xs={8} sm={8} md={8} lg={8}>
                            {/* <Input className="ant-input-lg-2" style={{ width: '100%' }} placeholder="Search..." value={searchText} onChange={this.onInputChange} onPressEnter={this.onSearch} /> */}

                            <Button icon={confirmLoading ? '' : "upload"} onClick={this.startUpload} style={{ float: 'right' }}>
                                {confirmLoading ? 'Please wait...' : 'Upload Site Target'}
                            </Button>
                        </Col>
                        <Col xs={6} sm={6} md={6} lg={6}>
                            <Button icon={confirmLoading? '' : "download"} onClick={this.export} style={{ float: 'right' }}>      
                                {confirmLoading? 'Please wait...': 'Export to Excel'}
                            </Button>
                        </Col>
                    </Row>
                    <br />
                    <Table columns={columns} rowKey={record => record.id} dataSource={this.state.data} pagination={this.state.pagination} loading={this.state.loading} onChange={this.handleTableChange} bordered type="flex" align="middle"/>
                </div>
                <div className="md-wrapper">
                    <Modal className="modal-width-400 c-modal-body"
                        visible={hideUpload}
                        title= 'Upload TX_CURR Targets for Sites'
                        maskClosable={false}
                        onCancel={this.exit}
                        footer={[
                            
                        ]}>

                        <Form>
                            <div className='ant-row'>
                                <div className='ant-col-24 padding-md'>
                                    <Item> 
                                        <Dragger disabled={this.state.confirmLoading} {...props}>
                                            <p className="ant-upload-drag-icon">
                                                <Icon disabled={this.state.confirmLoading} type="inbox" />
                                            </p>
                                            <p className="ant-upload-text">
                                                {this.state.confirmLoading ? 'Processing...please wait' : 'Click or drag file to this area to upload'}
                                            </p>
                                        </Dragger>

                                        <Button disabled={this.state.confirmLoading} className="top-15-margin" icon="download" onClick={this.dwnTemplate} style={{ float: 'left' }}>
                                            Download Template
                                        </Button>
                                    </Item>                                    
                                </div>
                            </div>
                        </Form>
                    </Modal>
                    <Modal className="modal-width-500"
                        visible={visible}
                        title={title}
                        maskClosable={false}
                        onCancel={this.exit}
                        footer={[
                            <Button className="login-button" key="submit" type="primary" size="large" onClick={this.process}>
                                <span id="buttonText">{buttonText}</span>
                            </Button>
                        ]}>
                        <Form>
                            <div className='ant-row'>
                                <div className='ant-col-24 padding-md'>
                                    <Item>
                                        <input onChange={(e) => this.textChange('name', e)} name="name" type="text" className="ant-input ant-input-lg input-no-border" placeholder="Site Name" value={site.name} />
                                    </Item>                                   
                                    <Item>
                                        <input onChange={(e) => this.textChange('lga', e)} name="lga" type="text" className="ant-input ant-input-lg input-no-border" placeholder="LGA" value={site.lga} />
                                    </Item>
                                    <Item>
                                        <input onChange={(e) => this.textChange('stateCode', e)} name="stateCode" type="text" className="ant-input ant-input-lg input-no-border" placeholder="State Code" value={site.stateCode} />
                                    </Item>
                                    <Item>
                                        <input onChange={(e) => this.textChange('state', e)} name="state" type="text" className="ant-input ant-input-lg input-no-border" placeholder="State Name" value={site.state} />
                                    </Item>
                                </div>
                            </div>
                        </Form>
                    </Modal>
                </div>
            </div>
        )
    }
}

var component = connect(
    // @ts-ignore
    state => state.site, // Selects which state properties are merged into the component's props.
    SiteStore.actionCreators // Selects which action creators are merged into the component's props.
)(SitePage);

// @ts-ignore
export default (withRouter(component));