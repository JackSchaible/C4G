<%@ Page Title="" Language="C#" MasterPageFile="~/Site.master" AutoEventWireup="true" CodeFile="Anon.aspx.cs" Inherits="Default_Anon" %>
<%@ Reference Control="~/Controls/MenuBar.ascx" %>
<%@ MasterType VirtualPath="~/Site.master" %>

<asp:Content ID="Content1" ContentPlaceHolderID="HeadContent" Runat="Server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="BannerContent" Runat="Server">
    <div class="homeBanners">
        <h2>Whether you search by deals or Not-For-Profits you can support great causes in just one click.</h2>
            <h3>Take a Look Around<br /><small>Browse our local deals as well as our Global Marketplace of Online Merchants </small></h3>
        <img src="../Images/c4g_heartinhand_home.png" class="right-heartinhand" /> 
    </div>
</asp:Content>
<asp:Content ID="Content3" ContentPlaceHolderID="Main_Content" Runat="Server">
    <h3>Support Your Favorite Not-For-Profit</h3>
    <ul class="tipList">
        <li class="homestep1">
            <h4>STEP 1:</h4>
            <p><strong>Choose</strong> your favourite organization.</p>
        </li>
        <li class="homestep2">
            <h4>STEP 2</h4>
            <p><strong>Select</strong> the restaurant or business that is fundraising for your group.</p>
        </li>
        <li class="homestep3">
            <h4>STEP 3</h4>
            <p><strong>Purchase</strong> the deal – a coupon or discount.</p>
        </li>
        <li class="homestep4">
            <h4>STEP 4</h4>
            <p><strong>Redeem</strong> the offer in-store on your next visit or directly online from our Global Marketplace.</p>
        </li>
    </ul>
    <hr>
    <h4 class="centered">OUR FEATURED DEALS</h4>
    <div class="merchantsList">
                <ul>
                    <li><a href="https://www.coupons4giving.ca/Default/MerchantPage.aspx?MerchantName=Basha%20Boutique-%20%20Blankets%20of%20Bangladesh"><img src="../images/c4g_basha.png" alt="Basha Boutique-  Blankets of Bangladesh"/></a></li>
                    <li><a href="https://www.coupons4giving.ca/Default/MerchantPage.aspx?MerchantName=Seahawk%20Holdings%20Ltd"><img src="../images/c4g_vaangels.png" alt="Seahwak Holdings Ltd."/></a></li>
                </ul>
    </div>
    <a href="DealsInMyArea.aspx" class="btn-blue"><i class="fa fa-search"></i> MORE MERCHANTS</a>
    <h4 class="centered">OUR FEATURED CAUSES</h4>
    <div class="nposList">
                <ul>
                    <li><a href="https://www.coupons4giving.ca/Default/NPOPage.aspx?name=Charity%20App%20Challenge"><img src="../images/c4g_cac.png" alt="Chartity App Challenge"/></a></li>
                    <li><a href="https://www.coupons4giving.ca/Default/NPOPage.aspx?name=Media%20and%20Visual%20Arts%20Housing%20Association"><img src="../images/c4g_mava.png" alt="Media & Visual Arts Housing Association"/></a></li>
                    <li><a href="https://www.coupons4giving.ca/Default/NPOPage.aspx?name=St.%20Albert%20Youth%20Musical%20Association"><img src="../images/c4g_sayma.png" alt="St. Albert Youth Musical Association"/></a></li>
                    <li><a href="https://www.coupons4giving.ca/Default/NPOPage.aspx?name=Student%20Energy"><img src="../images/c4g_studentenergy.png" alt="Student Energy"/></a></li>
                    <li><a href="https://www.coupons4giving.ca/Default/NPOPage.aspx?name=Need2"><img src="../images/c4g_need2.png" alt="Need2"/></a></li>
                    <li><a href="https://www.coupons4giving.ca/Default/NPOPage.aspx?name=AcceleratorYYC"><img src="../images/c4g_accelerator.png" alt="Accelerator YYC"/></a></li>
                </ul>
        <a href="CausesInMyArea.aspx" class="btn-blue"><i class="fa fa-search"></i> MORE CAUSES</a>
    </div>
    <hr>
    
    <blockquote>Whether you are raising money, looking for a great restaurant or you are a merchant who wants to support local community groups, <strong>Coupons4Giving makes it easy!</strong></blockquote>
    <div class="clear"></div>
    <a href="../Account/Register.aspx" class="btn-center"><i class="fa fa-arrow-circle-o-right"></i> GET STARTED TODAY!</a>

</asp:Content>