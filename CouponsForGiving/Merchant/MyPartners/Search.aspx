﻿<%@ Page Title="" Language="C#" MasterPageFile="~/Site.master" AutoEventWireup="true" CodeFile="Search.aspx.cs" Inherits="Merchant_MyPartners_Search" %>
<%@ Reference Control="~/Controls/MenuBar.ascx" %>

<asp:Content ID="Content1" ContentPlaceHolderID="HeadContent" Runat="Server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="Main_Content" Runat="Server">
    <div class="FormRow">
        <label>Search by City</label>
        <asp:TextBox ID="CityTextBox" runat="server"></asp:TextBox>
        <ajaxToolkit:AutoCompleteExtender ID="CityACE" runat="server" 
            UseContextKey="True" ServiceMethod="GetCompletionList" 
            TargetControlID="CityTextBox">
        </ajaxToolkit:AutoCompleteExtender>
    </div>
    <div class="FormRow">
        <label>Search by Name</label>
        <asp:TextBox ID="NameTextBox" runat="server"></asp:TextBox>
        <ajaxToolkit:AutoCompleteExtender ID="NameACE" runat="server" 
            UseContextKey="True" ServiceMethod="GetCompletionList2"
            TargetControlID="NameTextBox">
        </ajaxToolkit:AutoCompleteExtender>
    </div>
    <div class="FormRow">
        <asp:Label ID="ErrorLabel" runat="server"></asp:Label>
        <asp:Button ID="SearchButton" runat="server" Text="Search" OnClick="SearchButton_Click" />
    </div>
    <asp:GridView ID="NPOGV" runat="server" OnSelectedIndexChanging="NPOGV_SelectedIndexChanging">
        <Columns>
            <asp:ImageField DataImageUrlField="SmallLogo" DataImageUrlFormatString="../../{0}">
            </asp:ImageField>
            <asp:BoundField DataField="Name" />
            <asp:BoundField DataField="City" />
            <asp:BoundField DataField="Province" />
            <asp:HyperLinkField DataNavigateUrlFields="Name" 
                DataNavigateUrlFormatString="../../Default/MerchantPage.aspx?MerchantName={0}" 
                Text="Click to View Offers" />
            <asp:BoundField DataField="Offers" DataFormatString="{0} Offers Available" />
            <asp:CommandField SelectText="Remove" ShowSelectButton="True" />
        </Columns>
        <EmptyDataTemplate>
            <p>There are no Not-For-Profits to display. Try broadening your search criteria!</p>
        </EmptyDataTemplate>
    </asp:GridView>
</asp:Content>