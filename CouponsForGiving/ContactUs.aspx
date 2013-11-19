<%@ Page Title="Contact Us" Language="C#" MasterPageFile="~/Site.master" AutoEventWireup="true" CodeFile="ContactUs.aspx.cs" Inherits="ContactUs" %>
<%@ Reference Control="~/Controls/MenuBar.ascx" %>

<asp:Content ID="Content1" ContentPlaceHolderID="HeadContent" Runat="Server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="Main_Content" Runat="Server">
    <h1>Contact Us</h1>
    <img src="images/c4g_npos.png" class="circle_image_right" /> 
    <img src="images/c4g_heartinhand.png" class="circle_image_right" /> 
    <img src="images/c4g_merchantpartners.png" class="circle_image_right"/>
    <div class="Form">
        <div class="FormRow">
            <asp:Label ID="Label1" runat="server" Text="Name" AssociatedControlID="NameTextBox"></asp:Label>
            <asp:TextBox ID="NameTextBox" runat="server"></asp:TextBox>
            <asp:RequiredFieldValidator ID="RequiredFieldValidator1" runat="server" ForeColor="Red" 
                ErrorMessage="Name is required." ControlToValidate="NameTextBox" Text="*">
            </asp:RequiredFieldValidator>
        </div>
        <div class="FormRow">
            <asp:Label ID="Label2" runat="server" Text="Organization" AssociatedControlID="EmailTextBox"></asp:Label>
            <asp:TextBox ID="OrganizationTextBox" runat="server"></asp:TextBox>
        </div>
        <div class="FormRow">
            <asp:Label ID="Label3" runat="server" Text="Email" AssociatedControlID="EmailTextBox"></asp:Label>
            <asp:TextBox ID="EmailTextBox" runat="server"></asp:TextBox>
            <asp:RequiredFieldValidator ID="RequiredFieldValidator3" runat="server" ForeColor="Red"
                ErrorMessage="Email is required." ControlToValidate="EmailTextBox" Text="*">
            </asp:RequiredFieldValidator>
            <asp:RegularExpressionValidator ID="RegularExpressionValidator1" runat="server" ForeColor="Red"
                ErrorMessage="Email must be valid." ControlToValidate="EmailTextBox" Text="*" 
                ValidationExpression="\w+([-+.']\w+)*@\w+([-.]\w+)*\.\w+([-.]\w+)*">
            </asp:RegularExpressionValidator>
        </div>
        <div class="FormRow">
            <asp:Label ID="Label5" runat="server" Text="Looking to Fundraise?" AssociatedControlID="Fundraise"></asp:Label>
            <asp:RadioButtonList ID="Fundraise" runat="server">
                <asp:ListItem>Yes</asp:ListItem>
                <asp:ListItem Selected="True">No</asp:ListItem>
            </asp:RadioButtonList>
        </div>
        <div class="FormRow TextAreaRow">
            <asp:Label ID="Label4" runat="server" Text="How Can We Help You?" AssociatedControlID="ContentTextBox"></asp:Label>
            <asp:TextBox ID="ContentTextBox" runat="server" TextMode="MultiLine"></asp:TextBox>
            <asp:RequiredFieldValidator ID="RequiredFieldValidator4" runat="server" ForeColor="Red"
                ErrorMessage="Content must be provided." ControlToValidate="ContentTextBox" Text="*">
            </asp:RequiredFieldValidator>
            <div class="push"></div>
        </div>
        <div class="FormRow">
            <asp:Label ID="ErrorLabel" runat="server"></asp:Label>
            <asp:ValidationSummary ID="ValidationSummary1" runat="server" />
            <asp:Button ID="SubmitButton" runat="server" Text="Submit" OnClick="SubmitButton_Click" />
        </div>
    </div>
</asp:Content>