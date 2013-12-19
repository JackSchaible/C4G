using CouponsForGiving;
using CouponsForGiving.Data;
using CouponsForGiving.Data.Classes;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Security;
using System.Web.UI;
using System.Web.UI.WebControls;

public partial class Admin_Users : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {
        Controls_MenuBar control = (Controls_MenuBar)Master.FindControl("MenuBarControl");
        control.MenuBar = MenuBarType.Admin;

        if (!IsPostBack)
            BindData();
    }

    private void BindData()
    {
        List<cUser> users = cUsers.List();
        UsersGV.DataSource =
            (
                from
                    c
                in
                    users
                orderby
                    c.cUserID descending
                select new
                {
                    Username = c.Username,
                    Email = Membership.GetUser(c.Username).Email,
                    UserRoles = String.Join(", ", Roles.GetRolesForUser(c.Username))
                }
            );

        UsersGV.DataBind();
    }
}