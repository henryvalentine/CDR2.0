/* eslint-disable react/prop-types */
import "@Styles/guestLayout.scss";
// import "@Styles/main.css";
import * as React from "react";
import { ToastContainer } from "react-toastify";
import TopMenu from "@Components/shared/TopMenu";
import "@Styles/authorizedLayout.scss";
import Footer from "@Components/shared/Footer";
import '@babel/polyfill';
import Globals from "@Globals";
// import {Layout} from 'antd';


export default class GuestLayout extends React.Component 
{
    render()
    {
        var user = Globals.user || (Globals.session.public !== undefined && Globals.session.public !== null? Globals.session.public.user : null);
        return <div id="guestLayout" className="layout">
            {(user !== undefined && user !== null && user.isAuthenticated)? 
            <TopMenu />
            : ''}
                <div className="container containerx  container-content">
                    {this.props.children}
                </div>
                <ToastContainer />
                {(user !== undefined && user !== null && user.isAuthenticated)? 
                <Footer /> 
                : '' }
        </div>;
    }
}