<%@ Page Title="My Offers" Language="C#" MasterPageFile="~/Site.master" AutoEventWireup="true" CodeFile="MyOffers.aspx.cs" Inherits="Merchant_Offers_MyOffers" %>
<%@ Reference Control="~/Controls/MenuBar.ascx" %>

<asp:Content ID="Content1" ContentPlaceHolderID="HeadContent" Runat="Server">
</asp:Content>
<asp:Content ID="Content4" ContentPlaceHolderID="Main_Content" Runat="Server">
    <h1>My Offers</h1>
    <%--Current Offers --%>
    <h2>Current Offers</h2>
    <asp:GridView ID="CurrentOffersGV" runat="server" AutoGenerateColumns="False">
        <Columns>
            <asp:HyperLinkField DataNavigateUrlFields="DealID" DataNavigateUrlFormatString="Edit.aspx?diid={0}" Text="Edit" />
            <asp:BoundField DataField="Name" HeaderText="Name" />
            <asp:BoundField DataField="Purchases" HeaderText="Purchases" />
            <asp:BoundField DataField="Revenue" HeaderText="Revenue" DataFormatString="{0:c}" />
        </Columns>
        <EmptyDataTemplate>
            <p>You currently have no running offers. <a href="New.aspx">Click here</a> to add one!</p>
        </EmptyDataTemplate>
    </asp:GridView>
    <%--Future Offers--%>
    <h2>Upcoming Offers</h2>
    <asp:GridView ID="UpcomingOffersGV" runat="server" AutoGenerateColumns="False">
        <Columns>
            <asp:HyperLinkField DataNavigateUrlFields="DealID" DataNavigateUrlFormatString="Edit.aspx?diid={0}" Text="Edit" />
            <asp:BoundField DataField="Name" HeaderText="Name" />
            <asp:BoundField DataField="StartDate" HeaderText="Start Date" />
            <asp:BoundField DataField="EndDate" HeaderText="End Date" />
        </Columns>
        <EmptyDataTemplate>
            <p>You currently have no upcoming offers. <a href="New.aspx">Click here</a> to add one!</p>
        </EmptyDataTemplate>
    </asp:GridView>
    <%--Past Offers--%>
    <h2>Past Offers</h2>
    <asp:GridView ID="PastOffersGV" runat="server" AutoGenerateColumns="False">
        <Columns>
            <asp:BoundField DataField="Name" HeaderText="Name" />
            <asp:BoundField DataField="Purchases" HeaderText="Purchases" />
            <asp:BoundField DataField="Revenue" HeaderText="Revenue" DataFormatString="{0:c}" />
            <asp:BoundField DataField="StartDate" HeaderText="Start Date" />
            <asp:BoundField DataField="EndDate" HeaderText="End Date" />
        </Columns>
        <EmptyDataTemplate>
            <p>You currently have no past offers.</p>
        </EmptyDataTemplate>
    </asp:GridView>
</asp:Content>