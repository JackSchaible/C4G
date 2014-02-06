<%@ Page Title="" Language="C#" MasterPageFile="~/Site.master" AutoEventWireup="true" CodeFile="Sales.aspx.cs" Inherits="NPO_Reports_Sales" %>
<%@ Reference Control="~/Controls/MenuBar.ascx" %>

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
            <label>Campaign Name</label>
            <asp:CheckBox ID="CampaignCheckBox" runat="server" />
            <asp:RadioButtonList ID="CampaignRBL" runat="server">
                <asp:ListItem Text="Contains" Value="Contains" Selected="True" />
                <asp:ListItem Text="Is Exactly" Value="IsExactly" />
            </asp:RadioButtonList>
            <asp:TextBox ID="CampaignTextBox" runat="server" />
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
            <label>Days Left in Campaign</label>
            <asp:CheckBox ID="DaysLeftCheckBox" runat="server" />
            <asp:RadioButtonList ID="DaysLeftRBL" runat="server">
                <asp:ListItem Text="Is Greater Than" Value="GT" Selected="True" />
                <asp:ListItem Text="Is Exactly" Value="Exactly" />
                <asp:ListItem Text="Is Less Than" Value="LT" />
            </asp:RadioButtonList>
            <asp:TextBox ID="DaysLeftTextBox" runat="server" />
            <ajaxToolkit:FilteredTextBoxExtender ID="FilteredTextBoxExtender3" runat="server"
                TargetControlID="DaysLeftTextBox" FilterType="Numbers">
            </ajaxToolkit:FilteredTextBoxExtender>
        </div>
        <div class="FormRow">
            <label>Percentage Reached</label>
            <asp:CheckBox ID="PercentCheckBox" runat="server" />
            <asp:RadioButtonList ID="PercentRBL" runat="server">
                <asp:ListItem Text="Is Greater Than" Value="GT" Selected="True" />
                <asp:ListItem Text="Is Exactly" Value="Exactly" />
                <asp:ListItem Text="Is Less Than" Value="LT" />
            </asp:RadioButtonList>
            <asp:TextBox ID="PercentTextBox" runat="server" />
            <ajaxToolkit:FilteredTextBoxExtender ID="MerchantTotalFTE" runat="server"
                TargetControlID="PercentTextBox" FilterType="Custom, Numbers" ValidChars=".">
            </ajaxToolkit:FilteredTextBoxExtender>
        </div>
        <div class="FormRow">
            <asp:Button ID="SubmitButton" runat="server" Text="Filter"
                OnClick="SubmitButton_Click" />
        </div>
    </div>
    <asp:GridView ID="ReportGV" runat="server" AutoGenerateColumns="False"
        AllowSorting="True" AllowPaging="True" OnPageIndexChanging="ReportGV_PageIndexChanging"
        OnSorting="ReportGV_Sorting">
        <Columns>
            <asp:BoundField DataField="Campaign" HeaderText="Campaign" />
            <asp:BoundField DataField="CouponsSold" HeaderText="Coupons Sold" />
            <asp:BoundField DataField="CouponsAvailable" HeaderText="Coupons Left" />
            <asp:BoundField DataField="DaysLeft" HeaderText="Days Left in Campaign" />
            <asp:BoundField DataField="PercentageReached" HeaderText="Percent Reached" DataFormatString="{0:P2}" />
        </Columns>
        <EmptyDataTemplate>
            <p>There was no data with the specified filters. Try being less specific!</p>
        </EmptyDataTemplate>
    </asp:GridView>
</asp:Content>