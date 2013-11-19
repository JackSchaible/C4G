<%@ Page Title="NPO Requests" Language="C#" MasterPageFile="~/Site.master" AutoEventWireup="true" CodeFile="Requests.aspx.cs" Inherits="Merchant_MyPartners_Requests" %>
<%@ Reference Control="~/Controls/MenuBar.ascx" %>

<asp:Content ID="Content1" ContentPlaceHolderID="HeadContent" Runat="Server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="Main_Content" Runat="Server">
    <h1>All Pending Not-For-Profit Partner Requests</h1>
    <asp:Button ID="AcceptAll" Text="Accept All Requests" runat="server" OnClick="AcceptAll_Click" />
    <asp:Label ID="ErrorLabel" runat="server"></asp:Label>
    <asp:GridView ID="RequestsGV" runat="server" AutoGenerateColumns="False" OnSelectedIndexChanging="RequestsGV_SelectedIndexChanging" DataKeyNames="NPOID">
        <Columns>
            <asp:HyperLinkField DataNavigateUrlFields="URL" DataNavigateUrlFormatString="https://www.couponsforgiving.ca/{0}" Text="Profile" />
            <asp:CommandField SelectText="Accept" ShowSelectButton="True" />
            <asp:ImageField DataImageUrlField="Logo" HeaderText="Logo">
            </asp:ImageField>
            <asp:BoundField DataField="Name" HeaderText="Name" />
            <asp:BoundField DataField="City" HeaderText="City" />
            <asp:TemplateField HeaderText="Phone Number">
                <ItemTemplate>
                    <asp:Literal ID="litPhone" runat="server" Text='<%# string.Format("{0:(###) ###-####}", Int64.Parse(Eval("PhoneNumber").ToString())) %>' />
                </ItemTemplate>
            </asp:TemplateField>
            <asp:BoundField DataField="Email" HeaderText="Email" />
        </Columns>
        <EmptyDataTemplate>
            <p>You currently have no pending requests.</p>
        </EmptyDataTemplate>
    </asp:GridView>
</asp:Content>