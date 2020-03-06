
/* eslint-disable no-redeclare */
import { clone } from "@Utils";
import { wait } from "domain-wait";

const Actions = {
    FailureResponse: "USERS_FAILURE_RESPONSE",
    SearchRequest: "USERS_SEARCH_REQUEST",
    SearchResponse: "USERS_SEARCH_RESPONSE",
    AddRequest: "USERS_ADD_REQUEST",
    AddResponse: "USERS_ADD_RESPONSE",
    UpdateRequest: "USERS_UPDATE_REQUEST",
    UpdateResponse: "USERS_UPDATE_RESPONSE",
    DeleteRequest: "USERS_DELETE_REQUEST",
    DeleteResponse: "USERS_DELETE_RESPONSE"
};

export const actionCreators = {
    searchRequest: (term) => async (dispatch, getState) => {

        await wait(async (transformUrl) => {

            // Wait for server prerendering.
            dispatch({ type: Actions.SearchRequest });
            return null;
           
        });
    },
    addRequest: (model) => async (dispatch, getState) =>
    {
        return null;
    },
    updateRequest: (model) => async (dispatch, getState) =>
    {

        return null;
    }
};

const initialUser = {
    locations: [],
    indicators: {
        operationLoading: false
    }
};

export const reducer = (currentUser, incomingAction) => {

    const action = incomingAction;

    var cloneIndicators = () => clone(currentUser.indicators);

    switch (action.type)
    {
        case Actions.FailureResponse:
            var indicators = cloneIndicators();
            indicators.operationLoading = false;
            return { ...currentUser, indicators };
        case Actions.SearchRequest:
            var indicators = cloneIndicators();
            indicators.operationLoading = true;
            return { ...currentUser, indicators };
        case Actions.SearchResponse:
            var indicators = cloneIndicators();
            indicators.operationLoading = false;
            return { ...currentUser, indicators, locations: action.payload };
        case Actions.UpdateRequest:
            var indicators = cloneIndicators();
            indicators.operationLoading = true;
            return { ...currentUser, indicators };
        case Actions.UpdateResponse:
            var indicators = cloneIndicators();
            indicators.operationLoading = false;
            var data = clone(currentUser.locations);
            var itemToUpdate = data.filter(x => x.id === action.payload.id)[0];
            itemToUpdate.firstName = action.payload.firstName;
            itemToUpdate.lastName = action.payload.lastName;
            itemToUpdate.userName = action.payload.userName;
            itemToUpdate.email = action.payload.email;
            itemToUpdate.password = action.payload.password;
            itemToUpdate.confirmPassword = action.payload.confirmPassword;
            itemToUpdate.role = action.payload.role;

            return { ...currentUser, indicators, locations: data };
        case Actions.AddRequest:
            var indicators = cloneIndicators();
            indicators.operationLoading = true;
            return { ...currentUser, indicators };
        case Actions.AddResponse:
            var indicators = cloneIndicators();
            indicators.operationLoading = false;
            var data = clone(currentUser.locations);
            data.push(action.payload);
            return { ...currentUser, indicators, locations: data };
        case Actions.DeleteRequest:
            var indicators = cloneIndicators();
            indicators.operationLoading = true;
            return { ...currentUser, indicators };
        case Actions.DeleteResponse:
            var indicators = cloneIndicators();
            indicators.operationLoading = false;
            var data = clone(currentUser.locations).filter(x => x.id !== action.id);
            return { ...currentUser, indicators, locations: data };
        default:
            return currentUser || initialUser;
    }
};