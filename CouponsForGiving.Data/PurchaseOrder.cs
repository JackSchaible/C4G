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
    
    public partial class PurchaseOrder
    {
        public int PurchaseOrderID { get; set; }
        public int CampaignID { get; set; }
        public int OrderStatusID { get; set; }
        public int TransactionID { get; set; }
        public System.DateTime PurchaseDate { get; set; }
        public int DealInstanceID { get; set; }
        public decimal PurchaseAmount { get; set; }
        public decimal NPOSplit { get; set; }
        public decimal MerchantSplit { get; set; }
        public decimal OurSplit { get; set; }
        public System.Guid CouponCode { get; set; }
    
        public virtual Campaign Campaign { get; set; }
        public virtual DealInstance DealInstance { get; set; }
        public virtual OrderStatu OrderStatu { get; set; }
        public virtual PurchaseTransaction PurchaseTransaction { get; set; }
    }
}
