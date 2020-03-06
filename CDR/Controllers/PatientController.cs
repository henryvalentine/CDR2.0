using System;
using System.Collections.Generic;
using System.Data;
using System.Data.SqlClient;
using System.Linq;
using System.Threading.Tasks;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;
using Services.DataModels;
using Services.Interfaces;
using Services.Utils;
using CDR.Models;
using CDR.SessionManager;
using System.Text.RegularExpressions;
using MySql.Data.MySqlClient;
using System.Net;
using System.Net.Sockets;

namespace CDR.Controllers
{
    // [Authorize]
    [Route("api/[controller]")]
    [ApiController]
    public class PatientController : ControllerBase
    {       
        private readonly IPatientService _patientService;
        private readonly ISiteDataTrackingService _siteDataTrackingService;
        private readonly ILabResultService _labResultService;
        private readonly IArtBaselineService _artBaselineService;
        private readonly IArtVisitService _artVisitService;
        private readonly ISiteService _siteService;
                
        public PatientController(IPatientService patientService, ISiteDataTrackingService siteDataTrackingService = null, ILabResultService labResultService = null,
        IArtBaselineService artBaselineService = null, IArtVisitService artVisitService = null, ISiteService siteService = null) 
        {
            _patientService = patientService;
            _siteDataTrackingService = siteDataTrackingService;
            _labResultService = labResultService;
            _artBaselineService = artBaselineService;
            _artVisitService = artVisitService;
            _siteService = siteService;
        }

        [HttpGet]
        [Route("getPatients")]
        public ActionResult<GenericModel> GetPatients(int itemsPerPage, int pageNumber)
        {
            var user = HttpContext.Session.GetObjectFromJson<UserModel>("_user");
            if(user == null)
            {
                return new GenericModel();
            } 
            int dataCount;
            var patients = _patientService.GetPatients(itemsPerPage, pageNumber, out dataCount);
            return new GenericModel { Patients = patients, TotalItems = dataCount };
        }


        [HttpGet]
        [Route("getPatientsBySite")]
        public ActionResult<GenericModel> GetPatientsBySite(int itemsPerPage, int pageNumber, int siteId)
        {
            var user = HttpContext.Session.GetObjectFromJson<UserModel>("_user");
            if(user == null)
            {
                return new GenericModel();
            } 
            int dataCount;
            var patients = _patientService.GetPatientsBySite(itemsPerPage, pageNumber, siteId, out dataCount);
            return new GenericModel { Patients = patients, TotalItems = dataCount };
        }
        
        [HttpGet]
        [Route("searchPatients")]
        public ActionResult<GenericModel> Search(string term = null)
        {
            var user = HttpContext.Session.GetObjectFromJson<UserModel>("_user");
            if(user == null)
            {
                return new GenericModel();
            } 
            int dataCount;
            var patients = _patientService.Search(out dataCount, term);
            return new GenericModel { Patients = patients, TotalItems = dataCount };
        }
        
        // GET api/values/5
        [HttpGet]
        [Route("getClient")]
        public ActionResult<PatientModel> GetPatient(long id)
        {
            return _patientService.GetPatientById(id);
        }

        [HttpGet]
        [Route("getPatientByEnrolmentId/enrolmentId")]
        public ActionResult<PatientModel> GetPatientByEnrolmentId(string enrolmentId)
        {
            return _patientService.GetPatientByEnrolmentId(enrolmentId);
        }
                
        [HttpGet]
        [Route("getLastTrack")]
        public ActionResult<SiteDataTrackingModel> GetLastTrack(int siteId)
        {
            //var ipAddress = LocalIPAddress();
            var stDTr = _siteDataTrackingService.GetLastSiteDataTracking(siteId);
            //stDTr.IpAddress = ipAddress;
            return stDTr;
        }

        [HttpPost]
        [Route("cleanDb")]
        public ActionResult<GenericValidator> cleanDb([FromBody]PushData pushData)
        {
            var gVal = new GenericValidator();
            try
            {
                var user = HttpContext.Session.GetObjectFromJson<UserModel>("_user");
                if (user == null)
                {
                    return new GenericValidator();
                }
                if (string.IsNullOrEmpty(pushData.Server))
                {
                    gVal.Code = -1;
                    gVal.Message = "Please provide the address of the target server from which to push the data";
                    return gVal;
                }
                if (string.IsNullOrEmpty(pushData.UserName))
                {
                    gVal.Code = -1;
                    gVal.Message = "Please provide the UserName for the target server from which to push the data";
                    return gVal;
                }
                if (string.IsNullOrEmpty(pushData.Password))
                {
                    gVal.Code = -1;
                    gVal.Message = "Please provide the Password for the target server from which to push the data";
                    return gVal;
                }
                if (pushData.SiteId < 1)
                {
                    gVal.Code = -1;
                    gVal.Message = "Please select a Site";
                    return gVal;
                }

                var cleanScript = "UPDATE art_baseline_adult " +
                    "SET adlt_art_date = CONVERT(NVARCHAR(50),CONVERT(SMALLDATETIME, adlt_art_date,105)) " +
                    "ALTER TABLE art_baseline_adult " +
                    "ALTER COLUMN adlt_art_date SMALLDATETIME " +
                    "UPDATE art_baseline_paeds " +
                    "SET chld_arv_date = CONVERT(NVARCHAR(50),CONVERT(SMALLDATETIME, chld_arv_date,105)) " +
                    "ALTER TABLE art_baseline_paeds " +
                    "ALTER COLUMN chld_arv_date SMALLDATETIME " +
                    "UPDATE art_baseline_adult SET adlt_hiv_date = CONVERT(NVARCHAR(50),CONVERT(SMALLDATETIME, adlt_hiv_date,105)) " +
                    "ALTER TABLE art_baseline_adult " +
                    "ALTER COLUMN adlt_hiv_date SMALLDATETIME";

                using (SqlConnection connection = new SqlConn().GetSqlConn(pushData.Server, pushData.UserName, pushData.Password))
                {
                    using (SqlCommand cmd = new SqlCommand(cleanScript, connection))
                    {
                        connection.Open();

                        using (SqlDataReader reader = cmd.ExecuteReader())
                        {
                            gVal.Code = 5;
                            gVal.Message = "DB Date columns cleaned";
                            return gVal;
                        }
                    }
                }
            }
            catch (Exception ex)
            {
                gVal.Code = -1;
                gVal.Message = ex.Message != null ? ex.Message : ex.InnerException != null ? ex.InnerException.Message : "An unknown error was encountered. Please try again.";
                return gVal;
            }
        }

        [HttpGet]
        [Route("getStates")]
        public ActionResult<List<StateModel>> GetAllStates()
        {
            return _siteService.GetAllStates();
        }

        [HttpPost]
        [Route("pushData")]
        public ActionResult<GenericValidator> pushData([FromBody]PushData pushData)
        {
            var gVal = new GenericValidator();
            try
            {   var user = HttpContext.Session.GetObjectFromJson<UserModel>("_user");
                if(user == null)
                {
                    return new GenericValidator();
                } 
                if(string.IsNullOrEmpty(pushData.Server))
                {
                    gVal.Code = -1;
                    gVal.Message = "Please provide the address of the target server from which to push the data";
                    return gVal;        
                }
                if(string.IsNullOrEmpty(pushData.UserName))
                {
                    gVal.Code = -1;
                    gVal.Message = "Please provide the UserName for the target server from which to push the data";
                    return gVal;
                }
                if(string.IsNullOrEmpty(pushData.Password))
                {
                    gVal.Code = -1;
                    gVal.Message = "Please provide the Password for the target server from which to push the data";
                    return gVal;
                }    
                if(pushData.SiteId < 1)
                {
                    gVal.Code = -1;
                    gVal.Message = "Please select a Site";
                    return gVal;
                }

                return PushPwis(pushData);
            }
            catch(Exception ex)
            {
                gVal.Code = -1;
                gVal.Message = ex.Message != null ? ex.Message : ex.InnerException != null ? ex.InnerException.Message : "An unknown error was encountered. Please try again.";
                return gVal;
            }            
        }

        public ActionResult<GenericValidator> PushPwis(PushData pushData)
        {
            var gVal = new GenericValidator();
            try
            {
                using (SqlConnection connection = new SqlConn().GetSqlConn(pushData.Server, pushData.UserName, pushData.Password))
                {
                    switch (pushData.Target)
                    {
                        case 1:
                            gVal = GetPatients(connection, pushData.LastPatientPage, pushData.ItemsPerPage, pushData.SiteId, pushData.SiteCode);
                            return gVal;
                        case 2:
                            gVal = GetArtBaselineData(connection, pushData.LastAdultArtBaselinePage, pushData.ItemsPerPage, pushData.SiteId);
                            return gVal;
                        case 3:
                            gVal = GetPaediatricArtBaselineData(connection, pushData.LastPaediatricArtBaselinePage, pushData.ItemsPerPage, pushData.SiteId);
                            return gVal;
                        case 4:
                            gVal = GetArtVisits(connection, pushData.LastAdultArvVistPage, pushData.ItemsPerPage, pushData.SiteId);
                            return gVal;
                        case 5:
                            gVal = GetPaediatricArtVisits(connection, pushData.LastPaediatricArvVisitPage, pushData.ItemsPerPage, pushData.SiteId);
                            return gVal;
                        case 6:
                            gVal = GetLabResults(connection, pushData.LastLabResultPage, pushData.ItemsPerPage, pushData.SiteId);
                            return gVal;
                        default:
                            gVal.Code = -1;
                            gVal.Message = "An unknown error was encountered. The process was halted. Please try again latter";
                            return gVal;
                    }
                }
            }
            catch (Exception ex)
            {
                gVal.Code = -1;
                gVal.Message = ex.Message != null ? ex.Message : ex.InnerException != null ? ex.InnerException.Message : "An unknown error was encountered. Please try again.";
                return gVal;
            }
        }

        private GenericValidator GetPatients(SqlConnection connection, int currentPage, int itemsPerPage, int siteId, string siteCode)
        {
            var gVal = new GenericValidator();
            try
            {
                itemsPerPage = 1000;
                var paging = "desc offset " + itemsPerPage + "*" + (currentPage - 1) + " rows fetch next " + itemsPerPage + " rows only";
                var patientQuery = "select * from (select idno, enrol_id, visit_date, first_name, last_name, state_id, sex, d_o_b, age, ageblw5, village, town, lga, facid, state, pat_add, pat_phone_no, marr_stat, pref_lang, row_number() over(partition by enrol_id order by idno desc) as enrol_CT from PersonalHistGen_info)o where enrol_CT = 1 order by idno " + paging;
                    
                using (SqlCommand cmd = new SqlCommand(patientQuery, connection))
                {
                    // if(connection.State == ConnectionState.Open){
                    //     connection.Close();
                    // }
                    connection.Open();
                    using (SqlDataReader reader = cmd.ExecuteReader())
                    {
                        // Check if the reader has any rows at all before starting to read.
                        if (reader.HasRows)
                        {
                            var patients = new List<PatientModel>();
                            // Read advances to the next row.
                            while (reader.Read())
                            {
                                var p = new PatientModel
                                {
                                    FirstName = reader["first_name"].ToString().Trim(),
                                    LastName = reader["last_name"].ToString().Trim(),
                                    EnrolmentId = reader["enrol_id"].ToString().Trim(),
                                    IdNo = Convert.ToInt32(reader["idno"])
                                };

                                if (reader["visit_date"] != null)
                                {
                                    var visitDate = reader["visit_date"];
                                    if(!string.IsNullOrEmpty(visitDate.ToString().Trim()))
                                    {
                                        DateTime dateTime;
                                        if (DateTime.TryParse(visitDate.ToString().Trim(), out dateTime))
                                        {
                                            p.VisitDate = dateTime;
                                        }
                                    }
                                }
                                
                                if (reader["state_id"] != null)
                                {
                                    var stateId = reader["state_id"];
                                    if(!string.IsNullOrEmpty(stateId.ToString().Trim()))
                                    {
                                        p.StateId = stateId.ToString().Trim();
                                    }
                                }

                                //p.SiteCode = siteCode.Trim();

                                if (reader["d_o_b"] != null)
                                {
                                    var dob  = reader["d_o_b"];
                                    if(!string.IsNullOrEmpty(dob.ToString().Trim()))
                                    {
                                         DateTime dateTime;
                                        if (DateTime.TryParse(dob.ToString().Trim(), out dateTime))
                                        {
                                            p.DateOfBirth = dateTime;
                                            p.Age = DoBCalc.Age(dateTime);
                                        }
                                    }
                                }
                                
                                if (reader["sex"] != null)
                                {
                                    var sex = reader["sex"];
                                    if(!string.IsNullOrEmpty(sex.ToString().Trim()))
                                    {
                                        p.Sex = sex.ToString().Trim();
                                    }
                                }
                                if (reader["village"] != null)
                                {
                                    var village = reader["village"];
                                    if(!string.IsNullOrEmpty(village.ToString().Trim()))
                                    {
                                        p.Village = village.ToString().Trim();
                                    }
                                    
                                }
                                if (reader["town"] != null)
                                {
                                    var town = reader["town"];
                                    if(!string.IsNullOrEmpty(town.ToString().Trim()))
                                    {
                                        p.Town = town.ToString().Trim();
                                    }
                                }
                                if (reader["pat_phone_no"] != null)
                                {
                                    var phoneNumber = reader["pat_phone_no"];
                                    if(!string.IsNullOrEmpty(phoneNumber.ToString().Trim()))
                                    {
                                        p.PhoneNumber = RegexConvert.GetNumeric(phoneNumber.ToString().Trim().Replace(" ", string.Empty));
                                    }
                                }
                                if (reader["pat_add"] != null)
                                {
                                    var addr = reader["pat_add"];
                                    if(!string.IsNullOrEmpty(addr.ToString().Trim()))
                                    {
                                        p.AddressLine1 = addr.ToString().Trim();
                                    }
                                }
                                
                                if (reader["state"] != null)
                                {
                                    var state = reader["state"];
                                    if(!string.IsNullOrEmpty(state.ToString().Trim()))
                                    {
                                        p.State = state.ToString().Trim();
                                    }
                                }
                                if (reader["lga"] != null)
                                {
                                    var lga = reader["lga"];
                                    if(!string.IsNullOrEmpty(lga.ToString().Trim()))
                                    {
                                        p.Lga = lga.ToString().Trim();
                                    }
                                }
                                if (reader["marr_stat"] != null)
                                {
                                    var marStat = reader["marr_stat"];
                                    if(!string.IsNullOrEmpty(marStat.ToString().Trim()))
                                    {
                                        p.MaritalStatus = marStat.ToString().Trim();
                                    }
                                }
                                if (reader["pref_lang"] != null)
                                {
                                    var prefLang = reader["pref_lang"];
                                    if(!string.IsNullOrEmpty(prefLang.ToString().Trim()))
                                    {
                                        p.PreferredLanguage = prefLang.ToString().Trim();
                                    }
                                }
                                p.SiteId = siteId;
                                patients.Add(p);
                            }
                           
                            if (patients.Any())
                            {
                                //var processed = _patientService.AddPatients(patients, currentPage, siteId);
                                gVal = _patientService.AddPatients(patients, currentPage);
                                if (gVal.Code == -1)
                                {
                                    gVal.Message = "Patient Batch Processing failed";
                                }
                                else
                                {
                                    gVal.Message = "Patient Batch Processing succeeded";
                                }

                                return gVal;
                            }
                           
                        }
                        gVal.Code = 0;
                        gVal.Message = "No Patient records found";
                        return gVal;
                    }
                }
                
            }
            catch(Exception ex)
            {
                gVal.Code = -1;
                gVal.Message = ex.Message != null ? ex.Message : ex.InnerException != null ? ex.InnerException.Message : "An unknown error was encountered. Please try again.";
                return gVal;
            }            
        }
        private GenericValidator GetArtBaselineData(SqlConnection connection, int currentPage, int itemsPerPage, int siteId)
        {
            var gVal = new GenericValidator();
            try
            { 
                var paging = "desc offset " + itemsPerPage + "*" + (currentPage - 1) + " rows fetch next " + itemsPerPage + " rows only";

                var query = "select * from (select idno, enrol_id, adlt_hiv_date, adlt_enrol_date, adlt_art_date, pat_disp_code, pat_disp_date, " +
                    "row_number() over(partition by enrol_id order by idno desc) as enrol_CT from art_baseline_adult)o where enrol_CT = 1 order by idno " + paging;

                using (SqlCommand cmd = new SqlCommand(query, connection))
                {
                    connection.Open();
                    using (SqlDataReader reader = cmd.ExecuteReader())
                    {
                        // Check if the reader has any rows at all before starting to read.
                        if (reader.HasRows)
                        {
                            var artBaselines = new List<ArtBaselineModel>();
                            // Read advances to the next row.
                            //idno
                            while (reader.Read())
                            {
                                var p = new ArtBaselineModel
                                {
                                    EnrolmentId = reader["enrol_id"].ToString().Trim(),
                                    IdNo = Convert.ToInt32(reader["idno"])
                                };

                                if (reader["adlt_hiv_date"] != null)
                                {
                                    var hivConfirmationDate = reader["adlt_hiv_date"].ToString();
                                    if(!string.IsNullOrEmpty(hivConfirmationDate.Trim()))
                                    {
                                        if (Regex.IsMatch(hivConfirmationDate, @"[0-9][0-9]-[0-9][0-9] [0-9][0-9][0-9][0-9]\s+") || Regex.IsMatch(hivConfirmationDate, @"[0-9][0-9]-[0-9][0-9] [0-9][0-9][0-9][0-9]"))
                                        {
                                            var sr = hivConfirmationDate.Split('-');
                                            var tt = sr[1].Split(' ');
                                            hivConfirmationDate = tt[1] + "-" + tt[0] + "-" + sr[0];
                                        }
                                        else
                                        {
                                            if (Regex.IsMatch(hivConfirmationDate, @"[0-9][0-9]-[0-9][0-9]-[0-9][0-9][0-9][0-9]\s+") || Regex.IsMatch(hivConfirmationDate, @"[0-9][0-9]-[0-9][0-9]-[0-9][0-9][0-9][0-9]"))
                                            {
                                                var sr = hivConfirmationDate.Split('-');
                                                var tt = sr[2].Split(' ');
                                                hivConfirmationDate = tt[0] + "-" + sr[1] + "-" + sr[0];
                                            }
                                        }

                                        DateTime dateTime;
                                        if (DateTime.TryParse(hivConfirmationDate.Trim(), out dateTime))
                                        {
                                            p.HivConfirmationDate = dateTime > DateTime.Today? DateTime.Today : dateTime;
                                        }
                                        else
                                        {
                                            p.HivConfirmationDate = DateTime.Today;
                                        }
                                    }
                                    else
                                    {
                                        p.HivConfirmationDate = DateTime.Today;
                                    }
                                }
                                else
                                {
                                    p.HivConfirmationDate = DateTime.Today;
                                }

                                if (reader["adlt_enrol_date"] != null)
                                {
                                    var enrolmentDate = reader["adlt_enrol_date"];
                                    if(!string.IsNullOrEmpty(enrolmentDate.ToString().Trim()))
                                    {
                                        DateTime dateTime;
                                        if (DateTime.TryParse(enrolmentDate.ToString().Trim(), out dateTime))
                                        {
                                            p.EnrolmentDate = dateTime > DateTime.Today ? DateTime.Today : dateTime;
                                        }
                                        else
                                        {
                                            p.EnrolmentDate = DateTime.Today;
                                        }
                                    }
                                    else
                                    {
                                        p.EnrolmentDate = DateTime.Today;
                                    }
                                }
                                else
                                {
                                    p.EnrolmentDate = DateTime.Today;
                                }

                                if (reader["adlt_art_date"] != null)
                                {
                                    var artDate = reader["adlt_art_date"].ToString();
                                    if(!string.IsNullOrEmpty(artDate.Trim()))
                                    {
                                        if (Regex.IsMatch(artDate, @"[0-9][0-9]-[0-9][0-9] [0-9][0-9][0-9][0-9]\s+") || Regex.IsMatch(artDate, @"[0-9][0-9]-[0-9][0-9] [0-9][0-9][0-9][0-9]"))
                                        {
                                            var sr = artDate.Split('-');
                                            var tt = sr[1].Split(' ');
                                            artDate = tt[1] + "-" + tt[0] + "-" + sr[0];
                                        }
                                        else
                                        {
                                            if (Regex.IsMatch(artDate, @"[0-9][0-9]-[0-9][0-9]-[0-9][0-9][0-9][0-9]\s+") || Regex.IsMatch(artDate, @"[0-9][0-9]-[0-9][0-9]-[0-9][0-9][0-9][0-9]"))
                                            {
                                                var sr = artDate.Split('-');
                                                var tt = sr[2].Split(' ');
                                                artDate = tt[0] + "-" + sr[1] + "-" + sr[0];
                                            }
                                        }

                                        DateTime dateTime;
                                        if (DateTime.TryParse(artDate.Trim(), out dateTime))
                                        {
                                            p.ArtDate = dateTime > DateTime.Today ? DateTime.Today : dateTime;
                                        }
                                        else
                                        {
                                            p.ArtDate = DateTime.Today;
                                        }
                                    }
                                    else
                                    {
                                        p.ArtDate = DateTime.Today;
                                    }
                                }
                                else
                                {
                                    p.ArtDate = DateTime.Today;
                                }

                                if (reader["pat_disp_date"] != null)
                                {
                                    var dispDate = reader["pat_disp_date"];
                                    if (!string.IsNullOrEmpty(dispDate.ToString().Trim()))
                                    {
                                        var str = dispDate.ToString().Trim();
                                        p.DispositionDate = str.Length > 450 ? string.Empty : str;
                                    }
                                }

                                if (reader["pat_disp_code"] != null)
                                {
                                    var dispCode = reader["pat_disp_code"];
                                    if(!string.IsNullOrEmpty(dispCode.ToString().Trim()))
                                    {
                                        var str = dispCode.ToString().Trim();
                                        p.DispositionCode = str.Length > 450 ? string.Empty : str;
                                    }
                                }

                                artBaselines.Add(p);
                            }

                            if(artBaselines.Any())
                            {
                                var newBaselines = new List<ArtBaselineModel>();
                                artBaselines.ForEach(b => 
                                {
                                    var bb = newBaselines.Find(l => l.EnrolmentId == b.EnrolmentId);
                                    if (bb == null)
                                    {
                                        newBaselines.Add(b);
                                    }
                                    else
                                    {
                                        bb.HivConfirmationDate = b.HivConfirmationDate;
                                        bb.EnrolmentDate = b.EnrolmentDate;
                                        bb.ArtDate = b.ArtDate;
                                        bb.DispositionCode = b.DispositionCode;
                                        bb.DispositionDate = b.DispositionDate;
                                        bb.IdNo = b.IdNo;
                                    }
                                });
                                //var processed = _artBaselineService.AddArtBaselines(artBaselines, currentPage, siteId, 1);
                                gVal = _artBaselineService.InsertArtBaselines(newBaselines, currentPage, siteId, 1);
                                if (gVal.Code < 1)
                                {
                                    return gVal;
                                }
                                gVal.Message = "Adult Baseline Batch Processing succeeded";
                                return gVal;
                            }
                            
                        }
                        gVal.Code = 0;
                        gVal.Message = "No Adult Baseline records found";
                        return gVal;
                    }
                }
                
            }
            catch(Exception ex)
            {
                gVal.Code = -1;
                gVal.Message = ex.Message != null ? ex.Message : ex.InnerException != null ? ex.InnerException.Message : "An unknown error was encountered. Please try again.";
                return gVal;
            }            
        }

        private string LocalIPAddress()
        {
            string localIP = "You are not connected to the internet";
            if (System.Net.NetworkInformation.NetworkInterface.GetIsNetworkAvailable())
            {                
                using (Socket socket = new Socket(AddressFamily.InterNetwork, SocketType.Dgram, 0))
                {
                    socket.Connect("8.8.8.8", 65530);
                    IPEndPoint endPoint = socket.LocalEndPoint as IPEndPoint;
                    localIP = endPoint.Address.ToString();
                }               
                    
            }
            return localIP;
        }

        private GenericValidator GetPaediatricArtBaselineData(SqlConnection connection, int currentPage, int itemsPerPage, int siteId)
        {
            var gVal = new GenericValidator();
            try
            {
                var paging = "desc offset " + itemsPerPage + "*" + (currentPage - 1) + " rows fetch next " + itemsPerPage + " rows only";
                var query = "select * from (select idno, enrol_id, chld_hiv_date, chld_enrol_date, chld_arv_date, pat_out_date, pat_out_code, " +
                    "row_number() over(partition by enrol_id order by idno desc) as enrol_CT from art_baseline_paeds)o where enrol_CT = 1 order by idno " + paging;
       
                using (SqlCommand cmd = new SqlCommand(query, connection))
                {
                    // if(connection.State == ConnectionState.Open){
                    //     connection.Close();
                    // }
                    connection.Open();
                    using (SqlDataReader reader = cmd.ExecuteReader())
                    {
                        // Check if the reader has any rows at all before starting to read.
                        if (reader.HasRows)
                        {
                            var paediatricArtBaselines = new List<ArtBaselineModel>();
                            // Read advances to the next row.
                            //idno
                            while (reader.Read())
                            {
                                var p = new ArtBaselineModel
                                {
                                    EnrolmentId = reader["enrol_id"].ToString().Trim(),
                                    IdNo = Convert.ToInt32(reader["idno"])
                                };
                                if (reader["chld_hiv_date"] != null)
                                {
                                    var hivConfirmationDate = reader["chld_hiv_date"];
                                    if(!string.IsNullOrEmpty(hivConfirmationDate.ToString().Trim()))
                                    {
                                        DateTime dateTime;
                                        if (DateTime.TryParse(hivConfirmationDate.ToString().Trim(), out dateTime))
                                        {
                                            p.HivConfirmationDate = dateTime > DateTime.Today ? DateTime.Today : dateTime;
                                        }
                                        else
                                        {
                                            p.HivConfirmationDate = (DateTime)System.Data.SqlTypes.SqlDateTime.MinValue;
                                        }
                                    }
                                    else
                                    {
                                        p.HivConfirmationDate = (DateTime)System.Data.SqlTypes.SqlDateTime.MinValue;
                                    }
                                }
                                else
                                {
                                    p.HivConfirmationDate = (DateTime)System.Data.SqlTypes.SqlDateTime.MinValue;
                                }

                                if (reader["chld_enrol_date"] != null)
                                {
                                    var enrolmentDate = reader["chld_enrol_date"];
                                    if(!string.IsNullOrEmpty(enrolmentDate.ToString().Trim()))
                                    {
                                        DateTime dateTime;
                                        if (DateTime.TryParse(enrolmentDate.ToString().Trim(), out dateTime))
                                        {
                                            p.EnrolmentDate = dateTime > DateTime.Today ? DateTime.Today : dateTime;
                                        }
                                        else
                                        {
                                            p.EnrolmentDate = (DateTime)System.Data.SqlTypes.SqlDateTime.MinValue;
                                        }
                                    }
                                    else
                                    {
                                        p.EnrolmentDate = (DateTime)System.Data.SqlTypes.SqlDateTime.MinValue;
                                    }
                                }
                                else
                                {
                                    p.EnrolmentDate = (DateTime)System.Data.SqlTypes.SqlDateTime.MinValue;
                                }
                                if (reader["chld_arv_date"] != null)
                                {
                                    var artDate = reader["chld_arv_date"];
                                    if(!string.IsNullOrEmpty(artDate.ToString().Trim()))
                                    {
                                        DateTime dateTime;
                                        if (DateTime.TryParse(artDate.ToString().Trim(), out dateTime))
                                        {
                                            p.ArtDate = dateTime > DateTime.Today ? DateTime.Today : dateTime;
                                        }
                                        else
                                        {
                                            p.ArtDate = (DateTime)System.Data.SqlTypes.SqlDateTime.MinValue;
                                        }
                                    }
                                    else
                                    {
                                        p.ArtDate = (DateTime)System.Data.SqlTypes.SqlDateTime.MinValue;
                                    }
                                }
                                else
                                {
                                    p.ArtDate = (DateTime)System.Data.SqlTypes.SqlDateTime.MinValue;
                                }

                                if (reader["pat_out_date"] != null)
                                {
                                    var dispositionDate = reader["pat_out_date"];
                                    if (!string.IsNullOrEmpty(dispositionDate.ToString().Trim()))
                                    {
                                        var str = dispositionDate.ToString().Trim();
                                        p.DispositionDate = str.Length > 450? string.Empty : str;
                                    }
                                }

                                if (reader["pat_out_code"] != null)
                                {
                                    var dispCode = reader["pat_out_code"];
                                    if(!string.IsNullOrEmpty(dispCode.ToString().Trim()))
                                    {
                                        var str = dispCode.ToString().Trim();
                                        p.DispositionCode = str.Length > 450 ? string.Empty : str;
                                    }
                                }
                                paediatricArtBaselines.Add(p);
                            }
                            if(paediatricArtBaselines.Any())
                            {
                                var newBaselines = new List<ArtBaselineModel>();
                                paediatricArtBaselines.ForEach(b =>
                                {
                                    var bb = newBaselines.Find(l => l.EnrolmentId == b.EnrolmentId);
                                    if (bb == null)
                                    {
                                        newBaselines.Add(b);
                                    }
                                    else
                                    {
                                        bb.HivConfirmationDate = b.HivConfirmationDate;
                                        bb.EnrolmentDate = b.EnrolmentDate;
                                        bb.ArtDate = b.ArtDate;
                                        bb.DispositionCode = b.DispositionCode;
                                        bb.DispositionDate = b.DispositionDate;
                                        bb.IdNo = b.IdNo;
                                    }
                                });

                                //var processed = _artBaselineService.AddArtBaselines(paediatricArtBaselines, currentPage, siteId, 2);
                                gVal = _artBaselineService.InsertArtBaselines(newBaselines, currentPage, siteId, 2);
                                if (gVal.Code < 1)
                                {
                                    return gVal;
                                }

                                gVal.Message = "Paediatric Baseline Batch Processing succeeded";
                                return gVal;
                            }
                           
                        }

                        gVal.Code = 0;
                        gVal.Message = "No Paediatric Baseline records found";
                        return gVal;
                    }
                }                
            }
            catch(Exception ex)
            {
                gVal.Code = -1;
                gVal.Message = ex.Message != null ? ex.Message : ex.InnerException != null ? ex.InnerException.Message : "An unknown error was encountered. Please try again.";
                return gVal;
            }            
        }
        private GenericValidator GetArtVisits(SqlConnection connection, int currentPage, int itemsPerPage, int siteId)
        {
            var gVal = new GenericValidator();
            try
            {                
                var paging = "OFFSET " + itemsPerPage + "*" + (currentPage - 1) + " ROWS FETCH NEXT " + itemsPerPage + " ROWS ONLY";
                var artVisitQuery = "SELECT idno,enrol_id,visit_date,weight,height,temp_,bp,who_stage,pregn,tb_scr,diag_tbrx,start_tbrx,cotr_prop," +
                "art_start,arv_reg_code,art_adh_code,non_adh_code,drug_rxn_code,arv_stop_code,arv_stop_date,cd4_count,hgb,alt,fam_plan_code,apt_date,stat_code FROM art_visit_adult ORDER BY idno " + paging;                
                
                using (SqlCommand cmd = new SqlCommand(artVisitQuery, connection))
                {
                    // if(connection.State == ConnectionState.Open){
                    //     connection.Close();
                    // }
                    connection.Open();
                    using (SqlDataReader reader = cmd.ExecuteReader())
                    {
                        // Check if the reader has any rows at all before starting to read.
                        if (reader.HasRows)
                        {
                            var artVisits = new List<ArtVisitModel>(); 
                            // Read advances to the next row.
                            while (reader.Read())
                            {
                                var p = new ArtVisitModel
                                {
                                    EnrolmentId = reader["enrol_id"].ToString().Trim(),
                                    IdNo = Convert.ToInt32(reader["idno"])
                                };
                                if (reader["visit_date"] != null)
                                {
                                    var visitDate = reader["visit_date"];
                                    if(!string.IsNullOrEmpty(visitDate.ToString().Trim()))
                                    {
                                        DateTime dateTime;
                                        if (DateTime.TryParse(visitDate.ToString().Trim(), out dateTime))
                                        {
                                            p.VisitDate = dateTime > DateTime.Today ? DateTime.Today : dateTime;
                                        }
                                        else
                                        {
                                            p.VisitDate = DateTime.Today;
                                        }
                                    }
                                    else
                                    {
                                        p.VisitDate = DateTime.Today;
                                    }
                                }
                                else
                                {
                                    p.VisitDate = DateTime.Today;
                                }

                                var weight = reader["weight"].ToString().Trim().Replace(" ", string.Empty);                               
                                float wOut = 0;
                                if (!string.IsNullOrEmpty(weight))
                                {
                                    var wt = Regex.Match(weight, "\\d+");
                                    float.TryParse(wt.ToString(), out wOut);
                                    if (wOut > 0)
                                    {
                                        p.Weight = wOut;
                                    }
                                }                                  
                               
                                var height = reader["height"].ToString().Trim().Replace(" ", string.Empty);
                                float hOut = 0;
                                if (!string.IsNullOrEmpty(height))
                                {
                                    var ht = Regex.Match(height, "\\d+");
                                    float.TryParse(ht.ToString(), out hOut);
                                }
                                if (hOut > 0)
                                {
                                    p.Height = (hOut < 10) ? (hOut * 100) : hOut;
                                }

                                if (reader["temp_"] != null)
                                {
                                    var temp = reader["temp_"];
                                    if(!string.IsNullOrEmpty(temp.ToString().Trim()))
                                    {
                                        Double output;
                                        if (Double.TryParse(temp.ToString().Trim(), out output))
                                        {
                                            p.Temperature = output;
                                        }
                                    }
                                }
                                
                                if (reader["who_stage"] != null)
                                {
                                    var whoStage = reader["who_stage"];
                                    if(!string.IsNullOrEmpty(whoStage.ToString().Trim()))
                                    {
                                        p.WhoStage = whoStage.ToString().Trim();
                                    }
                                }   
                                if (reader["pregn"] != null)
                                {
                                    var pregn = reader["pregn"].ToString().Trim();
                                    if(!string.IsNullOrEmpty(pregn))
                                    {
                                        var prBool = pregn.ToLower();
                                        p.IsPregnant = prBool == "yes"? true : false;
                                    }
                                }
                                if (reader["tb_scr"] != null)
                                {
                                    var tbScr = reader["tb_scr"];
                                    if(!string.IsNullOrEmpty(tbScr.ToString().Trim()))
                                    {
                                        p.TbScreen = tbScr.ToString().Trim();
                                    }
                                }
                                if (reader["diag_tbrx"] != null)
                                {
                                    var diagTbrx = reader["diag_tbrx"];
                                    if(!string.IsNullOrEmpty(diagTbrx.ToString().Trim()))
                                    {
                                        p.TbDiagnosedTreatment = diagTbrx.ToString().Trim();
                                    }
                                }
                                
                                if (reader["start_tbrx"] != null)
                                {
                                    var startTbrx = reader["start_tbrx"];
                                    if(!string.IsNullOrEmpty(startTbrx.ToString().Trim()))
                                    {
                                        p.TbTreatmentStarted = startTbrx.ToString().Trim();
                                    }
                                }
                                if (reader["cotr_prop"] != null)
                                {
                                    var cotrProp = reader["cotr_prop"];
                                    if(!string.IsNullOrEmpty(cotrProp.ToString().Trim()))
                                    {
                                        p.CotrimeProphylaxis = cotrProp.ToString().Trim();
                                    }
                                }
                                if (reader["art_start"] != null)
                                {
                                    var artStart = reader["art_start"];
                                    if(!string.IsNullOrEmpty(artStart.ToString().Trim()))
                                    {
                                        var artStartBool = artStart.ToString().Trim().ToLower();
                                        p.ArtStarted = artStartBool == "yes";
                                    }
                                }
                                if (reader["arv_reg_code"] != null)
                                {
                                    var arvRegCode = reader["arv_reg_code"];
                                    if(!string.IsNullOrEmpty(arvRegCode.ToString().Trim()))
                                    {
                                        p.ArvRegimenCode = arvRegCode.ToString().Trim();
                                    }
                                }
                                
                                if (reader["art_adh_code"] != null)
                                {
                                    var artAdhCode = reader["art_adh_code"];
                                    if(!string.IsNullOrEmpty(artAdhCode.ToString().Trim()))
                                    {
                                        p.ArvAdherenceCode = artAdhCode.ToString().Trim();
                                    }
                                }
                                if (reader["non_adh_code"] != null)
                                {
                                    var nonAdhCode = reader["non_adh_code"];
                                    if(!string.IsNullOrEmpty(nonAdhCode.ToString().Trim()))
                                    {
                                        p.ArvNonAdherenceCode = nonAdhCode.ToString().Trim();
                                    }
                                }
                                if (reader["drug_rxn_code"] != null)
                                {
                                    var drugRxnCode = reader["drug_rxn_code"];
                                    if(!string.IsNullOrEmpty(drugRxnCode.ToString().Trim()))
                                    {
                                        p.DrugReactionCode = drugRxnCode.ToString().Trim();
                                    }
                                }
                                if (reader["arv_stop_code"] != null)
                                {
                                    var arvStopCode = reader["arv_stop_code"];
                                    if(!string.IsNullOrEmpty(arvStopCode.ToString().Trim()))
                                    {
                                        p.ArvStopCode = arvStopCode.ToString().Trim();
                                    }
                                }
                                if (reader["arv_stop_date"] != null)
                                {
                                    var arvStopDate  = reader["arv_stop_date"];
                                    if(!string.IsNullOrEmpty(arvStopDate.ToString().Trim()))
                                    {
                                        DateTime dateTime;
                                        if (DateTime.TryParse(arvStopDate.ToString().Trim(), out dateTime))
                                        {
                                            p.ArvStopDate = dateTime > DateTime.Today ? DateTime.Today : dateTime;
                                        }
                                    }
                                }
                                
                                if (reader["cd4_count"] != null)
                                {
                                    var cd4Count = reader["cd4_count"];
                                    if(!string.IsNullOrEmpty(cd4Count.ToString().Trim()))
                                    {
                                        p.Cd4Count = cd4Count.ToString().Trim();
                                    }
                                }
                                if (reader["bp"] != null)
                                {
                                    var bp = reader["bp"];
                                    if(!string.IsNullOrEmpty(bp.ToString().Trim()))
                                    {
                                        p.BloodPressure = bp.ToString().Trim();
                                    }
                                }
                                if (reader["fam_plan_code"] != null)
                                {
                                    var famPlanCode = reader["fam_plan_code"];
                                    if(!string.IsNullOrEmpty(famPlanCode.ToString().Trim()))
                                    {
                                        p.FamilyPlanningCode = famPlanCode.ToString().Trim();
                                    }
                                }

                                var nextApp = p.VisitDate.Value.AddMonths(3);

                                if (reader["apt_date"] != null)
                                {
                                    var aptDate  = reader["apt_date"];
                                    if(!string.IsNullOrEmpty(aptDate.ToString().Trim()))
                                    {
                                        DateTime dateTime;
                                        if (DateTime.TryParse(aptDate.ToString().Trim(), out dateTime))
                                        {
                                           
                                            p.AppointmentDate = dateTime > nextApp ? nextApp : dateTime;
                                        }
                                        else
                                        {
                                            p.AppointmentDate = nextApp;
                                        }
                                    }
                                    else
                                    {
                                        p.AppointmentDate = nextApp;
                                    }
                                }
                                else
                                {
                                    p.AppointmentDate = nextApp;
                                }

                                if (reader["stat_code"] != null)
                                {
                                    var statCode  = reader["stat_code"];
                                    if(!string.IsNullOrEmpty(statCode.ToString().Trim()))
                                    {
                                        p.StatusCode = statCode.ToString().Trim();
                                    }
                                }

                                if (!string.IsNullOrEmpty(p.ArvRegimenCode))
                                {
                                    p.ArvRegimenCode = p.ArvRegimenCode.Replace("-", "+").Replace("/", "+").Replace("+R", "/R");
                                }
                                else
                                {
                                    p.ArvRegimenCode = RegimenMapper.RetrieveRegimen(p.ArvRegimen1, p.ArvRegimen2, p.ArvRegimen3);
                                }

                                artVisits.Add(p);
                            }
                            if(artVisits.Any())
                            {
                                gVal = _artVisitService.InsertArtVisits(artVisits, currentPage, siteId);
                                //var processed = _artVisitService.AddArtVisits(artVisits, currentPage, siteId, 1);
                                if (gVal.Code < 1)
                                {
                                    return gVal;
                                }
                                gVal.Message = "Adult Baseline Batch Processing succeeded";
                                return gVal;
                            }
                        }

                        gVal.Code = 0;
                        gVal.Message = "No Adult Art Visit records found";
                        return gVal;
                    }
                }
                
            }
            catch(Exception ex)
            {
                gVal.Code = -1;
                gVal.Message = ex.Message != null ? ex.Message : ex.InnerException != null ? ex.InnerException.Message : "An unknown error was encountered. Please try again.";
                return gVal;
            }            
        }        
        private GenericValidator GetPaediatricArtVisits(SqlConnection connection, int currentPage, int itemsPerPage, int siteId)
        {
            var gVal = new GenericValidator();
            try
            {
                var paging = "OFFSET " + itemsPerPage + "*" + (currentPage - 1) + " ROWS FETCH NEXT " + itemsPerPage + " ROWS ONLY";
                var paediatricArtVisitQuery = "SELECT idno,enrol_id,visit_date,weight,who_stage,tbscr_cont,tbscr_susp,diag_tbrx," +
                "tbrx,ctx,start_arv,arv_reg_drug1,arv_reg_drug2,arv_reg_drug3,arv_adh_code,non_adh_code,adv_drug_code,"+
                "arv_stop_code,arv_stop_date,next_apt_date,arv_reg_code FROM art_visit_paeds ORDER BY idno " + paging;                
                
                using (SqlCommand cmd = new SqlCommand(paediatricArtVisitQuery, connection))
                {
                    // if(connection.State == ConnectionState.Open){
                    //     connection.Close();
                    // }
                    connection.Open();
                    using (SqlDataReader reader = cmd.ExecuteReader())
                    {
                        // Check if the reader has any rows at all before starting to read.
                        if (reader.HasRows)
                        {
                            var paediatricArtVisits = new List<ArtVisitModel>(); 
                            // Read advances to the next row.
                            while (reader.Read())
                            {
                                var p = new ArtVisitModel
                                {
                                    EnrolmentId = reader["enrol_id"].ToString().Trim(),
                                    IdNo = Convert.ToInt32(reader["idno"])
                                };
                                if (reader["visit_date"] != null)
                                {
                                    var visitDate = reader["visit_date"];
                                    if(!string.IsNullOrEmpty(visitDate.ToString().Trim()))
                                    {
                                        DateTime dateTime;
                                        if (DateTime.TryParse(visitDate.ToString().Trim(), out dateTime))
                                        {
                                            p.VisitDate = dateTime > DateTime.Today ? DateTime.Today : dateTime;
                                        }
                                    }
                                }
                                
                                if (reader["weight"] != null)
                                {
                                    var weight = reader["weight"];
                                    if(!string.IsNullOrEmpty(weight.ToString().Trim()))
                                    {
                                        Double output;
                                        if (Double.TryParse(weight.ToString().Trim(), out output))
                                        {
                                            p.Weight = output;
                                        }
                                    }
                                } 
                                if (reader["who_stage"] != null)
                                {
                                    var whoStage = reader["who_stage"];
                                    if(!string.IsNullOrEmpty(whoStage.ToString().Trim()))
                                    {
                                        p.WhoStage = whoStage.ToString().Trim();
                                    }
                                } 
                                if (reader["tbscr_cont"] != null)
                                {
                                    var tbscrCont = reader["tbscr_cont"];
                                    if(!string.IsNullOrEmpty(tbscrCont.ToString().Trim()))
                                    {
                                        p.TbScreen = tbscrCont.ToString().Trim();
                                    }
                                }
                                
                                if (reader["diag_tbrx"] != null)
                                {
                                    var diagTbrx = reader["diag_tbrx"];
                                    if(!string.IsNullOrEmpty(diagTbrx.ToString().Trim()))
                                    {
                                        var diagTbrxBool = diagTbrx.ToString().Trim().ToLower();
                                        p.TbDiagnosed = diagTbrxBool == "yes";
                                    }
                                }
                                if (reader["tbscr_susp"] != null)
                                {
                                    var tbscrSusp = reader["tbscr_susp"];
                                    if(!string.IsNullOrEmpty(tbscrSusp.ToString().Trim()))
                                    {
                                        var tbscrSuspBool = tbscrSusp.ToString().Trim().ToLower();
                                        p.TbSuspected = tbscrSuspBool == "yes";
                                    }
                                }      
                                if (reader["tbrx"] != null)
                                {
                                    var tbrx = reader["tbrx"];
                                    if(!string.IsNullOrEmpty(tbrx.ToString().Trim()))
                                    {
                                        var tbrxBool = tbrx.ToString().Trim().ToLower();
                                        p.TbTreatmentReceived = tbrxBool == "yes";
                                    }
                                }
                                if (reader["ctx"] != null)
                                {
                                    var ctx = reader["ctx"];
                                    if(!string.IsNullOrEmpty(ctx.ToString().Trim()))
                                    {
                                        var ctxBool = ctx.ToString().Trim().ToLower();
                                        p.ReceivingContrime = ctxBool == "yes";
                                    }
                                }
                                
                                if (reader["start_arv"] != null)
                                {
                                    var startArv = reader["start_arv"];
                                    if(!string.IsNullOrEmpty(startArv.ToString().Trim()))
                                    {
                                        var startArvBool = startArv.ToString().Trim().ToLower();
                                        p.ArtStarted = startArvBool == "yes";
                                    }
                                }
                                if (reader["arv_reg_code"] != null)
                                {
                                    var arvRegCode = reader["arv_reg_code"];
                                    if(!string.IsNullOrEmpty(arvRegCode.ToString().Trim()))
                                    {
                                        p.ArvRegimenCode = arvRegCode.ToString().Trim();
                                    }
                                }
                                if (reader["arv_adh_code"] != null)
                                {
                                    var artAdhCode = reader["arv_adh_code"];
                                    if(!string.IsNullOrEmpty(artAdhCode.ToString().Trim()))
                                    {
                                        p.ArvAdherenceCode = artAdhCode.ToString().Trim();
                                    }
                                }
                                if (reader["non_adh_code"] != null)
                                {
                                    var nonAdhCode = reader["non_adh_code"];
                                    if(!string.IsNullOrEmpty(nonAdhCode.ToString().Trim()))
                                    {
                                        p.ArvNonAdherenceCode = nonAdhCode.ToString().Trim();
                                    }
                                }
                                if (reader["arv_reg_drug1"] != null)
                                {
                                    var arvRegDrug1 = reader["arv_reg_drug1"];
                                    if(!string.IsNullOrEmpty(arvRegDrug1.ToString().Trim()))
                                    {
                                        p.ArvRegimen1 = arvRegDrug1.ToString().Trim();
                                    }
                                }
                                if (reader["arv_reg_drug2"] != null)
                                {
                                    var arvRegDrug2 = reader["arv_reg_drug2"];
                                    if(!string.IsNullOrEmpty(arvRegDrug2.ToString().Trim()))
                                    {
                                        p.ArvRegimen2 = arvRegDrug2.ToString().Trim();
                                    }
                                }
                                
                                if (reader["arv_reg_drug3"] != null)
                                {
                                    var arvRegDrug3 = reader["arv_reg_drug3"];
                                    if(!string.IsNullOrEmpty(arvRegDrug3.ToString().Trim()))
                                    {
                                        p.ArvRegimen3 = arvRegDrug3.ToString().Trim();
                                    }
                                }
                                if (reader["arv_stop_code"] != null)
                                {
                                    var arvStopCode = reader["arv_stop_code"];
                                    if(!string.IsNullOrEmpty(arvStopCode.ToString().Trim()))
                                    {
                                        p.ArvStopCode = arvStopCode.ToString().Trim();
                                    }
                                }
                                if (reader["arv_stop_date"] != null)
                                {
                                    var arvStopDate  = reader["arv_stop_date"];
                                    if(!string.IsNullOrEmpty(arvStopDate.ToString().Trim()))
                                    {
                                        DateTime dateTime;
                                        if (DateTime.TryParse(arvStopDate.ToString().Trim(), out dateTime))
                                        {
                                            p.ArvStopDate = dateTime > DateTime.Today ? DateTime.Today : dateTime;
                                        }
                                    }
                                }
                                if (reader["next_apt_date"] != null)
                                {
                                    var nextAptDate  = reader["next_apt_date"];
                                    if(!string.IsNullOrEmpty(nextAptDate.ToString().Trim()))
                                    {
                                        DateTime dateTime;
                                        if (DateTime.TryParse(nextAptDate.ToString().Trim(), out dateTime))
                                        {
                                            p.AppointmentDate = dateTime;
                                        }
                                    }
                                }
                                
                                 if (reader["adv_drug_code"] != null)
                                 {
                                    var advDrugCode = reader["adv_drug_code"];
                                    if(!string.IsNullOrEmpty(advDrugCode.ToString().Trim()))
                                    {
                                        p.AdvDrugCode = advDrugCode.ToString().Trim();
                                    }
                                 }
                                 
                                if (!string.IsNullOrEmpty(p.ArvRegimenCode))
                                {
                                    p.ArvRegimenCode = p.ArvRegimenCode.Replace("-", "+").Replace("/", "+").Replace("+R", "/R");
                                }
                                else
                                {
                                    p.ArvRegimenCode = RegimenMapper.RetrieveRegimen(p.ArvRegimen1, p.ArvRegimen2, p.ArvRegimen3);
                                }

                                paediatricArtVisits.Add(p);
                            }
                            if(paediatricArtVisits.Any())
                            {
                                //var processed = _artVisitService.AddArtVisits(paediatricArtVisits, currentPage, siteId, 2);
                                gVal = _artVisitService.AddPaedArtVisits(paediatricArtVisits, currentPage, siteId);
                                if (gVal.Code < 1)
                                {
                                    return gVal;
                                }
                                gVal.Message = "Paediatric Art Visit Batch Processing succeeded";
                                return gVal;
                            }
                        }

                        gVal.Code = 0;
                        gVal.Message = "No Adult Art Visit records found";
                        return gVal;
                    }
                }
                
            }
            catch(Exception ex)
            {
                gVal.Code = -1;
                gVal.Message = ex.Message != null ? ex.Message : ex.InnerException != null ? ex.InnerException.Message : "An unknown error was encountered. Please try again.";
                return gVal;
            }            
        }
        private GenericValidator GetLabResults(SqlConnection connection, int currentPage, int itemsPerPage, int siteId)
        {
            var gVal = new GenericValidator();
            try
            {
                var paging = "OFFSET " + itemsPerPage + "*" + (currentPage - 1) + "ROWS FETCH NEXT " + itemsPerPage + " ROWS ONLY";  
                var labResultQuery = "SELECT idno,enrol_id,datetrn,daterpt,lab_no,testgrp,descrip,resultab FROM labresult ORDER BY idno " + paging;             
                
                using (SqlCommand cmd = new SqlCommand(labResultQuery, connection))
                {
                    // if(connection.State == ConnectionState.Open){
                    //     connection.Close();
                    // }
                    connection.Open();
                    using (SqlDataReader reader = cmd.ExecuteReader())
                    {
                        // Check if the reader has any rows at all before starting to read.
                        if (reader.HasRows)
                        {
                            var labResults = new List<LabResultModel>(); 
                            // Read advances to the next row.
                            while (reader.Read())
                            {
                                var p = new LabResultModel
                                {
                                    EnrolmentId = reader["enrol_id"].ToString().Trim(),
                                    IdNo = Convert.ToInt32(reader["idno"])
                                };
                                if (reader["lab_no"] != null)
                                {
                                    var labNo = reader["lab_no"];
                                    if(!string.IsNullOrEmpty(labNo.ToString().Trim()))
                                    {
                                        p.LabNumber = labNo.ToString().Trim();
                                    }
                                }
                                if (reader["descrip"] != null)
                                {
                                    var descrip = reader["descrip"];
                                    if(!string.IsNullOrEmpty(descrip.ToString().Trim()))
                                    {
                                        p.Description = descrip.ToString().Trim();
                                    }
                                }
                                
                                if (reader["testgrp"] != null)
                                {
                                    var testgrp = reader["testgrp"];
                                    if(!string.IsNullOrEmpty(testgrp.ToString().Trim()))
                                    {
                                        p.TestGroup = testgrp.ToString().Trim();
                                    }
                                }
                                if (reader["resultab"] != null)
                                {
                                    var resultab = reader["resultab"];
                                    if(!string.IsNullOrEmpty(resultab.ToString().Trim()))
                                    {
                                        var res = resultab.ToString().Trim().Replace("<", string.Empty).ToLower();
                                        var containsNum = res.Any(c => char.IsDigit(c));
                                        if(containsNum)
                                        {
                                            p.TestResult = string.Join("", Regex.Split(res, @"[^\d]"));
                                        }
                                        else
                                        {
                                            if (res.Contains("tnd") || res.Contains("dt") || res.Equals("nd"))
                                            {
                                                p.TestResult = "0";
                                            }
                                            else if (res.Contains("negative") || res.Contains("neg") || res.Contains("unreadable") || res.Contains("invalid") || res.Contains("nill"))
                                            {
                                                p.TestResult = "0";
                                            }
                                            else p.TestResult = "0";
                                        }
                                        
                                    }
                                }
                                if (reader["datetrn"] != null)
                                {
                                    var datetrn = reader["datetrn"];
                                    if(!string.IsNullOrEmpty(datetrn.ToString().Trim()))
                                    {
                                        DateTime dateTime;
                                        if (DateTime.TryParse(datetrn.ToString().Trim(), out dateTime))
                                        {
                                            p.TestDate = dateTime > DateTime.Today ? DateTime.Today : dateTime;
                                        }
                                    }
                                }
                                if (reader["daterpt"] != null)
                                {
                                    var daterpt = reader["daterpt"];
                                    if(!string.IsNullOrEmpty(daterpt.ToString().Trim()))
                                    {
                                        DateTime dateTime;
                                        if (DateTime.TryParse(daterpt.ToString().Trim(), out dateTime))
                                        {
                                            p.DateReported = dateTime > DateTime.Today ? DateTime.Today : dateTime;
                                        }
                                    }
                                }
                                
                                labResults.Add(p);
                            }
                            if(labResults.Any())
                            {
                                gVal = _labResultService.InsertLabResults(labResults, currentPage, siteId);
                                //var processed = _labResultService.AddLabResults(labResults, currentPage, siteId);
                                if (gVal.Code < 1)
                                {
                                    return gVal;
                                }
                                gVal.Message = "Paediatric Art Visit Batch Processing succeeded";
                                return gVal;
                            }
                        }
                        gVal.Code = 0;
                        gVal.Message = "No Laboratory records found";
                        return gVal;
                    }
                }
                
            }
            catch(Exception ex)
            {
                gVal.Code = -1;
                gVal.Message = ex.Message != null ? ex.Message : ex.InnerException != null ? ex.InnerException.Message : "An unknown error was encountered. Please try again.";
                return gVal;
            }            
        }

        [HttpPost]
        [Route("addPatient")]
        public ActionResult<GenericValidator> AddPatient([FromBody]PatientModel patient)
        {
             var gVal = new GenericValidator();
            try
            {
                if (string.IsNullOrEmpty(patient.EnrolmentId))
                {
                    gVal.Code = -1;
                    gVal.Message = "Please provide Patient's enrolmentId.";
                    return gVal;
                }
                if (string.IsNullOrEmpty(patient.FirstName))
                {
                    gVal.Code = -1;
                    gVal.Message = "Please provide Patient's First Name.";
                    return gVal;
                }
                if (string.IsNullOrEmpty(patient.LastName))
                {
                    gVal.Code = -1;
                    gVal.Message = "Please provide Patient's Last Name.";
                    return gVal;
                }
                var status = _patientService.AddPatient(patient);
                if (status < 1)
                {
                    gVal.Code = -1;
                    gVal.Message = status == -3? "Patient record already exists" : "An unknown error was encountered. Please try again.";
                    return gVal;
                }

                gVal.Code = status;
                gVal.Message = "Patient information was successfully Added";
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
        [Route("updatePatient")]
        public ActionResult<GenericValidator> EditPatient([FromBody]PatientModel patient)
        {
            var gVal = new GenericValidator();
            try
            {
                if (string.IsNullOrEmpty(patient.EnrolmentId))
                {
                    gVal.Code = -1;
                    gVal.Message = "Please provide Patient's enrolmentId.";
                    return gVal;
                }
                if (string.IsNullOrEmpty(patient.FirstName))
                {
                    gVal.Code = -1;
                    gVal.Message = "Please provide Patient's First Name.";
                    return gVal;
                }
                if (string.IsNullOrEmpty(patient.LastName))
                {
                    gVal.Code = -1;
                    gVal.Message = "Please provide Patient's Last Name.";
                    return gVal;
                }
                if (patient.Id < 1)
                {
                    gVal.Code = -1;
                    gVal.Message = "Invalid Patient information selected. Please try again.";
                    return gVal;
                }

                var status = _patientService.UpdatePatient(patient);
                if (status < 1)
                {
                    gVal.Code = -1;
                    gVal.Message = status == -3 ? "Patient already exists" : "An unknown error was encountered. Please try again.";
                    return gVal;
                }

                gVal.Code = 5;
                gVal.Message = "Patient information was successfully Updated";
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
