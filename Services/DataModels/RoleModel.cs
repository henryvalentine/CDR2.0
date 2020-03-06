using System;
using System.Collections.Generic;

namespace Services.DataModels
{
    public partial class RoleModel
    {
        public string Id { get; set; }
        public string Name { get; set; }
        public string NormalizedName { get; set; }
        public string ConcurrencyStamp { get; set; }
    }
}
