import GuestLayout from "@Layouts/GuestLayout";
import AppRoute from "@Components/shared/AppRoute";
import * as React from 'react';
import { Switch } from 'react-router-dom';
import HomePage from '@Pages/HomePage';
import SitePage from '@Pages/SitePage';
import PatientPage from '@Pages/PatientPage';
import Users from '@Pages/Users';
import Regimen from '@Pages/Regimen';
import SiteQuery from '@Pages/SiteQuery';
import LineList from '@Pages/LineList';
import StateQuery from '@Pages/StateQuery';
import PushData from '@Pages/PushData';
import LoginPage from '@Pages/LoginPage';

export const routes = <Switch>
    <AppRoute layout={GuestLayout} exact path="/login" component={LoginPage} />
    <AppRoute layout={GuestLayout} exact path="/" component={HomePage} />
    <AppRoute layout={GuestLayout} exact path="/home" component={HomePage} />
    <AppRoute layout={GuestLayout} exact path="/lineList" component={LineList} />
    <AppRoute layout={GuestLayout} exact path="/pushdata" component={PushData} />
    <AppRoute layout={GuestLayout} exact path="/site" component={SitePage} />
    <AppRoute layout={GuestLayout} exact path="/siteQuery" component={SiteQuery} />
    <AppRoute layout={GuestLayout} exact path="/stateQuery" component={StateQuery} />
    <AppRoute layout={GuestLayout} exact path="/patient" component={PatientPage} />
    <AppRoute layout={GuestLayout} exact path="/regimen" component={Regimen} />
    <AppRoute layout={GuestLayout} exact path="/users" component={Users} />
    <AppRoute layout={GuestLayout} path="/patient?site=" component={PatientPage} />
</Switch>;