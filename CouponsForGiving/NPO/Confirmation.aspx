<%@ Page Title="Confirmation" Language="C#" MasterPageFile="~/Site.master" AutoEventWireup="true" CodeFile="Confirmation.aspx.cs" Inherits="NPO_Confirmation" %>
<%@ Reference Control="~/Controls/MenuBar.ascx" %>

<asp:Content ID="Content1" ContentPlaceHolderID="HeadContent" Runat="Server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="Main_Content" Runat="Server">
    <h1>Thank You for Signing up with Coupons4Giving!</h1>
    <p>Thanks for registering with Coupons4Giving. A team member will be in touch with shortly with some tips on how to get started! In the meantime if you have any questions, please contact us at <a href="mailto:support@couponsforgiving.ca">support@coupons4giving.ca.</a></p> 
    <p>Your unique Coupons4Giving profile page is <a href='www.coupons4giving.ca/Default/NPOPage.aspx?name=<%: npo.URL %>'>coupons4giving.ca/<%: npo.URL %></a></p>
    <p>Now you are ready for step 2: set up your My Merchant Partner list!</p>
    <a class="HeaderButton" href="Partners/Add.aspx">Get Started!</a>
</asp:Content>