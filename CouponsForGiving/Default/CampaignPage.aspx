<%@ Page Title="" Language="C#" MasterPageFile="~/Site.master" AutoEventWireup="true" CodeFile="CampaignPage.aspx.cs" Inherits="Default_NpoPage" %>
<%@ Reference Control="~/Controls/MenuBar.ascx" %>
<%@ Reference Control="~/Controls/ShareControl.ascx" %>

<asp:Content ID="Content1" ContentPlaceHolderID="HeadContent" Runat="Server">
    <style type="text/css">
        .TopContent {
            padding: 5px 0 0 0;
            width: 100%;
        }

        .TopContent img{
            width: 20%;
        }

        .TopContent h1 {
            display: block !important;
            padding: 0 0 20px 0 !important;
        }

        .FloatRight {
            float: right;
            padding: 0 0 0 2%;
            position: relative;
            width: 68%;
        }

        .FloatRight h1 {
            padding: 0 !important;
        }

        .FloatRight p {
            margin: 0 0 0 2% !important;
            width: auto !important;
        }

        #LeftContent {
            float: left;
            padding: 45px 0 0 0;
            width: 80%;
        }

        #Campaign {
            float: right;
            width: 20%;
        }

        #PG {
            bottom: 110px;
            left: 59px;
            position: absolute;
            width: 78px;
        }

        #FG {
            left: 60px;
            position: absolute;
            top: 40px;
        }

        #Thermo {
            padding: 0 0 0 30px;
            position: relative;
            width: 136px;
        }

        footer {
            clear: both;
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

        .FundingGoals {
            margin: 0 0 10px 70px !important;
        }

        #Campaign p {
            width: 200px;
        }

        .Campaign {
            margin: 50px 0 0 0;
        }

        .Campaign img {
            float: left;
            margin: 0 35px 0 0;
            width: 180px;
        }

        .Campaign h4 {
            display: block;
            text-align: center;
        }

        .Left, .Right {
            text-align: center;
            width: 50%;
        }

        .Left p, .Right p {
            width: auto !important;
        }

        .Left {
            float: left;
        }

        .Right {
            float: right;
        }

        #MidRow {
            min-height: 150px;
        }

        #topText {
            color: #333;
            font-style: italic;
            margin: 0 !important;
            opacity: 0.4;
            vertical-align: top;
            width: auto !important;
        }

        #MerchName {
            color: #18bee6;
            font-style: italic;
            font-weight: bolder !important;
            padding: 0 !important;
        }

        #Pricing {
            clear: both;
            min-height: 40px;
            width: 30%;
        }

        .priceUnit {
            float: left;
            width: 33%;
        }

        .priceUnit p {
            font-size: 140%;
            font-style: italic;
            margin: 0 !important;
            text-align: center;
            width: auto !important;
        }

        .tiny {
            color: #18bee6;
            font-size: 75% !important;
        }

        .BigLeft {
            float: left;
            position: relative;
            width: 80%;
        }

        #SocialText {
            padding: 35px 0 0 0;
            width: auto !important;
        }

        #CampaignImage {
            width: 150px;
        }

        #Deals {
        }

        #Deals img {
            width: 33%;
        }

        .Logo {
            width: 100% !important;
        }

        #Deals h3 {
            font-size: 15px;
        }

        td a {
            display: block;
            width: 64px;
        }

        .Offer {
            width: 25%;
        }

        #MainContent tr {
            border: 1px solid #BBB;
        }
    </style>
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="Main_Content" Runat="Server">
        <UC:ShareControl ID='ShareControl' runat='server' Share="Campaign" CType='Campaign' Campaign="<%# campaign.Name %>" 
            Name='<%# npo.Name %>' ImageURL='<%# "https://www.coupons4giving.ca/" + campaign.CampaignImage %>' 
            Description='<%# campaign.CampaignDescription %>' />
        <div class="TopContent">
            <h1><%: npo.Name %></h1>
            <img alt="Logo" src="../../<%: npo.Logo %>"/>
        </div>
        <div id="LeftContent">
            <img id="CampaignImage" alt="Logo" src="../../<%: campaign.CampaignImage %>"/>
            <div class="FloatRight">
                <h1><%: campaign.Name %></h1>
                <p><%: campaign.CampaignDescription %></p>
            </div>
            <div id="MidRow">
                <div class="Left">
                    <h3>About Our Campaign</h3>
                    <p><%: campaign.CampaignDescription %></p>
                </div>
                <div class="Right">
                    <h3>Running Until</h3>
                    <p style="text-align: center;"><%: ((DateTime)(campaign.EndDate)).ToString("dddd, MMM dd, yyyy") %></p>
                </div>
                <div class="ClearFix"></div>
            </div>
            <div id="Deals">
                <h1>Purchase A Deal Now to Help Us Reach Our Goal!</h1>
                <asp:GridView ID="DealsGV" runat="server" DataKeyNames="CampaignID,DealInstanceID" AutoGenerateColumns="False" OnSelectedIndexChanging="DealsGV_SelectedIndexChanging">
                    <Columns>
                        <asp:HyperLinkField DataNavigateUrlFields="MerchantName,DealName" DataNavigateUrlFormatString="DealPage.aspx?merchantname={0}&amp;deal={1}" Text="More Info" />
                        <asp:TemplateField HeaderText="Merchant Partner">
                            <ItemTemplate>
                                    <h3><%# Eval("MerchantName") %></h3>
                                    <img class="Logo" alt="" src='../<%# Eval("SmallLogo") %>' />
                            </ItemTemplate>
                        </asp:TemplateField>
                        <asp:BoundField DataField="DealName" HeaderText="Offer">
                            <ItemStyle CssClass="Offer"></ItemStyle>
                        </asp:BoundField>
                        <asp:ImageField DataImageUrlField="DealImage" DataImageUrlFormatString="../{0}"></asp:ImageField>
                        <asp:BoundField DataField="Savings" DataFormatString="{0:c}" HeaderText="Savings"></asp:BoundField>
                        <asp:BoundField DataField="Price" DataFormatString="{0:c}" HeaderText="Price"></asp:BoundField>
                        <asp:CommandField SelectText="Buy Now!" ShowSelectButton="True"></asp:CommandField>
                    </Columns>
                </asp:GridView>
                <asp:Label ID="ErrorLabel" runat="server"></asp:Label>
            </div>
        </div>
        <div id="Campaign" ClientIDMode="static" runat="server">
            <div id="Thermo">
                <img ClientIDMode="static" runat="server" id="BG" alt="ThermoBG" src="../Images/Thermo-BG.png" />
                <img ClientIDMode="static" runat="server" id="PG" alt="ThermoPG" src="../Images/Thermo-Red.png" />
                <img ClientIDMode="static" runat="server" id="FG" alt="ThermoFG" src="../Images/Thermo-FG.png" />
            </div>
            <p class="FundingGoals">$<%=(from po in campaign.PurchaseOrders select po.NPOSplit).Sum() %>/$<%=campaign.FundraisingGoal %></p>
        </div>
</asp:Content>