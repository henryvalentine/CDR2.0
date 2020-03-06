using System;
using System.Collections.Generic;

namespace Services.DataModels
{
    public partial class SiteTxTargetModel
    {
        public int Id { get; set; }
        public long TxCurrTarget { get; set; }
        public long TxNewTarget { get; set; }
        public int FiscalYear { get; set; }
        public int SiteId { get; set; }
        public virtual SiteModel Site { get; set; }
    }
}
