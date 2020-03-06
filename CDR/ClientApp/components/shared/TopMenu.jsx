// @ts-nocheck
import * as React from "react";
import { withRouter } from "react-router";
import { Button, Icon, Row, Col, Avatar, Menu, Dropdown, message } from 'antd';
const { SubMenu } = Menu;
import { NavLink, Redirect } from "react-router-dom";
import { postQuery } from '../../utils';
import defaultImage from '../../images/cihp_2.jpeg';
import Globals from "@Globals";

class TopMenu extends React.Component
 {    
    constructor(props) 
    {
        super(props);
        this.state = { logoutAction: false, current: '' };
        this.logout = this.logout.bind(this);
    }

    async logout() 
    {        
        var url = "api/Account/logout";
        await postQuery(url);
        Globals.user = null;
        Globals.reset(null);
        this.setState({ logoutAction: true });
    }
    
    componentDidMount() 
    {
       
    }

    handleClick(e)
    {
        this.setState({
            current: e.key,
        });
    }

    render() {

        if (this.state.logoutAction)
            return <Redirect to="/login" />;
        var user = Globals.user || (Globals.session.public !== undefined && Globals.session.public !== null ? Globals.session.public.user : null);
        const menu = (
            <Menu className='it-mn'>
                <Menu.Item key="1">
                    {user.firstName}
                </Menu.Item>
                {(user && user.role === "1")? < Menu.Item key="2">
                        <NavLink exact to={'/users'} activeClassName="active">Users</NavLink>
                    </Menu.Item> : ''}
                {(user && user.role === "1") ? <Menu.Item key="3">
                        <NavLink exact to={'/regimen'} activeClassName="active">Regimen</NavLink>
                    </Menu.Item>: ''}
                    <Menu.Item key="4">
                        <a style={{cursor: 'pointer'}} onClick={this.logout}>Sign out</a>
                    </Menu.Item>
                </Menu>
        );

        const perf = (
            <Menu className='it-mn'>
                <Menu.Item key="1">
                    <NavLink exact to={'/stateQuery'}>States</NavLink>
                </Menu.Item>
                <Menu.Item key="2">
                    <NavLink exact to={'/siteQuery'}>Sites</NavLink>
                </Menu.Item>
            </Menu>
        );


        return <div className="navbar navbar-default">            
            <div className="container-fluid">
                <div className="lg">
                    <NavLink exact to={'/home'} activeClassName="active"><img className="logo" src={defaultImage} alt="" /></NavLink>
                </div>                
                <div className="navbar-header">
                    <button  type="button" className="navbar-toggle collapsed" data-toggle="collapse" data-target="#navbar" aria-expanded="false" aria-controls="navbar">
                        <span className="sr-only">Toggle navigation</span>
                        <span className="icon-bar"></span>
                        <span className="icon-bar"></span>
                        <span className="icon-bar"></span>
                    </button>
                    <NavLink className="navbar-brand app-label" exact to={'/home'} activeClassName="active">CDR</NavLink>
                </div>

                <Menu className="ant-mn" onClick={(e) => this.handleClick(e)} selectedKeys={[this.state.current]} mode="horizontal">
                    <Menu.Item key="auth" className="top-menu-item">
                        {(user !== undefined && user !== null && user.isAuthenticated) ?
                            <Dropdown overlay={menu} style={{ width: '100%', float: 'right', paddingTop: '10px' }}>
                                <Button className="profileStyle">
                                    <Avatar id="userIcon" className="userIcon" icon="user" />
                                </Button>
                            </Dropdown>
                            :
                            <NavLink className="glyphicon glyphicon-log-in" role="button" exact to={'/login'} activeClassName="active"></NavLink>
                        }
                    </Menu.Item>
                    <Menu.Item key="import">
                        <Icon type="upload" /> <span><NavLink exact to={'/pushdata'} activeClassName="active">Import Data</NavLink></span>   
                    </Menu.Item>
                    <Menu.Item key="home">
                        <Icon type="home" />
                        <span> <NavLink exact to={'/site'} activeClassName="active">Sites</NavLink></span>   
                    </Menu.Item>
                    <Menu.Item key="team">
                        <Icon type="team" />
                        <span><NavLink exact to={'/patient'} activeClassName="active">Clients</NavLink></span>                        
                    </Menu.Item>
                    <Menu.Item key="perf" className="top-menu-item">                               
                        <Dropdown overlay={perf}>                               
                            <Dropdown overlay={perf}>
                                <Button>
                                    <Icon type="carry-out" /> Performances
                                </Button>
                            </Dropdown>
                        </Dropdown>                        
                    </Menu.Item>
                    <Menu.Item key="history">         
                        <Icon type="diff" />
                        <span><NavLink exact to={'/lineList'}>Aggregates</NavLink></span>                        
                    </Menu.Item>               
                </Menu>                 
            </div>
        </div>;
    }
}

export default withRouter(TopMenu);

//<Icon type="team" />
//<Icon type="import" />
//<Icon type="home" />
//<ul className="nav navbar-nav">
//    <li><NavLink exact to={'/patient'} activeClassName="active">Clients</NavLink></li>
//    <li><NavLink exact to={'/site'} activeClassName="active">Sites</NavLink></li>
//    <li><NavLink exact to={'/pushdata'} activeClassName="active">Push Data</NavLink></li>

//    {(user !== undefined && user !== null && user.isAuthenticated) ?
//        <li style={{ paddingTop: '10px' }}>
//            <Dropdown overlay={menu} style={{ width: '100%', float: 'right' }}>
//                <Button className="profileStyle">
//                    <Avatar id="userIcon" className="userIcon" icon="user" />
//                </Button>
//            </Dropdown>
//        </li>
//        :
//        <li>
//            <NavLink className="glyphicon glyphicon-log-in" role="button" exact to={'/login'} activeClassName="active"></NavLink>
//        </li>
//    }
//</ul>