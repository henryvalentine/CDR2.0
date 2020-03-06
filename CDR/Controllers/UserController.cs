
using System;
using System.Text.Encodings.Web;
using System.Threading.Tasks;
using Microsoft.AspNetCore.Mvc;
using CDR.Models;
using CDR.Services;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Identity;
using Microsoft.AspNetCore.Identity.UI.Services;
using System.ComponentModel.DataAnnotations;
using Microsoft.Extensions.Logging;
using Services.Utils;
// using CDR.Areas.Identity.Pages.User;
//using LoginModel = CDR.Models.LoginModel;
//using RegisterModel = CDR.Models.RegisterModel;
using Microsoft.AspNetCore.Http;
using CDR.SessionManager;

namespace CDR.Controllers
{
    [ApiController]
    [Route("api/[controller]")]
    public class UserController : ControllerBase
    {
        private readonly ILogger<SignupModel> _logger;
        private readonly SignInManager<IdentityUser> _signInManager;
        private readonly UserManager<IdentityUser> _userManager;
        private readonly IEmailSender _emailSender;

        public UserController( UserManager<IdentityUser> userManager, SignInManager<IdentityUser> signInManager, IEmailSender emailSender, ILogger<SignupModel> logger)
        {
            _userManager = userManager;
            _signInManager = signInManager;
            _emailSender = emailSender;
            _logger = logger;
        }

        public string ReturnUrl { get; set; }

        // [HttpPost]
        // [Route("login")]
        // public async Task<ActionResult<UserModel>> Login([FromBody]LoginModel model)
        // {
        //     if (model is null)
        //     {
        //         throw new ArgumentNullException(nameof(model));
        //     }

        //     var userInfo = new UserModel();
        //     var msg = "";

        //     try
        //     {
        //         if (ModelState.IsValid)
        //         {
        //             var t = _userManager.FindByEmailAsync(model.Email);
        //             if (t != null)
        //             {
        //                 var user = new IdentityUser { UserName = model.Email, Email = model.Email };
        //                 var result = await _userManager.CreateAsync(user, model.Password);
        //                 if (result.Succeeded)
        //                 {
        //                     var resultx = await _signInManager.PasswordSignInAsync(model.Email, model.Password, model.RememberMe, lockoutOnFailure: false);
        //                     if (resultx.Succeeded)
        //                     {
        //                         var u = t.Result as CDRUser;
        //                         userInfo.FirstName = u.FirstName;
        //                         userInfo.LastName = u.LastName;
        //                         userInfo.Email = u.Email;
        //                         userInfo.IsAuthenticated = true;
        //                         userInfo.Code = 5;
        //                         userInfo.UserName = u.UserName;
        //                         userInfo.Role = "Admin";   
        //                         userInfo.Message = "User credential was successfully processed";

        //                         HttpContext.Session.SetObjectAsJson("_user", userInfo);                                                                
        //                         return userInfo;
        //                     }
        //                 }
        //                 foreach (var error in result.Errors)
        //                 {
        //                     msg = error + "\n";
        //                 }
        //             }
        //             else
        //             {
        //                 var resultx = await _signInManager.PasswordSignInAsync(model.Email, model.Password, model.RememberMe, lockoutOnFailure: false);
        //                 if (resultx.Succeeded)
        //                 {
        //                     userInfo.Code = 5;
        //                     userInfo.Message = "User credential was successfully processed";
        //                     return userInfo;
        //                 }
        //                 msg = resultx.ToString();
        //             }
        //         }

        //         userInfo.Code = -1;
        //         userInfo.Message = msg;
        //         return userInfo;
        //     }
        //     catch (Exception e)
        //     {
        //         userInfo.Code = -1;
        //         userInfo.Message = e.Message != null ? e.Message : e.InnerException.Message;
        //         return userInfo;
        //     }

        // }

        [HttpGet]
        [Route("getSession")]
        public UserModel GetSession()
        {
            try
            {
                var user = HttpContext.Session.GetObjectFromJson<UserModel>("_user");
                if(user != null)
                {
                    return user;
                } 
                return new UserModel();
            }
            catch(Exception e)
            {
                return new UserModel();
            }
        }

        [HttpPost]
        [Route("logout")]
        public async Task<IActionResult> Logout()
        {
            await _signInManager.SignOutAsync();
            return Ok(5);
        }

        // public async Task<ActionResult<GenericValidator>> Register([FromBody]RegisterModel registerModel)
        // {
        //     var gVal = new GenericValidator();
        //     var msg = "";

        //     try
        //     {
        //         if (ModelState.IsValid)
        //         {
        //             var user = new CDRUser 
        //             {
        //                 FirstName = registerModel.FirstName, 
        //                 LastName = registerModel.LastName, 
        //                 UserName = registerModel.Email, 
        //                 Email = registerModel.Email
        //             };

        //             var result = await _userManager.CreateAsync(user, registerModel.Password);
        //             if (result.Succeeded)
        //             {
        //                 gVal.Code = 5;
        //                 gVal.Message = "User credential was successfully processed";
        //                 return gVal;
        //             }
        //             foreach (var error in result.Errors)
        //             {
        //                 msg = error + "\n";
        //             }
        //         }

        //         gVal.Code = -1;
        //         gVal.Message = msg;
        //         return gVal;
        //     }
        //     catch(Exception e)
        //     {
        //         gVal.Code = -1;
        //         gVal.Message = e.Message != null ? e.Message : e.InnerException.Message;
        //         return gVal;
        //     }
        // }
    }
}
