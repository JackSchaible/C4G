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
    
    public partial class PaymentOption_ListByUser_Result
    {
        public int PaymentOptionID { get; set; }
        public int cUserId { get; set; }
        public string Last4Digits { get; set; }
        public string StripeToken { get; set; }
        public string Name { get; set; }
    }
}
