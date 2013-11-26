<%@ Page Title="My Partners-Add" Language="C#" MasterPageFile="~/Site.master" AutoEventWireup="true" CodeFile="Add.aspx.cs" Inherits="NPO_Partners_Add" %>
<%@ Reference Control="~/Controls/MenuBar.ascx" %>

<asp:Content ID="Content1" ContentPlaceHolderID="HeadContent" Runat="Server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="Main_Content" Runat="Server">
    <style type="text/css">
        td img {
            width: 30%;
        }
    </style>
    <h1>Merchant Partner Setup</h1>
    <p>Click on a merchant partner to view their page and their available offers. Then you can add them to your list.</p>
    <h2>Local Merchants</h2>
    <div class="FormRow">
        <label>Select a City</label>
        <asp:DropDownList ID="CitiesDDL" runat="server" DataTextField="City" DataValueField="CityID" AutoPostBack="True"></asp:DropDownList>
    </div>
    <asp:GridView ID="LocalMerchantsGV" runat="server" AutoGenerateColumns="False" DataKeyNames="MerchantID" OnSelectedIndexChanging="LocalMerchantsGV_SelectedIndexChanging">
        <Columns>
            <asp:CommandField ShowSelectButton="True" />
            <asp:HyperLinkField DataNavigateUrlFields="MerchantID" Text="View" DataNavigateUrlFormatString="../../Default/MerchantPage.aspx?mid={0}" />
            <asp:BoundField DataField="Name" HeaderText="Name" SortExpression="Name" />
            <asp:ImageField DataImageUrlField="SmallLogo" DataImageUrlFormatString="../../{0}">
            </asp:ImageField>
            <asp:BoundField DataField="cAddress" HeaderText="Address" SortExpression="cAddress" />
            <asp:BoundField DataField="PhoneNumber" HeaderText="Phone Number" SortExpression="PhoneNumber" />
            <asp:HyperLinkField DataNavigateUrlFields="Website" HeaderText="Website" Target="_blank" Text="Click Here to Visit" />
        </Columns>
    </asp:GridView>
    <asp:Label ID="ErrorLabel" runat="server"></asp:Label>
    <h2>Global Marketplace</h2>
    <asp:GridView ID="GlobalMarketplaceGV" runat="server" AutoGenerateColumns="False" DataKeyNames="MerchantID" DataSourceID="GlobalMerchantsODS" OnSelectedIndexChanging="GlobalMarketplaceGV_SelectedIndexChanging">
        <Columns>
            <asp:CommandField InsertText="Add" NewText="Add" SelectText="View" ShowInsertButton="True" ShowSelectButton="True" />
            <asp:BoundField DataField="Name" HeaderText="Name" SortExpression="Name" />
            <asp:ImageField DataImageUrlField="SmallLogo">
            </asp:ImageField>
            <asp:BoundField DataField="PhoneNumber" HeaderText="PhoneNumber" SortExpression="PhoneNumber" />
            <asp:BoundField DataField="Website" HeaderText="Website" SortExpression="Website" />
        </Columns>
        <EmptyDataTemplate>
            <img src="../../images/c4g_comingsoon_small.png" style="width: 100%" />
        </EmptyDataTemplate>
    </asp:GridView>
    <asp:Label ID="GlobalError" runat="server"></asp:Label>
    <asp:ObjectDataSource ID="GlobalMerchantsODS" runat="server" OldValuesParameterFormatString="original_{0}" SelectMethod="Merchant_ListGlobal" TypeName="CouponsForGiving.Data.SysData"></asp:ObjectDataSource>
    <h2>Invite Your Preferred Merchants</h2>
    <p>You can add your own merchants by sending them an invitation to sign up with Coupons4Giving! When your
        preferred merchant accepts your invitation and registers with Coupons4Giving you will recieve
        an email notification and that merchant will be automatically added to your My Merchant Partner list.
    </p>
    <p>You can invite as many merchants as you want. Once you hit 'Send an Invitation', you will be
        brought back to this page and you may send another.
    </p>
    <div class="FormRow">
        <label>Contact Name</label>
        <asp:TextBox ID="NameTextBox" runat="server"></asp:TextBox>
        <asp:RequiredFieldValidator ID="RequiredFieldValidator1" runat="server" 
            ErrorMessage="Name is required." ControlToValidate="NameTextBox">
            *
        </asp:RequiredFieldValidator>
    </div>
    <div class="FormRow">
        <label>Company Name</label>
        <asp:TextBox ID="CompanyNameTextBox" runat="server"></asp:TextBox>
        <asp:RequiredFieldValidator ID="RequiredFieldValidator2" runat="server" 
            ErrorMessage="Company Name is required." ControlToValidate="CompanyNameTextBox">
            *
        </asp:RequiredFieldValidator>
    </div>
    <div class="FormRow">
        <label>Email Address</label>
        <asp:TextBox ID="EmailTextBox" runat="server"></asp:TextBox>
        <asp:RequiredFieldValidator ID="RequiredFieldValidator3" runat="server" 
            ErrorMessage="Email is required." ControlToValidate="EmailTextBox">
            *
        </asp:RequiredFieldValidator>
        <asp:RegularExpressionValidator ID="RegularExpressionValidator1" runat="server" 
            ErrorMessage="Email must be valid." ControlToValidate="EmailTextBox" 
            ValidationExpression="\w+([-+.']\w+)*@\w+([-.]\w+)*\.\w+([-.]\w+)*">
            *
        </asp:RegularExpressionValidator>
    </div>
    <div class="FormRow">
        <asp:Button ID="EmailSubmit" runat="server" OnClick="EmailSubmit_Click" CssClass="btn" Text="Click to Send Invitation"/>
        <asp:Label ID="ResultLabel" runat="server"></asp:Label>
    </div>
    <a href="MyPartners.aspx" class="HeaderButton">View Your Merchant Partner List</a>
    <a href="../Campaigns/New.aspx" class="HeaderButton">Set Up A Campaign</a>
</asp:Content>