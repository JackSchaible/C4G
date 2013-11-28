<%@ Page Title="Confirmation" Language="C#" MasterPageFile="~/Site.master" AutoEventWireup="true" CodeFile="Confirmation.aspx.cs" Inherits="NPO_Confirmation" %>
<%@ Reference Control="~/Controls/MenuBar.ascx" %>

<asp:Content ID="Content1" ContentPlaceHolderID="HeadContent" Runat="Server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="Main_Content" Runat="Server">
    <h1>Congratulations, You've Just Created Your Profile With Coupons4Giving!</h1>
    <div class="actionList">
        <ul>
            <li class="thumb">Your unique <strong>Coupons4Giving profile page</strong> is <strong><a href='https://www.coupons4giving.ca/Causes/<%: npo.Name %>'>coupons4giving.ca/Causes/<%: npo.Name %></a></strong></li>
        </ul>
    </div>
    <hr>
        <UC:ShareControl ID='ShareControl' runat='server' Share='Profile' CType='Campaign'
            Name='<%# npo.Name %>' ImageURL='<%# "https://www.coupons4giving.ca/" + npo.Logo %>' Description='<%# npo.NPODescription %>' />
    <hr>
    <p>If you have any questions, please contact us at <a href="mailto:support@coupons4giving.ca">support@coupons4giving.ca.</a></p>
    <p>Now you are ready for <strong>Step 2: set up your My Merchant Partner list!</strong></p>
    <a class="btn-center" href="Partners/Add.aspx">Get Started!</a>
</asp:Content>