using System;
using System.Collections.Generic;

namespace Entities.Models
{
    public partial class PatientDemography
    {
        public PatientDemography()
        {
            FingerPrint = new HashSet<FingerPrint>();
            HivEncounter = new HashSet<HivEncounter>();
            LaboratoryReport = new HashSet<LaboratoryReport>();
            PatientRegimen = new HashSet<PatientRegimen>();
        }

        public long Id { get; set; }
        public int SiteId { get; set; }
        public string EnrolleeCode { get; set; }
        public DateTime? PatientDateOfBirth { get; set; }
        public string PatientIdentifier { get; set; }
        public string PatientSexCode { get; set; }
        public string FacilityId { get; set; }
        public string FacilityName { get; set; }
        public string FacilityTypeCode { get; set; }
        public string OtherIdnumber { get; set; }
        public string OtherIdtypeCode { get; set; }
        public string ConditionCode { get; set; }
        public string AddressTypeCode { get; set; }
        public string StateCode { get; set; }
        public string CountryCode { get; set; }
        public string ProgramAreaCode { get; set; }
        public DateTime? FirstConfirmedHivtestDate { get; set; }
        public DateTime? ArtstartDate { get; set; }
        public string TransferredOutStatus { get; set; }
        public DateTime? EnrolledInHivcareDate { get; set; }
        public string HospitalNumber { get; set; }
        public DateTime? DateOfFirstReport { get; set; }
        public DateTime? DateOfLastReport { get; set; }
        public DateTime? DiagnosisDate { get; set; }
        public bool PatientDieFromThisIllness { get; set; }
        public int PatientAge { get; set; }

        public virtual Site Site { get; set; }
        public virtual ICollection<FingerPrint> FingerPrint { get; set; }
        public virtual ICollection<HivEncounter> HivEncounter { get; set; }
        public virtual ICollection<LaboratoryReport> LaboratoryReport { get; set; }
        public virtual ICollection<PatientRegimen> PatientRegimen { get; set; }
    }
}
