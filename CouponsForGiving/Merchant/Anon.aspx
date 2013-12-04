<%@ Page Title="For Merchants" Language="C#" MasterPageFile="~/Site.master" AutoEventWireup="true" CodeFile="Anon.aspx.cs" Inherits="Merchant_Anon" %>
<%@ Reference Control="~/Controls/MenuBar.ascx" %>

<asp:Content ID="Content1" ContentPlaceHolderID="HeadContent" Runat="Server">
</asp:Content>
<asp:Content ID="BannerStuff" ContentPlaceHolderID="BannerContent" runat="server">
    <div class="homeBanners">
        <h2>Retailers, Restaurants or Online Merchants:</h2>
        <h3><a href="../Account/Register.aspx">Increase footfall into your business or traffic to your website</a></h3>
        <img src="../images/c4g_merchant_home.png" class="right-merchant" />
    </div>
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="Main_Content" Runat="Server">
    <div class="tipList">
        <ul>
            <li class="merchantstep1"><h4>Step 1:</h4>Set up your Offer with Coupons4Giving</li>
            <li class="merchanthomestep2"><h4>Step 2:</h4> Choose your favourite charity or community group, or select from a pre-approved list</li>
            <li class="merchanthomestep3"><h4>Step 3:</h4> Redeem offers directly with the Coupons4Giving POS app or online through our e-commerce portal</li>
        </ul>
    </div>
    <blockquote>Be effective and target the right customers while supporting local charities and community groups.</blockquote>
    <p>Every time a customer purchases a coupon from your business, up to <strong>25% from each purchase goes to that fundraising organization</strong>. While you receive up to <strong>55% from each purchase</strong>.</p>
    <p>When you register with Coupons4Giving, we automatically set you up with <strong><a href="https://stripe.com/ca" target="_blank">Stripe</a>. <strong>Stripe is an easy and effective payment processor and will deposit directly into your bank account</strong>.</p>
    <hr>            
    <h3>Partnering with Not-For-Profits</h3>
    <p><img src="../images/c4g_npos.png" class="bio_head">​As a merchant we know that you can sometimes feel inundated with requests to support fundraising campaigns. Whether they are difficult to keep track of, or managing requests is time consuming, <strong>Coupons4Giving is your one-stop solution!</strong> We automate the process for you!  Through Coupons4Giving’s qualified network of Not-For-Profits you can connect with your favourite causes with offers that you control. </p>
    <p>When a Not-For-Profit registers with Coupons4Giving they have the ability to invite their preferred merchant partners to also register with Coupons4Giving. You may receive an invitation to connect, if you are already registered, great! If not, you will be directed to a sign up page. Once you are set up in the system you can make offers available according to your seasonal, product or service needs. You can decide how many offers you want to make available and for how long. When a Not-For-Profit selects a merchant to support their campaign, their campaign dates and location need to match available offers. If it’s a match, your offers are automatically included and you will receive your portion of the proceeds according to the Coupons4Giving Terms of Service Contract.</p>
    <p>You can review each request, or you can automatically accept requests that match your offer availability.</p>
    <h4>Make it easy on yourself and direct your favourite Not-For-Profits to Coupons4Giving.</h4>
    <div class="actionList">
        <ul>
            <li class="merchantstep1">Send them an email invitation <a href="MyPartners/Invite.aspx">click here</a></li>
            <li class="merchantstep2">Have them email us at <a href="mailto:info@coupons4giving.ca" target="_blank">info@coupons4giving.ca</a></li>
            <li class="merchantstep3">Or have them visit our website at <a href="https://www.coupons4giving.ca">www.coupons4giving.ca</a>
        </ul>
    </div>
    <a href='<%: (User.Identity.IsAuthenticated) ? "../redirect.aspx" : "../Account/Register.aspx" %>' class="btn-center">Get Started!</a>
    <hr>
    <h3>Take a Look Around</h3>
    <p>Browse our local deals as well as our <strong>Global Marketplace of E-tailers</strong> (online only merchants)</p>
    <h4 class="centered">OUR FEATURED DEALS</h4>
    <div class="merchantsList">
        <ul>
            <li><img src="../images/c4g_comingsoon_small.png" class="centered" /></li>
        </ul>
    </div>
    <a href="../Default/CausesInMyArea.aspx" class="btn">MORE MERCHANTS</a>
    <h4 class="centered">OUR FEATURED CAUSES</h4>
    <div class="nposList">
        <ul>
            <li><img src="../images/c4g_comingsoon_small.png" class="centered" /></li>
        </ul>
        <a href="../Default/CausesInMyArea.aspx" class="btn">MORE CAUSES</a>
    </div>
</asp:Content>