<%@ Page Title="Beta" Language="C#" MasterPageFile="~/Site.master" AutoEventWireup="true" CodeFile="Default.aspx.cs" Inherits="_Default" %>

<asp:Content ID="Content1" ContentPlaceHolderID="HeadContent" Runat="Server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="Main_Content" Runat="Server">
    <h1>Coupons4Giving: Beta!</h1>
    <p><strong>Coupons4Giving is currently in beta</strong>. If you have an account, please login below, otherwise, you may send us a message (at the bottom) to receive updates and news on Coupons4Giving!</p>
    <div class="Form">
        <fieldset>
            <div class="FormRow">
                <asp:Label ID="Label1" runat="server" Text="Username" AssociatedControlID="UsernameTextBox"></asp:Label>
                <asp:TextBox ID="UsernameTextBox" runat="server"></asp:TextBox>
                <asp:RequiredFieldValidator ID="RequiredFieldValidator1" runat="server" 
                    ErrorMessage="Username is required." ControlToValidate="UsernameTextBox" ValidationGroup="LoginValidate">
                </asp:RequiredFieldValidator>
                <div class="ClearFix"></div>
            </div>
            <div class="FormRow">
                <asp:Label ID="Label2" runat="server" Text="Password" AssociatedControlID="PasswordTextBox"></asp:Label>
                <asp:TextBox ID="PasswordTextBox" runat="server" TextMode="Password"></asp:TextBox>
                <asp:RequiredFieldValidator ID="RequiredFieldValidator2" runat="server" 
                    ErrorMessage="Password is required." ControlToValidate="PasswordTextBox" ValidationGroup="LoginValidate"></asp:RequiredFieldValidator>
                <div class="ClearFix"></div>
            </div>
            <div class="FormRow">
                <asp:Label ID="LoginErrorLabel" runat="server" AssociatedControlID="SubmitButton"></asp:Label>
                <asp:Button ID="SubmitButton" runat="server" Text="Login" OnClick="SubmitButton_Click" ValidationGroup="LoginValidate" />
                <div class="ClearFix"></div>
            </div>
        </fieldset>
    </div>
    <h2>Sign-up For The Latest Information</h2>
    <div class="Form">
        <fieldset>
            <div class="FormRow">
                <asp:Label ID="Label3" runat="server" Text="Name" AssociatedControlID="NameTextBox"></asp:Label>
                <asp:TextBox ID="NameTextBox" runat="server"></asp:TextBox>
                <asp:RequiredFieldValidator ID="RequiredFieldValidator3" runat="server" 
                    ErrorMessage="Name is required." ControlToValidate="NameTextBox">
                </asp:RequiredFieldValidator>
                <div class="ClearFix"></div>
            </div>
            <div class="FormRow">
                <asp:Label ID="Label4" runat="server" Text="Email Address" AssociatedControlID="EmailTextBox"></asp:Label>
                <asp:TextBox ID="EmailTextBox" runat="server" TextMode="Email"></asp:TextBox>
                <asp:RequiredFieldValidator ID="RequiredFieldValidator4" runat="server"
                    ErrorMessage="Email address is required." ControlToValidate="EmailTextBox">
                </asp:RequiredFieldValidator>
                <asp:RegularExpressionValidator ID="RegularExpressionValidator1" runat="server"
                    ErrorMessage="Email must be valid (i.e., name@domain.com)." ControlToValidate="EmailTextBox" ValidationExpression="\w+([-+.']\w+)*@\w+([-.]\w+)*\.\w+([-.]\w+)*"></asp:RegularExpressionValidator>
                <div class="ClearFix"></div>
            </div>
            <div class="FormRow">
                <asp:Label ID="EmailErrorLabel" runat="server" AssociatedControlID="EmailButton"></asp:Label>
                <asp:Button ID="EmailButton" runat="server" OnClick="EmailButton_Click" Text="Sign Up"/>
                <div class="ClearFix"></div>
            </div>
        </fieldset>
    </div>
</asp:Content>