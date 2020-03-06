
using System;
using System.Collections.Generic;

namespace Services.DataModels
{
    public partial class DashboardModel
    {
        public long Patients { get; set; }
        public long Active { get; set; }
        public long StateId { get; set; }
        public long Inactive { get; set; }
        public long SiteId { get; set; }
        public long LossToFollowUp { get; set; }
        public long Defaulters { get; set; }
        public long NewPatients { get; set; }    
        public string AdultBaselines { get; set; }
        public string PaediatricBaselines { get; set; }
        public string AdultVisits { get; set; }
        public string PaediatricVisits { get; set; }
         public string StateCode { get; set; }
        public string LabResults { get; set; }
        public string StateName {get; set;}
        public string SiteName {get; set;}
        public List<SiteModel> Sites { get; set; }
        public long ActiveSites { get; set; }
        public List<GroupByYear> PatientsYearGroup{get; set;}        
    }   

    public partial class StateStatsModel
    {
        public string Patients { get; set; }
        public string Active { get; set; }
        public int StateId { get; set; }
        public string Inactive { get; set; }
        public int SiteId { get; set; }
        public string LossToFollowUp { get; set; }
        public string Defaulters { get; set; }
        public string NewPatients { get; set; }    
        public string StateCode { get; set; }
        public string StateName {get; set;}
        public string SiteName {get; set;}
        public string Sites { get; set; }   
    }

    public class LabTest
    {
        public long Id { get; set; }
        public long PatientId { get; set; }
        public string EnrolmentId { get; set; }
        public string Pregnant{get; set;}
        public string TestDate { get; set; }
        public string DateReported { get; set; }
        public string Description { get; set; }
        public string SiteName { get; set; }
        public string TestResult { get; set; }
    }

    public class GroupByYear
    {
        public double Year{get; set;}
        public double Count{get; set;}
    }

    public partial class StatsModel
    {
        public DashboardModel Dashboard { get; set; }
        public string StateName {get; set;} 
    }

    public partial class ClientBand
    {
        public long Id { get; set; }
        public long Age { get; set; }
        public string Gender {get; set;} 
    }

    public partial class GroupCount
    {
        public int StateId { get; set; }
        public long AgeCount { get; set; }
        public long MaleCount { get; set; }
        public long FemaleCount { get; set; }
        public long Total { get; set; }
        public string Gender {get; set;}
        public string VLStatus { get; set; }
        public string GroupName {get; set;} 
    }

    public partial class LineCount
    {
        public long MaleCount { get; set; }
        public long FemaleCount { get; set; }
        public string GroupName { get; set; }
    }
}