<%@ Page Title="Result" Language="C#" MasterPageFile="~/Site.master" AutoEventWireup="true" CodeFile="Confirmation.aspx.cs" Inherits="Merchant_Locations_Confirmation" %>

<asp:Content ID="Content4" ContentPlaceHolderID="Main_Content" Runat="Server">
    <%
        switch (Request.QueryString["q"])
        {
            case "1":
                Response.Write("<h1>Success!</h1><p>Your merchant location was successfully added. <a href='Default.aspx'>Click here</a> to return to the Merchant Locations page.");
                break;

            case "2":
                Response.Write("<h1>Merchant Location Not Found!</h1><p>We're sorry, but we couldn't find the merchant location you were trying to edit. <a href='Default.aspx'>Click here</a> to return to the Merchant Locations page.");
                break;
                
            case "3":
                Response.Write("<h1>Success!</h1><p>Your merchant location was successfully deactivated. <a href='Default.aspx'>Click here</a> to return to the Merchant Locations page.");
                break;

            case "4":
                Response.Write("<h1>Success!</h1><p>Your merchant location was successfully edited. <a href='Default.aspx'>Click here</a> to return to the Merchant Locations page.");
                break;
        }
    %>
</asp:Content>