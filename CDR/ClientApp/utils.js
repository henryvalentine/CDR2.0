﻿

export function clone(object) {
    return JSON.parse(JSON.stringify(object));
}

/**
 * Is server prerendering by Node.js.
 * There can't be any DOM: window, document, etc.
 */
export function isNode() {
    return typeof process === 'object' && process.versions && !!process.versions.node;
}

export const isServer = typeof window === 'undefined';

export const fetchData = async (path, jwToken) =>
    fetch(path,
        {
            method: "GET",
            headers:
            {
                Accept: 'application/json', 'Content-Type': 'application/json'
            }
        }).then(data => data.json());

export const fetchExternal = async (url) =>
    fetch(url,
        {
            method: "GET",
            mode: 'cors',
            headers:
            {
                'Access-Control-Allow-Origin': 'localhost'
            }
        }).then(data => data.json());

export const postQuery = async (path, body) =>
    fetch(path,
        {
            method: "POST",
            headers:
            {
                'Accept': 'application/json', 
                'Content-Type': 'application/json'
            },
            body: body
        }).then(data => data.json());

export const uploadFile = async (path, file) =>
    
    fetch(path,
        {
            method: "POST",
            headers: {
                'Accept': 'application/json'
            },
            body: file
        }).then(data => data.json());

//export const isAllowed = (type, state) =>
//{
//    const role = routesMap[type] && routesMap[type].role;
//    if (!role) return true;

//    const user = isServer ? jwt.verify(state.jwToken, process.env.JWT_SECRET) : state.user;
//    if (!user) return false;
//    return user.roles.includes(role);
//};

// VERIFICATION MOCK:
// since middleware is syncrhonous you must use a jwt package that is sync
// like the one imported above.

// NOTE ON COOKIES:
// we're doing combination cookies + jwTokens because universal apps aren't
// single page apps (SPAs). Server-rendered requests, when triggered via
// direct visits by the user, do not have headers we can set. That's the
// takeaway.