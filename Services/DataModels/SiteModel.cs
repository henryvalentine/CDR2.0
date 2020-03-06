using System;
using System.Collections.Generic;

namespace Services.DataModels
{
    public partial class SiteModel
    {
        public int Id { get; set; }
        public string Name { get; set; }
        public string Lga { get; set; }
        public string StateCode { get; set; }
        public string SiteId { get; set; }
        public int StateId { get; set; }
        public long Active { get; set; }
        public long Suppressed { get; set; }
        public long Tested { get; set; }
        public long Unsuppressed { get; set; }
        public float Difference { get; set; }
        public long Inactive { get; set; }
        public long TotalClients { get; set; }
        public long LossToFollowUp { get; set; }
        public long NewClients { get; set; }
        public long Concurrence { get; set; }
        public string StateName { get; set; }
        public long TxCurr { get; set; }
        public long TxNew { get; set; }
        public long HasClients { get; set; }
        public long TxNewTarget { get; set; }
        public long FiscalYear { get; set; }

        public virtual StateModel State { get; set; }
        public virtual List<SiteTxTargetModel> SiteTxTarget { get; set; }
        public virtual List<PatientDemographyModel> PatientDemography { get; set; }
    }
}