using CouponsForGiving;
using CouponsForGiving.Data;
using CouponsForGiving.Data.Classes;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

public partial class NPO_Reports_Sales : System.Web.UI.Page
{
    public class Report
    {
        public string Campaign { get; set; }
        public int CouponsSold { get; set; }
        public int CouponsAvailable { get; set; }
        public int DaysLeft { get; set; }
        public decimal PercentageReached { get; set; }

        public Report(string campaign, int? couponsSold, int? couponsAvailable,
            TimeSpan? daysLeft, decimal? percentageReached)
        {
            Campaign = campaign;
            CouponsSold = couponsSold.Value;
            CouponsAvailable = couponsAvailable.Value;
            DaysLeft = (int)daysLeft.Value.TotalDays;
            PercentageReached = percentageReached.Value;
        }
    }

    protected void Page_Load(object sender, EventArgs e)
    {
        Controls_MenuBar control = (Controls_MenuBar)Master.FindControl("MenuBarControl");
        control.MenuBar = MenuBarType.NPO;
        Master.SideBar = false;

        BindData();

        if (!IsPostBack)
        {
            ViewState["Sort"] = "Coupon";
            ViewState["Direction"] = "asc";
        }
    }

    private void BindData()
    {
        List<Campaign> camps = Campaigns.ListAllByUsername(User.Identity.Name);

        List<Report> reports =
        (
            from c
            in camps
            select new Report
            (
                c.Name,
                c.PurchaseOrders.Where(x => x.OrderStatusID != 3).Count(),
                c.DealInstances.Sum(x => x.Deal.AbsoluteCouponLimit - x.PurchaseOrders.Where(y => y.OrderStatusID != 3).Count()),
                c.EndDate - DateTime.Now,
                c.PurchaseOrders.Sum(x => x.NPOSplit) / c.FundraisingGoal
            )
        ).ToList<Report>();

        ReportGV.DataSource = reports;
        ReportGV.DataBind();
    }

    private void BindData(List<Report> reports)
    {
        ReportGV.DataSource = reports;
        ReportGV.DataBind();
    }

    private List<Report> ApplyFilters()
    {
        List<Campaign> camps = Campaigns.ListAllByUsername(User.Identity.Name);

        List<Report> Reports =
        (
            from c
            in camps
            select new Report
            (
                c.Name,
                c.PurchaseOrders.Where(x => x.OrderStatusID != 3).Count(),
                c.DealInstances.Sum(x => x.Deal.AbsoluteCouponLimit - x.PurchaseOrders.Where(y => y.OrderStatusID != 3).Count()),
                c.EndDate - DateTime.Now,
                c.PurchaseOrders.Sum(x => x.NPOSplit) / c.FundraisingGoal
            )
        ).ToList<Report>();

        if (CampaignCheckBox.Checked)
            if (CampaignRBL.SelectedValue == "Contains")
                Reports = Reports.Where(x => x.Campaign.ToLower().Contains(CampaignTextBox.Text.Trim().ToLower())).ToList<Report>();
            else
                Reports = Reports.Where(x => x.Campaign.ToLower() == CampaignTextBox.Text.Trim().ToLower()).ToList<Report>();

        if (SoldCheckBox.Checked)
        {
            string soldTextBoxText = SoldTextBox.Text.Trim();
            int value = 0;

            if (soldTextBoxText != String.Empty)
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
            string remainingTextBoxText = RemainingTextBox.Text.Trim();
            int value = 0;

            if (remainingTextBoxText != String.Empty)
                value = int.Parse(RemainingTextBox.Text.Trim());
            else
                RemainingTextBox.Text = "0";

            switch (RemainingRBL.SelectedValue)
            {
                case "GT":
                    Reports = Reports.Where(x => x.CouponsAvailable > value).ToList<Report>();
                    break;

                case "Exactly":
                    Reports = Reports.Where(x => x.CouponsAvailable == value).ToList<Report>();
                    break;

                case "LT":
                    Reports = Reports.Where(x => x.CouponsAvailable < value).ToList<Report>();
                    break;
            }
        }

        if (DaysLeftCheckBox.Checked)
        {
            string daysLeftTextBoxText = DaysLeftTextBox.Text.Trim();
            int value = 0;

            if (daysLeftTextBoxText != String.Empty)
                value = int.Parse(DaysLeftTextBox.Text.Trim());
            else
                DaysLeftTextBox.Text = "0";

            switch (DaysLeftRBL.SelectedValue)
            {
                case "GT":
                    Reports = Reports.Where(x => x.DaysLeft > value).ToList<Report>();
                    break;

                case "Exactly":
                    Reports = Reports.Where(x => x.DaysLeft == value).ToList<Report>();
                    break;

                case "LT":
                    Reports = Reports.Where(x => x.DaysLeft < value).ToList<Report>();
                    break;
            }
        }

        if (PercentCheckBox.Checked)
        {
            string percentTextBoxText = PercentTextBox.Text.Trim();
            decimal value = 0;

            if (percentTextBoxText != String.Empty)
                value = decimal.Parse(PercentTextBox.Text.Trim()) / 100;
            else
                PercentTextBox.Text = "0";

            switch (PercentRBL.SelectedValue)
            {
                case "GT":
                    Reports = Reports.Where(x => x.PercentageReached > value).ToList<Report>();
                    break;

                case "Exactly":
                    Reports = Reports.Where(x => x.PercentageReached == value).ToList<Report>();
                    break;

                case "LT":
                    Reports = Reports.Where(x => x.PercentageReached < value).ToList<Report>();
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

    protected void ReportGV_PageIndexChanging(object sender, GridViewPageEventArgs e)
    {
        ReportGV.PageIndex = e.NewPageIndex;

        if (FilterState.Value == "Show")
            BindData(ApplyFilters());
        else
            BindData();
    }

    protected void ReportGV_Sorting(object sender, GridViewSortEventArgs e)
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
            List<Campaign> camps = Campaigns.ListAllByUsername(User.Identity.Name);

            reports =
            (
                from c
                in camps
                select new Report
                (
                    c.Name,
                    c.PurchaseOrders.Where(x => x.OrderStatusID != 3).Count(),
                    c.DealInstances.Sum(x => x.Deal.AbsoluteCouponLimit - x.PurchaseOrders.Where(y => y.OrderStatusID != 3).Count()),
                    c.EndDate - DateTime.Now,
                    c.PurchaseOrders.Sum(x => x.NPOSplit) / c.FundraisingGoal
                )
            ).ToList<Report>();
        }

        reports = reports.OrderBy(e.SortExpression, e.SortDirection);

        ReportGV.DataSource = reports.ToList<Report>();
        ReportGV.DataBind();
    }
}