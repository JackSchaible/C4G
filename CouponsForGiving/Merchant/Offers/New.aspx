<%@ Page Title="New Deal" Language="C#" MasterPageFile="~/Site.master" AutoEventWireup="true" CodeFile="New.aspx.cs" Inherits="Merchant_Deals_New" %>
<%@ Reference Control="~/Controls/MenuBar.ascx" %>

<asp:Content ID="Content1" ContentPlaceHolderID="HeadContent" Runat="Server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="Main_Content" Runat="Server">
    <script type="text/javascript">
        $(document).ready(function () {
            calcSplit();
        });

        function addLocation(locationID, name) {
            PageMethods.AddLocation(locationID, function () {
                $("#SelectedItems").append("<button id='" + locationID + "Button' onClick='removeLocation(" + locationID + ")>" + name + "</button>)");
            });
        }

        function removeLocation(locationID) {
            PageMethods.RemoveLocation(locationID, function () {
                $(locationID + "Button").remove();
            });
        }

        function calcSplit() {
            var value = $("#newDealGiftValue").val();
            var vat = value * 0.023;
            var tax = (value * 0.2) * 0.05;
            var split = value - (vat + tax);

            $("#VAT").text("$" + vat.toFixed(2).replace(/(\d)(?=(\d{3})+\.)/g, '$1,'));
            $("#Tax").text("$" + tax.toFixed(2).replace(/(\d)(?=(\d{3})+\.)/g, '$1,'));

            //IMPORTANT: MUST BE THE SAME AS THE FORMULA IN ShoppingCart.cs
            $("#SplitTotal").text("$" + split.toFixed(2).replace(/(\d)(?=(\d{3})+\.)/g, '$1,'));
        }
    </script>
    <h1>Offer Creation Page</h1>
    <p>To set up an offer you will need to have the following information:</p>
    <ul>
        <li>What product or service are you offering at a discounted or special rate?</li>
        <li>How long you want to make your offer available for?</li>
        <li>How many offers you want to sell?</li>
        <li>Any special rules of use</li>
        <li>Images of the product or service your are promoting</li>
        <li>Your offer as well as your profile page will now be available for not-for-profits to add to their campaign pages.</li>
    </ul>
    <h1>New <%: merch.Name %> Offer</h1>
    <div id="Form">
        <asp:Panel CssClass="FormRow" ID="LocationsPanel" runat="server">
            <div id="FormRow">
                <p>Your Merchant Locations</p>
                <asp:GridView ID="LocationsGV" runat="server" DataKeyNames="LocationID">
                    <Columns>
                        <asp:TemplateField>
                            <ItemTemplate>
                                <button onclick='addLocation(<%# Eval("LocationID") %>, \"<%# Eval("Address") %> <%# Eval("City") %>, <%# Eval("ShortProvince") %>, <%# Eval("ShortCountry") %>\"')>Add Location</button>
                            </ItemTemplate>
                        </asp:TemplateField>
                        <asp:BoundField DataField="Address" HeaderText="Address"></asp:BoundField>
                        <asp:BoundField DataField="City" HeaderText="City"></asp:BoundField>
                        <asp:BoundField DataField="Province" HeaderText="Province/State"></asp:BoundField>
                        <asp:BoundField DataField="Country" HeaderText="Country"></asp:BoundField>
                        <asp:BoundField DataField="Phone" HeaderText="Phone Number"></asp:BoundField>
                    </Columns>
                </asp:GridView>
                <div id="SelectedItems">
                </div>
            </div>
        </asp:Panel>
        <div class="FormRow">
            <asp:Label ID="Label1" runat="server" Text="Name" AssociatedControlID="newDealName"></asp:Label>
            <asp:TextBox ID="newDealName" runat="server" MaxLength="256"></asp:TextBox>
            <asp:RequiredFieldValidator ID="nameRequired" runat="server" ControlToValidate="newDealName"
                ErrorMessage="Name of offer is required.">
                *
            </asp:RequiredFieldValidator>
        </div>
        <div class="FormRow TextAreaRow">
            <asp:Label ID="Label4" runat="server" Text="Description" 
                AssociatedControlID="newDealDescription"></asp:Label>
            <asp:TextBox ID="newDealDescription" runat="server" TextMode="MultiLine" MaxLength="200"></asp:TextBox>
            <asp:RequiredFieldValidator ID="RequiredFieldValidator3" runat="server" 
                ControlToValidate="newDealDescription" ErrorMessage="A description of your offer is required.">
                *
            </asp:RequiredFieldValidator>
        </div>
        <div class="FormRow">
            <label>Offer Image<br /><small>Image must be under 4 MB.</small></label>
            <asp:FileUpload ID="dealImage" runat="server" />
        </div>
        <div class="FormRow">
            <asp:Label ID="Label2" runat="server" Text="Start Date" 
                AssociatedControlID="StartDate"></asp:Label>
            <UC:DateControl ID="StartDate" runat="server" AcceptPastDates="false"/>
        </div>
        <div class="FormRow">
            <asp:Label ID="Label3" runat="server" Text="End Date" 
                AssociatedControlID="EndDate"></asp:Label>
            <UC:DateControl ID="EndDate" runat="server" AcceptPastDates="false" />
        </div>
        <div class="FormRow">
            <asp:Label ID="Label7" runat="server" Text="Total Coupon Limit" 
                AssociatedControlID="newDealAbsoluteCouponLimit"></asp:Label>
            <asp:TextBox ID="newDealAbsoluteCouponLimit" runat="server" MaxLength="10">
            </asp:TextBox>
            <ajaxToolkit:FilteredTextBoxExtender ID="FilteredTextBoxExtender2" TargetControlID="newDealAbsoluteCouponLimit" 
                FilterType="Numbers" runat="server"></ajaxToolkit:FilteredTextBoxExtender>
        </div>
        <div class="FormRow">
            <asp:Label ID="Label8" runat="server" Text="Coupon Limit Per Customer" 
                AssociatedControlID="newDealLimitPerCustomer"></asp:Label>
            <asp:TextBox ID="newDealLimitPerCustomer" runat="server" MaxLength="10">
            </asp:TextBox>
            <ajaxToolkit:FilteredTextBoxExtender ID="FilteredTextBoxExtender1" 
                TargetControlID="newDealLimitPerCustomer" FilterType="Numbers" runat="server">
            </ajaxToolkit:FilteredTextBoxExtender>
        </div>
        <div class="FormRow">
            <label>Retail Value<br /><small>The regular price of the product/service.</small></label>
            <asp:TextBox ID="newDealRetailValue" runat="server" MaxLength="10"></asp:TextBox>
            <asp:RequiredFieldValidator ID="RequiredFieldValidator1" runat="server" 
                ControlToValidate="newDealRetailValue" ErrorMessage="The regular Retail Value of your offer is required.">
                *
            </asp:RequiredFieldValidator>
            <ajaxToolkit:FilteredTextBoxExtender ID="FilteredTextBoxExtender3" TargetControlID="newDealRetailValue" 
                FilterType="Custom, Numbers" ValidChars="." runat="server">
            </ajaxToolkit:FilteredTextBoxExtender>
            <asp:RegularExpressionValidator ID="RegularExpressionValidator2" runat="server"
                ControlToValidate="newDealRetailValue" ErrorMessage="The regular Retail Value of your offer is invalid. (ex. 15.00)" 
                ValidationExpression="^\$?\d{1,3}(,?\d{3})*(\.\d{1,2})?$">
                *
            </asp:RegularExpressionValidator>
        </div>
        <div class="FormRow">
            <label>Gift Value<br /><small>The Sale Price</small></label>
            <asp:TextBox ID="newDealGiftValue" runat="server" MaxLength="10" onkeyup="calcSplit()" ClientIDMode="Static"></asp:TextBox>
            <br />
            <p>2.3% VAT = <strong id="VAT">$0.00</strong></p>
            <br />
            <p>5% Tax on Coupons4Giving Fee = <strong id="Tax">$0.00</strong></p>
            <br />
            <p>Your Split on Each Purchase = <strong id="SplitTotal">$0.00</strong></p>
            <asp:RequiredFieldValidator ID="RequiredFieldValidator2" runat="server" 
                ControlToValidate="newDealGiftValue" ErrorMessage="The Gift Value of your offer is required. This is how much your offer will be sold for.">
                *
            </asp:RequiredFieldValidator>
            <ajaxToolkit:FilteredTextBoxExtender ID="FilteredTextBoxExtender4" 
                TargetControlID="newDealGiftValue" FilterType="Custom, Numbers" 
                ValidChars="." runat="server"></ajaxToolkit:FilteredTextBoxExtender>
            <asp:RegularExpressionValidator ID="RegularExpressionValidator1" runat="server" 
                ControlToValidate="newDealGiftValue" ErrorMessage="The Gift Value of your offer is invalid. (i.e., 15.00)" 
                ValidationExpression="^\$?\d{1,3}(,?\d{3})*(\.\d{1,2})?$">*</asp:RegularExpressionValidator>
            <asp:CompareValidator ID="CompareValidator1" runat="server" ControlToCompare="newDealRetailValue" 
                ControlToValidate="newDealGiftValue" ErrorMessage="Gift Value must be less than Retail Value" 
                Operator="LessThan" Type="Currency">*</asp:CompareValidator>
        </div>
        <div class="FormRow">
            <h4>Redemption Details</h4>
            <p>
                This is <strong>optional</strong> information that may help buyers with the redemption process, 
                explain restrictions, and tell them anything else they should know about your deal. This will 
                show up as fine print on the bottom of your offer page.
            </p>
            <asp:CheckBoxList ID="FinePrintList" runat="server" DataSourceID="FinePrintEDS" DataTextField="Content" DataValueField="FinePrintID">
            </asp:CheckBoxList>
            <asp:EntityDataSource ID="FinePrintEDS" runat="server" ConnectionString="name=C4GEntities" DefaultContainerName="C4GEntities" 
                EnableFlattening="False" EntitySetName="FinePrints">
            </asp:EntityDataSource>
        </div>
        <div class="FormRow TextAreaRow">
            <asp:Label ID="Label5" runat="server" Text="Additional Redemption Details" AssociatedControlID="AdditionalDetailsTextBox"></asp:Label>
            <asp:TextBox ID="AdditionalDetailsTextBox" runat="server" TextMode="MultiLine"></asp:TextBox>
        </div>
        <div class="FormRow">
            <asp:Label ID="newDealMessage" runat="server" AssociatedControlID="newDealSubmit"></asp:Label>
            <asp:Button ID="newDealSubmit" runat="server" Text="Submit" OnClick="newDealSubmit_Click" />
        </div>
    </div>
    <asp:ValidationSummary ID="ValidationSummary1" runat="server" />
</asp:Content>