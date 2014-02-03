<%@ Page Title="Financial Report" Language="C#" MasterPageFile="~/Site.master" AutoEventWireup="true" CodeFile="Financial.aspx.cs" Inherits="Admin_Financial" %>

<asp:Content ID="MainContent" ContentPlaceHolderID="Main_Content" Runat="Server">
    <h1>Financial Report</h1>
    <h2>Filtering Options</h2>
    <asp:GridView ID="ReportView" runat="server" AutoGenerateColumns="False" AllowPaging="True" OnPageIndexChanging="ReportView_PageIndexChanging"
        AllowSorting="true" OnSorting="ReportView_Sorting">
        <Columns>
            <asp:BoundField HeaderText="Coupon" DataField="Coupon" SortExpression="Coupon"/>
            <asp:BoundField DataField="MerchantAccount" HeaderText="Merchant Paid Out" SortExpression="MerchantAccount" />
            <asp:BoundField DataField="MerchantPay" DataFormatString="{0:c}" HeaderText="Total Amount Paid Out to Merchant" SortExpression="MerchantPay" />
            <asp:BoundField DataField="MerchantSplit" DataFormatString="{0:c}" HeaderText="Merchant Portion Collected" SortExpression="MerchantSplit" />
            <asp:BoundField DataField="NPOSplit" DataFormatString="{0:c}" HeaderText="NPO Portion Collected" SortExpression="NPOSplit" />
            <asp:BoundField DataField="OurSplit" DataFormatString="{0:c}" HeaderText="GenerUS Portion Collected" SortExpression="OurSplit" />
            <asp:BoundField DataField="GST" DataFormatString="{0:c}" HeaderText="GST" SortExpression="GST" />
            <asp:BoundField DataField="StripeFee" DataFormatString="{0:c}" HeaderText="Stripe Fee" SortExpression="StripeFee" />
            <asp:BoundField DataField="NPOAccount" HeaderText="NPO Paid Out" SortExpression="NPOAccount" />
            <asp:TemplateField HeaderText="Refunded" SortExpression="Refunded">
                <EditItemTemplate>
                    <asp:TextBox ID="TextBox1" runat="server" Text='<%# Bind("Refunded") %>'></asp:TextBox>
                </EditItemTemplate>
                <ItemTemplate>
                    <asp:Label ID="Label1" runat="server" Text='<%# Boolean.Parse(Eval("Refunded").ToString()) ? "Yes" : "No" %>'></asp:Label>
                </ItemTemplate>
            </asp:TemplateField>
            <asp:BoundField DataField="Date" DataFormatString="{0:dd MMMM yyyy}" HeaderText="Date" SortExpression="Date"/>
        </Columns>
</asp:GridView>
</asp:Content>