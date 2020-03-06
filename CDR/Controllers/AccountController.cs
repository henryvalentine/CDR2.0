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
using Microsoft.AspNetCore.Http;
using Services.Interfaces;
using CDR.SessionManager;
using System.Collections.Generic;
using Services.DataModels;

namespace CDR.Controllers
{
    [ApiController]
    [Route("api/[controller]")]
    public class AccountController : ControllerBase
    {
        private readonly IUserService _userService;

        public AccountController(IUserService userService)
        {
            _userService = userService;
        }

        [HttpPost]
        [Route("login")]
        public ActionResult<UserModel> Login([FromBody]Login model)
        {
            var userInfo = new UserModel();

            try
            {

                var u = _userService.CheckUserByEmail(model.Email);
                if (u != null)
                {
                    var resultx = PasswordManager.VerifyHashedPassword(u.PasswordHash, model.Password);
                    if (resultx)
                    {
                        userInfo.Id = u.Id;
                        userInfo.FirstName = u.FirstName;
                        userInfo.LastName = u.LastName;
                        userInfo.Email = u.Email;
                        userInfo.IsAuthenticated = true;
                        userInfo.Code = 5;
                        userInfo.UserName = u.UserName;
                        userInfo.Role = u.Role;
                        userInfo.Message = "User credential was successfully verified";
                        HttpContext.Session.SetObjectAsJson("_user", userInfo);
                        return userInfo;
                    }
                }

                userInfo.Code = -1;
                userInfo.Message = "The provided email or password is incorrect";
                return userInfo;
            }
            catch (Exception e)
            {
                userInfo.Code = -1;
                userInfo.Message = e.Message != null ? e.Message : e.InnerException.Message;
                return userInfo;
            }

        }

        [HttpGet]
        [Route("getSession")]
        public UserModel GetSession()
        {
            try
            {
                var user = HttpContext.Session.GetObjectFromJson<UserModel>("_user");
                if (user != null)
                {
                    return user;
                }
                return new UserModel();
            }
            catch (Exception e)
            {
                return new UserModel();
            }
        }

        [HttpPost]
        [Route("logout")]
        public IActionResult Logout()
        {
            HttpContext.Session.Remove("_user");
            return Ok(5);
        }

        [HttpPost]
        [Route("register")]
        public ActionResult<GenericValidator> Register([FromBody]UserModel registerModel)
        {
            var gVal = new GenericValidator();
            try
            {
                if (string.IsNullOrEmpty(registerModel.Email))
                {
                    gVal.Code = -1;
                    gVal.Message = "Please provide user's Email";
                    return gVal;
                }
                if (string.IsNullOrEmpty(registerModel.FirstName))
                {
                    gVal.Code = -1;
                    gVal.Message = "Please provide user's FirstName";
                    return gVal;
                }
                if (string.IsNullOrEmpty(registerModel.LastName))
                {
                    gVal.Code = -1;
                    gVal.Message = "Please provide user's LastName";
                    return gVal;
                }
                if (string.IsNullOrEmpty(registerModel.Password))
                {
                    gVal.Code = -1;
                    gVal.Message = "Please provide user's Password";
                    return gVal;
                }
                if (string.IsNullOrEmpty(registerModel.ConfirmPassword))
                {
                    gVal.Code = -1;
                    gVal.Message = "Please Confirm user's Password";
                    return gVal;
                }
                if (string.IsNullOrEmpty(registerModel.Role))
                {
                    gVal.Code = -1;
                    gVal.Message = "Please select a role for user";
                    return gVal;
                }
                if (registerModel.Password != registerModel.ConfirmPassword)
                {
                    gVal.Code = -1;
                    gVal.Message = "The passwords do not match";
                    return gVal;
                }
             
                var result = _userService.AddUser(registerModel);
                if (string.IsNullOrEmpty(result))
                {
                    gVal.Code = -1;
                    gVal.Message = "User credential could not be processed. Please try again later";
                    return gVal;
                }
                if (result == "-3")
                {
                    gVal.Code = -1;
                    gVal.Message = "User already exists";
                    return gVal;
                }
                gVal.Code = 5;
                gVal.Message = "User information was successfully processed";
                return gVal;
            }
            catch (Exception e)
            {
                gVal.Code = -1;
                gVal.Message = e.Message != null ? e.Message : e.InnerException.Message;
                return gVal;
            }
        }

        [HttpPost]
        [Route("updateUser")]
        public ActionResult<GenericValidator> UpdateUser([FromBody]UserModel user)
        {
            var gVal = new GenericValidator();
          
            try
            {
                if (string.IsNullOrEmpty(user.Email))
                {
                    gVal.Code = -1;
                    gVal.Message = "Please provide user's Email";
                    return gVal;
                }
                if (string.IsNullOrEmpty(user.FirstName))
                {
                    gVal.Code = -1;
                    gVal.Message = "Please provide user's FirstName";
                    return gVal;
                }
                if (string.IsNullOrEmpty(user.LastName))
                {
                    gVal.Code = -1;
                    gVal.Message = "Please provide user's LastName";
                    return gVal;
                }
                if (string.IsNullOrEmpty(user.Password))
                {
                    gVal.Code = -1;
                    gVal.Message = "Please provide user's Password";
                    return gVal;
                }
                if (string.IsNullOrEmpty(user.ConfirmPassword))
                {
                    gVal.Code = -1;
                    gVal.Message = "Please Confirm user's Password";
                    return gVal;
                }
                if (string.IsNullOrEmpty(user.Role))
                {
                    gVal.Code = -1;
                    gVal.Message = "Please select a role for user";
                    return gVal;
                }
                if (user.Password != user.ConfirmPassword)
                {
                    gVal.Code = -1;
                    gVal.Message = "The passwords do not match";
                    return gVal;
                }               

                if (!string.IsNullOrEmpty(user.Password))
                {
                    if (string.IsNullOrEmpty(user.ConfirmPassword))
                    {
                        gVal.Code = -1;
                        gVal.Message = "Please Confirm user's Password";
                        return gVal;
                    }
                    if (user.Password != user.ConfirmPassword)
                    {
                        gVal.Code = -1;
                        gVal.Message = "The passwords do not match";
                        return gVal;
                    }

                }
                var result = _userService.UpdateUser(user);
                if (result > 0)
                {
                    gVal.Code = 5;
                    gVal.Message = "User credential was successfully updated";
                    return gVal;
                }
                gVal.Code = -1;
                gVal.Message = "User information could not be updated";
                return gVal;
            }
            catch (Exception e)
            {
                gVal.Code = -1;
                gVal.Message = e.Message != null ? e.Message : e.InnerException.Message;
                return gVal;
            }
        }

        [HttpGet]
        [Route("getUsers")]
        public ActionResult<UserPayload> GetUsers(int itemsPerPage, int pageNumber)
        {
            int dataCount;
            var users = _userService.GetUsers(itemsPerPage, pageNumber, out dataCount);
            return new UserPayload { Users = users, TotalItems = dataCount };
        }

        [HttpGet]
        [Route("getRoles")]
        public ActionResult<List<RoleModel>> GetRoles()
        {
            return _userService.GetRoles();
        }

        [HttpGet]
        [Route("searchUsers")]
        public ActionResult<UserPayload> Search(int itemsPerPage, int pageNumber, string term = null)
        {
            int dataCount;
            var users = _userService.Search(itemsPerPage, pageNumber, out dataCount, term);
            return new UserPayload { Users = users, TotalItems = dataCount };
        }

        // GET api/values/5
        [HttpGet]
        [Route("getUser")]
        public ActionResult<UserModel> GetUser(string id)
        {
            return _userService.GetUserById(id);
        }

        [HttpGet]
        [Route("getUserByEmail")]
        public ActionResult<UserModel> GetUserByEmail(string email)
        {
            return _userService.GetUserByEmail(email);
        }
    }
}
