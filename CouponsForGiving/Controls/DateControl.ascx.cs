using System;
using System.Collections.Generic;
using System.ComponentModel;
using System.Globalization;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

public partial class Controls_DateControl : System.Web.UI.UserControl
{
    private DateTime MinDate = new DateTime(1900, 1, 1);
    private DateTime MaxDate = new DateTime(DateTime.Now.AddYears(10).Year, 1, 1);

    public bool AcceptPastDates { get; set; }
    public bool AcceptFutureDates { get; set; }
    public bool AutoPostBack { get; set; }

    public DateTime Date
    {
        get
        {
            DateTime result;

            try
            {
                result = new DateTime(int.Parse(YearDDL.SelectedValue), DateTime.ParseExact(MonthDDL.SelectedValue, "MMMM", CultureInfo.CurrentCulture).Month, int.Parse(DayDDL.SelectedValue));
            }
            catch
            {
                result = new DateTime(1900, 1, 1);
            }

            return result;
        }
    }

    public Controls_DateControl()
    {
        AcceptPastDates = true;
        AcceptFutureDates = true;
        AutoPostBack = false;
    }

    protected void Page_Load(object sender, EventArgs e)
    {
        if (!AcceptFutureDates)
            MaxDate = DateTime.Now;

        if (!AcceptPastDates)
            MinDate = DateTime.Now;

        if (AutoPostBack)
        {
            DayDDL.AutoPostBack = true;
            MonthDDL.AutoPostBack = true;
            YearDDL.AutoPostBack = true;
        }

        if (!IsPostBack)
            BindData();
    }

    private void BindData()
    {
        List<string> Months = new List<string>();
        List<string> Days = new List<string>();
        List<string> Years = new List<string>();

        Months.Add("January");
        Months.Add("February");
        Months.Add("March");
        Months.Add("April");
        Months.Add("May");
        Months.Add("June");
        Months.Add("July");
        Months.Add("August");
        Months.Add("September");
        Months.Add("October");
        Months.Add("November");
        Months.Add("December");
        
        for (int i = 1; i <= DateTime.DaysInMonth(MinDate.Year, MinDate.Month); i++)
            Days.Add(i.ToString());

        for (int i = MinDate.Year; i <= MaxDate.Year; i++)
            Years.Add(i.ToString());

        MonthDDL.DataSource = Months;
        DayDDL.DataSource = Days;
        YearDDL.DataSource = Years;

        MonthDDL.DataBind();
        DayDDL.DataBind();
        YearDDL.DataBind();
    }
}