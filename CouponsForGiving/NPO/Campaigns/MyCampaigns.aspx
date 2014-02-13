<%@ Page Title="My Campaigns" Language="C#" MasterPageFile="~/Site.master" AutoEventWireup="true" CodeFile="MyCampaigns.aspx.cs" Inherits="NPO_Campaigns_MyCampaigns" %>
<%@ Reference Control="~/Controls/MenuBar.ascx" %>

<asp:Content ID="Content1" ContentPlaceHolderID="HeadContent" Runat="Server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="Main_Content" Runat="Server">
    <asp:Panel ID="IncompleteCampaignsPanel" runat="server" Visible="False" Enabled="False">
        <h1>You have incomplete campaigns!</h1>
        <p>This is a list of campaigns that have not yet been completed. You may either edit them to finish the application form, or delete them. If you're unsure of how to fill something out, just ask us, and we'll be happy to walk you through it!</p>
        <asp:GridView ID="IncompleteCampaignsGV" runat="server" AutoGenerateColumns="False">
            <Columns>
                <asp:HyperLinkField DataNavigateUrlFields="CampaignID" DataNavigateUrlFormatString="Edit.aspx?cid={0}" Text="Edit" />
                <asp:BoundField DataField="Name" HeaderText="Name" />
                <asp:BoundField DataField="StartDate" DataFormatString="{0: dd MMM yyyy}" HeaderText="Start Date" />
                <asp:BoundField DataField="EndDate" DataFormatString="{0: dd MMM yyyy}" HeaderText="End Date" />
                <asp:BoundField DataField="FundraisingGoal" DataFormatString="{0:c}" HeaderText="Fundraising Goal" />
            </Columns>
        </asp:GridView>
    </asp:Panel>
    <h1>My Campaigns</h1>
    <p>This is a list of campaigns that you are currently running.</p>
    <asp:GridView ID="CurrentCampaignsGV" runat="server">
        <Columns>

        </Columns>
        <EmptyDataTemplate>
            <p>You currently have no active campaigns.</p>
        </EmptyDataTemplate>
    </asp:GridView>
</asp:Content>