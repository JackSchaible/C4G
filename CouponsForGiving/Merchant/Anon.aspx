<%@ Page Title="For Merchants" Language="C#" MasterPageFile="~/Site.master" AutoEventWireup="true" CodeFile="Anon.aspx.cs" Inherits="Merchant_Anon" %>
<%@ Reference Control="~/Controls/MenuBar.ascx" %>

<asp:Content ID="Content1" ContentPlaceHolderID="HeadContent" Runat="Server">
</asp:Content>
<asp:Content ID="BannerStuff" ContentPlaceHolderID="BannerContent" runat="server">
    <div class="homeBanners">
        <h2>Retailers, Restaurants or Online Merchants:</h2>
        <h3><i class="fa fa-arrow-circle-o-right"></i> <a href="../Account/Register.aspx" title="Register Today">Increase footfall into your business or traffic to your website!</a></h3>
        <img src="../images/c4g_merchant_home.png" class="right-merchant" />
    </div>
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="Main_Content" Runat="Server">
    <div class="tipList">
        <ul>
            <li class="merchantstep1"><h4>Step 1:</h4><p>Set up your Offer with Coupons4Giving</p></li>
            <li class="merchanthomestep2"><h4>Step 2:</h4><p>Choose your favourite charity or community group, or select from a pre-approved list</p></li>
            <li class="merchanthomestep3"><h4>Step 3:</h4><p>Redeem offers easily with our in-store support.</p></li>
            <li class="merchanthomestep4"><h4>Step 4:</h4><p>Support great causes while bringing in new customers!</p></li>
        </ul>
    </div>
    <blockquote>Be effective and target the right customers while supporting local charities and community groups.</blockquote>
    <p>Every time a customer purchases a coupon from your business, up to <strong>25% from each purchase goes to that fundraising organization</strong>. While you receive up to <strong>55% from each purchase</strong>.</p>
    <p>When you register with Coupons4Giving, we automatically set you up with <strong><a href="https://stripe.com/ca" target="_blank">Stripe</a>. <strong>Stripe is an easy and effective payment processor and will deposit directly into your bank account</strong>.</p>
    <hr>            
    <h3>Partnering with Not-For-Profits</h3>
    <p><img src="../images/c4g_npos.png" class="bio_head">As a merchant we know that you can sometimes feel inundated with requests to support fundraising campaigns. Whether they are difficult to keep track of, or managing requests is time consuming, Coupons4Giving is your one-stop solution! <strong>We automate the process for you!</strong> Through Coupons4Giving’s qualified network of Not-For-Profits you can connect with your favourite causes with offers that you control.</p>
    <p>When a Not-For-Profit registers with Coupons4Giving they have the ability to invite their preferred merchant partners to also register with Coupons4Giving. You may receive an invitation to connect, if you are already registered, great! If not, you will be directed to a sign up page. Once you are set up in the system you can make offers available
according to your seasonal, product or service needs. You can decide how many offers you want to make available and for how long. When a Not-For-Profit selects a merchant to support their campaign, their campaign dates and location need to match available offers. If it’s a match, your offers are automatically included and you will receive your portion of the proceeds according to the Coupons4Giving <a href="https://www.coupons4giving.ca/Content/Terms/MerchantServicesAgreement.pdf" target="_blank">Merchant Service Agreement</a>.</p>
    <p>You can review each request, or you can automatically accept requests that match your offer availability.</p>
    
    <p>Coupons4Giving empowers not-for-profits to market their causes through our <a href="https://www.coupons4giving.ca/NPO/SocialMediaToolkit.aspx" target="_blank">Social Media Toolkit</a>. You can even share your offer and the cause you are supporting through Facebook and Twitter.</p>
    <hr>
    <h4>Make it easy on yourself and direct your favourite Not-For-Profits to Coupons4Giving.</h4>
    <div class="actionList">
        <ul>
            <li class="merchantstep1">Send them an email invitation <a href="MyPartners/Invite.aspx">click here</a></li>
            <li class="merchantstep2">Have them email us at <a href="mailto:info@coupons4giving.ca" target="_blank">info@coupons4giving.ca</a></li>
            <li class="merchantstep3">Or have them visit our website at <a href="https://www.coupons4giving.ca">www.coupons4giving.ca</a>
        </ul>
    </div>
    <a href='<%: (User.Identity.IsAuthenticated) ? "../redirect.aspx" : "../Account/Register.aspx" %>' class="btn-center"><i class="fa fa-arrow-circle-o-right"></i> Get Started!</a>
</asp:Content>