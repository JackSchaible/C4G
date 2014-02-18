using CouponsForGiving;
using CouponsForGiving.Data;
using CouponsForGiving.Data.Classes;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

public partial class Merchant_ConnectToStripe : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {
        Controls_MenuBar control = (Controls_MenuBar)Master.FindControl("MenuBarControl");
        control.MenuBar = MenuBarType.Merchant;

        Merchant m = Merchants.GetByUsername(User.Identity.Name);
        City c = Cities.Get(m.CityID);

        string vars = String.Format("stripe_user[email]={0}&stripe_user[url]={1}&stripe_user[phone_number]={2}&stripe_user[business_name]={3}&stripe_user[business_type]={4}&stripe_user[first_name]={5}&stripe_user[last_name]={6}&stripe_user[dob_day]={7}&stripe_user[dob_month]={8}&stripe_user[dob_year]={9}&stripe_user[street_address]={10}&stripe_user[city]={11}&stripe_user[state]={12}&stripe_user[zip]={13}&stripe_user[physical_product]={14}&stripe_user[product_category]={15}&stripe_user[country]={16}&stripe_user[currency]={17}",
                                HttpContext.Current.Server.UrlEncode(m.Email), HttpContext.Current.Server.UrlEncode(m.Website), HttpContext.Current.Server.UrlEncode(m.PhoneNumber),
                                HttpContext.Current.Server.UrlEncode(m.Name), "", "", "", "", "", "", HttpContext.Current.Server.UrlEncode(m.cAddress), HttpContext.Current.Server.UrlEncode(c.Name), HttpContext.Current.Server.UrlEncode(c.PoliticalDivision.Name),
                                HttpContext.Current.Server.UrlEncode(m.PostalCode), "", "", HttpContext.Current.Server.UrlEncode(c.Country.Name), "");

        string result = String.Format("https://connect.stripe.com/oauth/authorize?response_type=code&client_id=ca_2dcruIQ1MEWM9BfJot2jJUPvKqJGofMU&scope=read_write&{0}", vars);

        Response.Redirect(result);
    }
}