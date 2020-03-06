using System;
using System.Collections.Generic;

namespace Services.DataModels
{
    public partial class HivEncounterModel
    {
        public long Id { get; set; }
        public long PatientId { get; set; }
        public long VisitId { get; set; }
        public DateTime VisitDate { get; set; }
        public int DurationOnArt { get; set; }
        public double? Weight { get; set; }
        public double? ChildHeight { get; set; }
        public string BloodPressure { get; set; }
        public string FunctionalStatus { get; set; }
        public string WhoclinicalStage { get; set; }
        public DateTime? NextAppointmentDate { get; set; }
        public string ArvdrugRegimenCode { get; set; }
        public string ArvdrugRegimenDesc { get; set; }

        public virtual PatientDemographyModel Patient { get; set; }
    }
}
