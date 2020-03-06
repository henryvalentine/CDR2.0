import * as React from "react";

export default class Footer extends React.Component 
{
    constructor(props) 
    {
        super(props);
    }
    render() {
        return <footer className="footer text-center">
            <p>Copyright (c) 2019 - Clinical Data Repository (CDR)</p>
        </footer>;
    }
}