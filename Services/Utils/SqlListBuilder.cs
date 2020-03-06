using Microsoft.SqlServer.Server;
using Services.DataModels;
using System;
using System.Collections.Generic;
using System.Data;
using System.Data.SqlClient;
using System.Data.SqlTypes;
using System.Linq;

namespace Services.Utils
{
    public class SqlListBuilder
    {
        public List<SqlDataRecord> BuildPatients(List<PatientDemographyModel> patients)
        {
            try
            {
                var records = new List<SqlDataRecord>();
                var errors = new List<PatientDemographyModel>();
                SqlMetaData[] sqlMetaData = new SqlMetaData[18];
                sqlMetaData[0] = new SqlMetaData("OtherIdnumber", SqlDbType.NVarChar, 450);
                sqlMetaData[1] = new SqlMetaData("OtherIdtypeCode", SqlDbType.NVarChar, 450);
                sqlMetaData[2] = new SqlMetaData("PatientIdentifier", SqlDbType.NVarChar, 450);
                sqlMetaData[3] = new SqlMetaData("ArtstartDate", SqlDbType.DateTime2);
                sqlMetaData[4] = new SqlMetaData("PatientDieFromThisIllness", SqlDbType.Bit);
                sqlMetaData[5] = new SqlMetaData("TransferredOutStatus", SqlDbType.NVarChar, 450);
                sqlMetaData[6] = new SqlMetaData("HospitalNumber", SqlDbType.NVarChar, 450);
                sqlMetaData[7] = new SqlMetaData("FacilityId", SqlDbType.NVarChar, 450);
                sqlMetaData[8] = new SqlMetaData("PatientDateOfBirth", SqlDbType.DateTime2);
                sqlMetaData[9] = new SqlMetaData("DateOfLastReport", SqlDbType.DateTime2);
                sqlMetaData[10] = new SqlMetaData("DateOfFirstReport", SqlDbType.DateTime2);
                sqlMetaData[11] = new SqlMetaData("EnrolledInHivcareDate", SqlDbType.DateTime2);
                sqlMetaData[12] = new SqlMetaData("PatientAge", SqlDbType.Int);
                sqlMetaData[13] = new SqlMetaData("SiteId", SqlDbType.Int);
                sqlMetaData[14] = new SqlMetaData("PatientSexCode", SqlDbType.NVarChar, 50);
                sqlMetaData[15] = new SqlMetaData("EnrolleeCode", SqlDbType.NVarChar, -1);
                sqlMetaData[16] = new SqlMetaData("ConditionCode", SqlDbType.NVarChar, 100);
                sqlMetaData[17] = new SqlMetaData("AddressTypeCode", SqlDbType.NVarChar, -1);
                sqlMetaData[18] = new SqlMetaData("StateCode", SqlDbType.NVarChar, 450);
                sqlMetaData[19] = new SqlMetaData("CountryCode", SqlDbType.NVarChar, 450);
                sqlMetaData[20] = new SqlMetaData("MaritalStatus", SqlDbType.NVarChar, 50);
                sqlMetaData[21] = new SqlMetaData("ProgramAreaCode", SqlDbType.NVarChar, 450);


                patients.ForEach(p =>
                {
                    if (!string.IsNullOrEmpty(p.PatientIdentifier))
                    {
                        var row = new SqlDataRecord(sqlMetaData);
                        row.SetString(0, p.FirstName);
                        row.SetString(1, p.LastName);
                        row.SetString(2, p.PatientIdentifier);
                        row.SetInt32(3, p.IdNo);
                        row.SetDateTime(4, p.VisitDate != null? p.VisitDate.Value : DateTime.Parse("1753-1-1"));
                        row.SetString(5, !string.IsNullOrEmpty(p.StateId)? p.StateId : string.Empty);
                        row.SetInt32(6, p.FacilityId);
                        row.SetDateTime(7, p.PatientDateOfBirth != null? p.PatientDateOfBirth.Value : DateTime.Parse("1753-1-1"));
                        row.SetInt32(8, p.Age);
                        row.SetString(9, !string.IsNullOrEmpty(p.PatientSexCode)? p.PatientSexCode : string.Empty);
                        row.SetString(10, !string.IsNullOrEmpty(p.Village)? p.Village : string.Empty);
                        row.SetString(11, !string.IsNullOrEmpty(p.Town)? p.Town : string.Empty);
                        row.SetString(12, !string.IsNullOrEmpty(p.PhoneNumber) ? p.PhoneNumber : string.Empty);
                        row.SetString(13, !string.IsNullOrEmpty(p.AddressLine1)? p.AddressLine1 : string.Empty);
                        row.SetString(14, !string.IsNullOrEmpty(p.State)? p.State: string.Empty);
                        row.SetString(15, !string.IsNullOrEmpty(p.Lga)? p.Lga : string.Empty);
                        row.SetString(16, !string.IsNullOrEmpty(p.MaritalStatus)? p.MaritalStatus : string.Empty);
                        row.SetString(17, !string.IsNullOrEmpty(p.PreferredLanguage)? p.PreferredLanguage : string.Empty);
                        records.Add(row);
                    }
                    else
                    {
                        errors.Add(p);
                    }
                });

                return records;

            }
            catch(Exception e)
            {
                return new List<SqlDataRecord>();
            }            
        }
        public List<SqlDataRecord> BuildBaselines(List<ArtBaselineModel> baselines, int siteId)
        {
            var records = new List<SqlDataRecord>();
            var errors = new List<ArtBaselineModel>();
            SqlMetaData[] sqlMetaData = new SqlMetaData[8];
            sqlMetaData[0] = new SqlMetaData("PatientIdentifier", SqlDbType.NVarChar, 450);
            sqlMetaData[1] = new SqlMetaData("IdNo", SqlDbType.Int);
            sqlMetaData[2] = new SqlMetaData("HivConfirmationDate", SqlDbType.DateTime2);
            sqlMetaData[3] = new SqlMetaData("EnrolmentDate", SqlDbType.DateTime2);
            sqlMetaData[4] = new SqlMetaData("ArtDate", SqlDbType.DateTime2);
            sqlMetaData[5] = new SqlMetaData("DispositionDate", SqlDbType.NVarChar, 450);            
            sqlMetaData[6] = new SqlMetaData("DispositionCode", SqlDbType.NVarChar, 50);
            sqlMetaData[7] = new SqlMetaData("FacilityId", SqlDbType.Int);
            
            var duplicateBaselines = baselines.GroupBy(x => x.PatientIdentifier).Where(x => x.Count() > 1).Select(x => x.Key).ToList();
           
            baselines.ForEach(p =>
            {
                    var row = new SqlDataRecord(sqlMetaData);
                    row.SetString(0, p.PatientIdentifier);
                    row.SetInt32(1, p.IdNo);
                    row.SetDateTime(2, p.HivConfirmationDate != null ? p.HivConfirmationDate.Value : (DateTime)SqlDateTime.MinValue);
                    row.SetDateTime(3, p.EnrolmentDate != null ? p.EnrolmentDate.Value : (DateTime)SqlDateTime.MinValue);
                    row.SetDateTime(4, p.ArtDate != null ? p.ArtDate.Value : (DateTime)SqlDateTime.MinValue);
                    row.SetString(5, !string.IsNullOrEmpty(p.DispositionDate)? p.DispositionDate : string.Empty);                    
                    row.SetString(6, !string.IsNullOrEmpty(p.DispositionCode) ? p.DispositionCode : string.Empty);
                    row.SetInt32(7, siteId);
                    records.Add(row);

            });

            return records;
        }
        public List<SqlDataRecord> BuildAdultArtVisitss(List<ArtVisitModel> artVisits, int siteId)
        {
            var records = new List<SqlDataRecord>();
            var errors = new List<ArtVisitModel>();
            try
            {
                SqlMetaData[] sqlMetaData = new SqlMetaData[24];
                sqlMetaData[0] = new SqlMetaData("PatientIdentifier", SqlDbType.NVarChar, 100);
                sqlMetaData[1] = new SqlMetaData("IdNo", SqlDbType.Int);
                sqlMetaData[2] = new SqlMetaData("VisitDate", SqlDbType.DateTime2);
                sqlMetaData[3] = new SqlMetaData("Weight", SqlDbType.Float);
                sqlMetaData[4] = new SqlMetaData("Height", SqlDbType.Float);
                sqlMetaData[5] = new SqlMetaData("Temperature", SqlDbType.Float);
                sqlMetaData[6] = new SqlMetaData("WhoStage", SqlDbType.NVarChar, 50);
                sqlMetaData[7] = new SqlMetaData("IsPregnant", SqlDbType.Bit);
                sqlMetaData[8] = new SqlMetaData("TbScreen", SqlDbType.NVarChar, 50);
                sqlMetaData[9] = new SqlMetaData("TbDiagnosedTreatment", SqlDbType.NVarChar, 50);
                sqlMetaData[10] = new SqlMetaData("TbTreatmentStarted", SqlDbType.NVarChar, 50);
                sqlMetaData[11] = new SqlMetaData("CotrimeProphylaxis", SqlDbType.NVarChar, 50);
                sqlMetaData[12] = new SqlMetaData("ArtStarted", SqlDbType.Bit);
                sqlMetaData[13] = new SqlMetaData("ArvAdherenceCode", SqlDbType.NVarChar, 50);
                sqlMetaData[14] = new SqlMetaData("ArvNonAdherenceCode", SqlDbType.NVarChar, 50);
                sqlMetaData[15] = new SqlMetaData("DrugReactionCode", SqlDbType.NVarChar, 50);
                sqlMetaData[16] = new SqlMetaData("ArvStopCode", SqlDbType.NVarChar, 50);
                sqlMetaData[17] = new SqlMetaData("ArvStopDate", SqlDbType.DateTime2);
                sqlMetaData[18] = new SqlMetaData("Cd4Count", SqlDbType.NVarChar, 50);
                sqlMetaData[19] = new SqlMetaData("BloodPressure", SqlDbType.NVarChar, 50);
                sqlMetaData[20] = new SqlMetaData("FamilyPlanningCode", SqlDbType.NVarChar, 50);
                sqlMetaData[21] = new SqlMetaData("AppointmentDate", SqlDbType.DateTime2);
                sqlMetaData[22] = new SqlMetaData("StatusCode", SqlDbType.NVarChar, 50);
                sqlMetaData[23] = new SqlMetaData("FacilityId", SqlDbType.Int);
                
                artVisits.ForEach(p =>
                {
                    if (!string.IsNullOrEmpty(p.PatientIdentifier))
                    {
                        var row = new SqlDataRecord(sqlMetaData);
                        row.SetString(0, p.PatientIdentifier);
                        row.SetInt32(1, p.IdNo);
                        row.SetDateTime(2, (p.VisitDate == null || (p.VisitDate != null && p.VisitDate.Value < (DateTime)SqlDateTime.MinValue) || (p.VisitDate != null && p.VisitDate.Value > (DateTime)SqlDateTime.MaxValue)) ? DateTime.Today : p.VisitDate.Value);
                        row.SetDouble(3, p.Weight != null ? p.Weight.Value : 0.0);
                        row.SetDouble(4, p.Height != null ? p.Height.Value : 0.0);
                        row.SetDouble(5, p.Temperature != null ? p.Temperature.Value : 0.0);
                        row.SetString(6, !string.IsNullOrEmpty(p.WhoStage) ? p.WhoStage : string.Empty);
                        row.SetBoolean(7, p.IsPregnant != null ? p.IsPregnant.Value : false);
                        row.SetString(8, !string.IsNullOrEmpty(p.TbScreen) ? p.TbScreen : string.Empty);
                        row.SetString(9, !string.IsNullOrEmpty(p.TbDiagnosedTreatment) ? p.TbDiagnosedTreatment : string.Empty);
                        row.SetString(10, !string.IsNullOrEmpty(p.TbTreatmentStarted) ? p.TbTreatmentStarted : string.Empty);
                        row.SetString(11, !string.IsNullOrEmpty(p.CotrimeProphylaxis) ? p.CotrimeProphylaxis : string.Empty);
                        row.SetBoolean(12, p.ArtStarted != null ? p.ArtStarted.Value : false);
                        row.SetString(13, !string.IsNullOrEmpty(p.ArvAdherenceCode) ? p.ArvAdherenceCode : string.Empty);
                        row.SetString(14, !string.IsNullOrEmpty(p.ArvNonAdherenceCode) ? p.ArvNonAdherenceCode : string.Empty);
                        row.SetString(15, !string.IsNullOrEmpty(p.DrugReactionCode) ? p.DrugReactionCode : string.Empty);
                        row.SetString(16, !string.IsNullOrEmpty(p.ArvStopCode) ? p.ArvStopCode : string.Empty);
                        row.SetDateTime(17, (p.ArvStopDate == null || (p.ArvStopDate != null && p.ArvStopDate.Value < (DateTime)SqlDateTime.MinValue) || (p.ArvStopDate != null && p.ArvStopDate.Value > (DateTime)SqlDateTime.MaxValue)) ? DateTime.Today : p.ArvStopDate.Value);
                        row.SetString(18, !string.IsNullOrEmpty(p.Cd4Count) ? p.Cd4Count : string.Empty);
                        row.SetString(19, !string.IsNullOrEmpty(p.BloodPressure) ? p.BloodPressure : string.Empty);
                        row.SetString(20, !string.IsNullOrEmpty(p.FamilyPlanningCode) ? p.FamilyPlanningCode : string.Empty);
                        row.SetDateTime(21, (p.AppointmentDate == null || (p.AppointmentDate != null && p.AppointmentDate.Value < (DateTime)SqlDateTime.MinValue) || (p.AppointmentDate != null && p.AppointmentDate.Value > (DateTime)SqlDateTime.MaxValue)) ? DateTime.Today : p.AppointmentDate.Value);
                        row.SetString(22, !string.IsNullOrEmpty(p.StatusCode) ? p.StatusCode : string.Empty);
                        row.SetInt32(23, siteId);
                
                        records.Add(row);

                    }
                    else
                    {
                        errors.Add(p);
                    }
                });

                return records;
            }
            catch(Exception e)
            {
                return records;
            }
        }
        public List<SqlDataRecord> BuildPaedArtVisits(List<ArtVisitModel> artVisits, int siteId)
        {
            var records = new List<SqlDataRecord>();
            var errors = new List<ArtVisitModel>();
            try
            {
                SqlMetaData[] sqlMetaData = new SqlMetaData[22];
                sqlMetaData[0] = new SqlMetaData("PatientIdentifier", SqlDbType.NVarChar, 100);
                sqlMetaData[1] = new SqlMetaData("IdNo", SqlDbType.Int);
                sqlMetaData[2] = new SqlMetaData("VisitDate", SqlDbType.DateTime2);
                sqlMetaData[3] = new SqlMetaData("Weight", SqlDbType.Float);
                sqlMetaData[4] = new SqlMetaData("WhoStage", SqlDbType.NVarChar, 50);
                sqlMetaData[5] = new SqlMetaData("TbScreen", SqlDbType.NVarChar, 50);
                sqlMetaData[6] = new SqlMetaData("TbDiagnosed", SqlDbType.Bit);
                sqlMetaData[7] = new SqlMetaData("TbSuspected", SqlDbType.Bit);
                sqlMetaData[8] = new SqlMetaData("TbTreatmentReceived", SqlDbType.Bit);
                sqlMetaData[9] = new SqlMetaData("ReceivingContrime", SqlDbType.Bit);
                sqlMetaData[10] = new SqlMetaData("ArtStarted", SqlDbType.Bit);
                sqlMetaData[11] = new SqlMetaData("ArvRegimenCode", SqlDbType.NVarChar, 50);
                sqlMetaData[12] = new SqlMetaData("ArvAdherenceCode", SqlDbType.NVarChar, 50);
                sqlMetaData[13] = new SqlMetaData("ArvNonAdherenceCode", SqlDbType.NVarChar, 50);
                sqlMetaData[14] = new SqlMetaData("ArvRegimen1", SqlDbType.NVarChar, 50);
                sqlMetaData[15] = new SqlMetaData("ArvRegimen2", SqlDbType.NVarChar, 50);
                sqlMetaData[16] = new SqlMetaData("ArvRegimen3", SqlDbType.NVarChar, 50);
                sqlMetaData[17] = new SqlMetaData("ArvStopCode", SqlDbType.NVarChar, 50);
                sqlMetaData[18] = new SqlMetaData("ArvStopDate", SqlDbType.DateTime2);
                sqlMetaData[19] = new SqlMetaData("AppointmentDate", SqlDbType.DateTime2);
                sqlMetaData[20] = new SqlMetaData("AdvDrugCode", SqlDbType.NVarChar, 50);           
                sqlMetaData[21] = new SqlMetaData("FacilityId", SqlDbType.Int);            

                artVisits.ForEach(p =>
                {
                    if (!string.IsNullOrEmpty(p.PatientIdentifier))
                    {
                        var row = new SqlDataRecord(sqlMetaData);

                        row.SetValues(new object[] 
                        {
                            p.PatientIdentifier, p.IdNo,
                            (p.VisitDate == null || (p.VisitDate != null && p.VisitDate.Value < (DateTime)SqlDateTime.MinValue) || (p.VisitDate != null && p.VisitDate.Value > (DateTime)SqlDateTime.MaxValue)) ? DateTime.Today : p.VisitDate.Value,
                            p.Weight != null ? p.Weight.Value : 0.0, !string.IsNullOrEmpty(p.WhoStage)? p.WhoStage : string.Empty, !string.IsNullOrEmpty(p.TbScreen)? p.TbScreen : string.Empty,
                            p.TbDiagnosed != null? p.TbDiagnosed.Value : false, p.TbSuspected != null? p.TbSuspected.Value : false,
                            p.TbTreatmentReceived != null? p.TbTreatmentReceived : false, p.ReceivingContrime != null? p.ReceivingContrime : false,
                            p.ArtStarted != null? p.ArtStarted : false, !string.IsNullOrEmpty(p.ArvRegimenCode)? p.ArvRegimenCode : string.Empty,
                            !string.IsNullOrEmpty(p.ArvAdherenceCode)? p.ArvAdherenceCode : string.Empty,
                            !string.IsNullOrEmpty(p.ArvNonAdherenceCode)? p.ArvNonAdherenceCode : string.Empty,
                            !string.IsNullOrEmpty(p.ArvRegimen1)? p.ArvRegimen1 : string.Empty,
                            !string.IsNullOrEmpty(p.ArvRegimen2)? p.ArvRegimen2 : string.Empty,
                            !string.IsNullOrEmpty(p.ArvRegimen3)? p.ArvRegimen3 : string.Empty,
                            !string.IsNullOrEmpty(p.ArvStopCode)? p.ArvStopCode : string.Empty,
                            (p.ArvStopDate == null || (p.ArvStopDate != null && p.ArvStopDate.Value < (DateTime)SqlDateTime.MinValue) || (p.ArvStopDate != null && p.ArvStopDate.Value > (DateTime)SqlDateTime.MaxValue)) ? DateTime.Today : p.ArvStopDate.Value,
                            (p.AppointmentDate == null || (p.AppointmentDate != null && p.AppointmentDate.Value < (DateTime)SqlDateTime.MinValue) || (p.AppointmentDate != null && p.AppointmentDate.Value > (DateTime)SqlDateTime.MaxValue)) ? DateTime.Today : p.AppointmentDate.Value,
                            !string.IsNullOrEmpty(p.AdvDrugCode)? p.AdvDrugCode : string.Empty, siteId });
                    
                        records.Add(row);
                    }
                    else
                    {
                        errors.Add(p);
                    }
                });

                return records;
            }
            catch (Exception e)
            {
                return records;
            }
        }
        public List<SqlDataRecord> BuildLabResults(List<LabResultModel> labResults, int siteId)
        {
            var records = new List<SqlDataRecord>();
            var errors = new List<LabResultModel>();
            SqlMetaData[] sqlMetaData = new SqlMetaData[9];
            sqlMetaData[0] = new SqlMetaData("PatientIdentifier", SqlDbType.NVarChar, 100);
            sqlMetaData[1] = new SqlMetaData("IdNo", SqlDbType.Int);
            sqlMetaData[2] = new SqlMetaData("LabNumber", SqlDbType.NVarChar, 100);
            sqlMetaData[3] = new SqlMetaData("Description", SqlDbType.NVarChar, 500);
            sqlMetaData[4] = new SqlMetaData("TestGroup", SqlDbType.NVarChar, 100);
            sqlMetaData[5] = new SqlMetaData("TestResult", SqlDbType.NVarChar, 100);
            sqlMetaData[6] = new SqlMetaData("TestDate", SqlDbType.DateTime2);
            sqlMetaData[7] = new SqlMetaData("DateReported", SqlDbType.DateTime2);
            sqlMetaData[8] = new SqlMetaData("FacilityId", SqlDbType.Int);
           
            labResults.ForEach(p =>
            {
                if (!string.IsNullOrEmpty(p.PatientIdentifier))
                {
                    var row = new SqlDataRecord(sqlMetaData);
                    row.SetValues(new object[] { p.PatientIdentifier, p.IdNo, !string.IsNullOrEmpty(p.LabNumber)? p.LabNumber : string.Empty, !string.IsNullOrEmpty(p.Description)? p.Description : string.Empty, !string.IsNullOrEmpty(p.TestGroup)? p.TestGroup : string.Empty, !string.IsNullOrEmpty(p.TestResult)? p.TestResult : string.Empty, p.TestDate, p.DateReported, siteId});
                    records.Add(row);
                }
                else
                {
                    errors.Add(p);
                }
            });

            return records;
        }
    }
}