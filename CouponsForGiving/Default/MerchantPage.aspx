<%@ Page Title="" Language="C#" MasterPageFile="~/Site.master" AutoEventWireup="true" CodeFile="MerchantPage.aspx.cs" Inherits="Default_MerchantPage" %>
<%@ Reference Control="~/Controls/MenuBar.ascx" %>

<asp:Content ID="Content1" ContentPlaceHolderID="HeadContent" Runat="Server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="Main_Content" Runat="Server">
    <style type="text/css">
        #MainContent h1 {
            margin: 0 0 5% 0;
            text-align: center;
            width: 100%;
        }

        #MainContent h2 {
            display: block;
            margin: 50px 0 0 0;
            text-align: center;
        }

        #MainContent h3 {
            font-size: 25px;
            text-align: center;
        }

        #MainContent p {
            margin: 0 !important;
        }

        .Campaign {
            border-top: none !important;
            border-radius: 0;
            padding: 1%;
        }

        #Campaigns a {
            background-color: #22bfe8;
            border-radius: 7px;
            color: #FFF;
            display: inline-block;
            font-family: Corbel, Arial, sans-serif;
            margin: 0 0 0 25%;
            padding: 5px 10px;
            text-decoration: none;
            width: 45%;
        }

        #Campaigns {
            margin: 0 auto;
            width: 60%;
        }

        #Logo {
            float: right;
            margin: 30px 10% 5% 0;
            width: 33%;
        }

        #Text {
            float: left;
            padding: 0 0 0 10%;
            width: 40%;
        }

        #Text a {
            text-align: center;
            display: inline-block;
            width: 100%;
            font-family: Corbel, Arial, sans-serif;
            font-size: 20px;
            color: #22bfe8;
        }
    </style>
    <div id="NPO">
        <div id="Text">
            <h1><%: merchant.Name %></h1>
            <p><%: merchant.cUser.MerchantInfoes.FirstOrDefault<CouponsForGiving.Data.MerchantInfo>().MerchantDescription %></p>
        </div>
        <img alt="Our Logo" id="Logo" src="../<%: merchant.LargeLogo %>" />
        <div class="ClearFix"></div>
    </div>
    <asp:Panel ID="Campaigns" runat="server" ClientIDMode="Static">
        <h2>Our Deals</h2>
        <%
            foreach (CouponsForGiving.Data.DealInstance oc in (CouponsForGiving.Data.SysData.DealInstance_ListByMerchant(merchant.MerchantID)))
                Response.Write("<div class=\"Campaign\"><a href=\"DealPage.aspx?merchantname=" + merchant.Name + "&deal=" + Server.UrlEncode(oc.Deal.Name) + "\">" + oc.Deal.Name + "</a></div>");
        %>
    </asp:Panel>
</asp:Content>