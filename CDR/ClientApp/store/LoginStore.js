import { clone } from "@Utils";
import Globals from "@Globals";
import {postQuery} from '../utils';

const Actions = {
    /**
     * You need to have the initial state to
     * reset the indicators (e.g. loginSuccess)
     * that call redirect or any other actions.
     * It must be called in method 'componentDidMount'
     * of a component.
     */
    Init: "LOGIN_INIT",
    Request: "LOGIN_REQUEST",
    Success: "LOGIN_SUCCESS",
    Failure: "LOGIN_FAILURE"
};

export const actionCreators = {
    init: () => async (dispatch, getState) => 
    {
        dispatch({ type: Actions.Init });
        return;
    },
    loginRequest: (model) => async (dispatch, getState) => 
    {
        dispatch({ type: Actions.Request });
        var url = "api/Account/login";
        let res = await postQuery(url, JSON.stringify(model));  

        if (res.code < 1 || !res.isAuthenticated) {
            Globals.user = null;
            dispatch({ type: Actions.Failure });
        }
        else
        {
            Globals.user = res;
            dispatch({ type: Actions.Success, payload: res });
        }
        
        return res;
    }
};

const initialState = {
    indicators: {
        operationLoading: false,
        loginSuccess: false
    }
};

export const reducer = (currentState, incomingAction) => 
{
    const action = incomingAction;
    var cloneIndicators = () => clone(currentState.indicators);
    let indicators = null;

    switch (action.type) 
    {        
        case Actions.Init:
            return initialState;
        case Actions.Request:
            indicators = cloneIndicators();
            indicators.operationLoading = true;
            return { ...currentState, indicators };
        case Actions.Success:
            indicators = cloneIndicators();
            indicators.operationLoading = false;
            indicators.loginSuccess = true;
            return { ...currentState, indicators };
        case Actions.Failure:
            indicators = cloneIndicators();
            indicators.operationLoading = false;
            return { ...currentState, indicators };
        default:
            return currentState || initialState;
    }
};