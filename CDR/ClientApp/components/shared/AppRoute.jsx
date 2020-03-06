/* eslint-disable react/prop-types */
import { Route, Redirect } from "react-router";
import * as React from "react";
import Globals from "@Globals";

const AppRoute = ({ component: Component, layout: Layout, path: Path, ...rest }) => 
{    
    
    var isLoginPath = Path === "/login";
    var user = Globals.user || (Globals.session.public !== undefined && Globals.session.public !== null? Globals.session.public.user : null);
 
    if ((user === undefined || user === null || !user.isAuthenticated) && !isLoginPath) 
    {
        return <Redirect to="/login" />;
    }
    if (user !== undefined && user !== null && user.isAuthenticated && isLoginPath) 
    {
        return <Redirect to="/home" />;
    }

    return <Route {...rest} render={props => (
        <Layout>
            <Component {...props} />
        </Layout>
    )} />;
}

export default AppRoute;