<%@ Page Title="My Shopping Cart" Language="C#" MasterPageFile="~/Site.master" AutoEventWireup="true" CodeFile="Cart.aspx.cs" Inherits="Default_My_Cart" %>
<%@ Reference Control="~/Controls/MenuBar.ascx" %>

<asp:Content ID="Content1" ContentPlaceHolderID="HeadContent" Runat="Server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="Main_Content" Runat="Server">
    <style type="text/css">
        .ButtonColumn {
            width: 139px;
        }

        #Totals {
            float: right;
            margin: 0 188px 0 0;
        }

        #Totals p {
            width: auto !important;
        }

        #Buttons {
            float: right;
            padding: 85px 45px;
        }

        #Buttons input {
            font-family: Corbel, Arial, sans-serif;
            text-decoration: none;
            border-radius: 5px;
            background-color: #22bfe8;
            color: #FFF;
            padding: 2px 7px 2px 7px;
            border: 1px solid #BBB;
        }

        #Buttons input:hover {
            background-color: #FFF;
            color: #22bfe8;
        }
    </style>
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
            <p>Subtotal: </p><asp:Label ID="SubtotalLabel" runat="server"></asp:Label>
            <p>Total: </p><asp:Label ID="TotalLabel" runat="server"></asp:Label>
        </div>
        <div id="Buttons">
            <asp:Label ID="ErrorLabel" runat="server"></asp:Label>
            <asp:Button ID="ClearButton" runat="server" Text="Clear" OnClick="ClearButton_Click" />
            <asp:Button ID="CheckoutButton" runat="server" Text="Checkout" OnClick="CheckoutButton_Click" />
        </div>
</asp:Content>