using CouponsForGiving;
using CouponsForGiving.Data;
using CouponsForGiving.Data.Classes;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Linq.Expressions;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

public partial class Admin_Financial : System.Web.UI.Page
{
    public class Report
    {
        public string Coupon { get; set; }
        public string NPOAccount { get; set; }
        public string MerchantAccount { get; set; }
        public decimal NPOSplit { get; set; }
        public decimal MerchantSplit { get; set; }
        public decimal MerchantPay { get { return Refunded ? 0 : MerchantSplit - GST; } }
        public decimal OurSplit { get; set; }
        public decimal GST { get { return OurSplit * 0.05M; } }
        public decimal StripeFee { get { return ((OurSplit * 0.029M) + 0.3M); } }
        public bool Refunded { get; set; }
        public DateTime Date { get; set; }

        public Report(string coupon, decimal npoSplit, decimal merchantSplit, 
            decimal ourSplit, bool refunded, DateTime date, string npo, string merchant)
        {
            Coupon = coupon;
            NPOSplit = npoSplit;
            MerchantSplit = merchantSplit;
            OurSplit = ourSplit;
            Refunded = refunded;
            Date = date;
            NPOAccount = npo;
            MerchantAccount = merchant;
        }
    }

    protected void Page_Load(object sender, EventArgs e)
    {
        BindData();

        if (!IsPostBack)
        {
            ViewState["Sort"] = "Coupon";
            ViewState["Direction"] = "asc";
        }
    }

    private void BindData()
    {
        List<Report> Reports =
        (
            from po
            in PurchaseOrders.List()
            select new Report
            (
                po.DealInstance.Deal.Name,
                po.NPOSplit,
                po.MerchantSplit,
                po.OurSplit,
                po.OrderStatusID != 1 && po.OrderStatusID != 2,
                po.PurchaseDate,
                po.Campaign.NPO.Name,
                po.DealInstance.Deal.Merchant.Name
            )
        ).ToList<Report>();

        ReportView.DataSource = Reports;
        ReportView.DataBind();
    }

    protected void ReportView_PageIndexChanging(object sender, GridViewPageEventArgs e)
    {
        ReportView.PageIndex = e.NewPageIndex;
        BindData();
    }

    protected void ReportView_Sorting(object sender, GridViewSortEventArgs e)
    {
        if (ViewState["Sort"] != null)
        {
            if (ViewState["Direction"] != null)
            {
                if (ViewState["Sort"].ToString() != e.SortExpression.ToString())
                {
                    if (ViewState["Direction"].ToString() == "asc")
                    {
                        ViewState["Direction"] = "desc";
                        e.SortDirection = SortDirection.Descending;
                    }
                    else
                    {
                        ViewState["Direction"] = "asc";
                        e.SortDirection = SortDirection.Ascending;
                    }
                }
                else
                {
                    ViewState["Sort"] = e.SortExpression;
                    ViewState["Direction"] = "asc";
                    e.SortDirection = SortDirection.Ascending;
                }
            }
        }

        IEnumerable<Report> reports =
        (
            from po
            in PurchaseOrders.List()
            select new Report
            (
                po.DealInstance.Deal.Name,
                po.NPOSplit,
                po.MerchantSplit,
                po.OurSplit,
                po.OrderStatusID != 1 && po.OrderStatusID != 2,
                po.PurchaseDate,
                po.Campaign.NPO.Name,
                po.DealInstance.Deal.Merchant.Name
            )
        );

        reports = reports.OrderBy(e.SortExpression, e.SortDirection);

        ReportView.DataSource = reports.ToList<Report>();
        ReportView.DataBind();
    }
}