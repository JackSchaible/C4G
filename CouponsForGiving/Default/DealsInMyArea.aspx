<%@ Page Title="Deals in my Area" Language="C#" MasterPageFile="~/Site.master" AutoEventWireup="true" CodeFile="DealsInMyArea.aspx.cs" Inherits="Default_DealsInMyArea" EnableViewStateMac="False" %>
<%@ Reference Control="~/Controls/MenuBar.ascx" %>

<asp:Content ID="Content1" ContentPlaceHolderID="HeadContent" Runat="Server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="Main_Content" Runat="Server" EnableViewState="True" ViewStateMode="Inherit" ValidateRequestMode="Inherit">
    <style type="text/css">
        #Loading img{
            display: block;
            margin: 0 auto;
        }

        #Loading p {
            text-align: center;
            width: 100%;
        }
    </style>
        <h1>Deals in <%:City %></h1>
        <asp:gridview runat="server" ID="DealsGV" AutoGenerateColumns="False" 
            DataKeyNames="DealInstanceID,CampaignID" OnSelectedIndexChanging="DealsGV_SelectedIndexChanging">
            <Columns>
                <asp:CommandField SelectText="View Deal" ShowSelectButton="True" >
                <ItemStyle CssClass="ButtonColumn" />
                </asp:CommandField>
                <asp:TemplateField HeaderText="Fundraiser" SortExpression="NPOName">
                    <EditItemTemplate>
                        <asp:TextBox ID="TextBox1" runat="server" Text='<%# Bind("NPOName") %>'></asp:TextBox>
                    </EditItemTemplate>
                    <ItemTemplate>
                        <asp:Label ID="Label1" runat="server" Text='<%# Bind("NPOName") %>'></asp:Label>
                    </ItemTemplate>
                    <ItemStyle CssClass="NameColumn" />
                </asp:TemplateField>
                <asp:BoundField DataField="CampaignName" HeaderText="Campaign" SortExpression="CampaignName" />
                <asp:BoundField DataField="MerchantName" HeaderText="Merchant" SortExpression="MerchantName" />
                <asp:BoundField DataField="DealName" HeaderText="Deal" SortExpression="DealName" />
                <asp:BoundField DataField="CouponsRemaining" HeaderText="Coupons Left" />
                <asp:BoundField DataField="GiftValue" HeaderText="Gift Value" SortExpression="GiftValue" DataFormatString="{0:c}" />
                <asp:BoundField DataField="RetailValue" HeaderText="Actual Retail Value" SortExpression="RetailValue" DataFormatString="{0:c}" />
            </Columns>
            <EmptyDataTemplate>
                <p>We were unable to locate any deals in your city.</p>
            </EmptyDataTemplate>
        </asp:gridview>
        <asp:Label ID="ErrorLabel" runat="server"></asp:Label>
        <div id="NoCity" runat="server">
            <asp:GridView ID="CitiesGV" runat="server" AutoGenerateColumns="False" DataSourceID="CitiesODS" 
                OnSelectedIndexChanging="CitiesGV_SelectedIndexChanging" DataKeyNames="CityCode" Visible="False">
                <Columns>
                    <asp:CommandField ShowSelectButton="True" />
                    <asp:BoundField DataField="NumberOfDeals" HeaderText="Number of Deals" SortExpression="NumberOfDeals" />
                    <asp:BoundField DataField="City" HeaderText="City" SortExpression="City" />
                    <asp:BoundField DataField="State_Province" HeaderText="State/Province" SortExpression="State_Province" />
                    <asp:BoundField DataField="Country" HeaderText="Country" SortExpression="Country" />
                </Columns>
            </asp:GridView>
            <asp:ObjectDataSource ID="CitiesODS" runat="server" OldValuesParameterFormatString="original_{0}" SelectMethod="ListCities" TypeName="CouponsForGiving.Data.SysData"></asp:ObjectDataSource>
        </div>
</asp:Content>