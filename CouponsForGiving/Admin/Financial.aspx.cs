using CouponsForGiving.Data;
using CouponsForGiving.Data.Classes;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

public partial class Admin_Financial : System.Web.UI.Page
{
    public class Report
    {
        public string NPOAccount { get; set; }
        public string Merchant { get; set; }
        decimal NPOSplit { get; set; }
        decimal MerchantSplit { get; set; }
        decimal OurSplit { get; set; }
        decimal GST { get { return OurSplit * 0.05M; } }
        decimal StripeFee { get { return ((OurSplit * 0.029M) + 0.3M); } }
        bool ChargedBack { get; set; }
        DateTime Date { get; set; }

        public Report(decimal npoSplit, decimal merchantSplit, decimal ourSplit,
            bool chargedBack, DateTime date)
        {
            NPOSplit = npoSplit;
            MerchantSplit = merchantSplit;
            OurSplit = ourSplit;
            ChargedBack = chargedBack;
            Date = date;
        }
    }

    protected void Page_Load(object sender, EventArgs e)
    {
        BindData();
    }

    private void BindData()
    {
        List<Report> Reports =
        (
            from po
            in PurchaseOrders.List()
            select new Report
            (
                po.NPOSplit,
                po.MerchantSplit,
                po.OurSplit,
                po.OrderStatusID == 1 || po.OrderStatusID == 2,
                po.PurchaseDate
            )
        ).ToList<Report>();

        ReportView.DataSource = Reports;
        ReportView.DataBind();
    }
}