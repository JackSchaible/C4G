<%@ Page Title="Confirmation" Language="C#" MasterPageFile="~/Site.master" AutoEventWireup="true" CodeFile="Confirmation.aspx.cs" Inherits="NPO_Confirmation" %>
<%@ Reference Control="~/Controls/MenuBar.ascx" %>

<asp:Content ID="Content1" ContentPlaceHolderID="HeadContent" Runat="Server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="Main_Content" Runat="Server">
    <h1>Congratulations, You've Just Created Your Profile With Coupons4Giving!</h1>
    <p>Your unique Coupons4Giving profile page is <a href='www.coupons4giving.ca/Default/NPOPage.aspx?name=<%: npo.URL %>'>coupons4giving.ca/<%: npo.URL %></a></p>
    <div class="SocialStuff">
        <p>Share this on your social media account!</p>
            <UC:ShareControl ID='ShareControl' runat='server' Share='Profile' CType='Campaign'
                Name='<%# npo.Name %>' ImageURL='<%# "https://www.coupons4giving.ca/" + npo.Logo %>' Description='<%# npo.NPODescription %>' />

    </div>
    <p>If you have any questions, please contact us at <a href="mailto:teamc4g@coupons4giving.ca">teamc4g@coupons4giving.ca.</a></p>
    <p>Now you are ready for step 2: set up your My Merchant Partner list!</p>
    <a class="HeaderButton" href="Partners/Add.aspx">Get Started!</a>
</asp:Content>