using CouponsForGiving;
using CouponsForGiving.Data;
using CouponsForGiving.Data.Classes;
using Stripe;
using System;
using System.Collections.Generic;
using System.Drawing;
using System.Globalization;
using System.Linq;
using System.Transactions;
using System.Web;
using System.Web.Security;
using System.Web.UI;
using System.Web.UI.WebControls;

public partial class Default_My_PaymentOptions : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {
        Controls_MenuBar control = (Controls_MenuBar)Master.FindControl("MenuBarControl");
        control.MenuBar = MenuBarType.Supporter;

        if (!IsPostBack)
            BindData();

        if (Session["Cart"] != null)
        {
            if (((List<ShoppingCart>)Session["Cart"]).Count() < 1)
                Response.Redirect("../DealsInMyArea.aspx");
        }
        else
            Response.Redirect("../DealsInMyArea.aspx");
    }

    private void BindData()
    {
        PaymentOptionsGV.DataSource = SysData.PaymentOptions_ListByUser(User.Identity.Name);
        PaymentOptionsGV.DataBind();

        List<int> years = new List<int>();

        for (int i = 0; i < 11; i++)
            years.Add(DateTime.Now.AddYears(i).Year);

        YearDDL.DataSource = years;
        YearDDL.DataBind();

        ProceedErrorLabel.Text = "";
        ErrorLabel.Text = "";
    }

    protected void CustomValidator1_ServerValidate(object source, ServerValidateEventArgs args)
    {
        if (CCTextBox.Text.Trim().Length != 16)
            args.IsValid = false;
    }

    protected void SubmitButton_Click(object sender, EventArgs e)
    {
        try
        {
            int cardTypeID = int.Parse(CardTypesDDL.SelectedValue.Trim());
            string cardNumber = CCTextBox.Text.Trim();
            int month = DateTime.ParseExact(MonthDropdown.SelectedValue.Trim(), "MMMM", CultureInfo.CurrentCulture).Month;
            int year = int.Parse(YearDDL.SelectedValue);
            string firstName = FirstNameTextBox.Text.Trim();
            string lastName = LastNameTextBox.Text.Trim();
            string address = AddressTextBox.Text.Trim();
            string city = CityTextBox.Text.Trim();
            string province = ProvinceTextBox.Text.Trim();
            string postal = PostalTextBox.Text.Trim().Replace("-", "").Replace(" ", "");
            string country = CountryDDL.SelectedValue;

            StripeCardCreateOptions options = new StripeCardCreateOptions();
            options.CardNumber = cardNumber.ToString();
            options.CardExpirationYear = year.ToString();
            options.CardExpirationMonth = month.ToString();
            
            string cardID = (new StripeCardService()).Create(SysData.cUser_GetByName(User.Identity.Name).StripeKey, options).Id;

            SysData.PaymentOptions_Insert(User.Identity.Name, cardTypeID, cardNumber.ToString().Substring(12), cardID,
                address, city, province, postal, country);

            BindData();
        }
        catch (Exception ex)
        {
            ErrorLabel.ForeColor = Color.Red;
            ErrorLabel.Text = ex.Message;
            newForm.Style["display"] = "block";
        }
    }

    protected void Proceed_Click(object sender, EventArgs e)
    {
        try
        {
            if (Request.Form["PaymentTypeButton"] == null)
            {
                ProceedErrorLabel.Text = "You must select a payment method.";
                ProceedErrorLabel.ForeColor = Color.Red;
            }
            else
            {
                PaymentOption option = SysData.PaymentOption_Get(int.Parse(Request.Form["PaymentTypeButton"]));
                List<ShoppingCart> cart = (List<ShoppingCart>)Session["Cart"];
                List<int> merchantIDs = cart.Select(m => m.MerchantID).Distinct().ToList<int>();

                //Group "cart" variable into lists of deals by merchant
                List<List<ShoppingCart>> deals = new List<List<ShoppingCart>>();
                foreach (int item in merchantIDs)
                    deals.Add(cart.Where(x => x.MerchantID == item).ToList<ShoppingCart>());

                StripeCharge charge = null;

                List<PurchaseOrder> orders = new List<PurchaseOrder>();

                using (TransactionScope ts = new TransactionScope())
                {
                    try
                    {
                        orders = SysData.PurchaseOrder_Insert(cart, User.Identity.Name);

                        cUser user = SysData.cUser_GetByName(User.Identity.Name);
                        MerchantStripeInfo info;

                        foreach (List<ShoppingCart> ds in deals)
                        {
                            info = SysData.MerchantStripeInfo_Get(ds[0].MerchantID);

                            var myToken = new StripeTokenCreateOptions();
                            myToken.CustomerId = user.StripeKey;


                            StripeToken stripeToken = new StripeTokenService(info.ApiKey).Create(myToken);
                            var stripeService = new StripeChargeService(info.ApiKey);
                            //int chargeAmount = (int)(ds.Sum(x => Math.Round(x.Split.MerchantSplit, 2)) * 100);
                            //int appFee = (int)(Math.Round(ds.Sum(x => x.Split.NPOSplit + x.Split.OurSplit), 2) * 100);

                            int ca = 0;
                            int af = 0;
                            Price p = SysData.Price_GetByDealInstance(ds[0].DealInstanceID);

                            foreach (ShoppingCart item in ds)
                            {
                                decimal tax = p.OurSplit * 0.05M;
                                ca += (int)((p.MerchantSplit - tax) * 100);
                                af += (int)((p.OurSplit + tax + p.NPOSplit) * 100);
                            }

                            var stripeChargeOption = new StripeChargeCreateOptions()
                            {
                                AmountInCents = ca + af,
                                Currency = "cad",
                                Card = stripeToken.Id,
                                Description = "Your Purchase with Coupons4Giving - " + info.Merchant.Name,
                                ApplicationFeeInCents = af
                            };
                            var response = stripeService.Create(stripeChargeOption);
                        }
                        Session["Cart"] = new List<ShoppingCart>();
                        ts.Complete();
                    }
                    catch (Exception ex)
                    {
                        try
                        {
                            ts.Dispose();
                        }
                        catch (Exception ex2)
                        {
                            ts.Dispose();
                            ex2.ToString();
                        }

                        ErrorLabel.Text = ex.Message + " Stack Trace: " + ex.StackTrace;
                    }
                }

                if (charge != null)
                {
                    if (charge.FailureCode != null)
                    {
                        ErrorLabel.Text = "Charge Failure! : " + charge.FailureMessage;
                    }
                }
                else
                {
                    try
                    {
                        foreach (PurchaseOrder item in orders)
                            EmailUtils.SendPurchaseEmail(item);
                    }
                    catch (Exception ex)
                    {
                    }

                    Response.Redirect("ThankYou.aspx");
                }
            }
        }
        catch (Exception ex)
        {
            ProceedErrorLabel.Text = ex.Message + " Stack Trace: " + ex.StackTrace;
            ProceedErrorLabel.ForeColor = Color.Red;
        }
    }

    protected void PaymentOptionsGV_RowDeleting(object sender, GridViewDeleteEventArgs e)
    {
        try
        {
            SysData.PaymentOption_Delete(int.Parse(PaymentOptionsGV.DataKeys[e.RowIndex].Value.ToString()));
            BindData();
        }
        catch (Exception ex)
        {
            ProceedErrorLabel.Text = ex.Message + " Inner Exception: " + ex.InnerException + " Payment Option ID: " + PaymentOptionsGV.DataKeys[e.RowIndex].Value.ToString();
            ProceedErrorLabel.ForeColor = Color.Red;
        }
    }
}