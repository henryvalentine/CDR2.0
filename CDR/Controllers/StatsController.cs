using System;
using System.Collections.Generic;
using System.Data.SqlClient;
using System.Linq;
using System.Threading.Tasks;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;
using Services.DataModels;
using Services.Interfaces;
using Services.Utils;
using CDR.SessionManager;
using Microsoft.AspNetCore.Hosting;
using System.IO;
using System.Security.AccessControl;
using OfficeOpenXml;
using Microsoft.Extensions.FileProviders;
using OfficeOpenXml.Style;

namespace CDR.Controllers
{
    // [Authorize]
    [Route("api/[controller]")]
    [ApiController]
    public class StatsController : ControllerBase
    {    
        private readonly IStatsService _statsService;
        private List<RegimenModel> regimens = new List<RegimenModel>();
        private readonly IRegimenService _regimenService;
        private readonly IHostingEnvironment _hostingEnvironment;
        public StatsController(IStatsService statsService, IRegimenService regimenService = null, IHostingEnvironment hostingEnvironment = null)
        {
           _statsService = statsService;
            _regimenService = regimenService;
            _hostingEnvironment = hostingEnvironment;
        }

        [HttpGet]
        [Route("getFile")]
        public virtual ActionResult Download(string fileName)
        {
            string fullPath = Path.Combine(_hostingEnvironment.WebRootPath, "Exports", fileName);
            return File(fullPath, "application/vnd.ms-excel", fullPath);
        }
        
        [HttpGet]
        [Route("getDashboardStats")]
        public ActionResult<DashboardModel> DashboardStats()
        {
            try
            {            
                var user = HttpContext.Session.GetObjectFromJson<UserModel>("_user");
                if(user == null)
                {
                    return new DashboardModel();
                } 
                return _statsService.GetStats();                
                
            }
            catch(Exception ex)
            {
                return new DashboardModel { PatientsYearGroup = new List<GroupByYear>() };
            }
        }        

        [HttpGet]
        [Route("getStateStats")]
        public ActionResult<List<DashboardModel>> GetStateStats()
         {
            try
            {   
                 var user = HttpContext.Session.GetObjectFromJson<UserModel>("_user");
                if(user == null)
                {
                    return new List<DashboardModel>();
                } 

               return _statsService.GetStateStats();  
            }
            catch(Exception ex)
            {
                return new List<DashboardModel> ();
            }
        }

        [HttpGet]
        [Route("getTxCurrBands")]
        public ActionResult<List<GroupCount>> GetTxCurrBands()
         {
            try
            {            
                 var user = HttpContext.Session.GetObjectFromJson<UserModel>("_user");
                if(user == null)
                {
                    return new List<GroupCount>();
                } 

               return _statsService.GetTxCurrBands();               
            }
            catch(Exception ex)
            {
                return new List<GroupCount> ();
            }
        }

        [HttpGet]
        [Route("getVLAgeBands")]
        public ActionResult<List<GroupCount>> getVLAgeBands()
        {
            try
            {
                var user = HttpContext.Session.GetObjectFromJson<UserModel>("_user");
                if (user == null)
                {
                    return new List<GroupCount>();
                }

                return _statsService.GetVLAgeBands();
            }
            catch (Exception ex)
            {
                return new List<GroupCount>();
            }
        }               

        [HttpPost]
        [Route("getTxCurrBandsByPeriod")]
        public ActionResult<GenericModel> GetTxCurrBandsByPeriod([FromBody] QueryModel query)
        {
            try
            {
                var user = HttpContext.Session.GetObjectFromJson<UserModel>("_user");
                if (user == null || query.StateId < 1 || query.From == null || query.From.Year < 2000 || query.To == null || query.To.Year < 2000)
                {
                    return new GenericModel();
                }
                var clientGroup = _statsService.GetTxCurrBandsByPeriod(query);
                return new GenericModel { GroupCounts = clientGroup, TotalItems = clientGroup.Count};
            }
            catch (Exception ex)
            {
                return new GenericModel();
            }
        }

        #region Queries by Sites
        [HttpPost]
        [Route("getTxNewByPeriod")]
        public ActionResult<GenericModel> GetTxNewByPeriod([FromBody] QueryModel query)
        {
            try
            {            
                var user = HttpContext.Session.GetObjectFromJson<UserModel>("_user");
                if(user == null)
                {
                    return new GenericModel();
                }

                long dataCount;
                var sites = _statsService.GetTxNewByPeriod(query.From, query.To, query.ItemsPerPage, query.PageNumber, query.SiteId, out dataCount);
                return new GenericModel { Sites = sites, TotalItems = dataCount };
            }
            catch(Exception ex)
            {
                return new GenericModel();
            }
        }

        [HttpPost]
        [Route("getTxCurrByPeriod")]
        public ActionResult<GenericModel> GetTxCurrByPeriod([FromBody]QueryModel query)
        {
            try
            {
                var user = HttpContext.Session.GetObjectFromJson<UserModel>("_user");
                if (user == null)
                {
                    return new GenericModel();
                }

                long dataCount;
                var sites = _statsService.GetTxCurrByPeriod(query.From, query.To, query.ItemsPerPage, query.PageNumber, query.SiteId, out dataCount);
                return new GenericModel { Sites = sites, TotalItems = dataCount };
            }
            catch (Exception ex)
            {
                return new GenericModel();
            }
        }

        [HttpPost]
        [Route("getVLByPeriod")]
        public ActionResult<GenericModel> GetVLByPeriod([FromBody] QueryModel query)
        {
            try
            {
                var user = HttpContext.Session.GetObjectFromJson<UserModel>("_user");
                if (user == null)
                {
                    return new GenericModel();
                }

                long dataCount;
                var sites = _statsService.GetViralSuppressionByPeriod(query.From, query.To, query.ItemsPerPage, query.PageNumber, query.SiteId, out dataCount);
                return new GenericModel { Sites = sites, TotalItems = dataCount };
            }
            catch (Exception ex)
            {
                return new GenericModel();
            }
        }
        #endregion

        #region State Queries

        [HttpPost]
        [Route("getStateTxCurrByPeriod")]
        public ActionResult<GenericModel> GetStateTxCurrByPeriod([FromBody] QueryModel query)
        {
            try
            {
                var user = HttpContext.Session.GetObjectFromJson<UserModel>("_user");
                if (user == null)
                {
                    return new GenericModel();
                }
                
                var sites = _statsService.GetStateTxCurrByPeriod(query.From, query.To, query.StateId);
                return new GenericModel { Sites = sites, TotalItems = 1 };
            }
            catch (Exception ex)
            {
                return new GenericModel();
            }
        }

        [HttpPost]
        [Route("getStateTxNewByPeriod")]
        public ActionResult<GenericModel> GetStateTxNewByPeriod([FromBody]QueryModel query)
        {
            try
            {
                var user = HttpContext.Session.GetObjectFromJson<UserModel>("_user");
                if (user == null)
                {
                    return new GenericModel();
                }

                var sites = _statsService.GetStateTxNewByPeriod(query.From, query.To, query.StateId);
                return new GenericModel { Sites = sites, TotalItems = 1 };
            }
            catch (Exception ex)
            {
                return new GenericModel();
            }
        }

        [HttpPost]
        [Route("getStateVLByPeriod")]
        public ActionResult<GenericModel> GetStateVLByPeriod([FromBody] QueryModel query)
        {
            try
            {
                var user = HttpContext.Session.GetObjectFromJson<UserModel>("_user");
                if (user == null)
                {
                    return new GenericModel();
                }

                var sites = _statsService.GetStateViralSuppressionByPeriod(query.From, query.To, query.StateId);
                return new GenericModel { Sites = sites, TotalItems = 1};
            }
            catch (Exception ex)
            {
                return new GenericModel();
            }
        }

        #endregion

        #region Line List By Age-Sex Aggregation

        [HttpPost]
        [Route("getLineList")]
        public ActionResult<GenericModel> GetLineList([FromBody] QueryModel query)
        {
            try
            {
                var user = HttpContext.Session.GetObjectFromJson<UserModel>("_user");
                if (user == null || query.StateId < 1 || query.From  == null || query.From.Year < 2000 || query.To == null || query.To.Year < 2000)
                {
                    return new GenericModel();
                }
                var clientGroup = _statsService.GetTxCurrLineListByPeriod(query.From, query.To, query.ItemsPerPage, query.PageNumber, query.StateId, query.SiteId);
                return new GenericModel { LineList = clientGroup, TotalItems = 1 };
            }
            catch (Exception ex)
            {
                return new GenericModel();
            }
        }               

        [HttpPost("exportLineList")]
        public ActionResult<GenericValidator> ExportLineList([FromBody] QueryModel query)
        {
            var gVal = new GenericValidator();
            try
            {
                var comlumHeadrs = new string[]
                {
                    "Client Id",
                    "Gender",
                    "Age(yrs)",
                    "Preg.",
                    "Art Date",
                    "First Regimen",
                    "First Regimen Line",
                    "Current Visit Date",
                    "Current Viral Load Sample Date",
                    "Current Viral Load Result",
                    "Current Regimen",
                    "Current Regimen Line"
                };

                var user = HttpContext.Session.GetObjectFromJson<UserModel>("_user");
                if (user == null)
                {
                    gVal.Code = -1;
                    gVal.Message = "You need to login or contact the Admin to get an account.";
                    return gVal;
                }

                string sWebRootFolder = _hostingEnvironment.WebRootPath;
                var excelName = $"linelist-{user.Id.Replace("-", string.Empty)}.xlsx";
                string URL = string.Format("{0}://{1}/{2}/{3}", Request.Scheme, Request.Host, "Exports", excelName);

                var exports = Path.Combine(sWebRootFolder, "Exports");
                if (!Directory.Exists(exports))
                {
                    var directory = Directory.CreateDirectory(exports);
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

                    var worksheet = package.Workbook.Worksheets.Add("Line List"); //Worksheet name

                    using (var cells = worksheet.Cells["A1:O1"]) //(1,1) (1,5)
                    {
                        cells.Merge = true;
                        cells.Style.WrapText = true;
                        cells.Style.VerticalAlignment = ExcelVerticalAlignment.Center;
                        cells.Style.HorizontalAlignment = ExcelHorizontalAlignment.Center;
                        cells.Value = query.Header + ": " + Convert.ToDateTime(query.From).ToShortDateString() + " - " + Convert.ToDateTime(query.To).ToShortDateString();
                        cells.Style.Font.Bold = true;
                    }

                    using (var cells = worksheet.Cells["A3:M3"])
                    {
                        cells.Style.Font.Bold = true;
                    }

                    //First add the headers
                    for (var i = 0; i < comlumHeadrs.Count(); i++)
                    {
                        worksheet.Cells[3, i + 1].Value = comlumHeadrs[i];
                    }                    
                    // result = package.GetAsByteArray();                                                      

                    package.Save();
                }

                regimens = _regimenService.GetAllRegimens();

                if (!regimens.Any())
                {
                    gVal.Code = -1;
                    gVal.Message = "An error was encountered. Please contact the Admin to set up list of ARV Regimen";
                    return gVal;
                }

                var status = ProcessLists(path, 4, query);
                if(status > 0)
                {
                    gVal.Code = status;
                    gVal.Message = "File was successfully generated";
                    // gVal.Asset = excelName;
                    gVal.Asset = URL;
                    gVal.FileName = excelName;
                    return gVal;
                }

                gVal.Code = -5;
                gVal.Message = "Query export failed. Please try again later";
                gVal.Asset = "";
                return gVal;

            }
            catch (Exception e)
            {
                return gVal;
            }
        }

        private int ProcessLists(string filePath, int lastRow, QueryModel query)
        {
            try
            {
                var sites = _statsService.GetTxCurrLineListByPeriod(query.From, query.To, 1000, query.PageNumber, query.StateId, query.SiteId);
                var j = lastRow;
                if (sites.Any())
                {
                    var existingFile = new FileInfo(filePath);
                    using (var package = new ExcelPackage(existingFile))
                    {
                        //get the first worksheet in the workbook
                        var worksheet = package.Workbook.Worksheets[0];
                        sites.ForEach(s =>
                        {
                            var cr = regimens.Where(f => f.Combination.ToLower() == s.ArvRegimenCode.ToLower()).ToList();
                            var fr = regimens.Where(f => f.Combination.ToLower() == s.FirstRegimenCode.ToLower()).ToList();

                            var rgLine = cr.Any() ? cr[0].Line : "";
                            var fRgLine = fr.Any() ? fr[0].Line : "";

                            worksheet.Cells["A" + j].Value = s.EnrolmentId;
                            worksheet.Cells["B" + j].Value = s.Gender;
                            worksheet.Cells["C" + j].Value = s.Age;
                            worksheet.Cells["D" + j].Value = s.Pregnant;
                            worksheet.Cells["E" + j].Value = s.ArtDateStr;
                            worksheet.Cells["F" + j].Value = s.FirstRegimenCode;
                            worksheet.Cells["G" + j].Value = fRgLine;
                            worksheet.Cells["H" + j].Value = s.VisitDateStr;
                            worksheet.Cells["I" + j].Value = s.TestDateStr;
                            worksheet.Cells["J" + j].Value = s.TestResult;
                            worksheet.Cells["K" + j].Value = s.ArvRegimenCode;
                            worksheet.Cells["L" + j].Value = rgLine;
                            j++;
                        });
                        package.Save();
                    }

                    query.PageNumber += 1;
                    var status = ProcessLists(filePath, j, query);
                }

                return j;
            }
            catch (Exception e)
            {
                return 0;
            }
        }

        [HttpGet]
        [Route("deleteFile")]
        public void DeleteFile(string p)
        {
            try
            {
                var provider = new PhysicalFileProvider(Path.Combine(_hostingEnvironment.WebRootPath, "Exports"));
                var fileInfo = provider.GetFileInfo(p);
                var file = new FileInfo(fileInfo.PhysicalPath);

                if (file.Exists)
                {
                    file.Delete();
                }
            }
            catch(Exception e)
            {

            }
        }
        #endregion

        #region Lab Tests
        [HttpPost]
        [Route("getTestDetailsByPeriod")]
        public ActionResult<List<LabTest>> GetTestDetailsByPeriod([FromBody] QueryModel query)
        {
            try
            {
                var user = HttpContext.Session.GetObjectFromJson<UserModel>("_user");
                if (user == null)
                {
                    return new List<LabTest>();
                }

                return _statsService.GetTestDetailsByPeriod(query);
            }
            catch (Exception ex)
            {
                return new List<LabTest>();
            }
        }

        [HttpPost("exportLabTests")]
        public ActionResult<GenericValidator> ExportLabTests([FromBody] QueryModel query)
        {
            var gVal = new GenericValidator();
            try
            {
                var comlumHeadrs = new string[]
                {
                    "Client Id",
                    "Pregnant",
                    "Test Type",
                    "Sample Date",
                    "Result Date",
                    "Test Result",
                    "Facility"
                };           

                var user = HttpContext.Session.GetObjectFromJson<UserModel>("_user");
                if (user == null)
                {
                    gVal.Code = -1;
                    gVal.Message = "You need to login or contact the Admin to get an account.";
                    return gVal;
                }

                string sWebRootFolder = _hostingEnvironment.WebRootPath;
                var excelName = $"labTests-{user.Id.Replace("-", string.Empty)}.xlsx";
                string URL = string.Format("{0}://{1}/{2}/{3}", Request.Scheme, Request.Host, "Exports", excelName);

                var exports = Path.Combine(sWebRootFolder, "Exports");
                if (!Directory.Exists(exports))
                {
                    var directory = Directory.CreateDirectory(exports);
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

                    var worksheet = package.Workbook.Worksheets.Add("Lab Tests"); //Worksheet name

                    using (var cells = worksheet.Cells["A1:O1"]) //(1,1) (1,5)
                    {
                        cells.Merge = true;
                        cells.Style.WrapText = true;
                        cells.Style.VerticalAlignment = ExcelVerticalAlignment.Center;
                        cells.Style.HorizontalAlignment = ExcelHorizontalAlignment.Center;
                        cells.Value = query.Header + ": " + Convert.ToDateTime(query.From).ToShortDateString() + " - " + Convert.ToDateTime(query.To).ToShortDateString();
                        cells.Style.Font.Bold = true;
                    }

                    using (var cells = worksheet.Cells["A3:H3"])
                    {
                        cells.Style.Font.Bold = true;
                    }

                    //First add the headers
                    for (var i = 0; i < comlumHeadrs.Count(); i++)
                    {
                        worksheet.Cells[3, i + 1].Value = comlumHeadrs[i];
                    }
                    // result = package.GetAsByteArray();                                                      

                    package.Save();
                }
                query.ItemsPerPage = 1000;
                var status = ProcessLabTests(path, 4, query);
                if (status > 0)
                {
                    gVal.Code = status;
                    gVal.Message = "File was successfully generated";
                    // gVal.Asset = excelName;
                    gVal.Asset = URL;
                    gVal.FileName = excelName;
                    return gVal;
                }

                gVal.Code = -5;
                gVal.Message = "Query export failed. Please try again later";
                gVal.Asset = "";
                return gVal;

            }
            catch (Exception e)
            {
                return gVal;
            }
        }

        private int ProcessLabTests(string filePath, int lastRow, QueryModel query)
        {
            try
            {                
                var sites = _statsService.GetTestDetailsByPeriod(query);
                var j = lastRow;
                if (sites.Any())
                {
                    var existingFile = new FileInfo(filePath);
                    using (var package = new ExcelPackage(existingFile))
                    {
                        //get the first worksheet in the workbook
                        var worksheet = package.Workbook.Worksheets[0];
                        sites.ForEach(s =>
                        {
                            worksheet.Cells["A" + j].Value = s.EnrolmentId;
                            worksheet.Cells["B" + j].Value = s.Pregnant;
                            worksheet.Cells["C" + j].Value = s.Description;
                            worksheet.Cells["D" + j].Value = s.TestDate;
                            worksheet.Cells["E" + j].Value = s.DateReported;
                            worksheet.Cells["F" + j].Value = s.TestResult;
                            worksheet.Cells["G" + j].Value = s.SiteName;
                            j++;
                        });

                        package.Save();
                    }

                    query.PageNumber += 1;
                    var status = ProcessLabTests(filePath, j, query);
                }

                return j;
            }
            catch (Exception e)
            {
                return 0;
            }
        }



        #endregion

    }
}
