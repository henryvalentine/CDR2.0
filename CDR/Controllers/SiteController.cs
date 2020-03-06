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
using System.Net;
using System.Net.Sockets;

namespace CDR.Controllers
{
    // [Authorize]
    [Route("api/[controller]")]
    [ApiController]
    public class SiteController : ControllerBase
    {       
        private readonly ISiteService _siteService;
        private readonly IHostingEnvironment _hostingEnvironment;
        public SiteController(ISiteService siteService, IHostingEnvironment hostingEnvironment = null)
        {
            _siteService = siteService;
            _hostingEnvironment = hostingEnvironment;
        }

        [HttpGet]
        [Route("getExport")]
        public IActionResult GetExport(string fileName)
        {
            return downloadFile(fileName);
        }
        public FileResult downloadFile(string fileName)
        {
            var provider = new PhysicalFileProvider(_hostingEnvironment.WebRootPath);
            var fileInfo = provider.GetFileInfo(fileName);
            var readStream = fileInfo.CreateReadStream();
            var mimeType = "application/vnd.ms-excel";
            return File(readStream, mimeType, fileName);
        }

        [HttpGet]
        [Route("getSites")]
        public ActionResult<GenericModel> GetSites(int itemsPerPage, int pageNumber)
        {
            var user = HttpContext.Session.GetObjectFromJson<UserModel>("_user");
            if(user == null)
            {
                return new GenericModel();
            } 
            int dataCount;
            var sites = _siteService.GetSites(itemsPerPage, pageNumber, out dataCount);
            return new GenericModel { Sites = sites, TotalItems = dataCount };
        }

        [HttpGet]
        [Route("getAllSites")]
        public ActionResult<List<SiteModel>> GetAllSites()
        {
            var user = HttpContext.Session.GetObjectFromJson<UserModel>("_user");
            if (user == null)
            {
                return new List<SiteModel>();
            }
            return _siteService.GetAllSites();
        }

        [HttpGet]
        [Route("getAllStates")]
        public ActionResult<List<StateModel>> GetAllStates()
        {
            var user = HttpContext.Session.GetObjectFromJson<UserModel>("_user");
            if (user == null)
            {
                return new List<StateModel>();
            }
            return _siteService.GetAllStates();
        }

        [HttpGet]
        [Route("getSitesByStateCode")]
        public ActionResult<List<SiteModel>> GetSitesByStateCode(string stateCode)
        {
            var user = HttpContext.Session.GetObjectFromJson<UserModel>("_user");
            if(user == null)
            {
                return new List<SiteModel>();
            } 
            return _siteService.GetSitesByStateCode(stateCode);
        }

        [HttpGet]
        [Route("getSitesByStateId")]
        public ActionResult<List<SiteModel>> GetSitesByStateId(int stateId)
        {
            var user = HttpContext.Session.GetObjectFromJson<UserModel>("_user");
            if (user == null)
            {
                return new List<SiteModel>();
            }
            return _siteService.GetSitesByStateId(stateId);
        }

        [HttpGet("exportSites")]
        public ActionResult<GenericValidator> ExportSites ()
        {
            var gVal = new GenericValidator();
            try
            {
                var comlumHeadrs = new string[]
                {
                    "Site",
                    "State Code",
                    "Total Clients",
                    "Active",
                    "Coverage(%)",
                    "Inactive",
                    "LTFU",
                    "New Clients"
                };

                // byte[] result;

                var user = HttpContext.Session.GetObjectFromJson<UserModel>("_user");
                if(user == null)
                {
                    gVal.Code = -1;
                    gVal.Message = "You need to login or contact the Admin to get an account.";                    
                    return gVal;
                } 

                string sWebRootFolder = _hostingEnvironment.WebRootPath;
                var excelName = $"sites-{user.Id.Replace("-", string.Empty)}.xlsx";               
                string URL = string.Format("{0}://{1}/{2}/{3}", Request.Scheme, Request.Host, "Exports", excelName);                 

                var exports = Path.Combine(sWebRootFolder, "Exports");
                if (!Directory.Exists(exports))
                {
                    var directory = System.IO.Directory.CreateDirectory(exports);
                    // Get a DirectorySecurity object that represents the
                    // current security settings.
                    var dSecurity = directory.GetAccessControl();

                    // Add the FileSystemAccessRule to the security settings.
                    dSecurity.AddAccessRule(
                        new FileSystemAccessRule(
                            new System.Security.Principal.SecurityIdentifier(
                                System.Security.Principal.WellKnownSidType.BuiltinUsersSid,
                                null
                            ),
                            FileSystemRights.FullControl,
                            AccessControlType.Allow
                        )
                    );
                    // Set the new access settings.
                    directory.SetAccessControl(dSecurity);
                }                             

                var path = Path.Combine(sWebRootFolder, "Exports", excelName);

                var file = new FileInfo(path);

                if (file.Exists)
                {
                    file.Delete();
                }  
                
                using (var package = new ExcelPackage(file))
                {
                    // add a new worksheet to the empty workbook
    
                    var worksheet = package.Workbook.Worksheets.Add("Site List"); //Worksheet name
                    using (var cells = worksheet.Cells[1, 1, 1, 8]) //(1,1) (1,5)
                    {
                        cells.Style.Font.Bold = true;
                    }

                    //First add the headers
                    for (var i = 0; i < comlumHeadrs.Count(); i++)
                    {
                        worksheet.Cells[1, i + 1].Value = comlumHeadrs[i];
                    }

                    worksheet = ProcessSites(1000, 1, worksheet, 2);
                    // result = package.GetAsByteArray();                                                      

                     package.Save();
                }         

                gVal.Code = 1;
                gVal.Message  = "File was successfully generated";    
                // gVal.Asset = excelName;
                gVal.Asset = URL;
                return gVal;

            }
            catch(Exception e)
            {
                return gVal;
            }            
        }

        public FileResult GetFile(string path)
        {
            var result = PhysicalFile(path, "application/vnd.openxmlformats-officedocument.spreadsheetml.sheet");
            var fileName = Path.GetFileName(path);
            Response.Headers["Content-Disposition"] = new ContentDispositionHeaderValue("attachment")
            {
                FileName = fileName
            }.ToString();
                
            return result;
        }

        [HttpPost("processeTxNew")]
        public async Task<ActionResult<GenericValidator>> ProcesseTxNew()
        {
            var gVal = new GenericValidator();
            var form = Request.Form;
            try
            {
                var formFiles = form.Files;
                if(!formFiles.Any())
                {
                    gVal.Code = -1;
                    gVal.Message = "The requested file is empty";
                    return gVal;
                }

                var formFile = formFiles[0];
                if (formFile == null || formFile.Length <= 0)
                {
                    gVal.Code = -1;
                    gVal.Message = "The selected file could not be processed";
                    return gVal;
                }

                if (!Path.GetExtension(formFile.FileName).Equals(".xlsx", StringComparison.OrdinalIgnoreCase))
                {
                    gVal.Code = -1;
                    gVal.Message = "Unknown file extension";
                    return gVal;
                }

                var list = new List<TXCurrImport>();

                using (var stream = new MemoryStream())
                {
                    await formFile.CopyToAsync(stream);

                    using (var package = new ExcelPackage(stream))
                    {
                        var worksheet = package.Workbook.Worksheets[0];
                        var rowCount = worksheet.Dimension.Rows;

                        for (int row = 2; row <= rowCount; row++)
                        {
                            var siteId = worksheet.Cells[row, 1].Value.ToString().Trim();
                            var siteName = worksheet.Cells[row, 2].Value.ToString().Trim();
                            var txNew = worksheet.Cells[row, 4].Value;
                            var txCurr = worksheet.Cells[row, 3].Value;

                            long tX_CURR_TARGET = 0;
                            long tX_NEW_TARGET = 0;

                            if(txNew != null)
                            {
                                tX_NEW_TARGET = Convert.ToInt64(txNew.ToString().Trim().Replace(" ", string.Empty));
                            }
                            if (txCurr != null)
                            {
                                tX_CURR_TARGET = Convert.ToInt64(txCurr.ToString().Trim().Replace(" ", string.Empty));
                            }

                            var fISCAL_YEAR = worksheet.Cells[row, 5].Value.ToString().Trim();

                            if (!string.IsNullOrEmpty(siteId) && !string.IsNullOrEmpty(siteName) && (tX_CURR_TARGET > 0 || tX_NEW_TARGET > 0) && !string.IsNullOrEmpty(fISCAL_YEAR))
                            {
                                list.Add(new TXCurrImport
                                {
                                    SiteId = siteId,
                                    SiteName = siteName,
                                    TX_CURR_TARGET = tX_CURR_TARGET,
                                    TX_NEW_TARGET = tX_NEW_TARGET,
                                    FISCAL_YEAR = int.Parse(fISCAL_YEAR)
                                });
                            }
                        }

                        if (list.Any())
                        {
                            var t = _siteService.AddTXCurrs(list);
                            gVal.Code = 5;
                            gVal.Message = t + " entries successfully processed";

                        }
                        else
                        {
                            gVal.Code = -1;
                            gVal.Message = "File could not be processed. Please try again later";
                        }
                        return gVal;
                    }

                }
            }
            catch(Exception e)
            {
                gVal.Code = -1;
                gVal.Message = "File could not be processed. Please try again later";
                return gVal;
            }
        }

        private ExcelWorksheet ProcessSites(int itemsPerPage, int pageNumber, ExcelWorksheet worksheet, int lastRow)
        {
            try
            {
                var sites = _siteService.GetSites(itemsPerPage, pageNumber);
                var j = lastRow;
                if (sites.Any())
                {
                    //Add values

                    sites.ForEach(s =>
                    {
                        worksheet.Cells["A" + j].Value = s.Name;
                        worksheet.Cells["B" + j].Value = s.StateCode;
                        worksheet.Cells["C" + j].Value = s.TotalClients;
                        worksheet.Cells["D" + j].Value = s.Active;
                        worksheet.Cells["E" + j].Value = s.Difference;
                        worksheet.Cells["F" + j].Value = s.Inactive;
                        worksheet.Cells["G" + j].Value = s.LossToFollowUp;
                        worksheet.Cells["H" + j].Value = s.NewClients;
                        j++;
                    });
                    pageNumber += 1;
                    worksheet = ProcessSites(itemsPerPage, pageNumber, worksheet, j);
                }

                return worksheet;
            }
            catch(Exception e)
            {
                return null;
            }
        }

        [HttpGet]
        [Route("searchSite")]
        public ActionResult<GenericModel> Search(int itemsPerPage, int pageNumber, string term = null)
        {
            var user = HttpContext.Session.GetObjectFromJson<UserModel>("_user");
            if(user == null)
            {
                return new GenericModel();
            } 
            int dataCount;
            var sites = _siteService.Search(itemsPerPage, pageNumber, out dataCount, term);
            return new GenericModel { Sites = sites, TotalItems = dataCount };
        }
        // GET api/values/5
        [HttpGet]
        [Route("getSite")]
        public ActionResult<SiteModel> GetSite(long id)
        {
            return _siteService.GetSiteById(id);
        }

         // GET api/values/5
        [HttpGet]
        [Route("getSiteBySiteId/{lng}/{lat}")]
        public ActionResult<SiteModel> GetSiteBySiteId(string siteId)
        {
            return _siteService.GetSiteBySiteId(siteId);
        }       

        // POST api/values
        [HttpPost]
        [Route("addSite")]
        public ActionResult<GenericValidator> AddSite([FromBody]SiteModel site)
        {
             var gVal = new GenericValidator();
            try
            {
                if (string.IsNullOrEmpty(site.SiteId))
                {
                    gVal.Code = -1;
                    gVal.Message = "Please provide Site's enrolmentId.";
                    return gVal;
                }
                if (string.IsNullOrEmpty(site.Name))
                {
                    gVal.Code = -1;
                    gVal.Message = "Please provide Site's Name.";
                    return gVal;
                }
                var status = _siteService.AddSite(site);
                if (status < 1)
                {
                    gVal.Code = -1;
                    gVal.Message = status == -3? "Site record already exists" : "An unknown error was encountered. Please try again.";
                    return gVal;
                }

                gVal.Code = status;
                gVal.Message = "Site information was successfully Added";
                return gVal;

            }
            catch (Exception ex)
            {
                gVal.Code = -1;
                gVal.Message = ex.Message != null? ex.Message : ex.InnerException != null? ex.InnerException.Message : "An unknown error was encountered. Please try again.";
                return gVal;
            }
           
        }

        [HttpPatch]
        [Route("updateSite")]
        public ActionResult<GenericValidator> EditSite([FromBody]SiteModel site)
        {
            var gVal = new GenericValidator();
            try
            {
                if (string.IsNullOrEmpty(site.SiteId))
                {
                    gVal.Code = -1;
                    gVal.Message = "Please provide Site's enrolmentId.";
                    return gVal;
                }
                if (string.IsNullOrEmpty(site.Name))
                {
                    gVal.Code = -1;
                    gVal.Message = "Please provide Site's First Name.";
                    return gVal;
                }
                if (site.Id < 1)
                {
                    gVal.Code = -1;
                    gVal.Message = "Invalid Site information selected. Please try again.";
                    return gVal;
                }

                var status = _siteService.UpdateSite(site);
                if (status < 1)
                {
                    gVal.Code = -1;
                    gVal.Message = status == -3 ? "Site already exists" : "An unknown error was encountered. Please try again.";
                    return gVal;
                }

                gVal.Code = 5;
                gVal.Message = "Site information was successfully Updated";
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
