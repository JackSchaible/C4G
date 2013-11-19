<%@ Page Title="" Language="C#" MasterPageFile="~/Site.master" AutoEventWireup="true" CodeFile="MyPartners.aspx.cs" Inherits="Merchant_MyPartners_MyPartners" %>
<%@ Reference Control="~/Controls/MenuBar.ascx" %>

<asp:Content ID="Content1" ContentPlaceHolderID="HeadContent" Runat="Server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="Main_Content" Runat="Server">
    <asp:Panel ID="PendingRequestsPanel" runat="server">
        <h1>All Pending Not-For-Profit Partner Requests</h1>
        <asp:Button ID="AcceptAll" Text="Accept All Requests" runat="server" OnClick="AcceptAll_Click" />
        <asp:Label ID="Label1" runat="server"></asp:Label>
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
    </asp:Panel>

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
    
    <h1>Search for a Not-For-Profit</h1>
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
        <asp:Label ID="Label2" runat="server"></asp:Label>
        <asp:Button ID="SearchButton" runat="server" Text="Search" OnClick="SearchButton_Click" />
    </div>
    <asp:GridView ID="GridView1" runat="server" OnSelectedIndexChanging="NPOGV_SelectedIndexChanging">
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