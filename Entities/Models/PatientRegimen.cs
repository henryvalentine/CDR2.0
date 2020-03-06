using System;
using System.Collections.Generic;

namespace Entities.Models
{
    public partial class PatientRegimen
    {
        public long Id { get; set; }
        public long PatientId { get; set; }
        public long VisitId { get; set; }
        public DateTime? VisitDate { get; set; }
        public string PrescribedRegimenCode { get; set; }
        public string PrescribedRegimenDesc { get; set; }
        public string PrescribedRegimenTypeCode { get; set; }
        public string PrescribedRegimenLineCode { get; set; }
        public int PrescribedRegimenDuration { get; set; }
        public DateTime? PrescribedRegimenDispensedDate { get; set; }
        public DateTime? DateRegimenStarted { get; set; }
        public string DateRegimenEnded { get; set; }
        public string PrescribedRegimenInitialIndicator { get; set; }
        public string SubstitutionIndicator { get; set; }
        public string SwitchIndicator { get; set; }

        public virtual PatientDemography Patient { get; set; }
    }
}
