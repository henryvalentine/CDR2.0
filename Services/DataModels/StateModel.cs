using System;
using System.Collections.Generic;

namespace Services.DataModels
{
    public partial class StateModel
    {
        public int Id { get; set; }
        public string Name { get; set; }
        public string Code { get; set; }

        public virtual List<SiteModel> Site { get; set; }
    }
}
