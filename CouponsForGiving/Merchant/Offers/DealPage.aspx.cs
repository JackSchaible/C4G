using CouponsForGiving.Data;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

public partial class Merchant_Offers_DealPage : System.Web.UI.Page
{
    public Deal deal;
    public DealInstance dealInstance;
    public Merchant merchant;

    protected override void OnPreInit(EventArgs e)
    {
            if (Request.QueryString["deal"] == null)
                Response.Redirect("~/Default/Home.aspx", true);
            else
            {
                string merchantName = "";

                merchant = SysData.Merchant_GetByName(User.Identity.Name);
                dealInstance = SysData.DealInstance_GetByID(int.Parse(Request.QueryString["deal"]));
                deal = dealInstance.Deal;

                if (deal == null)
                    Response.Redirect("../" + merchantName);

                merchant = deal.Merchant;
                Title = String.Format("{1} - {0}", deal.Name, merchant.Name);
            }

        base.OnPreInit(e);
    }

    protected void Page_Load(object sender, EventArgs e)
    {

    }
}