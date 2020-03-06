
/* eslint-disable no-redeclare */
import { clone } from "@Utils";
import { wait } from "domain-wait";

const Actions = {
    FailureResponse: "PATIENT_FAILURE_RESPONSE",
    SearchRequest: "PATIENT_SEARCH_REQUEST",
    SearchResponse: "PATIENT_SEARCH_RESPONSE",
    AddRequest: "PATIENT_ADD_REQUEST",
    AddResponse: "PATIENT_ADD_RESPONSE",
    UpdateRequest: "PATIENT_UPDATE_REQUEST",
    UpdateResponse: "PATIENT_UPDATE_RESPONSE",
    DeleteRequest: "PATIENT_DELETE_REQUEST",
    DeleteResponse: "PATIENT_DELETE_RESPONSE"
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

const initialPatient = {
    locations: [],
    indicators: {
        operationLoading: false
    }
};

export const reducer = (currentPatient, incomingAction) => {

    const action = incomingAction;

    var cloneIndicators = () => clone(currentPatient.indicators);

    switch (action.type)
    {
        case Actions.FailureResponse:
            var indicators = cloneIndicators();
            indicators.operationLoading = false;
            return { ...currentPatient, indicators };
        case Actions.SearchRequest:
            var indicators = cloneIndicators();
            indicators.operationLoading = true;
            return { ...currentPatient, indicators };
        case Actions.SearchResponse:
            var indicators = cloneIndicators();
            indicators.operationLoading = false;
            return { ...currentPatient, indicators, locations: action.payload };
        case Actions.UpdateRequest:
            var indicators = cloneIndicators();
            indicators.operationLoading = true;
            return { ...currentPatient, indicators };
        case Actions.UpdateResponse:
            var indicators = cloneIndicators();
            indicators.operationLoading = false;
            var data = clone(currentPatient.locations);
            var itemToUpdate = data.filter(x => x.id === action.payload.id)[0];
            itemToUpdate.name = action.payload.name;
            itemToUpdate.numberOfLGAs = action.payload.numberOfLGAs;
            itemToUpdate.longitude = action.payload.longitude;
            itemToUpdate.latitude = action.payload.latitude;

            return { ...currentPatient, indicators, locations: data };
        case Actions.AddRequest:
            var indicators = cloneIndicators();
            indicators.operationLoading = true;
            return { ...currentPatient, indicators };
        case Actions.AddResponse:
            var indicators = cloneIndicators();
            indicators.operationLoading = false;
            var data = clone(currentPatient.locations);
            data.push(action.payload);
            return { ...currentPatient, indicators, locations: data };
        case Actions.DeleteRequest:
            var indicators = cloneIndicators();
            indicators.operationLoading = true;
            return { ...currentPatient, indicators };
        case Actions.DeleteResponse:
            var indicators = cloneIndicators();
            indicators.operationLoading = false;
            var data = clone(currentPatient.locations).filter(x => x.id !== action.id);
            return { ...currentPatient, indicators, locations: data };
        default:
            return currentPatient || initialPatient;
    }
};