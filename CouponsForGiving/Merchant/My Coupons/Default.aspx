<%@ Page Title="" Language="C#" MasterPageFile="~/Site.master" AutoEventWireup="true" CodeFile="Default.aspx.cs" Inherits="Merchant_My_Coupons_Coupons" %>
<%@ Reference Control="~/Controls/MenuBar.ascx" %>

<asp:Content ID="Content1" ContentPlaceHolderID="HeadContent" Runat="Server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="Main_Content" Runat="Server">
    <h1>My Coupons</h1>
    <div class="Form">
        <div class="FormRow">
            <label>Show</label>
            <asp:DropDownList ID="FilterDDL" runat="server" AutoPostBack="True">
                <asp:ListItem>All</asp:ListItem>
                <asp:ListItem>Unredeemed</asp:ListItem>
                <asp:ListItem>Redeemed</asp:ListItem>
            </asp:DropDownList>
        </div>
        <div class="FormRow">
            <asp:GridView ID="CouponsGV" runat="server" OnSelectedIndexChanging="CouponsGV_SelectedIndexChanging"
                OnPageIndexChanging="CouponsGV_PageIndexChanging" DataKeyNames="CouponCode">
                <Columns>
                    <asp:CommandField SelectText="Redeem/Unredeem" ShowSelectButton="True"></asp:CommandField>
                    <asp:BoundField DataField="CouponCode" HeaderText="Coupon Code"></asp:BoundField>
                    <asp:HyperLinkField DataNavigateUrlFields="MerchantName,DealName" 
                        DataNavigateUrlFormatString="../../Coupons/{0}/{1}" DataTextField="DealName"
                        HeaderText="Deal"></asp:HyperLinkField>
                    <asp:HyperLinkField DataNavigateUrlFields="NPOName,CampaignName" 
                        DataNavigateUrlFormatString="../../Causes/{0}/{1}" DataTextField="CampaignName" 
                        HeaderText="Campaign"></asp:HyperLinkField>
                    <asp:BoundField DataField="Customer" HeaderText="Customer Username"></asp:BoundField>
                    <asp:BoundField DataField="StartDate" HeaderText="Start Date"></asp:BoundField>
                    <asp:BoundField DataField="EndDate" HeaderText="End Date"></asp:BoundField>
                </Columns>
                <EmptyDataTemplate>
                    <p>You currently have no <%: EmptyMessage %>.</p>
                </EmptyDataTemplate>
            </asp:GridView>
        </div>
        <div class="FormRow">
            <asp:Label ID="ErrorLabel" runat="server"></asp:Label>
        </div>
    </div>
</asp:Content>