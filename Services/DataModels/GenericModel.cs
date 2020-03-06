using System;
using System.Collections.Generic;

namespace Services.DataModels
{
    public class GenericModel
    {       
        public List<SiteModel> Sites { get; set; }
        public long TotalItems { get; set; }
        public List<LineItem> LineList { get; set; }
        public List<GroupCount> GroupCounts { get; set; }
        public List<RegimenModel> Regimens { get; set; }
    }

    public class TXCurrImport
    {
        public string SiteId { get; set; }
        public string SiteName { get; set; }
        public long TX_CURR_TARGET { get; set; }
        public long TX_NEW_TARGET { get; set; }
        public int FISCAL_YEAR { get; set; }       

    }

    public class QueryModel
    {
       public DateTime From { get; set; }
       public DateTime To { get; set; }
       public int ItemsPerPage { get; set; }
       public int PageNumber { get; set; }
       public int SiteId { get; set; }
       public int StateId { get; set; }
        public string Header { get; set; }

    }
}
