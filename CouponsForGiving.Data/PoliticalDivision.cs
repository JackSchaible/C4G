//------------------------------------------------------------------------------
// <auto-generated>
//    This code was generated from a template.
//
//    Manual changes to this file may cause unexpected behavior in your application.
//    Manual changes to this file will be overwritten if the code is regenerated.
// </auto-generated>
//------------------------------------------------------------------------------

namespace CouponsForGiving.Data
{
    using System;
    using System.Collections.Generic;
    
    public partial class PoliticalDivision
    {
        public PoliticalDivision()
        {
            this.Cities = new HashSet<City>();
        }
    
        public int PoliticalDivisionID { get; set; }
        public string CountryCode { get; set; }
        public string DivisionCode { get; set; }
        public string Name { get; set; }
    
        public virtual Country Country { get; set; }
        public virtual ICollection<City> Cities { get; set; }
    }
}
