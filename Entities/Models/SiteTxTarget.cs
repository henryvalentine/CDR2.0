using System;
using System.Collections.Generic;

namespace Entities.Models
{
    public partial class SiteTxTarget
    {
        public int Id { get; set; }
        public long TxCurrTarget { get; set; }
        public long TxNewTarget { get; set; }
        public int FiscalYear { get; set; }
        public int SiteId { get; set; }

        public virtual Site Site { get; set; }
    }
}
