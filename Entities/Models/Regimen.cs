using System;
using System.Collections.Generic;

namespace Entities.Models
{
    public partial class Regimen
    {
        public int Id { get; set; }
        public string Combination { get; set; }
        public string Code { get; set; }
        public string Line { get; set; }
    }
}
