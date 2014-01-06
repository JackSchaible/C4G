<%@ Page Title="My Shopping Cart" Language="C#" MasterPageFile="~/Site.master" AutoEventWireup="true" CodeFile="Cart.aspx.cs" Inherits="Default_My_Cart" %>
<%@ Reference Control="~/Controls/MenuBar.ascx" %>

<asp:Content ID="Content1" ContentPlaceHolderID="HeadContent" Runat="Server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="Main_Content" Runat="Server">
    <script type="text/javascript">
        function changeNPO() {
        }
    </script>
    <h1>My Shopping Cart</h1>
    <table cellspacing="0" rules="all" border="1" id="FeaturedMerchantGV" style="border-collapse:collapse;">
		<tbody>
            <tr>
                <th scope="col"><%--View deal--%></th>
                <th scope="col"><%--Delete item--%></th>
                <th scope="col">Campaign</th>
                <th scope="col">Merchant</th>
                <th scope="col">Deal</th>
                <th scope="col">Gift Value</th>
		    </tr>
            <%
                foreach (ShoppingCart item in (List<ShoppingCart>)Session["Cart"])
                {
                    List<CouponsForGiving.Data.Campaign> campaigns = CouponsForGiving.Data.Classes.Campaigns.ListByDeal(item.DealInstanceID);
                    string button = String.Format("<a href=\"../DealPage.aspx?MerchantName={0}&OfferName={1}\">View Deal</a>", item.MerchantName, item.DealName);
                    string deleteButton = String.Format("<a href=\"javascript:deleteDeal({0}, {1})>Delete</a>", item.DealInstanceID, item.CampaignID);
                    string campaignList = "<select onchange=\"changeNPO()\">";

                    foreach (CouponsForGiving.Data.Campaign c in campaigns)
                    {
                        if (c.CampaignID == item.CampaignID)
                            campaignList += String.Format("<option selected=\"selected\">{0}</option>", c.NPO.Name + "-" + c.Name);
                        else
                            campaignList += String.Format("<option>{0}</option>", c.NPO.Name + "-" + c.Name);
                    }
                                        
                    campaignList += "</select>";

                    string merchant = item.MerchantName;
                    string deal = item.DealName;
                    string price = item.GiftValue.ToString("0:c");
                    string row = String.Format("<td>{0}</td><td>{1}</td><td>{2}</td><td>{3}</td><td>{4}</td><td>{5}</td>",
                        button, deleteButton, campaignList, merchant, deal, price);
                    
                    Response.Write(row);
                }
            %>
	</tbody>
    </table>
    <div id="Totals">
        <p><strong>Subtotal:</strong> <asp:Label ID="SubtotalLabel" runat="server"></asp:Label></p>
        <p><strong>Total:</strong> <asp:Label ID="TotalLabel" runat="server"></asp:Label></p>
    </div>
    <div class="clear"></div>
    <div id="Buttons">
        <asp:Label ID="ErrorLabel" runat="server"></asp:Label>
        <asp:Button CssClass="btn-shoppingcart" ID="ClearButton" runat="server" Text="Clear" OnClick="ClearButton_Click" />
        <asp:Button CssClass="btn-shoppingcart" ID="CheckoutButton" runat="server" Text="Checkout" OnClick="CheckoutButton_Click" />
    </div>
</asp:Content>