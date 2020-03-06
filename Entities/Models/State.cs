using System;
using System.Collections.Generic;

namespace Entities.Models
{
    public partial class State
    {
        public State()
        {
            Site = new HashSet<Site>();
        }

        public int Id { get; set; }
        public string Name { get; set; }
        public string Code { get; set; }

        public virtual ICollection<Site> Site { get; set; }
    }
}
