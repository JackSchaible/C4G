using CouponsForGiving;
using CouponsForGiving.Data;
using CouponsForGiving.Data.Classes;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

public partial class Merchant_Reports_Sales : System.Web.UI.Page
{
    private class Report
    {
        public string Offer { get; set; }
        public decimal AmountCollected { get; set; }
        public int CouponsSold { get; set; }
        public int CouponsLeft { get; set; }
        public int CouponsRedeemed { get; set; }

        public Report(string offer, decimal amountCollected, int couponsSold,
            int couponsLeft, int couponsRedeemed)
        {
            Offer = offer;
            AmountCollected = amountCollected;
            CouponsSold = couponsSold;
            CouponsLeft = couponsLeft;
            CouponsRedeemed = couponsRedeemed;
        }
    }

    protected void Page_Load(object sender, EventArgs e)
    {
        Controls_MenuBar control = (Controls_MenuBar)Master.FindControl("MenuBarControl");
        control.MenuBar = MenuBarType.Merchant;

        BindData();

        if (!IsPostBack)
        {
            ViewState["Sort"] = "Coupon";
            ViewState["Direction"] = "asc";
        }
    }

    private void BindData()
    {
        List<DealInstance> deals = SysData.DealInstance_ListByMerchant(Merchants.GetByUsername(User.Identity.Name).MerchantID);

        List<Report> Reports =
        (
            from d
            in deals
            select new Report
            (
                d.Deal.Name,
                d.PurchaseOrders.Where(x => x.OrderStatusID != 3).Sum(x => x.MerchantSplit),
                d.PurchaseOrders.Where(x => x.OrderStatusID != 3).Count(),
                (d.Deal.AbsoluteCouponLimit - d.PurchaseOrders.Where(x => x.OrderStatusID != 3).Count()).Value,
                d.PurchaseOrders.Where(x => x.OrderStatusID == 2).Count()
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
        List<DealInstance> deals = SysData.DealInstance_ListByMerchant(Merchants.GetByUsername(User.Identity.Name).MerchantID);

        List<Report> Reports =
        (
            from d
            in deals
            select new Report
            (
                d.Deal.Name,
                d.PurchaseOrders.Where(x => x.OrderStatusID == 1 || x.OrderStatusID == 2).Sum(x => x.MerchantSplit),
                d.PurchaseOrders.Where(x => x.OrderStatusID == 1 || x.OrderStatusID == 2).Count(),
                (d.Deal.AbsoluteCouponLimit - d.PurchaseOrders.Where(x => x.OrderStatusID == 1 || x.OrderStatusID == 2).Count()).Value,
                d.PurchaseOrders.Where(x => x.OrderStatusID == 2).Count()
            )
        ).ToList<Report>();

        if (OfferCheckBox.Checked)
            if (OfferRBL.SelectedValue == "Contains")
                Reports = Reports.Where(x => x.Offer.ToLower().Contains(OfferTextBox.Text.Trim().ToLower())).ToList<Report>();
            else
                Reports = Reports.Where(x => x.Offer.ToLower() == OfferTextBox.Text.Trim().ToLower()).ToList<Report>();

        if (AmountCheckBox.Checked)
        {
            string textBoxText = AmountTextBox.Text.Trim();
            decimal value = 0;

            if (textBoxText != String.Empty)
                value = decimal.Parse(AmountTextBox.Text.Trim());
            else
                AmountTextBox.Text = "0";

            switch (AmountRBL.SelectedValue)
            {
                case "GT":
                    Reports = Reports.Where(x => Math.Round(x.AmountCollected, 2) > value).ToList<Report>();
                    break;

                case "Exactly":
                    Reports = Reports.Where(x => Math.Round(x.AmountCollected, 2) == value).ToList<Report>();
                    break;

                case "LT":
                    Reports = Reports.Where(x => Math.Round(x.AmountCollected, 2) < value).ToList<Report>();
                    break;
            }
        }

        if (SoldCheckBox.Checked)
        {
            string textBoxText = SoldTextBox.Text.Trim();
            int value = 0;

            if (textBoxText != String.Empty)
                value = int.Parse(SoldTextBox.Text.Trim());
            else
                SoldTextBox.Text = "0";

            switch (SoldRBL.SelectedValue)
            {
                case "GT":
                    Reports = Reports.Where(x => x.CouponsSold > value).ToList<Report>();
                    break;

                case "Exactly":
                    Reports = Reports.Where(x => x.CouponsSold == value).ToList<Report>();
                    break;

                case "LT":
                    Reports = Reports.Where(x => x.CouponsSold < value).ToList<Report>();
                    break;
            }
        }

        if (RemainingCheckBox.Checked)
        {
            string textBoxText = RemainingTextBox.Text.Trim();
            int value = 0;

            if (textBoxText != String.Empty)
                value = int.Parse(RemainingTextBox.Text.Trim());
            else
                RemainingTextBox.Text = "0";

            switch (RemainingRBL.SelectedValue)
            {
                case "GT":
                    Reports = Reports.Where(x => x.CouponsLeft > value).ToList<Report>();
                    break;

                case "Exactly":
                    Reports = Reports.Where(x => x.CouponsLeft == value).ToList<Report>();
                    break;

                case "LT":
                    Reports = Reports.Where(x => x.CouponsLeft < value).ToList<Report>();
                    break;
            }
        }

        if (RedeemedCheckBox.Checked)
        {
            string textBoxText = RedeemedTextBox.Text.Trim();
            int value = 0;

            if (textBoxText != String.Empty)
                value = int.Parse(RedeemedTextBox.Text.Trim());
            else
                RedeemedTextBox.Text = "0";

            switch (RedeemedRBL.SelectedValue)
            {
                case "GT":
                    Reports = Reports.Where(x => x.CouponsRedeemed > value).ToList<Report>();
                    break;

                case "Exactly":
                    Reports = Reports.Where(x => x.CouponsRedeemed == value).ToList<Report>();
                    break;

                case "LT":
                    Reports = Reports.Where(x => x.CouponsRedeemed < value).ToList<Report>();
                    break;
            }
        }

        return Reports;
    }

    protected void SubmitButton_Click(object sender, EventArgs e)
    {
        if (FilterState.Value == "Show")
            BindData(ApplyFilters());
        else
            BindData();
    }

    protected void ReportsGV_PageIndexChanging(object sender, GridViewPageEventArgs e)
    {
        ReportGV.PageIndex = e.NewPageIndex;

        if (FilterState.Value == "Show")
            BindData(ApplyFilters());
        else
            BindData();
    }

    protected void ReportsGV_Sorting(object sender, GridViewSortEventArgs e)
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
        {
            List<DealInstance> deals = SysData.DealInstance_ListByMerchant(Merchants.GetByUsername(User.Identity.Name).MerchantID);
            reports =
            (
                from d
                in deals
                select new Report
                (
                    d.Deal.Name,
                    d.PurchaseOrders.Where(x => x.OrderStatusID == 1 || x.OrderStatusID == 2).Sum(x => x.MerchantSplit),
                    d.PurchaseOrders.Where(x => x.OrderStatusID == 1 || x.OrderStatusID == 2).Count(),
                    (d.Deal.AbsoluteCouponLimit - d.PurchaseOrders.Where(x => x.OrderStatusID == 1 || x.OrderStatusID == 2).Count()).Value,
                    d.PurchaseOrders.Where(x => x.OrderStatusID == 2).Count()
                )
            ).ToList<Report>();
        }

        reports = reports.OrderBy(e.SortExpression, e.SortDirection);

        ReportGV.DataSource = reports.ToList<Report>();
        ReportGV.DataBind();
    }
    
}