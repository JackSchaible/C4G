<%@ Page Title="FAQ" Language="C#" MasterPageFile="~/Site.master" AutoEventWireup="true" CodeFile="FAQ.aspx.cs" Inherits="FAQ" %>
<%@ Reference Control="~/Controls/MenuBar.ascx" %>

<asp:Content ID="Content1" ContentPlaceHolderID="HeadContent" Runat="Server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="Main_Content" Runat="Server">
    <h1>Frequently Asked Questions (“FAQ”)</h1>
    <ol>
        <li>
            <strong>Is it free to sign up?</strong>
            <p>Yes, Coupons4Giving is a free service for Not-For-Profits, Merchants and Customers. There is no fee to sign up and use the system.</p>
        </li>
        <li>
            <strong>How do I get started?</strong>
            <ul>
                <li>As an NPO - you can sign up to use Coupons4Giving by going to the registration page and filling out: the user registration form, followed by the Set up a Profile and then Create a Campaign.</li>
                <li>As a Merchant or E-tailer - you can sign up to use Coupons4Giving by going to the registration page and filling out: the user registration form, followed by the Set up a Profile and then Create an Offer.</li>
                <li>As a Customer - you can sign up to purchase coupons by going to the registration page and filling out the registration form. All you need is your email address.</li>
            </ul>
        </li>
        <li>
            <strong>Do I need to be a registered charity to qualify as an NPO?</strong>
            <p>No, you do not need to be a registered charity to use Coupons4Giving. But you do need to have an organization or credible cause you want to raise funds for. The Coupons4Giving team will review all Not-For-Profit registrations and you do need to agree to the Terms of Service which is located on the Set up a Profile page.</p>
        </li>
        <li>
            <strong>What is the Global Marketplace of E-tailers?</strong>
            <p>Coupons4Giving will help you expand your merchant partnership opportunities by sourcing qualified merchants from various countries who have products or services they wish to sell through the Coupons4Giving network. These merchants run online “only businesses” and many are small businesses from communities in developing countries where “Fair Trade” practices are helping to create sustainable economies and financial independence. Think of this as “Cause for Cause” marketing. Goods and services are sold directly from the company’s website so shipping costs may be extra.</p>
        </li>
        <li>
            <strong>How do I build My Merchant Partner List?</strong>
            <p>Coupons4Giving allows you to develop better relationships with merchants that have supported your causes in the past, as well as seek out new relationships with merchants who are interested partnering with you to support your current causes. After you have created a profile with Coupons4Giving you can then set up your Merchant Partner list. You can build your list in three ways:</p>
            <ol>
                <li>Build a Preferred Merchant Partner list by Inviting your current merchant partners to join Coupons4Giving. By filling out a form with their contact name, company name and email address and email is automatically sent to them inviting them to support you by registering with Coupons4Giving.</li>
                <li>Build a Local Merchant Partner list by selecting from a list of merchants who are already registered with Coupons4Giving to support your causes. You can view their information and the deals they have made available. You can select the merchants you want to be on your list for future campaigns. Some merchants may require a Request to Partner notification which will be automatically sent to them upon selection.</li>
                <li>Build a Global Marketplace of E-tailers Partner list by selecting from a list of “online only” or E-tailers, with whom you would like to partner. You can view their information and the deals they have made available. Some merchants may require a Request to Partner notification which will be automatically sent to them upon selection.</li>
            </ol>
            <p>If an email request is sent to a Merchant Partner, you will receive both a notification that email has been sent for your records, as well as a notification once that company has accepted that request. Once your request has been accepted, that merchant will be automatically updated in your Merchant Partner List.</p>
        </li>
        <li>
            <strong>How do I match offers with my campaigns?</strong>
            <p>When you create a campaign you will be able to select the dates for how long your campaign will run until. When you go to add an Offer, only offers that match the end date of your campaign will be available to you. The dates of your campaign must match the dates of the availability of their offer in order for a coupon to then be included in your campaign. The Offer and Coupon will show up on your Campaign Page.</p>
        </li>
        <li>
            <strong>Can I run more than one campaign at a time?</strong>
            <p>Coupons4Giving makes it easy to fundraise for your causes. You can run as many campaigns as you wish and you can include as many merchant offers in each campaign as you want to help you reach your goals.</p>
        </li>
        <li>
             <strong>Is there a maximum or minimum amount of time I can run a campaign or offer for?</strong>
            <p>No, you set the time parameters for your campaigns or your offers. In order for campaigns to match with deals, the end date of the Campaign must be greater than the end date of the Offer.</p>
            <p><strong>For Not-For-Profits:</strong> You can edit your campaign dates at any time.</p>
            <p><strong>For Merchants:</strong> You cannot change the dates of an offer that has already been accepted by an Not-For-Profit and is part of their campaign. Please refer to the <a href="Content/Terms/MerchantServicesAgreement.pdf">Merchant Services Agreement</a> for additional information.</p>
        </li>
        <li>
            <strong>How do I build a Not-For-Profit Partner list?</strong>
            <p>Coupons4Giving appreciates that as a merchant, you are inundated with requests to sponsor or support campaigns with give-aways, special offers, freebies and donations. Coupons4Giving makes it easy and effective for you to support your favorite causes whenever and however you wish. When you register with Coupons4Giving you can create offers and make them available to all qualified not-for-profits or you can request a notification from a not-for-profit who wants to partner with you. You can also invite your preferred not-for-profits to register with Coupons4Giving by email invite or asking them to contact us directly. An automatic email invitation is included.</p>
        </li>
        <li>
            <strong>How do I make money from Coupons4Giving?</strong>
            <p>Coupons4Giving works on a revenue share. Not-For-Profits make up to 25% and Merchants make up to 55%. Merchant payments are processed through Stripe and monies are paid out according to Stripe’s payment terms. Not-For-Profits are paid directly from Coupons4Giving.</p>
        </li>
        <li>
            <strong>Do I need a PayPal or repository account to transfer my funds to?</strong>
            <p>As a Merchant you will require a Stripe account (which can be set up when you register your Merchant account). Not-for-Profits are paid according to the NPO Service Agreement.</p>
        </li>
        <li>
            <strong>How long before I receive payment?</strong>
            <p>Stripe takes a week (7 days, including non-business days) to deposit funds, this applies to Merchants. NPO’s are paid on a net 30 day term.</p>
        </li>
        <li>
            <strong>How long are offers I purchase valid for?</strong>
            <p>Offers are valid according to the terms and conditions set out by the Merchant and in accordance with Provincial, Federal or State laws.</p>
        </li>
        <li>
            <strong>Is shipping included when I purchase from e-tailers? How long will it take for me to receive my order?</strong>
            <p>Unless otherwise stated by the Merchant, shipping is not included. Delivery times, if not indicated by the Merchant are subject to shipping method terms.</p>
        </li>
    </ol>
</asp:Content>