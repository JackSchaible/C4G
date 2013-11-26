<%@ Page Title="" Language="C#" MasterPageFile="~/Site.master" AutoEventWireup="true" CodeFile="NPOPage.aspx.cs" Inherits="Default_NpoPage" %>
<%@ Reference Control="~/Controls/MenuBar.ascx" %>

<asp:Content ID="Content1" ContentPlaceHolderID="HeadContent" Runat="Server">
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
            color: #FFF;
            background-color: #22bfe8;
            border-radius: 7px;
            font-family: Corbel, Arial, sans-serif;
            padding: 5px 10px;
            text-decoration: none;
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

        #Featured, .Campaign {
            border: 1px solid #BBB;
        }

        #Featured {
            border-top-left-radius: 5px;
            border-top-right-radius: 5px;
        }

        #Featured img {
            border-radius: 5px;
            float: left;
            margin: 0 0 0 5%;
        }

        #Featured a {
            display: inline-block;
            font-size: 40px;
            margin: 4% 0 0 9%;
        }
    </style>
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="Main_Content" Runat="Server">
    <UC:ShareControl ID='ShareControl' runat='server' Share='Profile' CType='Campaign'
        Name='<%# npo.Name %>' ImageURL='<%# "https://www.coupons4giving.ca/" + npo.Logo %>' Description='<%# npo.NPODescription %>' />
    <div id="NPO">
        <div id="Text">
            <h1><%: npo.Name %></h1>
            <p><%: npo.NPODescription %></p>
        </div>
        <img alt="Our Logo" id="Logo" src="../<%: npo.Logo %>" />
        <div class="ClearFix"></div>
    </div>
    <asp:Panel ID="Campaigns" ClientIDMode="Static" runat="server">
        <h2>Our Campaigns</h2>
        <div id="Featured">
            <asp:Panel ID="FeaturedCampaign" runat="server">
                <img alt="Featured Campaign Image" src="../<%: featured.CampaignImage %>" />
                <a href="../Default/CampaignPage.aspx?npoName=<%: npo.URL + "&campaign=" + featured.Name %>"><%: featured.Name %></a>
                <div class="ClearFix"></div>
            </asp:Panel>
        </div>
        <%
            foreach (CouponsForGiving.Data.Campaign oc in (from c in npo.Campaigns where c.ShowOnHome == false && c.StartDate < DateTime.Now && c.EndDate > DateTime.Now select c))
                Response.Write("<div class=\"Campaign\"><a href=\"../Default/CampaignPage.aspx?nponame=" + npo.URL + "&campaign=" + Server.UrlEncode(oc.Name) + "\">" + oc.Name + "</a></div>");
        %>
    </asp:Panel>
</asp:Content>