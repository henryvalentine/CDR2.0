/* eslint-disable standard/object-curly-even-spacing */
/* eslint-disable no-console */
// import "@Styles/main.css";
import * as React from "react";
import { Helmet } from "react-helmet";
import Highcharts from 'highcharts';
import waiter from '../images/cihp_waiter.gif';
import { NavLink, Redirect } from "react-router-dom";
// import HighchartsReact from 'highcharts-react-official';
import {fetchData} from '../utils'
import { Button, Card, Row, Col, Icon } from 'antd';

export default class HomePage extends React.Component 
{
    constructor(props) 
    {
        super(props);

        this.state =
         {
            labresult: false,
            linelist: false,
             loading: false,
            filter: {state: '', site: '', startDate: null, endDate: null, },
            dashboard: {patients: 0, active: 0, sites: 0, inactive: 0, activeSites: 0, newPatients: 0, loss: 0, patientsYearGroup: []}
        };        
          
        this.handleSelectChange = this.handleSelectChange.bind(this);
        this.dateChange = this.dateChange.bind(this);
        this.getAgeGenderBand = this.getAgeGenderBand.bind(this);
        this.groupBy = this.groupBy.bind(this);
        this.getStats = this.getStats.bind(this);
        this.redirectToLineList = this.redirectToLineList.bind(this);
        this.redirectLabResults = this.redirectLabResults.bind(this);
        this.getVLAgeBands = this.getVLAgeBands.bind(this);
    }
    

    handleSelectChange(feature, value, target) 
    {
        let filter = this.state.filter;
        filter[feature] = value[target];
        this.setState({filter});
    }

    dateChange(feature, date) 
    {
        let filter = this.state.filter;
        filter[feature] = date;
        this.setState({filter});
    }

    async UNSAFE_componentWillMount()
    {
        let sts = localStorage.getItem("states");
        if (!sts)
        {
            let res = await fetchData('/api/Site/getAllStates');
            localStorage.setItem('states', JSON.stringify(res));
        } 
        this.getStats();
    }

    async getStats()
    {
        let el = this;
        el.setState({ loading: true });
        var url = `/api/Stats/getDashboardStats`;
        let res = await fetchData(url);

        let dashboard = el.state.dashboard;
        dashboard.patients = res.patients;
        dashboard.sites = res.sites;
        dashboard.active = res.active;
        dashboard.inactive = res.inactive;
        dashboard.newPatients = res.newPatients;
        // dashboard.patientsYearGroup = res.patientsYearGroup;
        el.setState({ dashboard });

        if (res.sites.length > 0)
        {
            localStorage.removeItem('sites');
            localStorage.setItem('sites', JSON.stringify(res.sites));
        }

        this.setState({ loading: true });
        var url1 = `/api/Stats/getStateStats`;
        let res1 = await fetchData(url1);
        this.setState({ loading: false });
        if (res1.length > 0) {
            let totals = [];
            let actives = [];
            let tx_curr_states = [];
            let tx_news = [];
            let inactives = [];
            //let drilldowns = [];

            let categories = [];
            //let drillCategories = [];
            //let drillTotals = [];
            //let drillActives = [];
            //let drillTx_news = [];
            //let drillInactives = [];

            res1.map(function (p) {
                totals.push(p.patients);
                actives.push(p.active);
                tx_curr_states.push([p.stateName, p.active]);
                tx_news.push(p.newPatients);
                inactives.push(p.inactive);
                categories.push(p.stateName);
                categories.push(p.stateName);

                //if (p.sites && p.sites.length > 0)
                //{
                //    p.sites.map(function (s)
                //    {

                //        drillTotals.push(s.patients);
                //        drillActives.push(s.active);
                //        drillTx_news.push(s.newPatients);
                //        drillInactives.push(s.inactive);
                //        drillCategories.push(s.stateName);
                //    });
                //}                
            });

            let pData =
                [
                    { name: 'total', data: totals },
                    { name: 'active', data: actives },
                    { name: 'tx_new', data: tx_news },
                    { name: 'inactive', data: inactives },
                ];

            let colors = ['#95CEFF', '#50B432', '#24CBE5', '#ff7043', '#DDDF00', '#24CBE5',
                '#64E572', '#FF9655', '#FFF263', '#6AF9C4'];

            Highcharts.chart('patient-year',
                {
                    chart: {
                        type: 'column'
                    },
                    title: {
                        text: 'Client Distribution By State'
                    },
                    xAxis: {
                        categories: categories
                    },
                    yAxis: {
                        allowDecimals: false,
                        min: 0,
                        title: {
                            text: 'Patient'
                        }
                    },
                    tooltip: {
                        headerFormat: '<table style="width: 110px"><tr style="font-size:12px; font-weight: bold; border-bottom: thin solid #ddd"><td>{point.key}</td></tr>',
                        pointFormat: '<tr style="font-size:11px;"><td style="color:{series.color};padding:0">{series.name}: </td>' +
                            '<td style="padding:0"><b>{point.y:,.0f}</b></td></tr>',
                        footerFormat: '</table>',
                        shared: true,
                        useHTML: true
                    },
                    plotOptions: {
                        column: {
                            pointPadding: 0.02,
                            borderWidth: 0
                        }
                    },
                    colors: colors,
                    series: pData
                });

            Highcharts.chart('patient-total',
                {
                    chart: {
                        plotBackgroundColor: null,
                        plotBorderWidth: null,
                        plotShadow: false,
                        type: 'pie'
                    },
                    title: {
                        text: 'Tx_curr By State'
                    },
                    tooltip: {
                        pointFormat: '{series.name}: <b>{point.percentage:.1f}%</b>'
                    },
                    plotOptions: {
                        pie: {
                            allowPointSelect: true,
                            cursor: 'pointer',
                            dataLabels: {
                                enabled: true,
                                format: '<b>{point.name}</b>: {point.percentage:.1f} %',
                                style: {
                                    color: (Highcharts.theme && Highcharts.theme.contrastTextColor) || 'black'
                                }
                            }
                        }
                    },
                    series: [{
                        type: 'pie',
                        name: 'Tx_curr by state',
                        data: tx_curr_states
                    }]
                });

            this.getAgeGenderBand();
        }
        else {
            el.setState({ loading: false });
        }
    }

    async componentDidMount()
    {        
               
    }

    redirectToLineList()
    {
        this.setState({ linelist: true });
    }
    redirectLabResults() {
        this.setState({ labresult: true });
    }

    async getAgeGenderBand()
    {
        var url2 = `/api/Stats/getTxCurrBands`;
        let res2 = await fetchData(url2);
        let el = this;
        if (res2.length > 0) {
            let males = [];
            let females = [];

            //Caching these items is necessary for later use in the 'age-gender queries (linelist)' page
            localStorage.removeItem('ageSexAggregations');
            localStorage.setItem('ageSexAggregations', JSON.stringify(res2));

            let genderGroups = await el.groupBy(res2, 'groupName');

            Object.keys(genderGroups).forEach(key => {
                let ll = genderGroups[key];
                let f = 0;
                let m = 0;
                ll.map(function (p) {
                    if (p.gender.toLowerCase() === "female") f += p.ageCount;
                    if (p.gender.toLowerCase() === "male") m += p.ageCount;
                });

                females.push(-f);
                males.push(m);
            });

            var categories = [
                '0-4', '5-9', '10-14', '15-19',
                '20-24', '25-29', '30-34', '35-39', '40-44',
                '45-49', '50+ '
            ];

            Highcharts.chart('band',
                {
                    chart: {
                        type: 'bar'
                    },
                    title:
                    {
                        useHTML: true,
                        text: 'Clients on ART by Age and Gender'
                    },
                    subtitle: {
                        text: 'Active Clients (+28 Days)'
                    },
                    xAxis: [{
                        categories: categories,
                        reversed: false,
                        labels: {
                            step: 1
                        }
                    }, { // mirror axis on right side
                        opposite: true,
                        reversed: false,
                        categories: categories,
                        linkedTo: 0,
                        labels: {
                            step: 1
                        }
                    }],
                    yAxis: {
                        title: {
                            text: null
                        },
                        labels: {
                            formatter: function () {
                                return Math.abs(this.value);
                            }
                        }
                    },

                    plotOptions: {
                        series: {
                            stacking: 'normal'
                        }
                    },

                    tooltip: {
                        formatter: function () {
                            return '<b>' + this.series.name + ', age ' + this.point.category + '</b><br/>' +
                                'No. of Clients: ' + Highcharts.numberFormat(Math.abs(this.point.y), 0);
                        }
                    },

                    series: [{
                        name: 'Male',
                        data: males
                    }, {
                        name: 'Female',
                        data: females
                    }]
                });

            this.getVLAgeBands();
        }
        else {
            el.setState({ loading: false });
        }
    }

    async getVLAgeBands() {
        var url2 = `/api/Stats/getVLAgeBands`;
        let res2 = await fetchData(url2);
        let el = this;
        el.setState({ loading: false });
        if (res2.length > 0)
        {
            let unsuppressed = [];
            let suppressed = [];            

            let suppressionGroups = await el.groupBy(res2, 'groupName');
            
            Object.keys(suppressionGroups).forEach(key =>
            {
                let ll = suppressionGroups[key];
                let s = 0;
                let u = 0;
                ll.map(function (p)
                {
                    if (p.vlStatus.toLowerCase() === "suppressed") s += p.ageCount;
                    if (p.vlStatus.toLowerCase() === "unsuppressed") u += p.ageCount;
                });

                suppressed.push(-s);
                unsuppressed.push(u);
            });

            var categories = [
                '0-4', '5-9', '10-14', '15-19',
                '20-24', '25-29', '30-34', '35-39', '40-44',
                '45-49', '50+ '
            ];

            Highcharts.chart('suppressed',
                {
                    chart: {
                        type: 'bar'
                    },
                    title:
                    {
                        useHTML: true,
                        text: 'Viral Suppression by Age band'
                    },
                    //subtitle: {
                    //    text: 'Active Clients (+28 Days)'
                    //},
                    xAxis: [{
                        categories: categories,
                        reversed: false,
                        labels: {
                            step: 1
                        }
                    }, { // mirror axis on right side
                        opposite: true,
                        reversed: false,
                        categories: categories,
                        linkedTo: 0,
                        labels: {
                            step: 1
                        }
                    }],
                    yAxis: {
                        title: {
                            text: null
                        },
                        labels: {
                            formatter: function () {
                                return Math.abs(this.value);
                            }
                        }
                    },

                    plotOptions: {
                        series: {
                            stacking: 'normal'
                        }
                    },

                    tooltip: {
                        formatter: function () {
                            return '<b>' + this.series.name + ', age ' + this.point.category + '</b><br/>' +
                                'No. of Clients: ' + Highcharts.numberFormat(Math.abs(this.point.y), 0);
                        }
                    },

                    series: [{
                        name: 'Unsuppressed',
                        data: unsuppressed
                    }, {
                        name: 'Suppressed',
                        data: suppressed
                    }]
                });
        }
    }

    async groupBy(array, property) {
        return array.reduce(function (accumulator, object) {
            // get the value of the object(gender in this case) to use to group the array as the array key   
            const key = object[property];
            // if the current value is similar to the key(gender) don't accumulate the transformed array and leave it empty  
            if (!accumulator[key]) {
                accumulator[key] = [];
            }
            // add the value to the array
            accumulator[key].push(object);
            // return the transformed array
            return accumulator;
            // Also we also set the initial value of reduce() to an empty object
        }, {});
    } 

    render() {
        
        const { dashboard, linelist, labresult, loading } = this.state;
        if (linelist) return <Redirect to="/lineList" />;
        if (labresult) return <Redirect to="/labTest" />;
        
        return <div style={{backgroundColor: '#f0f2f5'}}>
                    <Helmet>
                        <title>CDR - Dashboard</title>
                    </Helmet>
            {loading && <img className="waiter" src={waiter} alt="" style={{ width: '54px', height: '54px' }}/>}
                    <Row className="row-30px-pad-10px-top" style={{paddingTop: '10px'}}>
                        <Col span={12}>
                            <h4 style={{ fontWeight: 'bold', fontSize: '18px' }}>Dashboard [* AS AT TODAY] </h4>
                        </Col>
                        <Col span={12}>
                            {dashboard.sites && <h4 style={{ float: 'right', marginRight: '20px' }}>Facilities: <span style={{ fontWeight: 'bold', fontSize: '22px' }} className="db-h3-t">{String(dashboard.sites.filter(function (s) { return s.hasClients > 0 }).length).replace(/(.)(?=(\d{3})+$)/g, '$1,')}</span></h4>}
                        </Col>
                    </Row>  
                    <Row className="sr row-30px-pad-10px-top" gutter={2}>
                        <Col xs={24} sm={12} md={12} lg={12} xl={6}>
                            <Card className="ant-card-body pfs s-list">
                                <div className="custom-image">
                                    <h3 className="db-h3 db-h3-i">{String(dashboard.patients).replace(/(.)(?=(\d{3})+$)/g,'$1,')}</h3>
                                </div>
                                <Icon type="team" className="db-i"/>
                                <div className="custom-card" title="View more">
                                    <NavLink title="View more" exact to={'/patient'} activeClassName="active"><h3>Clients Enrolled on ART&nbsp; <Icon type="eye" /></h3></NavLink>
                                </div>
                            </Card>
                        </Col>
                        <Col xs={24} sm={12} md={12} lg={12} xl={6}>
                            <Card className="ant-card-body pfs s-list">
                                <div className="custom-image">                                        
                                    <h3 className="db-h3 db-h3-g">{String(dashboard.active).replace(/(.)(?=(\d{3})+$)/g,'$1,')}</h3>
                                </div>
                                <Icon type="solution" className="db-i"/>
                                <div className="custom-card">
                                    <h3>Active Clients (+28 days)&nbsp;</h3>                                  
                                </div>
                            </Card>
                        </Col>   
                        <Col xs={24} sm={12} md={12} lg={12} xl={6}>
                            <Card className="ant-card-body pfs s-list">
                                <div className="custom-image">
                                    <h3 className="db-h3 db-h3-n">{String(dashboard.inactive).replace(/(.)(?=(\d{3})+$)/g,'$1,')}</h3>
                                </div>
                                <Icon type="team" className="db-i"/>
                                <div className="custom-card" title="View more">
                                    <h3>Active Clients (+90 days)&nbsp;</h3>                                                                        
                                </div>
                            </Card>
                        </Col>
                        <Col xs={24} sm={12} md={12} lg={12} xl={6}>
                            <Card className="ant-card-body pfs s-list">
                                <div className="custom-image">
                                    <h3 className="db-h3 db-h3-b">{String(dashboard.newPatients).replace(/(.)(?=(\d{3})+$)/g,'$1,')}</h3>
                        </div>
                        <Icon type="usergroup-add" className="db-i" />
                             <div className="custom-card">
                               <h3>New Clients</h3>                                                               
                            </div>
                           </Card>
                        </Col>
                        {/* <Col xs={24} sm={12} md={12} lg={12} xl={6} style={{ paddingLeft: '8px', paddingRight: '8px', marginBottom: '10px'}}>
                            <Card className="ant-card-body pfs s-list">
                                <div className="custom-image">
                                    <h3 className="db-h3 db-h3-t">{String(dashboard.sites).replace(/(.)(?=(\d{3})+$)/g,'$1,')}</h3>
                                </div>
                                <Icon type="home" className="db-i" />
                                <div className="custom-card" title="View more">
                                    <NavLink title="View more" exact to={'/site'} activeClassName="active"><h3>Sites&nbsp; <Icon type="eye" /></h3></NavLink>                                                           
                                </div>
                            </Card>
                        </Col> */}
                        {/* <Col xs={24} sm={12} md={12} lg={12} xl={6} style={{ paddingLeft: '8px', paddingRight: '8px', marginBottom: '10px'}}>
                            <Card className="ant-card-body pfs s-list">
                                <div className="custom-image">
                                    <h3 className="db-h3 db-h3-t">{String(dashboard.sites).replace(/(.)(?=(\d{3})+$)/g,'$1,')}</h3>
                                </div>
                                <Icon type="home" className="db-i" />
                                <div className="custom-card" title="View more">
                                    <NavLink title="View more" exact to={'/site'} activeClassName="active"><h3>Total Sites&nbsp; <Icon type="eye" /></h3></NavLink>                                                           
                                </div>
                            </Card>
                        </Col> */}
                        {/* <Col xs={24} sm={12} md={12} lg={12} xl={6} style={{ paddingLeft: '8px', paddingRight: '8px', marginBottom: '10px'}}>
                            <Card className="ant-card-body pfs s-list">
                                <div className="custom-image">
                                    <h3 className="db-h3 db-h3-r">{String(dashboard.loss).replace(/(.)(?=(\d{3})+$)/g,'$1,')}</h3>
                                </div>                       
                                <Icon type="usergroup-delete" className="db-i" />
                                <div className="custom-card" title="View more">
                                    <a><h3>Loss-to-follow up&nbsp; <Icon type="eye" /><small>{'> 90 days'}</small></h3></a>                                                             
                                </div>
                            </Card>
                        </Col> */}
                    </Row> 
                    <Row gutter={2} className="row-30px-pad-10px-top">
                        <Col xs={24} sm={24} md={16} lg={16} xl={16}  id="patient-year">
                        </Col>  
                        <div style={{width: "1%"}}>
                        </div> 
                        <Col xs={24} sm={24} md={8} lg={8} xl={8}  id="patient-total">
                        </Col>
                    </Row>     
                    <Row gutter={2} className="row-30px-pad-10px-top top-20px">                           
                        <Col span={24} id="band" className="ageband"></Col>
                        <Col span={24}>
                    <Button type="primary" className="c-sdt" onClick={this.redirectToLineList}>
                                More Details
                                <Icon type="right" />
                            </Button>
                        </Col>
                    </Row>         
                    <Row gutter={2} className="row-30px-pad-10px-top top-20px">
                        <Col span={24} id="suppressed" className="ageband"></Col>
                        <Col span={24}>
                    <Button type="primary" className="c-sdt" onClick={this.redirectLabResults}>
                                More Details
                                <Icon type="right" />
                            </Button>
                        </Col>
                    </Row>
            </div>;
    }
}
