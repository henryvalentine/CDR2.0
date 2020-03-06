using System;
using System.Collections.Generic;

namespace Entities.Models
{
    public partial class Site
    {
        public Site()
        {
            PatientDemography = new HashSet<PatientDemography>();
            SiteTxTarget = new HashSet<SiteTxTarget>();
        }

        public int Id { get; set; }
        public string Name { get; set; }
        public string Lga { get; set; }
        public string StateCode { get; set; }
        public string SiteId { get; set; }
        public int StateId { get; set; }

        public virtual State State { get; set; }
        public virtual ICollection<PatientDemography> PatientDemography { get; set; }
        public virtual ICollection<SiteTxTarget> SiteTxTarget { get; set; }
    }
}
