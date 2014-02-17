<%@ Page Title="" Language="C#" MasterPageFile="~/Site.master" AutoEventWireup="true" CodeFile="Result.aspx.cs" Inherits="Merchant_Result" %>
<%@ Reference Control="~/Controls/MenuBar.ascx" %>

<asp:Content ID="Content4" ContentPlaceHolderID="Main_Content" Runat="Server">
    <%
        switch (Request.QueryString["q"])
        {
            case "1":
                Response.Write("<h1>Error!</h1><p>You attempted to add locations to an offer, but no offer was specified. <a href='MyHome.aspx'>Click here</a> to return to your merchant page.");
                break;

            case "2":
                Response.Write("<h1>Error!</h1><p>You attempted to add locations to an offer, but it appears that offer does not belong to this account. <a href='MyHome.aspx'>Click here</a> to return to your merchant page.");
                break;

            case "3":
                Response.Write("<h1>Error!</h1><p>You attempted to add locations to an offer, but it appears that offer does not exist. <a href='MyHome.aspx'>Click here</a> to return to your merchant page.");
                break;
        }
    %>
</asp:Content>