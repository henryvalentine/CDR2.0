using System;
using System.Collections.Generic;

namespace Entities.Models
{
    public partial class LaboratoryReport
    {
        public long Id { get; set; }
        public long PatientId { get; set; }
        public long VisitId { get; set; }
        public DateTime? VisitDate { get; set; }
        public DateTime? CollectionDate { get; set; }
        public string ArtstatusCode { get; set; }
        public DateTime? OrderedTestDate { get; set; }
        public DateTime? ResultedTestDate { get; set; }
        public double? LabResult { get; set; }
        public string LabTestCode { get; set; }
        public string LabTestDesc { get; set; }

        public virtual PatientDemography Patient { get; set; }
    }
}
