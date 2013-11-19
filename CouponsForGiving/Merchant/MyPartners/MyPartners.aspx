<%@ Page Title="" Language="C#" MasterPageFile="~/Site.master" AutoEventWireup="true" CodeFile="MyPartners.aspx.cs" Inherits="Merchant_MyPartners_MyPartners" %>
<%@ Reference Control="~/Controls/MenuBar.ascx" %>

<asp:Content ID="Content1" ContentPlaceHolderID="HeadContent" Runat="Server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="Main_Content" Runat="Server">
    <h1>My Not-For-Profit Partners</h1>
    <asp:GridView runat="server" ID="NPOGV" AutoGenerateColumns="False" DataKeyNames="NPOID" OnRowDeleting="NPOGV_RowDeleting">
        <Columns>
            <asp:BoundField DataField="Name" />
            <asp:BoundField DataField="City" />
            <asp:BoundField DataField="Province" />
            <asp:HyperLinkField DataNavigateUrlFields="Name" DataNavigateUrlFormatString="../../Default/NPOPage.aspx?name={0}" Text="Click to View" />
            <asp:BoundField DataField="Campaigns" DataFormatString="{0} Campaigns Running" />
            <asp:CommandField DeleteText="Remove" ShowDeleteButton="true" />
        </Columns>
        <EmptyDataTemplate>
            <p>You currently have no active partners. <a href="Search.aspx">Click here to add some!</a></p>
        </EmptyDataTemplate>
    </asp:GridView>
    <asp:Label ID="ErrorLabel" runat="server"></asp:Label>
    <a href="Search.aspx" class="btn">Add A New Not-For-Profit</a>
</asp:Content>