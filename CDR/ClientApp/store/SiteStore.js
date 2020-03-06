/* eslint-disable no-redeclare */
import { clone } from "@Utils";
import { wait } from "domain-wait";

const Actions = {
    FailureResponse: "SITE_FAILURE_RESPONSE",
    SearchRequest: "SITE_SEARCH_REQUEST",
    SearchResponse: "SITE_SEARCH_RESPONSE",
    AddRequest: "SITE_ADD_REQUEST",
    SiteClients: "SITE_CLIENTS",
    AddResponse: "SITE_ADD_RESPONSE",
    UpdateRequest: "SITE_UPDATE_REQUEST",
    UpdateResponse: "SITE_UPDATE_RESPONSE",
    DeleteRequest: "SITE_DELETE_REQUEST",
    DeleteResponse: "SITE_DELETE_RESPONSE"
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

const initialSite = {
    locations: [],
    indicators: {
        operationLoading: false
    }
};

export const reducer = (currentSite, incomingAction) => {

    const action = incomingAction;

    var cloneIndicators = () => clone(currentSite.indicators);

    switch (action.type)
    {
        case Actions.FailureResponse:
            var indicators = cloneIndicators();
            indicators.operationLoading = false;
            return { ...currentSite, indicators };
        case Actions.SearchRequest:
            var indicators = cloneIndicators();
            indicators.operationLoading = true;
            return { ...currentSite, indicators };
        case Actions.SearchResponse:
            var indicators = cloneIndicators();
            indicators.operationLoading = false;
            return { ...currentSite, indicators, locations: action.payload };
        case Actions.UpdateRequest:
            var indicators = cloneIndicators();
            indicators.operationLoading = true;
            return { ...currentSite, indicators };
        case Actions.UpdateResponse:
            var indicators = cloneIndicators();
            indicators.operationLoading = false;
            var data = clone(currentSite.locations);
            var itemToUpdate = data.filter(x => x.id === action.payload.id)[0];
            itemToUpdate.name = action.payload.name;
            itemToUpdate.numberOfLGAs = action.payload.numberOfLGAs;
            itemToUpdate.longitude = action.payload.longitude;
            itemToUpdate.latitude = action.payload.latitude;

            return { ...currentSite, indicators, locations: data };
        case Actions.AddRequest:
            var indicators = cloneIndicators();
            indicators.operationLoading = true;
            return { ...currentSite, indicators };
        case Actions.AddResponse:
            var indicators = cloneIndicators();
            indicators.operationLoading = false;
            var data = clone(currentSite.locations);
            data.push(action.payload);
            return { ...currentSite, indicators, locations: data };
        case Actions.DeleteRequest:
            var indicators = cloneIndicators();
            indicators.operationLoading = true;
            return { ...currentSite, indicators };
        case Actions.DeleteResponse:
            var indicators = cloneIndicators();
            indicators.operationLoading = false;
            var data = clone(currentSite.locations).filter(x => x.id !== action.id);
            return { ...currentSite, indicators, locations: data };
        default:
            return currentSite || initialSite;
    }
};