using CouponsForGiving.Data;
using CouponsForGiving.Data.Classes;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

public partial class Default_AllDeals : System.Web.UI.Page
{
    public List<DealInstance> DIs;

    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack)
            DIs = DealInstances.ListAll();
    }
}