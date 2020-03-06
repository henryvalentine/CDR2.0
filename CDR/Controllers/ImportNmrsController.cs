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

namespace CDR.Controllers
{
    // [Authorize]
    [Route("api/[controller]")]
    [ApiController]
    public class ImportNmrsController : ControllerBase
    {       
        private readonly IPatientService _patientService;
        private readonly ISiteDataTrackingService _siteDataTrackingService;
        private readonly ILabResultService _labResultService;
        private readonly IArtBaselineService _artBaselineService;
        private readonly IArtVisitService _artVisitService;
        private readonly ISiteService _siteService;
                
        public ImportNmrsController(IPatientService patientService, ISiteDataTrackingService siteDataTrackingService = null, ILabResultService labResultService = null,
        IArtBaselineService artBaselineService = null, IArtVisitService artVisitService = null, ISiteService siteService = null) 
        {
            _patientService = patientService;
            _siteDataTrackingService = siteDataTrackingService;
            _labResultService = labResultService;
            _artBaselineService = artBaselineService;
            _artVisitService = artVisitService;
            _siteService = siteService;
        }

        [HttpPost]
        [Route("pushNmrs")]
        public ActionResult<GenericValidator> pushNmrs([FromBody]PushData pushData)
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

                if (pushData.SourceId < 1)
                {
                    gVal.Code = -1;
                    gVal.Message = "Please select a Datasource Type";
                    return gVal;
                }

                return PushNmrs(pushData);
            }
            catch(Exception ex)
            {
                gVal.Code = -1;
                gVal.Message = ex.Message != null ? ex.Message : ex.InnerException != null ? ex.InnerException.Message : "An unknown error was encountered. Please try again.";
                return gVal;
            }            
        }

        public ActionResult<GenericValidator> PushNmrs(PushData pushData)
        {
            var gVal = new GenericValidator();
            try
            {
                using (var connection = new SqlConn().GetMySqlConn(pushData.Server, pushData.UserName, pushData.Password))
                {
                    var pResult = 0;
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
                            pResult = GetArtVisits(connection, pushData.LastAdultArvVistPage, pushData.ItemsPerPage, pushData.SiteId);
                            gVal.Code = pResult;
                            return gVal;
                        case 5:
                            pResult = GetPaediatricArtVisits(connection, pushData.LastPaediatricArvVisitPage, pushData.ItemsPerPage, pushData.SiteId);
                            gVal.Code = pResult;
                            return gVal;
                        case 6:
                            pResult = GetLabResults(connection, pushData.LastLabResultPage, pushData.ItemsPerPage, pushData.SiteId);
                            gVal.Code = pResult;
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

        private GenericValidator GetPatients(MySqlConnection connection, int currentPage, int itemsPerPage, int siteId, string siteCode)
        {
            var gVal = new GenericValidator();
            try
            {
                var lastId = 0;

                var patientQuery = "select p.patient_id, given_name, family_name, birthdate, gender, value as phone, dead, identifier, address1, address2, city_village, state_province, " +
                    "country from (SELECT * FROM person) ps join(SELECT* FROM person_name) pn on ps.person_id = pn.person_id join(SELECT * FROM patient) p on ps.person_id = p.patient_id " +
                    "join(SELECT * FROM patient_identifier where identifier_type = 4) i on p.patient_id = i.patient_id left join(SELECT* FROM person_address) a on " +
                    "p.patient_id = a.person_id left join(select* from person_attribute where person_attribute_type_id = 8 and value is not null) h on p.patient_id = " +
                    "h.person_id WHERE ps.person_id > " + lastId + "ORDER BY ps.person_id LIMIT 1000";
                    
                using (var cmd = new MySqlCommand(patientQuery, connection))
                {
                    // if(connection.State == ConnectionState.Open){
                    //     connection.Close();
                    // }
                    connection.Open();
                    using (var reader = cmd.ExecuteReader())
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
                                    FirstName = reader["family_name"].ToString().Trim(),
                                    LastName = reader["given_name"].ToString().Trim(),
                                    EnrolmentId = RegexConvert.GetAlphaNumeric(reader["identifier"].ToString().Trim().Replace(" ", string.Empty)),
                                    IdNo = Convert.ToInt32(reader["patient_id"])
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
                                
                                if (reader["state_province"] != null)
                                {
                                    var stateId = reader["state_province"];
                                    if(!string.IsNullOrEmpty(stateId.ToString().Trim()))
                                    {
                                        p.StateId = stateId.ToString().Trim();
                                    }
                                }
                              
                                if (reader["birthdate"] != null)
                                {
                                    var dob  = reader["birthdate"];
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
                                
                                if (reader["gender"] != null)
                                {
                                    var sex = reader["gender"];
                                    if(!string.IsNullOrEmpty(sex.ToString().Trim()))
                                    {
                                        p.Sex = sex.ToString().Trim();
                                    }
                                }

                                if (reader["city_village"] != null)
                                {
                                    var village = reader["city_village"];
                                    if(!string.IsNullOrEmpty(village.ToString().Trim()))
                                    {
                                        p.Village = village.ToString().Trim();
                                    }
                                    
                                }

                                if (reader["phone"] != null)
                                {
                                    var phoneNumber = reader["phone"];
                                    if(!string.IsNullOrEmpty(phoneNumber.ToString().Trim()))
                                    {
                                        p.PhoneNumber = RegexConvert.GetNumeric(phoneNumber.ToString().Trim().Replace(" ", string.Empty));
                                    }
                                }
                                if (reader["address1"] != null)
                                {
                                    var addr = reader["address1"];
                                    if(!string.IsNullOrEmpty(addr.ToString().Trim()))
                                    {
                                        p.AddressLine1 = addr.ToString().Trim();
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
                                p.SiteId = siteId;
                                patients.Add(p);
                            }
                           
                            if (patients.Any())
                            {
                                //var processed = _patientService.AddPatients(patients, currentPage, siteId);
                                var processed = _patientService.AddPatients(patients, currentPage);
                                if (processed < 1)
                                {
                                    gVal.Code = 0;
                                    gVal.Message = "Patient Batch Processing failed";
                                    return gVal;
                                }
                               
                                gVal.Code = processed;
                                gVal.Message = "Patient Batch Processing succeeded";
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
                    "count(*) over(partition by enrol_id) as enrol_CT from art_baseline_adult)o where enrol_CT = 1 order by idno " + paging;

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
                            var artBaselines = new List<ArtBaselineModel>();
                            // Read advances to the next row.
                            //idno
                            while (reader.Read())
                            {
                                var p = new ArtBaselineModel
                                {
                                    EnrolmentId = RegexConvert.GetAlphaNumeric(reader["enrol_id"].ToString().Trim().Replace(" ", string.Empty)),
                                    IdNo = Convert.ToInt32(reader["idno"])
                                };

                                if (reader["adlt_hiv_date"] != null)
                                {
                                    var hivConfirmationDate = reader["adlt_hiv_date"];
                                    if(!string.IsNullOrEmpty(hivConfirmationDate.ToString().Trim()))
                                    {
                                        DateTime dateTime;
                                        if (DateTime.TryParse(hivConfirmationDate.ToString().Trim(), out dateTime))
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
                                    var artDate = reader["adlt_art_date"];
                                    if(!string.IsNullOrEmpty(artDate.ToString().Trim()))
                                    {
                                        DateTime dateTime;
                                        if (DateTime.TryParse(artDate.ToString().Trim(), out dateTime))
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
                                //var processed = _artBaselineService.AddArtBaselines(artBaselines, currentPage, siteId, 1);
                                var processed = _artBaselineService.InsertArtBaselines(artBaselines, currentPage, siteId, 1);
                                if (processed < 1)
                                {

                                    gVal.Code = 0;
                                    gVal.Message = "Adult Baseline Batch Processing failed";
                                    return gVal;
                                }

                                gVal.Code = processed;
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
        private GenericValidator GetPaediatricArtBaselineData(SqlConnection connection, int currentPage, int itemsPerPage, int siteId)
        {
            var gVal = new GenericValidator();
            try
            {
                var paging = "desc offset " + itemsPerPage + "*" + (currentPage - 1) + " rows fetch next " + itemsPerPage + " rows only";
                var query = "select * from (select idno, enrol_id, chld_hiv_date, chld_enrol_date, chld_arv_date, pat_out_date, pat_out_code, " +
                    "count(*) over(partition by enrol_id) as enrol_CT from art_baseline_paeds)o where enrol_CT = 1 order by idno " + paging;
       
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
                                    EnrolmentId = RegexConvert.GetAlphaNumeric(reader["enrol_id"].ToString().Trim().Replace(" ", string.Empty)),
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
                                //var processed = _artBaselineService.AddArtBaselines(paediatricArtBaselines, currentPage, siteId, 2);
                                var processed = _artBaselineService.InsertArtBaselines(paediatricArtBaselines, currentPage, siteId, 2);
                                if (processed < 1)
                                {
                                    gVal.Code = 0;
                                    gVal.Message = "Paediatric Baseline Batch Processing failed";
                                    return gVal;
                                }
                                gVal.Code = processed;
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
        private int GetArtVisits(SqlConnection connection, int currentPage, int itemsPerPage, int siteId)
        {
            var  pushDataResult = new PushDataResult();
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
                                    EnrolmentId = RegexConvert.GetAlphaNumeric(reader["enrol_id"].ToString().Trim().Replace(" ", string.Empty)),
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
                                var processed = _artVisitService.InsertArtVisits(artVisits, currentPage, siteId);
                                //var processed = _artVisitService.AddArtVisits(artVisits, currentPage, siteId, 1);
                                if (processed < 1)
                                {
                                    
                                    return 0;
                                }
                                return processed;
                            }
                        }
                        return  0;
                    }
                }
                
            }
            catch(Exception ex)
            {                
                return -1;
            }            
        }        
        private int GetPaediatricArtVisits(SqlConnection connection, int currentPage, int itemsPerPage, int siteId)
        {
            var pushDataResult = new PushDataResult();
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
                                    EnrolmentId = RegexConvert.GetAlphaNumeric(reader["enrol_id"].ToString().Trim().Replace(" ", string.Empty)),
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
                                var processed = _artVisitService.AddPaedArtVisits(paediatricArtVisits, currentPage, siteId);
                                if (processed < 1)
                                {
                                    
                                    return 0;
                                }
                                return processed;
                            }
                        }
                        return  0;
                    }
                }
                
            }
            catch(Exception ex)
            {                
                return -1;
            }            
        }
        private int GetLabResults(SqlConnection connection, int currentPage, int itemsPerPage, int siteId)
        {
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
                                    EnrolmentId = RegexConvert.GetAlphaNumeric(reader["enrol_id"].ToString().Trim().Replace(" ", string.Empty)),
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
                                        p.TestResult = resultab.ToString().Trim();
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
                                var processed = _labResultService.InsertLabResults(labResults, currentPage, siteId);
                                //var processed = _labResultService.AddLabResults(labResults, currentPage, siteId);
                                if (processed < 1)
                                {                                    
                                    return 0;
                                }
                                return processed;
                            }
                        }
                        return  0;
                    }
                }
                
            }
            catch(Exception ex)
            {
                return -1;
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
