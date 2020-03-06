using System;
using System.Collections.Generic;

namespace Services.DataModels
{
    public partial class FingerPrintModel
    {
        public long Id { get; set; }
        public long PatientId { get; set; }
        public string Source { get; set; }
        public bool Present { get; set; }
        public int Hand { get; set; }
        public string Template { get; set; }
        public string FingerPosition { get; set; }

        public virtual PatientDemographyModel Patient { get; set; }
    }
}
