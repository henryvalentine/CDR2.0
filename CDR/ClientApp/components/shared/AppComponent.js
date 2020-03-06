import * as React from "react";

/**
 * This component contains helpful method which
 * allows you to make "force update" of the stuck elements.
 */
export default class AppComponent extends React.Component 
{   
    constructor(props) 
    {
        super(props);
        this.forceUpdate = this.forceUpdate.bind(this);

        /**
     * Place it into the "key" attribute of an element.
     */    
        this.state = {renderKey: 0};
    }

    /**
     * Call this if component state is stuck.
     * But you should set the renderKey to the element's attribute.
     */

    forceUpdate() 
    {
        this.setState({renderKey: Math.random()});
    }
}