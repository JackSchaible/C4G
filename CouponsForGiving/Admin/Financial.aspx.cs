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
        public decimal Amount { get; set; }
        public string Coupon { get; set; }
        public string NPOAccount { get; set; }
        public string MerchantAccount { get; set; }
        public decimal NPOSplit { get; set; }
        public decimal MerchantSplit { get; set; }
        public decimal MerchantPay { get { return Refunded ? 0 : Amount - (OurSplit + NPOSplit + StripeFee); } }
        public decimal OurSplit { get; set; }
        public decimal GST { get { return OurSplit * 0.05M; } }
        public decimal StripeFee { get { return ((Amount * 0.029M) + 0.3M); } }
        public bool Refunded { get; set; }
        public DateTime Date { get; set; }

        public Report(decimal amount, string coupon, decimal npoSplit, decimal merchantSplit, 
            decimal ourSplit, bool refunded, DateTime date, string npo, string merchant)
        {
            Amount = amount;
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
                po.PurchaseAmount,
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

        ReportGV.DataSource = Reports;
        ReportGV.DataBind();
    }

    private void BindData(List<Report> Reports)
    {
        ReportGV.DataSource = Reports;
        ReportGV.DataBind();
    }

    private List<Report> ApplyFilters()
    {
        List<Report> Reports =
            (
                from po
                in PurchaseOrders.List()
                select new Report
                (
                    po.PurchaseAmount,
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

        if (CouponCheckBox.Checked)
            if (CouponNameRBL.SelectedValue == "Contains")
                Reports = Reports.Where(x => x.Coupon.ToLower().Contains(CouponName.Text.Trim().ToLower())).ToList<Report>();
            else
                Reports = Reports.Where(x => x.Coupon.ToLower() == CouponName.Text.Trim().ToLower()).ToList<Report>();

        if (MerchantCheckBox.Checked)
            if (MerchantRBL.SelectedValue == "Contains")
                Reports = Reports.Where(x => x.MerchantAccount.ToLower().Contains(MerchantTextBox.Text.Trim().ToLower())).ToList<Report>();
            else
                Reports = Reports.Where(x => x.MerchantAccount.ToLower() == MerchantTextBox.Text.Trim().ToLower()).ToList<Report>();

        if (MerchantTotalCheckBox.Checked)
        {
            decimal value = decimal.Parse(MerchantTotalTextBox.Text.Trim());

            switch (MerchantTotalRBL.SelectedValue)
            {
                case "GT":
                    Reports = Reports.Where(x => Math.Round(x.MerchantPay, 2) > value).ToList<Report>();
                    break;

                case "Exactly":
                    Reports = Reports.Where(x => Math.Round(x.MerchantPay, 2) == value).ToList<Report>();
                    break;

                case "LT":
                    Reports = Reports.Where(x => Math.Round(x.MerchantPay, 2) < value).ToList<Report>();
                    break;
            }
        }

        if (MerchantSplitCheckBox.Checked)
        {
            decimal value = decimal.Parse(MerchantSplitTextBox.Text.Trim());

            switch (MerchantSplitRBL.SelectedValue)
            {
                case "GT":
                    Reports = Reports.Where(x => Math.Round(x.MerchantSplit, 2) > value).ToList<Report>();
                    break;

                case "Exactly":
                    Reports = Reports.Where(x => Math.Round(x.MerchantSplit, 2) == value).ToList<Report>();
                    break;

                case "LT":
                    Reports = Reports.Where(x => Math.Round(x.MerchantSplit, 2) < value).ToList<Report>();
                    break;
            }
        }

        if (NPOSplitCheckBox.Checked)
        {
            decimal value = decimal.Parse(NPOSplitTextBox.Text.Trim());

            switch (NPOSplitRBL.SelectedValue)
            {
                case "GT":
                    Reports = Reports.Where(x => Math.Round(x.NPOSplit, 2) > value).ToList<Report>();
                    break;

                case "Exactly":
                    Reports = Reports.Where(x => Math.Round(x.NPOSplit, 2) == value).ToList<Report>();
                    break;

                case "LT":
                    Reports = Reports.Where(x => Math.Round(x.NPOSplit, 2) < value).ToList<Report>();
                    break;
            }
        }

        if (OurSplitCheckBox.Checked)
        {
            decimal value = decimal.Parse(OurSplitTextBox.Text.Trim());

            switch (OurSplitRBL.SelectedValue)
            {
                case "GT":
                    Reports = Reports.Where(x => Math.Round(x.OurSplit, 2) > value).ToList<Report>();
                    break;

                case "Exactly":
                    Reports = Reports.Where(x => Math.Round(x.OurSplit, 2) == value).ToList<Report>();
                    break;

                case "LT":
                    Reports = Reports.Where(x => Math.Round(x.OurSplit, 2) < value).ToList<Report>();
                    break;
            }
        }

        if (GSTCheckBox.Checked)
        {
            decimal value = decimal.Parse(GSTTextBox.Text.Trim());

            switch (GSTRBL.SelectedValue)
            {
                case "GT":
                    Reports = Reports.Where(x => Math.Round(x.GST, 2) > value).ToList<Report>();
                    break;

                case "Exactly":
                    Reports = Reports.Where(x => Math.Round(x.GST, 2) == value).ToList<Report>();
                    break;

                case "LT":
                    Reports = Reports.Where(x => Math.Round(x.GST, 2) < value).ToList<Report>();
                    break;
            }
        }

        if (StripeCheckBox.Checked)
        {
            decimal value = decimal.Parse(StripeTextBox.Text.Trim());

            switch (StripeRBL.SelectedValue)
            {
                case "GT":
                    Reports = Reports.Where(x => Math.Round(x.StripeFee, 2) > value).ToList<Report>();
                    break;

                case "Exactly":
                    Reports = Reports.Where(x => Math.Round(x.StripeFee, 2) == value).ToList<Report>();
                    break;

                case "LT":
                    Reports = Reports.Where(x => Math.Round(x.StripeFee, 2) < value).ToList<Report>();
                    break;
            }
        }

        if (NPOCheckBox.Checked)
            if (NPORBL.SelectedValue == "Contains")
                Reports = Reports.Where(x => x.NPOAccount.ToLower().Contains(NPOTextBox.Text.Trim().ToLower())).ToList<Report>();
            else
                Reports = Reports.Where(x => x.NPOAccount.ToLower() == NPOTextBox.Text.Trim().ToLower()).ToList<Report>();

        if (RefundedCheckBox.Checked)
            if (RefundedRBL.SelectedValue == "True")
                Reports = Reports.Where(x => x.Refunded).ToList<Report>();
            else
                Reports = Reports.Where(x => !x.Refunded).ToList<Report>();

        if (DateCheckBox.Checked)
        {
            DateTime start = StartDate.Date;

            switch (DateRBL.SelectedValue)
            {
                case "Before":
                    Reports = Reports.Where(x => x.Date.Date < start.Date).ToList<Report>();
                    break;

                case "Exactly":
                    Reports = Reports.Where(x => x.Date.Date == start.Date).ToList<Report>();
                    break;

                case "After":
                    Reports = Reports.Where(x => x.Date.Date > start.Date).ToList<Report>();
                    break;

                case "Between":
                    DateTime end = EndDate.Date;

                    Reports = Reports.Where(x => x.Date.Date > start.Date && x.Date.Date < end.Date).ToList<Report>();
                    break;
            }
        }

        return Reports;
    }

    protected void Submit_Click(object sender, EventArgs e)
    {
        if (FilterState.Value == "Show")
            BindData(ApplyFilters());
        else
            BindData();
    } 

    protected void ReportView_PageIndexChanging(object sender, GridViewPageEventArgs e)
    {
        ReportGV.PageIndex = e.NewPageIndex;

        if (FilterState.Value == "Show")
            BindData(ApplyFilters());
        else
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

        IEnumerable<Report> reports = null;

        if (FilterState.Value == "Show")
            reports = ApplyFilters();
        else
            reports = 
            (
                from po
                in PurchaseOrders.List()
                select new Report
                (
                    po.PurchaseAmount,
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

        ReportGV.DataSource = reports.ToList<Report>();
        ReportGV.DataBind();
    }
}