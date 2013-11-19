<%@ Page Title="" Language="C#" MasterPageFile="~/Site.master" AutoEventWireup="true" CodeFile="SetUpYourOffers.aspx.cs" Inherits="SetUpYourOffers" %>
<%@ Reference Control="~/Controls/MenuBar.ascx" %>

<asp:Content ID="Content1" ContentPlaceHolderID="HeadContent" Runat="Server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="Main_Content" Runat="Server">
    <style type="text/css">
        #MainImage {
            background-color: #e3f0f8;
            border-top: 4px solid #464646;
            border-bottom: 4px solid #464646;
        }

        #MainImage img{
            display: block;
            margin: 0 auto;
        }

        #MainContent img {
            position: relative;
            top: 2px;
            width: 25px;
        }

        p {
            font-weight: normal !important;
            margin: 20px 0 20px 0 !important;
        }

        h4 {
            margin: 75px 0 0 0;
        }
    </style>
    <div id="MainImage">
        <img alt="Banner" src="Images/banner.jpg" />
    </div>
    <h1>Set Up Your Offers with Coupons4Giving</h1>
    <h2>Coupons4Giving: Make Fundraising Easy with Coupons for Giving</h2>
    <h3>What is Coupons4Giving?</h3>
    <p>Coupons4Giving is a fundraising tool that allows you to support your favorite charities and not-for-profits in just one click! Choose your charity and support them with an Offer.  Supporters will purchase coupons from the Coupons4Giving website, and a portion of those proceeds will go directly to your preferred organization. Help make fundraising campaigns easy and see more traffic in your place of business. Each charity or not-for-profit group sets up a campaign with Coupons4Giving and promotes their goals and accomplishments using our social media toolkit. A win-win for all!</p>
    <p>Whether you are raising money, looking for a great restaurant or you are a merchant who wants to support local community groups, Coupons4Giving makes it easy!</p>
    <h3>How does it work?</h3>
    <h4>Local Businesses:</h4>
    <p>Have a favorite charity or community group you want to support? Take daily deals to a whole new level with GenerUS!</p>
    <p>Be effective and target the right customers while supporting local charities and community groups.</p>
    <p>Step 1: Set up your Offer with GenerUS</p>
    <p>Step 2: Choose your favorite charity or community group, or select from a pre-approved list</p>
    <p>Step 3: Redeem offers directly with the GenerUS POS app</p>
</asp:Content>