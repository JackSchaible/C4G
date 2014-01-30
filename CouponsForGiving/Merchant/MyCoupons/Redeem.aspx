<%@ Page Title="" Language="C#" MasterPageFile="~/Site.master" AutoEventWireup="true" CodeFile="Redeem.aspx.cs" Inherits="Merchant_My_Coupons_Redeem" %>
<%@ Reference Control="~/Controls/MenuBar.ascx" %>

<asp:Content ID="Content2" ContentPlaceHolderID="Main_Content" Runat="Server">
    <h1>Redeem A Coupon</h1>
    <div class="Form">
        <div class="FormRow">
            <label>Enter a Coupon Code <br /><small>This is a 32-digit code on the bottom of each coupon.</small></label>
            <asp:TextBox ID="CouponCodeTextBox" runat="server"></asp:TextBox>
            <asp:Button ID="RedeemButton" runat="server" Text="Redeem" OnClick="RedeemButton_Click" />
        </div>
    </div>
    <div class="FormRow">
        <asp:Label ID="ErrorLabel" runat="server"></asp:Label>
    </div>
    <div class="FormRow">
        <label>Or select from a list of your coupons:</label>
        <asp:GridView ID="CouponsGV" runat="server" AutoGenerateColumns="false" 
            AllowPaging="True" OnPageIndexChanging="CouponsGV_PageIndexChanging" 
            OnSelectedIndexChanging="CouponsGV_SelectedIndexChanging" DataKeyNames="CouponID">
            <Columns>
                <asp:CommandField SelectText="Redeem" ShowSelectButton="True"></asp:CommandField>
                <asp:BoundField DataField="CouponID" HeaderText="Coupon ID"></asp:BoundField>
                <asp:HyperLinkField DataNavigateUrlFields="MerchantName,DealName" 
                    DataNavigateUrlFormatString="../../Offers/{0}/{1}" DataTextField="DealName"
                    HeaderText="Deal"></asp:HyperLinkField>
                <asp:HyperLinkField DataNavigateUrlFields="NPOName,CampaignName" 
                    DataNavigateUrlFormatString="../../Causes/{0}/{1}" DataTextField="CampaignName" 
                    HeaderText="Campaign"></asp:HyperLinkField>
                <asp:BoundField DataField="Customer" HeaderText="Customer Username"></asp:BoundField>
                <asp:BoundField DataField="StartDate" HeaderText="Start Date"></asp:BoundField>
                <asp:BoundField DataField="EndDate" HeaderText="End Date"></asp:BoundField>
                <asp:BoundField DataField="CouponCode" HeaderText="Coupon Code"></asp:BoundField>
            </Columns>
            <EmptyDataTemplate>
                <p>You currently have no unredeemed coupons.</p>
            </EmptyDataTemplate>
        </asp:GridView>
    </div>
</asp:Content>