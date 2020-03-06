using System;
using System.Collections.Generic;

namespace Services.DataModels
{
    public class LineItem
    {
        public int Age { get; set; }
        public string Gender { get; set; }
        public string TestResult { get; set; }
        public int SiteId { get; set; }
        public string StateCode { get; set; }
        public string TestType { get; set; }
        public string EnrolmentId { get; set; }
        public string DateReportedStr { get; set; }
        public string TestDateStr { get; set; }
        public string HivConfirmationDateStr { get; set; }
        public string EnrolmentDateStr { get; set; }
        public string ArtDateStr { get; set; }
        public string ArvRegimen1 { get; set; }
        public string ArvRegimen2 { get; set; }
        public string ArvRegimen3 { get; set; }
        public string FirstRegimenCode { get; set; }
        public string FirstRegimenLine { get; set; }
        public string ArvRegimenCode { get; set; }
        public string RegimenLine { get; set; }
        public string AdvDrugCode { get; set; }
        public string DateOfBirthStr { get; set; }
        public string Pregnant { get; set; }
        public string VisitDateStr { get; set; }
        public string AppointmentDateStr { get; set; }
        public long TotalResult { get; set; }
    }
}