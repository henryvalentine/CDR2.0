/**
 * Contains global isomorphic session.
 */
export default class Globals 
{    
    // static isInitialized = false;
    // static session = {};

    static reset() 
    {
        this.isInitialized = false;
        this.session = {};
    }

    static init(session) 
    {     
        if (this.isInitialized) 
        {
            throw Error("Globals is already initialized.");
        }

        this.session = (session || 
        {
            public: {}, private: {}
        });
        this.isInitialized = true;
    }

    static throwIfNotInitialized() 
    {
        if (!this.isInitialized) {
            throw Error("'Globals' is not initialized. You have to call 'Globals.init' before.");
        }
    }

    static getSession() 
    {      
        this.throwIfNotInitialized();
        return this.session;
    }

    static setSession(session) 
    {
        this.throwIfNotInitialized();
        // Update session object by the new data.
        this.user = session.user;
        this.session = { ...this.session, ...session };
    }

    static get serviceUser() 
    {
        let currentSession = this.getSession();
        if (currentSession) {
            let publicSession = currentSession.public;
            if (publicSession) {
                return publicSession.user;
            } else {
                throw Error("Globals: public session was not initialized.")
            }
        }
        throw Error("Globals: current session was not initialized.")
    }

    static set serviceUser(user) 
    {
        this.user = user;
        this.setSession({ public: { user: user } });
    }

    static get isAuthenticated() 
    {
        return this.session.public.user != null && this.session.public.user.isAuthenticated === true;
    }
}