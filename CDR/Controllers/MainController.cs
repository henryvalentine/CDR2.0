using System.Diagnostics;
using System.Linq;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;
using Services.Utils;
using CDR.Models;
using CDR.SessionManager;

namespace CDR.Controllers
{    
    public class MainController : Controller
    {
        public IActionResult Index()
        {
            var user = HttpContext.Session.GetObjectFromJson<UserModel>("_user");
            if(user == null)
            {
                user = new UserModel();
            } 
            var nodeSession = new NodeSession
            {
                Private = new PrivateSession
                {
                    Cookie = string.Join(", ", Request.Cookies.Select(x => $"{x.Key}={x.Value};"))
                },
                
                Public = new PublicSession
                {
                    User = user
                }
            };
            return View(nodeSession);
        }

        public IActionResult Error()
        {
            ViewData["RequestId"] = Activity.Current?.Id ?? HttpContext.TraceIdentifier;
            return View();
        }
    }
}
