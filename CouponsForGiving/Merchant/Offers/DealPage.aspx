<%@ Page Title="" Language="C#" MasterPageFile="~/Site.master" AutoEventWireup="true" CodeFile="DealPage.aspx.cs" Inherits="Merchant_Offers_DealPage" %>

<asp:Content ID="Content1" ContentPlaceHolderID="HeadContent" Runat="Server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="Main_Content" Runat="Server">
    <h1><%: merchant.Name %> <%: deal.Name %></h1>
    <p>Congratulations! You've just set up your offer. Now you can share your offer with your network.</p>
    <div id="SocialStuff">
        <p>Bitly</p>
        <p>FB, Twitter, LinkedIn</p>
    </div>
    <h2><%: merchant.Name %></h2>
    <img alt="Logo" src='../../<%: merchant.SmallLogo %>' />
    <h1><%: deal.Name %></h1>
    <p><%: deal.DealDescription %></p>
    <img alt='Deal Image' src='../../<%: deal.ImageURL %>' />
    <p>Gift Value: <%: String.Format("{0:c}", deal.Prices.FirstOrDefault<CouponsForGiving.Data.Price>().GiftValue) %></p>
    <p>Retail Value: <%: String.Format("{0:c}", deal.Prices.FirstOrDefault<CouponsForGiving.Data.Price>().RetailValue) %></p>
    <p>Your Savings: <%: String.Format("{0:c}", (deal.Prices.FirstOrDefault<CouponsForGiving.Data.Price>().RetailValue - deal.Prices.FirstOrDefault<CouponsForGiving.Data.Price>().GiftValue)) %></p>
    <h3>The Fine Print</h3>
    <h4>Additional Details</h4>
    <p><%: deal.RedeemDetails.FirstOrDefault<CouponsForGiving.Data.RedeemDetail>().AdditionalDetails %></p>
    <h4>Restrictions</h4>
    <p><%: deal.RedeemDetails.FirstOrDefault<CouponsForGiving.Data.RedeemDetail>().Restrictions %></p>
    <h4>Highlights</h4>
    <p><%: deal.RedeemDetails.FirstOrDefault<CouponsForGiving.Data.RedeemDetail>().Highlights %></p>
    <h4>Other</h4>
    <p><%: deal.RedeemDetails.FirstOrDefault<CouponsForGiving.Data.RedeemDetail>().RedeemDetailsDescription %></p>
</asp:Content>