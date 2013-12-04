<%@ Page Title="My Shopping Cart" Language="C#" MasterPageFile="~/Site.master" AutoEventWireup="true" CodeFile="Cart.aspx.cs" Inherits="Default_My_Cart" %>
<%@ Reference Control="~/Controls/MenuBar.ascx" %>

<asp:Content ID="Content1" ContentPlaceHolderID="HeadContent" Runat="Server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="Main_Content" Runat="Server">
    <h1>My Shopping Cart</h1>
    <asp:gridview runat="server" ID="CartGV" AutoGenerateColumns="False" DataKeyNames="DealInstanceID,CampaignID" 
        OnRowDeleting="Cart_RowDeleting" OnSelectedIndexChanged="Cart_SelectedIndexChanged">
        <Columns>
            <asp:CommandField SelectText="View Deal" ShowSelectButton="True" ShowDeleteButton="True" >
            <ItemStyle CssClass="ButtonColumn" />
            </asp:CommandField>
            <asp:TemplateField HeaderText="Fundraiser" SortExpression="NPOName">
                <EditItemTemplate>
                    <asp:TextBox ID="TextBox1" runat="server" Text='<%# Bind("NPOName") %>'></asp:TextBox>
                </EditItemTemplate>
                <ItemTemplate>
                    <asp:Label ID="Label1" runat="server" Text='<%# Bind("NPOName") %>'></asp:Label>
                </ItemTemplate>
                <ItemStyle CssClass="NameColumn" />
            </asp:TemplateField>
            <asp:BoundField DataField="CampaignName" HeaderText="Campaign" SortExpression="CampaignName" />
            <asp:BoundField DataField="MerchantName" HeaderText="Merchant" SortExpression="Merchant_Name" />
            <asp:BoundField DataField="DealName" HeaderText="Deal" SortExpression="Deal_Name" />
            <asp:BoundField DataField="GiftValue" HeaderText="Gift Value" SortExpression="GiftValue" DataFormatString="{0:c}" />
        </Columns>
        <EmptyDataTemplate>
            <p>You have no items in your cart currently.</p>
        </EmptyDataTemplate>
    </asp:gridview>
    <div id="Totals">
        <p><strong>Subtotal:</strong> <asp:Label ID="SubtotalLabel" runat="server"></asp:Label></p>
        <p><strong>Total:</strong> <asp:Label ID="TotalLabel" runat="server"></asp:Label></p>
    </div>
    <div class="clear"></div>
    <div id="Buttons">
        <asp:Label ID="ErrorLabel" runat="server"></asp:Label>
        <asp:Button CssClass="btn-shoppingcart" ID="ClearButton" runat="server" Text="Clear" OnClick="ClearButton_Click" />
        <asp:Button CssClass="btn-shoppingcart" ID="CheckoutButton" runat="server" Text="Checkout" OnClick="CheckoutButton_Click" />
    </div>
</asp:Content>