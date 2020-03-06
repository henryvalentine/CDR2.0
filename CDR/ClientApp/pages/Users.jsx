// @ts-nocheck
/* eslint-disable no-console */
// import "@Styles/main.css";
import * as React from "react";
import { Helmet } from "react-helmet";
import { withRouter } from "react-router";
import { fetchData, postQuery } from '../utils';
import Globals from "@Globals";
import { Redirect } from "react-router-dom";
import * as UsersStore from "@Store/UsersStore";
// import Loader from "@Components/shared/Loader";
import { connect } from "react-redux";
import { Table, Input, Button, Select, Form, Row, message, Col, Icon, Menu, Modal } from 'antd';
const { Option } = Select;
const {Item} = Form;

class Users extends React.Component 
{
    constructor(props)
    {
        super(props);
        this.state =
            {
                buttonText: 'Add',
                data: [],
                roles: [],
                redir: false,
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
                userId: 0,
                loading: false,
                confirmLoading: false,
                title: 'New User',
                user: {id: '', firstName: '', lastName: '', userName: '', email: '', password: '', confirmPassword: '', role: ''},
                searchText: "",
                visible: false,
                selected: false
            };           

        this.selectionChanged = this.selectionChanged.bind(this);
        this.textChange = this.textChange.bind(this);
        this.exit = this.exit.bind(this);
        this.process = this.process.bind(this);
        this.edit = this.edit.bind(this);
        this.add = this.add.bind(this);
        this.onSearch = this.onSearch.bind(this);
        this.onInputChange = this.onInputChange.bind(this);
        this.handleChange = this.handleChange.bind(this);
        this.handleTableChange = this.handleTableChange.bind(this);
        this.getItems = this.getItems.bind(this);
        this.handleSelectChange = this.handleSelectChange.bind(this);
        this.selectRole = this.selectRole.bind(this);
    }   

    async componentDidMount()
    {
        var user = Globals.user || (Globals.session.public !== undefined && Globals.session.public !== null ? Globals.session.public.user : null);
        if (user && user.role !== "1")
        {
            this.setState({ redir: true });
        }
        var pushForm = document.getElementById("users");
        if (pushForm)
        {
            pushForm.addEventListener("keyup", function (event)
            {
                if (event.keyCode === 13)
                {
                    event.preventDefault();
                    document.getElementById("submit-btn").click();
                }
            });
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

    async UNSAFE_componentWillMount()
    {
        let roles = await fetchData(`/api/Account/getRoles`);
        this.setState({ roles: roles });
    }

    async selectRole(value)
    {
        const { user } = this.state;
        let role = "";
        if (value)
        {
            role = value.key;
        }
        user.role = role;
        this.setState({ user });
    }

    edit(data, row)
    {
        this.setState({ visible: true, title: 'Update User', buttonText: 'Update', user: data });
    }

    add()
    {
        this.setState({visible: true, title: 'Add User', buttonText: 'Add', user: {id: '', firstName: '', lastName: '', userName: '', email: '', password: '', confirmPassword: '', role: ''}});
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
        
        var query = searchText ? `/api/Account/searchUsers?itemsPerPage=${results}&pageNumber=${page}&searchText=${searchText}` 
            : `/api/Account/getUsers?itemsPerPage=${results}&pageNumber=${page}`;
       
        el.setState({loading: true});
        
        let res = await fetchData(query);

        el.setState({loading: false});

        if (res.users.length > 0)
        {
            res.users.map(function (r)
            {
                r.password = '';
                r.confirmPassword = '';

                let rr = el.state.roles.filter(function (f) { return f.id === r.role});
                if (rr.length > 0)
                {
                    r.roleName = rr[0].name;
                }
                else
                {
                    r.roleName = "";
                }
            });

            const { pagination } = el.state;
            pagination.total = res.totalItems;           
            el.setState({
                data: res.users,
                pagination
            });
        }

        if (searchText && searchText.trim().length > 0)
        {
            const reg = new RegExp(searchText, 'gi');
            this.setState({
                filtered: !!searchText,
                data: this.state.data.map((record) =>
                {
                    const match = record.firstName.toString().match(reg) || record.lastName.toString().match(reg) || record.email.toString().match(reg);

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

    async getUser(row)
    {
        let el = this;

        var query = `/api/Account/getUser?id=${row.id}`;

        el.setState({ loading: true });

        let user = await fetchData(query);
        el.setState({ loading: false });
      
        if (user.id > 0)
        {          
            el.setState({
                user: user,
                visible: true
            });
        }
        else
        {
            message.error('User information could not be retrieved');
        }
    }
      
    async process()
    {
        if (!this.state.user.firstName)
        {
            message.error("Please provide User's First Name");
            return;
        }
        if (!this.state.user.lastName)
        {
            message.error("Please provide User's Last Name");
            return;
        }
        if (!this.state.user.lastName)
        {
            message.error("Please provide User's Last Name");
            return;
        }
        if (!this.state.user.role || this.state.user.role.length < 1)
        {
            message.error("Please select a role for user");
            return;
        }
        if (!this.state.user.email)
        {
            message.error("Please provide User's Email");
            return;
        }
        if (!this.state.user.id)
        {
            if (!this.state.user.password)
            {
                message.error("Please provide User's Password");
                return;
            }
            if (!this.state.user.confirmPassword)
            {
                message.error("Please confirm User's confirmPassword");
                return;
            }
        }
        let url = '';
        let payload = {};
        if (!this.state.user.id || this.state.user.id.length < 1) {
            url = '/api/Account/register';
            payload =  
            {
                firstName: this.state.user.firstName, 
                lastName: this.state.user.lastName, 
                userName: this.state.user.email,
                email: this.state.user.email,
                password: this.state.user.password,
                confirmPassword: this.state.user.confirmPassword,
                role: this.state.user.role
            }
        }
        else 
        {
            url = '/api/Account/updateUser';
            payload =  
            { 
                id: this.state.user.id, 
                firstName: this.state.user.firstName, 
                lastName: this.state.user.lastName, 
                userName: this.state.user.userName,
                email: this.state.user.email,
                password: this.state.user.password,
                confirmPassword: this.state.user.confirmPassword,
                role: this.state.user.role
            };
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
        else
        {
           message.error(res.message);
        }
    }
    
    exit() {
        this.setState({
            visible: false
        });
    }

    handleSelectChange(feature, value, target) 
    {
        // console.log(value); // { key: "lucy", label: "Lucy (101)" }
        let user = this.state.user;
        user[feature] = value[target];
        this.setState({user});
    }

    textChange(feture, e)
    {
        const { user } = this.state;
        user[feture] = e.target.value;
        this.setState({ user });
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
        const { searchText, selected, user, confirmLoading, buttonText, visible, title, roles, redir } = this.state;
        if (redir)
        {
            return <Redirect to="/login" />;
        }


        const columns =
            [
                {
                    title: 'First Name',
                    dataIndex: 'firstName',
                    key: 'firstName'
                },
                {
                    title: 'Last Name',
                    dataIndex: 'lastName',
                    key: 'lastName',
                    // sorter: true
                },
                {
                    title: 'Email',
                    dataIndex: 'email',
                    key: 'email'
                    // sorter: true
                },
                {
                    title: 'Role',
                    dataIndex: 'roleName',
                    key: 'roleName',
                    // sorter: true
                },
                {
                    title: 'Update',
                    dataIndex: '', key: 'x',
                    render: (value, row, index) => <a key={value.id} title="update" onClick={() => this.edit(value, row)} style={{cursor: 'pointer'}}><Icon type="edit" /></a>
                }
        ];         
        
        return (
            <div style={{marginTop: '15px', padding: '20px'}}>
                <Helmet>
                    <title>CDR - Users</title>
                </Helmet>
                <div style={{display: selected? 'none':'block'}}>
                    <div className="custom-filter-dropdown">
                        <Row style={{ marginTop: '2px' }}>
                            <Col span={24}>
                                <h4 style={{fontWeight: 'bold', fontSize: '18px'}}>Users</h4>
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
                            <Button  onClick={this.add} type="primary" style={{float: 'right'}}>
                                Add User
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
                                <Button id="submit-btn" className="login-button" loading={confirmLoading} key="submit" type="primary" size="large" onClick={this.process}>
                                    <span id="buttonText">{buttonText}</span>
                                </Button>
                            ]}>

                            <Form id="users">
                                <div className='ant-row'>
                                    <div className='ant-col-24 padding-md'>
                                        <Item>
                                            <input onChange={(e) => this.textChange('firstName', e)} name="firstName" type="text" className="ant-input ant-input-lg input-no-border" placeholder="First Name *" value={user.firstName} />
                                        </Item>                                   
                                        <Item>
                                            <input onChange={(e) => this.textChange('lastName', e)} name="lastName" type="text" className="ant-input ant-input-lg input-no-border" placeholder="lastName *" value={user.lastName} />
                                        </Item>
                                        <Item>
                                            <input onChange={(e) => this.textChange('email', e)} name="email" type="email" className="ant-input ant-input-lg input-no-border" placeholder="Email *" value={user.email} />
                                        </Item>
                                        <Item>
                                            <input onChange={(e) => this.textChange('password', e)} name="password" type="password" className="ant-input ant-input-lg input-no-border" placeholder="Password *" value={user.password} />
                                        </Item>
                                        <Item>
                                            <input onChange={(e) => this.textChange('confirmPassword', e)} name="confirmPassword" type="password" className="ant-input ant-input-lg input-no-border" placeholder="Confirm Password *" value={user.confirmPassword} />
                                        </Item>
                                        <Item>   
                                            <Select
                                                labelInValue
                                                style={{ width: '100%' }}
                                                value={{ key: user.role }}
                                                placeholder="Select Role"
                                                onChange={(value) => this.selectRole(value)}
                                            >
                                                <Option value="">-- Select Role --</Option>
                                                {roles && roles.map(s => <Option key={s.id} value={s.id}>{s.name}</Option>)}
                                            </Select>
                                        </Item>
                                    </div>
                                </div>
                            </Form>
                        </Modal>
                    </div>
            </div>              
        </div>
    )}
}

var component = connect(
    // @ts-ignore
    state => state.users, // Selects which state properties are merged into the component's props.
    UsersStore.actionCreators // Selects which action creators are merged into the component's props.
)(Users);

// @ts-ignore
export default (withRouter(component));