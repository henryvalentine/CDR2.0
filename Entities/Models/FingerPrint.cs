using System;
using System.Collections.Generic;

namespace Entities.Models
{
    public partial class FingerPrint
    {
        public long Id { get; set; }
        public long PatientId { get; set; }
        public string Source { get; set; }
        public bool Present { get; set; }
        public int Hand { get; set; }
        public string Template { get; set; }
        public string FingerPosition { get; set; }

        public virtual PatientDemography Patient { get; set; }
    }
}
