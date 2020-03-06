import * as LoginStore from "@Store/LoginStore";
import "@Styles/login.css";
import * as React from "react";
import { Helmet } from "react-helmet";
import defaultImage from '../images/cihp_2.jpeg';
import { connect } from "react-redux";
import { Redirect, RouteComponentProps, withRouter } from "react-router";
import { Button, Icon, Input, Select, Form, Row, Col, message} from 'antd';
const {Item} = Form;

class LoginPage extends React.Component 
{
    constructor(props) 
    {
        super(props);
        this.state = 
        {
            confirmLoading: false,
            user: {email : '',  password: ''}
        }
        this.login = this.login.bind(this);
        this.textChange = this.textChange.bind(this);
    }

    componentDidMount() 
    {        
        this.props.init();

        var loginForm = document.getElementById("login-form");
        if (loginForm && loginForm !== null)
        {
            loginForm.addEventListener("keyup", function (event)
            {
                if (event.keyCode === 13) {
                    event.preventDefault();
                    document.getElementById("login-button").click();
                }
            });
        }        
    }

    textChange(feture, e)
    {
        const { user } = this.state;
        user[feture] = e.target.value;
        this.setState({ user });
    }

    async login(event) 
    {
        event.preventDefault();
        if (!this.state.user.email)
        {
            message.error("Please provide User's Email");
            return;
        }
        if (!this.state.user.password)
        {
            message.error("Please provide User's Password");
            return;
        }

        // var data = this.elForm.getData();
        this.setState({confirmLoading: true});
        let res = await this.props.loginRequest(this.state.user);
        this.setState({ confirmLoading: false });
        if (res.code < 1)
        {
            message.error(res.message);
            return;
        }
    }

    render() {

        if (this.props.indicators.loginSuccess)
        {
            return <Redirect to="/home"/>;
        }

        const {confirmLoading, user} = this.state;

        return <div id="loginPage" className="main-bg">

            <Helmet>
                <title>Login - CDR</title>
            </Helmet>                       
            <h3  className="title">
                CDR
            </h3>	
            {/* <div className="bg-glass"></div> */}
            <div className="sub-main-w3">
                <div className="bg-content-w3pvt">
                    <div className="top-content-style">
                        <img className="logo" src={defaultImage} alt="" />
                    </div>
                    <div className="access-div">
                        <p className="legend">Login Here<span className="fa fa-hand-o-down"></span></p>
                        <Form id="login-form">
                            <Row>                                        
                                <Item>
                                    <Col span={24}>
                                        <Input onChange={(e) => this.textChange('email', e)} className="ant-input-lg input-no-border" suffix={<Icon type="mail" />} type="email" placeholder="Email *" name="email" required value={user.email}/>
                                    </Col>                                    
                                </Item>
                                <Item>
                                    <Col span={24}>                                            
                                    <Input.Password onChange={(e) => this.textChange('password', e)} className="ant-input-lg input-no-border" type="password" placeholder="Password *" name="password" required value={user.password}/>
                                    </Col>                                    
                                </Item>
                                <Item style={{marginBottom: '2px !important'}}>
                                    <Col className="logY" span={24} style={{textAlign: 'center'}}>
                                        <Button className="login-button" id="login-button" loading={confirmLoading} key="submit" type="primary" size="large" onClick={this.login} style={{paddingRight: '40px', paddingLeft: '40px', backgroundColor: '#1cc7d0 !important', borderColor: '#1cc7d0 !important'}}>
                                        {confirmLoading? 'Please wait...': <Icon type="login" />}
                                        </Button>
                                    </Col>
                                </Item>                               
                            </Row>
                        </Form>
                    </div>
                </div>
                </div>
                <div className="copyright">
                    <h2>&copy; 2019 Clinical Data Repository. All rights reserved
                    </h2>
                </div>            
            </div>
            
    }
}

var component = connect(
    state => state.login, // Selects which state properties are merged into the component's props
    LoginStore.actionCreators // Selects which action creators are merged into the component's props
)(LoginPage);

export default (withRouter(component));

