using CouponsForGiving;
using CouponsForGiving.Data;
using System;
using System.Collections.Generic;
using System.Drawing;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

public partial class Requests_Approve : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {
        Controls_MenuBar control = (Controls_MenuBar)Master.FindControl("MenuBarControl");
        control.MenuBar = MenuBarType.Anonymous;

        if (Request.QueryString["rid"] == null)
            ResultLabel.Text = "It seems that request does not exist. Sorry :(";
        else
        {
            try
            {
                string buffer = CouponsForGiving.EncryptionUtils.Decrypt(Request.QueryString["rid"]);
                string[] data = buffer.Split(new char[] { '&' }, StringSplitOptions.RemoveEmptyEntries);
                int mid = int.Parse(data[0].Split(new char[] { '=' }, StringSplitOptions.RemoveEmptyEntries)[1]);
                int npoid = int.Parse(data[1].Split(new char[] { '=' }, StringSplitOptions.RemoveEmptyEntries)[1]);

                if (SysData.Merchant_ApproveRequest(mid, npoid))
                {
                    ResultLabel.Text = "Request accepted!";
                }
                else
                    ResultLabel.Text = "Request has expired.";

            }
            catch (Exception ex)
            {
                ResultLabel.Text = ex.Message;
                ResultLabel.ForeColor = Color.Red;
            }
        }
    }
}