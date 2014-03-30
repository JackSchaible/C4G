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
    <asp:GridView ID="CurrentCampaignsGV" runat="server" AutoGenerateColumns="false">
        <Columns>
            <asp:TemplateField>
                <ItemTemplate>
                    <img src="../../images/c4g_action_link.png" class="left" />
                    <p><asp:Label ID="Label1" runat="server" class="btn-url" Text='<%# Bind("URL") %>'></asp:Label></p>
                </ItemTemplate>
            </asp:TemplateField>
            <asp:TemplateField>
                <ItemTemplate>
                    <img src="../../Images/c4g_email_facebook.png" OnClick="shareOnFB('<%# Eval("URL") %>', 'Help support our cause <%# Eval("NPOName") %> <%# Eval("Name") %> and buy a great deal from Coupons4Giving', 'https://www.coupons4giving.ca/<%# Eval("NPOName") %>', '<%# Eval("Name") %>', '')" />
                </ItemTemplate>
            </asp:TemplateField>
            <asp:TemplateField>
                <ItemTemplate>
                    <p>
                        <a href="https://twitter.com/share" class="twitter-share-button" data-url="<%# Eval("URL") %>"
                            data-text="Help us reach our <%# Eval("Name") %> goals and buy a great deal on @Coupons4Giving!" data-hashtags="DealsThatMakeADifference">Tweet</a>
                    </p>
                </ItemTemplate>
            </asp:TemplateField>
            <asp:TemplateField>
                <ItemTemplate>
                    <a href="http://www.linkedin.com/shareArticle?mini=true&url=<%# Eval("URL") %>&title=<%# Eval("Name") %>&summary=Help support our cause <%# Eval("NPOName") %> <%# Eval("Name") %> and buy great deals from Coupons4Giving!&source=Coupons4Giving" rel="nofollow" onclick="window.open(this.href,'_blank','location=yes,height=570,width=520,scrollbars=yes,status=yes');return false" onfocus="this.blur()">
                        <img src="../../Images/c4g_email_linkedin.png" />
                    </a>
                </ItemTemplate>
            </asp:TemplateField>
            <asp:HyperLinkField DataNavigateUrlFields="CampaignID" DataNavigateUrlFormatString="Edit.aspx?cid={0}" Text="Edit" />
            <asp:BoundField DataField="Name" HeaderText="Name" />
            <asp:BoundField DataField="StartDate" DataFormatString="{0: dd MMM yyyy}" HeaderText="Start Date" />
            <asp:BoundField DataField="EndDate" DataFormatString="{0: dd MMM yyyy}" HeaderText="End Date" />
            <asp:BoundField DataField="FundraisingGoal" DataFormatString="{0:c}" HeaderText="Fundraising Goal" />
        </Columns>
        <EmptyDataTemplate>
            <p>You currently have no active campaigns.</p>
            <a href="New.aspx">Click here to create one!</a>
        </EmptyDataTemplate>
    </asp:GridView>
</asp:Content>