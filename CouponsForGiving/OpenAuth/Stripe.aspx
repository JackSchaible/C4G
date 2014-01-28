<%@ Page Title="Stripe Connect" Language="C#" MasterPageFile="~/Site.master" AutoEventWireup="true" CodeFile="Stripe.aspx.cs" Inherits="OpenAuth_Stripe" %>

<asp:Content ID="Content4" ContentPlaceHolderID="Main_Content" Runat="Server">
    <h1>Stripe Connect</h1>
    <asp:Panel ID="SuccessPanel" runat="server" Visible="false">
        <h2>Congratulations!</h2>
        <p>Your Stripe Account was successfully set up and connected. Please log in again here: <a runat="server" href="~/Account/Login.aspx">LOGIN</a>.</p>
    </asp:Panel>
    <asp:Label ID="ErrorLabel" runat="server"></asp:Label>

</asp:Content>
<asp:Content ID="Content5" ContentPlaceHolderID="PostContentContent" Runat="Server">
</asp:Content>

