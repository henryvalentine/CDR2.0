using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;

namespace CDR.Models
{
    public class PushData
    {
        public string Server { get; set; }
        public string UserName { get; set; }
        public string Password { get; set; }
        public int SiteId { get; set; }
        public int SourceId { get; set; }
        public string SiteCode { get; set; }
        public int Target{get; set;}
        public int ItemsPerPage { get; set; }
        public int ProcessCount { get; set; }
        public int LastAdultArvVistPage { get; set; }
        public int LastPaediatricArvVisitPage { get; set; }
        public int LastAdultArtBaselinePage { get; set; }
        public int LastPaediatricArtBaselinePage { get; set; }
        public int LastPatientPage { get; set; }
        public int LastLabResultPage { get; set; }
        public DateTime TrackingDate { get; set; }
    }
}