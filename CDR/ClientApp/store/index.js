import * as LoginStore from "@Store/LoginStore";
import * as SiteStore from "@Store/SiteStore";
import * as PatientStore from "@Store/PatientStore";
import * as UsersStore from "@Store/UsersStore";
import * as SiteQueryStore from "@Store/SiteQueryStore";
import * as StateQueryStore from "@Store/StateQueryStore";
import * as PushDataStore from "@Store/PushDataStore";
// Whenever an action is dispatched, Redux will update each top-level application state property using
// the reducer with the matching name. It's important that the names match exactly, and that the reducer
// acts on the corresponding ApplicationState property type.
export const reducers = {
    login: LoginStore.reducer,
    site: SiteStore.reducer,
    patient: PatientStore.reducer,
    pushdata: PushDataStore.reducer,
    users: UsersStore.reducer,
    siteQuery: SiteQueryStore,
    stateQuery: StateQueryStore
};