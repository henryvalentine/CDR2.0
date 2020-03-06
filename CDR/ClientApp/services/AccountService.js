
import Globals from "@Globals";

export default class AccountService extends ServiceBase {
    
    static async login(loginModel) {
        var result = await this.requestJson({
            url: "api/Account/login",
            method: "POST",
            data: loginModel
        });

        if (!result.hasErrors) {
            Globals.serviceUser = result.value;
        }

        return result;
    }

    static async logout() {
        var result = await this.requestJson({
            url: "api/Account/Logout",
            method: "POST"
        });

        if (!result.hasErrors) {
            Globals.serviceUser = null;
        }

        return result;
    }
}