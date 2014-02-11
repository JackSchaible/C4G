<%@ Page Title="Sales Report" Language="C#" MasterPageFile="~/Site.master" AutoEventWireup="true" CodeFile="Sales.aspx.cs" Inherits="Merchant_Reports_Sales" %>
<%@ Reference Control="~/Controls/MenuBar.ascx" %>
<%@ MasterType VirtualPath="~/Site.master" %>

<asp:Content ID="Content4" ContentPlaceHolderID="Main_Content" Runat="Server">
    <script type="text/javascript">
        $(document).ready(function () {
            var filterState = $("#FilterState").val();
            if (filterState != undefined) {
                if (filterState == "Show") {
                    $("#FilterControl").text("Hide");
                    $("#FilterOptions").show();
                }
            }
        });

        function toggleFilter() {
            if ($("#FilterControl").text() == "Show") {
                $("#FilterControl").text("Hide");
                $("#FilterOptions").slideDown(400);
                $("#FilterState").val("Show");
            }
            else {
                $("#FilterControl").text("Show");
                $("#FilterOptions").slideUp(400);
                $("#FilterState").val("Hide");
            }
        }
    </script>
    <h1>Sales Report</h1>
    <h2>Filtering Options</h2>
    <asp:HiddenField ID="FilterState" runat="server" ClientIDMode="Static" />
    <a id="FilterControl" href="javascript:toggleFilter()">Show</a>
    <div id="FilterOptions" style="display: none;">
        <div class="FormRow">
            <label>Offer Name</label>
            <asp:CheckBox ID="OfferCheckBox" runat="server" />
            <asp:RadioButtonList ID="OfferRBL" runat="server">
                <asp:ListItem Text="Contains" Value="Contains" Selected="True" />
                <asp:ListItem Text="Is Exactly" Value="IsExactly" />
            </asp:RadioButtonList>
            <asp:TextBox ID="OfferTextBox" runat="server" />
        </div>
        <div class="FormRow">
            <label>Amount Collected</label>
            <asp:CheckBox ID="AmountCheckBox" runat="server" />
            <asp:RadioButtonList ID="AmountRBL" runat="server">
                <asp:ListItem Text="Is Greater Than" Value="GT" Selected="True" />
                <asp:ListItem Text="Is Exactly" Value="Exactly" />
                <asp:ListItem Text="Is Less Than" Value="LT" />
            </asp:RadioButtonList>
            <asp:TextBox ID="AmountTextBox" runat="server" />
            <ajaxToolkit:FilteredTextBoxExtender ID="MerchantTotalFTE" runat="server"
                TargetControlID="AmountTextBox" FilterType="Custom, Numbers" ValidChars=".">
            </ajaxToolkit:FilteredTextBoxExtender>
        </div>
        <div class="FormRow">
            <label>Coupons Sold</label>
            <asp:CheckBox ID="SoldCheckBox" runat="server" />
            <asp:RadioButtonList ID="SoldRBL" runat="server">
                <asp:ListItem Text="Is Greater Than" Value="GT" Selected="True" />
                <asp:ListItem Text="Is Exactly" Value="Exactly" />
                <asp:ListItem Text="Is Less Than" Value="LT" />
            </asp:RadioButtonList>
            <asp:TextBox ID="SoldTextBox" runat="server" />
            <ajaxToolkit:FilteredTextBoxExtender ID="FilteredTextBoxExtender1" runat="server"
                TargetControlID="SoldTextBox" FilterType="Numbers">
            </ajaxToolkit:FilteredTextBoxExtender>
        </div>
        <div class="FormRow">
            <label>Coupons Left</label>
            <asp:CheckBox ID="RemainingCheckBox" runat="server" />
            <asp:RadioButtonList ID="RemainingRBL" runat="server">
                <asp:ListItem Text="Is Greater Than" Value="GT" Selected="True" />
                <asp:ListItem Text="Is Exactly" Value="Exactly" />
                <asp:ListItem Text="Is Less Than" Value="LT" />
            </asp:RadioButtonList>
            <asp:TextBox ID="RemainingTextBox" runat="server" />
            <ajaxToolkit:FilteredTextBoxExtender ID="FilteredTextBoxExtender2" runat="server"
                TargetControlID="RemainingTextBox" FilterType="Numbers">
            </ajaxToolkit:FilteredTextBoxExtender>
        </div>
        <div class="FormRow">
            <label>Coupons Redeemed</label>
            <asp:CheckBox ID="RedeemedCheckBox" runat="server" />
            <asp:RadioButtonList ID="RedeemedRBL" runat="server">
                <asp:ListItem Text="Is Greater Than" Value="GT" Selected="True" />
                <asp:ListItem Text="Is Exactly" Value="Exactly" />
                <asp:ListItem Text="Is Less Than" Value="LT" />
            </asp:RadioButtonList>
            <asp:TextBox ID="RedeemedTextBox" runat="server" />
            <ajaxToolkit:FilteredTextBoxExtender ID="FilteredTextBoxExtender3" runat="server"
                TargetControlID="RedeemedTextBox" FilterType="Numbers">
            </ajaxToolkit:FilteredTextBoxExtender>
        </div>
        <div class="FormRow">
            <asp:Button ID="SubmitButton" runat="server" Text="Filter" OnClick="SubmitButton_Click" />
        </div>
    </div>
    <asp:GridView ID="ReportGV" runat="server" AutoGenerateColumns="False" AllowPaging="True"
        AllowSorting="True" OnPageIndexChanging="ReportsGV_PageIndexChanging" OnSorting="ReportsGV_Sorting"
        ShowFooter="true" OnRowDataBound="ReportGV_RowDataBound">
        <Columns>
            <asp:BoundField DataField="Offer" HeaderText="Offer" />
            <asp:BoundField DataField="AmountCollected" DataFormatString="{0:c}" HeaderText="Amount Collected" />
            <asp:BoundField DataField="CouponsSold" HeaderText="Coupons Sold" />
            <asp:BoundField DataField="CouponsLeft" HeaderText="Coupons Left" />
            <asp:BoundField DataField="CouponsRedeemed" HeaderText="Coupons Redeemed" />
        </Columns>
        <FooterStyle CssClass="Report-Footer" />
        <EmptyDataTemplate>
            <p>There was no data with the specified parameters. Try being less specific!</p>
        </EmptyDataTemplate>
    </asp:GridView>
</asp:Content>