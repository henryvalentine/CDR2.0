using System;
using System.Collections.Generic;
using System.Data.SqlClient;
using System.IO;
using System.Linq;
using System.Net.Http.Headers;
using System.Security.AccessControl;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Hosting;
using Microsoft.AspNetCore.Mvc;
using Microsoft.Extensions.FileProviders;
using OfficeOpenXml;
using Services.DataModels;
using Services.Interfaces;
using Services.Utils;
using CDR.SessionManager;
using System.Threading.Tasks;
using Microsoft.AspNetCore.Http;
using System.Threading;

namespace CDR.Controllers
{
    // [Authorize]
    [Route("api/[controller]")]
    [ApiController]
    public class RegimenController : ControllerBase
    {       
        private readonly IRegimenService _regimenService;
        public RegimenController(IRegimenService regimenService, IHostingEnvironment hostingEnvironment = null)
        {
            _regimenService = regimenService;
        }
        
        [HttpGet]
        [Route("getRegimens")]
        public ActionResult<GenericModel> GetRegimens(int itemsPerPage, int pageNumber)
        {
            var user = HttpContext.Session.GetObjectFromJson<UserModel>("_user");
            if(user == null)
            {
                return new GenericModel();
            } 
            int dataCount;
            var regimens = _regimenService.GetRegimens(itemsPerPage, pageNumber, out dataCount);
            return new GenericModel { Regimens = regimens, TotalItems = dataCount };
        }

        [HttpGet]
        [Route("getAllRegimens")]
        public ActionResult<List<RegimenModel>> GetAllRegimens()
        {
            var user = HttpContext.Session.GetObjectFromJson<UserModel>("_user");
            if (user == null)
            {
                return new List<RegimenModel>();
            }
            return _regimenService.GetAllRegimens();
        }
        
        [HttpGet]
        [Route("searchRegimen")]
        public ActionResult<GenericModel> Search(int itemsPerPage, int pageNumber, string term = null)
        {
            var user = HttpContext.Session.GetObjectFromJson<UserModel>("_user");
            if(user == null)
            {
                return new GenericModel();
            } 
            int dataCount;
            var regimens = _regimenService.Search(itemsPerPage, pageNumber, out dataCount, term);
            return new GenericModel { Regimens = regimens, TotalItems = dataCount };
        }
        // GET api/values/5
        [HttpGet]
        [Route("getRegimen")]
        public ActionResult<RegimenModel> GetRegimen(int id)
        {
            return _regimenService.GetRegimen(id);
        } 

        // POST api/values
        [HttpPost]
        [Route("addRegimen")]
        public ActionResult<GenericValidator> AddRegimen([FromBody]RegimenModel regimen)
        {
             var gVal = new GenericValidator();
            try
            {
                if (string.IsNullOrEmpty(regimen.Combination) || string.IsNullOrEmpty(regimen.Code) || string.IsNullOrEmpty(regimen.Line))
                {
                    gVal.Code = -1;
                    gVal.Message = "Provide all fields and try again";
                    return gVal;
                }                
                var status = _regimenService.AddRegimen(regimen);
                if (status < 1)
                {
                    gVal.Code = -1;
                    gVal.Message = status == -3? "Regimen record already exists" : "An unknown error was encountered. Please try again.";
                    return gVal;
                }

                gVal.Code = status;
                gVal.Message = "Regimen information was successfully Added";
                return gVal;

            }
            catch (Exception ex)
            {
                gVal.Code = -1;
                gVal.Message = ex.Message != null? ex.Message : ex.InnerException != null? ex.InnerException.Message : "An unknown error was encountered. Please try again.";
                return gVal;
            }
           
        }

        [HttpPost]
        [Route("updateRegimen")]
        public ActionResult<GenericValidator> EditRegimen([FromBody]RegimenModel regimen)
        {
            var gVal = new GenericValidator();
            try
            {
                if (string.IsNullOrEmpty(regimen.Combination) || string.IsNullOrEmpty(regimen.Code) || string.IsNullOrEmpty(regimen.Line))
                {
                    gVal.Code = -1;
                    gVal.Message = "Provide all fields and try again";
                    return gVal;
                }
                if (regimen.Id < 1)
                {
                    gVal.Code = -1;
                    gVal.Message = "Invalid Regimen information was selected. Please try again.";
                    return gVal;
                }

                var status = _regimenService.UpdateRegimen(regimen);
                if (status < 1)
                {
                    gVal.Code = -1;
                    gVal.Message = status == -3 ? "Regimen already exists" : "An unknown error was encountered. Please try again.";
                    return gVal;
                }

                gVal.Code = 5;
                gVal.Message = "Regimen information was successfully Updated";
                return gVal;

            }
            catch (Exception ex)
            {
                gVal.Code = -1;
                gVal.Message = ex.Message != null ? ex.Message : ex.InnerException != null ? ex.InnerException.Message : "An unknown error was encountered. Please try again.";
                return gVal;
            }
        }

    }
}
