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
    
    public partial class PaymentOption
    {
        public int PaymentOptionID { get; set; }
        public int cUserId { get; set; }
        public int CardTypeID { get; set; }
        public string Last4Digits { get; set; }
        public string StripeToken { get; set; }
    
        public virtual CardType CardType { get; set; }
        public virtual cUser cUser { get; set; }
    }
}
