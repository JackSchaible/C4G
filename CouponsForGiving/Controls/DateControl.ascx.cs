﻿using System;
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
                result = new DateTime(int.Parse(YearDDL.SelectedValue), DateTime.ParseExact(MonthDDL.SelectedValue, "MM", CultureInfo.CurrentCulture).Month, int.Parse(DayDDL.SelectedValue));
            }
            catch
            {
                result = new DateTime(1900, 1, 1);
            }

            return result;
        }

        set
        {
            int Day = value.Day;
            string Month = value.Month.ToString("MMMM");
            int Year = value.Year;


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
        Dictionary<string, string> Months = new Dictionary<string, string>();
        List<string> Days = new List<string>();
        List<string> Years = new List<string>();

        Months.Add("01", "January");
        Months.Add("02", "February");
        Months.Add("03", "March");
        Months.Add("04", "April");
        Months.Add("05", "May");
        Months.Add("06", "June");
        Months.Add("07", "July");
        Months.Add("08", "August");
        Months.Add("09", "September");
        Months.Add("10", "October");
        Months.Add("11", "November");
        Months.Add("12", "December");

        for (int i = 1; i <= DateTime.DaysInMonth(MinDate.Year, MinDate.Month); i++)
        {
            if (i < 10)
                Days.Add(String.Format("0{0}", i));
            else
                Days.Add(i.ToString());
        }

        for (int i = MinDate.Year; i <= MaxDate.Year; i++)
            Years.Add(i.ToString());

        MonthDDL.DataValueField = "Key";
        MonthDDL.DataTextField = "Value";
        MonthDDL.DataSource = Months;
        DayDDL.DataSource = Days;
        YearDDL.DataSource = Years;

        MonthDDL.DataBind();
        DayDDL.DataBind();
        YearDDL.DataBind();
    }
}