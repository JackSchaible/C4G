<%@ Page Title="My Shopping Cart" Language="C#" MasterPageFile="~/Site.master" AutoEventWireup="true" CodeFile="Cart.aspx.cs" Inherits="Default_My_Cart" %>
<%@ Reference Control="~/Controls/MenuBar.ascx" %>

<asp:Content ID="Content1" ContentPlaceHolderID="HeadContent" Runat="Server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="Main_Content" Runat="Server">
    <script type="text/javascript">
        function changeNPO(dealInstanceID) {
            var value = $("#" + dealInstanceID + "DDL option:selected").val();

            PageMethods.ChangeCampaign(dealInstanceID, value);
        }

        function deleteDeal(dealInstanceID, campaignID) {
            PageMethods.DeleteDeal(dealInstanceID, campaignID, function () {
                location.reload();
            });
        }
    </script>
    <h1>My Shopping Cart</h1>
            <%
                if (Session["Cart"] != null)
                    if (((List<ShoppingCart>)Session["Cart"]).Count > 0)
                    {
                        Response.Write("<table cellspacing=\"0\" rules=\"all\" border=\"1\" id=\"FeaturedMerchantGV\" style=\"border-collapse:collapse;\"><tbody><tr><th scope=\"col\"></th><th scope=\"col\"></th><th scope=\"col\">Campaign</th><th scope=\"col\">Merchant</th><th scope=\"col\">Deal</th><th scope=\"col\">Gift Value</th></tr>");
                    
                        foreach (ShoppingCart item in (List<ShoppingCart>)Session["Cart"])
                        {
                            List<CouponsForGiving.Data.Campaign> campaigns = CouponsForGiving.Data.Classes.Campaigns.ListByDeal(item.DealInstanceID);
                            string button = String.Format("<a href=\"../DealPage.aspx?MerchantName={0}&deal={1}\">View Deal</a>", item.MerchantName, item.DealName);
                            string deleteButton = String.Format("<a href=\"javascript:deleteDeal({0}, {1})\">Delete</a>", item.DealInstanceID, item.CampaignID);
                            string campaignList = "<select id=\"" + item.DealInstanceID + "DDL\" onchange=\"changeNPO(" + item.DealInstanceID + ")\">";

                            foreach (CouponsForGiving.Data.Campaign c in campaigns)
                            {
                                if (c.CampaignID == item.CampaignID)
                                    campaignList += String.Format("<option value=\"{1}\" selected=\"selected\">{0}</option>", c.NPO.Name + " - " + c.Name, c.CampaignID);
                                else
                                    campaignList += String.Format("<option value=\"{1}\">{0}</option>", c.NPO.Name + "-" + c.Name, c.CampaignID);
                            }

                            campaignList += "</select>";

                            string merchant = item.MerchantName;
                            string deal = item.DealName;
                            string price = item.GiftValue.ToString("C");
                            string row = String.Format("<tr><td>{0}</td><td>{1}</td><td>{2}</td><td>{3}</td><td>{4}</td><td>{5}</td></tr>",
                                button, deleteButton, campaignList, merchant, deal, price);

                            Response.Write(row);
                        }
                    
                        Response.Write("</tbody></table>");
                    }
                    else
                    {
                        Response.Write("<p>" + strings.SelectSingleNode("/SiteText/Pages/Cart/ErrorMessages/EmptyCartPrefix").InnerText + "<a href=\"../DealsInMyArea.aspx\">" + strings.SelectSingleNode("/SiteText/Pages/Cart/ErrorMessages/EmptyCartLink").InnerText + "</a>" + strings.SelectSingleNode("/SiteText/Pages/Cart/ErrorMessages/EmptyCartSuffix").InnerText + "</p>");
                    }
            %>
    <div id="Totals">
        <p><strong>Total:</strong> <asp:Label ID="TotalLabel" runat="server"></asp:Label></p>
    </div>
    <div class="clear"></div>
    <div id="Buttons">
        <asp:Label ID="ErrorLabel" runat="server"></asp:Label>
        <asp:Button CssClass="btn-shoppingcart" ID="ClearButton" runat="server" Text="Clear" OnClick="ClearButton_Click" />
        <asp:Button CssClass="btn-shoppingcart" ID="CheckoutButton" runat="server" Text="Checkout" OnClick="CheckoutButton_Click" />
    </div>
</asp:Content>