/* eslint-disable no-console */
// import "@Styles/main.css";
import * as React from "react";
import { Helmet } from "react-helmet";
import { fetchData, postQuery } from '../utils'
import Globals from "@Globals";
import { Redirect } from "react-router-dom";
import { Table, Input, Button, Select, message, Form, Row, Col, Modal } from 'antd';
const { Option } = Select;
const { Item } = Form;

export default class Regimen extends React.Component 
{

    constructor(props)
    {
        super(props);
        this.state =
            {
                buttonText: 'Add',
                data: [],
                redir: false,
                pagination:
                {
                    current: 1,
                    total: 0,
                    pageSize: 10,
                    sorter: {
                        field: "combination",
                        order: "asc"
                    }
                },
                loading: false,
                confirmLoading: false,
                title: 'New Regimen',
                regimen: { Id: '', combination: '', code: '', line: ''},
                searchText: "",
                visible: false,
            };

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
    }

    async componentDidMount()
    {      
        var user = Globals.user || (Globals.session.public !== undefined && Globals.session.public !== null ? Globals.session.public.user : null);
        if (user && user.role !== "1")
        {
            this.setState({ redir: true });
        }

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

        var query = searchText ? `/api/regimen/searchRegimen?itemsPerPage=${results}&pageNumber=${page}&searchText=${searchText}` : `/api/regimen/getRegimens?itemsPerPage=${results}&pageNumber=${page}`;

        let res = await fetchData(query);

        const { pagination } = el.state;
            pagination.total = res.totalItems;           
            el.setState({
                data: res.regimens,
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
                    const match = record.combination.toString().match(reg);

                    if (!match)
                    {
                        return null;
                    }
                    return {
                        ...record,
                        combination: (<span> {record.combination.split(reg).map((text, i) => (i > 0 ? [<span key={record.id} className="highlight">{match[0]}</span>, text] : text
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
        this.setState({ visible: true, title: 'Update regimen', buttonText: 'Update', regimen: row });
        var pushForm = document.getElementById("regimn");
        if (pushForm) {
            pushForm.addEventListener("keyup", function (event) {
                if (event.keyCode === 13) {
                    event.preventDefault();
                    document.getElementById("submit-btn").click();
                }
            });
        }  
    }

    Add()
    {
        this.setState({ visible: true, title: 'Add Regimen', buttonText: 'Add', regimen: { id: '', combination: '', code: '', line: '' } });
        var pushForm = document.getElementById("regimn");
        if (pushForm) {
            pushForm.addEventListener("keyup", function (event) {
                if (event.keyCode === 13) {
                    event.preventDefault();
                    document.getElementById("submit-btn").click();
                }
            });
        }  
    }
          
    async process()
    {
        if (!this.state.regimen.combination || !this.state.regimen.code || !this.state.regimen.line)
        {
            message.error('Provide all fields and try again');
            return;
        }
        let url = '';
        let payload = {};
        if (!this.state.regimen.id || this.state.regimen.id.length < 1) 
        {
            url = '/api/regimen/addRegimen';
            payload = { combination: this.state.regimen.combination, code: this.state.regimen.code, line: this.state.regimen.line };
        }
        else
        {
            url = '/api/regimen/updateRegimen';
            payload = { id: this.state.regimen.id, combination: this.state.regimen.combination, code: this.state.regimen.code, line: this.state.regimen.line };
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
        if (res.code > 0)
        {
            this.getItems(params);
            this.setState({ visible: false });
            message.success(res.message);
        }
        else {
            message.error(res.message);
        }
    }
        
    exit()
    {
        this.setState({ visible: false });
    }
    
    textChange(feture, e)
    {
        const { regimen } = this.state;
        regimen[feture] = e.target.value;
        this.setState({ regimen });
    }
       
    render()
    {
        const { buttonText, regimen, title, visible, confirmLoading, searchText, redir } = this.state;        
        if (redir)
        {
            return <Redirect to="/login" />;
        }

        const columns =
            [
                {
                title: 'regimen',
                dataIndex: 'combination',
                    key: 'combination',
                    render: (value, row, index) => <a key={value.id} title="view more" onClick={() => this.edit(value, row)} style={{ cursor: 'pointer' }}>{value}</a>
                },
                {
                    title: 'Regimen Line',
                    dataIndex: 'line',
                    key: 'line'
                },
                {
                    title: 'Code',
                    dataIndex: 'code',
                    key: 'code'
                }
            ];

        return (
            <div className="site-top">
                <Helmet>
                    <title>CDR - ART Regimen</title>
                </Helmet>
                <div className="custom-filter-dropdown">
                    <Row style={{ marginTop: '10px' }}>
                        <Col span={24}>
                            <h4 style={{ fontWeight: 'bold', fontSize: '18px' }}>Manage ART Regimen</h4>
                        </Col>
                    </Row>
                    <br />
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
                            <Input className="ant-input ant-input-lg input-no-border" style={{ width: '100%' }} placeholder="Search..." value={searchText} onChange={this.onInputChange} onPressEnter={this.onSearch} />
                        </Col>
                        <Col xs={6} sm={6} md={6} lg={6}>
                            <Button onClick={this.Add} type="primary" size="large" style={{float: 'right'}}>
                                Add Regimen
                            </Button>
                        </Col>
                    </Row>
                    <br />
                    <Table columns={columns} rowKey={record => record.id} dataSource={this.state.data} pagination={this.state.pagination} loading={this.state.loading} onChange={this.handleTableChange} bordered type="flex" align="middle"/>
                </div>
                <div className="md-wrapper">                   
                    <Modal className="modal-width-500"
                        visible={visible}
                        title={title}
                        maskClosable={false}
                        onCancel={this.exit}
                        footer={[
                            <Button id="submit-btn" disabled={confirmLoading} className="login-button" key="submit" type="primary" size="large" onClick={this.process}>
                                <span id="buttonText">{buttonText}</span>
                            </Button>
                        ]}>
                        <Form id="regimn">
                            <div className='ant-row'>
                                <div className='ant-col-24 padding-md'>
                                    <Item>
                                        <input onChange={(e) => this.textChange('combination', e)} combination="combination" type="text" className="ant-input ant-input-lg input-no-border" placeholder="Combination {eg. ABC-3TC-EFV}" value={regimen.combination} />
                                    </Item>                                   
                                    <Item>
                                        <input onChange={(e) => this.textChange('line', e)} combination="line" type="text" className="ant-input ant-input-lg input-no-border" placeholder="Line {eg. Adult First line, etc.}" value={regimen.line} />
                                    </Item>
                                    <Item>
                                        <input onChange={(e) => this.textChange('code', e)} combination="code" type="text" className="ant-input ant-input-lg input-no-border" placeholder="Line Code {eg. 1a, 1a-i, etc.}" value={regimen.code} />
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