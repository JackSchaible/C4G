<%@ Page Title="Newsletter" Language="C#" MasterPageFile="~/Site.master" AutoEventWireup="true" CodeFile="Newsletter.aspx.cs" Inherits="Newsletter" %>
<%@ Reference Control="~/Controls/MenuBar.ascx" %>

<asp:Content ID="Content1" ContentPlaceHolderID="HeadContent" Runat="Server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="Main_Content" Runat="Server">
        <h1>Sign Up for Our Newsletter</h1>
        <div class="Form">
            <div class="FormRow">
                <asp:Label ID="Label1" runat="server" Text="Email"></asp:Label>
                <asp:TextBox ID="EmailTextbox" runat="server" TextMode="Email"></asp:TextBox>
            </div>
            <div class="FormRow">
                <asp:Label ID="ErrorLabel" runat="server"></asp:Label>
                <asp:Button ID="SubmitButton" runat="server" Text="Get Our Newsletter" OnClick="SubmitButton_Click" />
            </div>
        </div>
</asp:Content>