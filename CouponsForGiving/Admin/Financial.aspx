<%@ Page Title="" Language="C#" MasterPageFile="~/Site.master" AutoEventWireup="true" CodeFile="Financial.aspx.cs" Inherits="Admin_Financial" %>

<asp:Content ID="MainContent" ContentPlaceHolderID="Main_Content" Runat="Server">
    <h1>Financial Report</h1>
    <asp:GridView ID="ReportView" runat="server" AutoGenerateColumns="False">
        <Columns>
            <asp:BoundField HeaderText="Coupon" />
            <asp:BoundField DataField="MerchantSplit" DataFormatString="{0:c}" HeaderText="Merchant Portion Collected" />
            <asp:BoundField DataField="NPOSplit" DataFormatString="{0:c}" HeaderText="NPO Portion Collected" />
            <asp:BoundField DataField="OurSplit" DataFormatString="{0:c}" HeaderText="GenerUS Portion Collected" />
            <asp:BoundField DataField="GST" DataFormatString="{0:c}" HeaderText="GST" />
            <asp:BoundField DataField="StripeFee" DataFormatString="{0:c}" HeaderText="Stripe Fee" />
            <asp:BoundField DataField="MerchantAccount" HeaderText="Merchant Paid Out" />
            <asp:BoundField DataField="MerchantPay" DataFormatString="{0:c}" HeaderText="Total Amount Paid Out to Merchant" />
            <asp:BoundField DataField="NPOAccount" HeaderText="NPO Paid Out" />
            <asp:BoundField DataField="ChargedBack" HeaderText="Charged Back" />
            <asp:BoundField DataField="Date" DataFormatString="{0:&quot;dd MMMM yyyy&quot;}" HeaderText="Date" />
        </Columns>
    </asp:GridView>
</asp:Content>