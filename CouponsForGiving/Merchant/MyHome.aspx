<%@ Page Title="Home" Language="C#" MasterPageFile="~/Site.master" AutoEventWireup="true" CodeFile="MyHome.aspx.cs" Inherits="Merchant_Home" %>
<%@ Reference Control="~/Controls/MenuBar.ascx" %>

<asp:Content ID="Content1" ContentPlaceHolderID="HeadContent" Runat="Server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="Main_Content" Runat="Server">
    <style type="text/css">
        #MainContent .HeaderButton {
            display: inline-block;
            margin: 2% 0 2% 0;
        }
    </style>
    <asp:Panel ID="AnonPanel" runat="server">
        <h1>Retailers, Restaurants or Online Merchants (E-tailers):</h1>
        <h1>Increase footfall into your business or traffic to your website</h1>
        <ul>
            <li>Step 1: Set up your Offer with Coupons4Giving</li>
            <li>Step 2: Choose your favorite charity or community group, or select from a pre-approved list</li>
            <li>Step 3: Redeem offers directly with the Coupons4Giving POS app or online through our e-commerce portal</li>
        </ul>
        <p>Be effective and target the right customers while supporting local charities and community groups.</p>
        <p>Every time a customer purchases a coupon from your business, up to 25% from each purchase goes to that fundraising organization. While you receive up to 55% from each purchase.</p>
        <p>When you register with Coupons4Giving, we automatically set you up with Stripe. Stripe is an easy and effective payment processor and will deposit directly into your bank account.</p>
        <h1>Partnering with Not-For-Profits</h1>
        <p>As a merchant we know that you can sometimes feel inundated with requests to support fundraising campaigns. Whether they are difficult to keep track of, or managing requests is time consuming, Coupons4Giving is your one-stop solution! We automate the process for you!  Through Coupons4Giving’s qualified network of Not-For-Profits you can connect with your favorite causes with offers that you control. </p>
        <p>When a Not-For-Profit registers with Coupons4Giving they have the ability to invite their preferred merchant partners to also register with Coupons4Giving. You may receive an invitation to connect, if you are already registered, great! If not, you will be directed to a sign up page. Once you are set up in the system you can make offers available according to your seasonal, product or service needs. You can decide how many offers you want to make available and for how long. When a Not-For-Profit selects a merchant to support their campaign, their campaign dates and location need to match available offers. If it’s a match, your offers are automatically included and you will receive your portion of the proceeds according to the Coupons4Giving Terms of Service Contract.</p>
        <p>You can review each request, or you can automatically accept requests that match your offer availability.</p>
        <p>Make it easy on yourself and direct your favorite Not-For-Profits to Coupons4Giving. </p>
        <p>Send them an email invitation click here</p>
        <p>Have them email us at info@coupons4giving.ca</p>
        <p>Or have them visit our website at www.coupons4giving.ca</p>
        <a href="~/Account/Signup.aspx" runat="server" class="HeaderButton">Get Started!</a>
    </asp:Panel>
    <asp:Panel ID="LoggedInPanel" runat="server"></asp:Panel>
</asp:Content>