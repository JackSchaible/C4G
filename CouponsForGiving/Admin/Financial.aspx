<%@ Page Title="Financial Report" Language="C#" MasterPageFile="~/Site.master" AutoEventWireup="true" CodeFile="Financial.aspx.cs" Inherits="Admin_Financial" %>
<%@ Reference Control="~/Controls/MenuBar.ascx" %>
<%@ MasterType VirtualPath="~/Site.master" %>

<asp:Content ID="MainContent" ContentPlaceHolderID="Main_Content" Runat="Server">
    <script type="text/javascript">
        $(document).ready(function () {
            var filterState = $("#FilterState").val();
            if (filterState != undefined) {
                if (filterState == "Show") {
                    $("#FilterControl").text("Hide");
                    $("#FilterOptions").show();
                }
            }

            var value = $("#DateRBL input:radio:checked").val();
            if (value == "Between")
                $("#EndDateDiv").show();
            else
                $("#EndDateDiv").hide();


            $("#DateRBL input").change(function () {
                var value = $("#DateRBL input:radio:checked").val();
                if (value == "Between")
                    $("#EndDateDiv").slideDown(200);
                else
                    $("#EndDateDiv").slideUp(200);
            });
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
    <h1>Financial Report</h1>
    
    <hr>
    <h4>Filtering Options</h4>
    <asp:HiddenField ID="FilterState" runat="server" ClientIDMode="Static" />
    <a id="FilterControl" href="javascript:toggleFilter()" class="btn"><i class="fa fa-sort"></i> Show</a>
    <div id="FilterOptions" style="display: none;" class="FilterOptions">
        <div class="FormRow">
            <label><i class="fa fa-sort"></i> Coupon Name</label>
            <asp:CheckBox ID="CouponCheckBox" runat="server" />
            <asp:RadioButtonList ID="CouponNameRBL" runat="server">
                <asp:ListItem Text="Contains" Value="Contains" Selected="True" />
                <asp:ListItem Text="Is Exactly" Value="IsExactly" />
            </asp:RadioButtonList>
            <asp:TextBox ID="CouponName" runat="server" />
        </div>
        <div class="FormRow">
            <label>Merchant</label>
            <asp:CheckBox ID="MerchantCheckBox" runat="server" />
            <asp:RadioButtonList ID="MerchantRBL" runat="server">
                <asp:ListItem Text="Contains" Value="Contains" Selected="True" />
                <asp:ListItem Text="Is Exactly" Value="ISExactly" />
            </asp:RadioButtonList>
            <asp:TextBox ID="MerchantTextBox" runat="server" />
        </div>
        <div class="FormRow">
            <label>Total Paid Out to Merchant</label>
            <asp:CheckBox ID="MerchantTotalCheckBox" runat="server" />
            <asp:RadioButtonList ID="MerchantTotalRBL" runat="server">
                <asp:ListItem Text="Is Greater Than" Value="GT" Selected="True" />
                <asp:ListItem Text="Is Exactly" Value="Exactly" />
                <asp:ListItem Text="Is Less Than" Value="LT" />
            </asp:RadioButtonList>
            <asp:TextBox ID="MerchantTotalTextBox" runat="server" />
            <ajaxToolkit:FilteredTextBoxExtender ID="MerchantTotalFTE" runat="server"
                TargetControlID="MerchantTotalTextBox" FilterType="Custom, Numbers" ValidChars=".">
            </ajaxToolkit:FilteredTextBoxExtender>
        </div>
        <div class="FormRow">
            <label>Merchant Portion Collected</label>
            <asp:CheckBox ID="MerchantSplitCheckBox" runat="server" />
            <asp:RadioButtonList ID="MerchantSplitRBL" runat="server">
                <asp:ListItem Text="Is Greater Than" Value="GT" Selected="True" />
                <asp:ListItem Text="Is Exactly" Value="Exactly" />
                <asp:ListItem Text="Is Less Than" Value="LT" />
            </asp:RadioButtonList>
            <asp:TextBox ID="MerchantSplitTextBox" runat="server" />
            <ajaxToolkit:FilteredTextBoxExtender ID="FilteredTextBoxExtender1" runat="server"
                TargetControlID="MerchantSplitTextBox" FilterType="Custom, Numbers" ValidChars=".">
            </ajaxToolkit:FilteredTextBoxExtender>
        </div>
        <div class="FormRow">
            <label>NPO Portion Collected</label>
            <asp:CheckBox ID="NPOSplitCheckBox" runat="server" />
            <asp:RadioButtonList ID="NPOSplitRBL" runat="server">
                <asp:ListItem Text="Is Greater Than" Value="GT" Selected="True" />
                <asp:ListItem Text="Is Exactly" Value="Exactly" />
                <asp:ListItem Text="Is Less Than" Value="LT" />
            </asp:RadioButtonList>
            <asp:TextBox ID="NPOSplitTextBox" runat="server" />
            <ajaxToolkit:FilteredTextBoxExtender ID="FilteredTextBoxExtender2" runat="server"
                TargetControlID="NPOSplitTextBox" FilterType="Custom, Numbers" ValidChars="." FilterInterval="5">
            </ajaxToolkit:FilteredTextBoxExtender>
        </div>
        <div class="FormRow">
            <label>GenerUS Portion Collected</label>
            <asp:CheckBox ID="OurSplitCheckBox" runat="server" />
            <asp:RadioButtonList ID="OurSplitRBL" runat="server">
                <asp:ListItem Text="Is Greater Than" Value="GT" Selected="True" />
                <asp:ListItem Text="Is Exactly" Value="Exactly" />
                <asp:ListItem Text="Is Less Than" Value="LT" />
            </asp:RadioButtonList>
            <asp:TextBox ID="OurSplitTextBox" runat="server" />
            <ajaxToolkit:FilteredTextBoxExtender ID="FilteredTextBoxExtender3" runat="server"
                TargetControlID="OurSplitTextBox" FilterType="Custom, Numbers" ValidChars="." FilterInterval="5">
            </ajaxToolkit:FilteredTextBoxExtender>
        </div>
        <div class="FormRow">
            <label>GST</label>
            <asp:CheckBox ID="GSTCheckBox" runat="server" />
            <asp:RadioButtonList ID="GSTRBL" runat="server">
                <asp:ListItem Text="Is Greater Than" Value="GT" Selected="True" />
                <asp:ListItem Text="Is Exactly" Value="Exactly" />
                <asp:ListItem Text="Is Less Than" Value="LT" />
            </asp:RadioButtonList>
            <asp:TextBox ID="GSTTextBox" runat="server" />
            <ajaxToolkit:FilteredTextBoxExtender ID="FilteredTextBoxExtender4" runat="server"
                TargetControlID="GSTTextBox" FilterType="Custom, Numbers" ValidChars="." FilterInterval="5">
            </ajaxToolkit:FilteredTextBoxExtender>
        </div>
        <div class="FormRow">
            <label>Stripe Fee</label>
            <asp:CheckBox ID="StripeCheckBox" runat="server" />
            <asp:RadioButtonList ID="StripeRBL" runat="server">
                <asp:ListItem Text="Is Greater Than" Value="GT" Selected="True" />
                <asp:ListItem Text="Is Exactly" Value="Exactly" />
                <asp:ListItem Text="Is Less Than" Value="LT" />
            </asp:RadioButtonList>
            <asp:TextBox ID="StripeTextBox" runat="server" />
            <ajaxToolkit:FilteredTextBoxExtender ID="FilteredTextBoxExtender5" runat="server"
                TargetControlID="StripeTextBox" FilterType="Custom, Numbers" ValidChars="." FilterInterval="5">
            </ajaxToolkit:FilteredTextBoxExtender>
        </div>
        <div class="FormRow">
            <label>NPO Paid Out</label>
            <asp:CheckBox ID="NPOCheckBox" runat="server" />
            <asp:RadioButtonList ID="NPORBL" runat="server">
                <asp:ListItem Text="Contains" Value="Contains" Selected="True" />
                <asp:ListItem Text="Is Exactly" Value="IsExactly" />
            </asp:RadioButtonList>
            <asp:TextBox ID="NPOTextBox" runat="server" />
        </div>
        <div class="FormRow">
            <label>Refunded</label>
            <asp:CheckBox ID="RefundedCheckBox" runat="server" />
            <asp:RadioButtonList ID="RefundedRBL" runat="server">
                <asp:ListItem Text="Yes" Value="True" Selected="True" />
                <asp:ListItem Text="No" Value="False" />
            </asp:RadioButtonList>
        </div>
        <div class="FormRow">
            <label>Date</label>
            <asp:CheckBox ID="DateCheckBox" runat="server" />
            <asp:RadioButtonList ID="DateRBL" runat="server" ClientIDMode="Static">
                <asp:ListItem Text="Before" Value="Before" Selected="True" />
                <asp:ListItem Text="Exactly" Value="Exactly" />
                <asp:ListItem Text="After" Value="After" />
                <asp:ListItem Text="Between" Value="Between" />
            </asp:RadioButtonList>
            <label>Start Date</label>
            <UC:DateControl ID="StartDate" runat="server" AcceptFutureDates="false" />
            <div id="EndDateDiv" style="display: none;">
                <label>End Date</label>
                <UC:DateControl AcceptFutureDates="false" ID="EndDate" runat="server" />
            </div>
        </div>
        <div class="FormRow">
            <asp:Button ID="Submit" runat="server" OnClick="Submit_Click" Text="Filter" />
        </div>
    </div>
    <asp:GridView ID="ReportGV" runat="server" AutoGenerateColumns="False" AllowPaging="True" OnPageIndexChanging="ReportView_PageIndexChanging"
        AllowSorting="true" OnSorting="ReportView_Sorting" ShowFooter="true" OnRowDataBound="ReportGV_RowDataBound">
        <Columns>
            <asp:BoundField HeaderText="Coupon" DataField="Coupon" SortExpression="Coupon"/>
            <asp:BoundField DataField="MerchantAccount" HeaderText="Merchant Paid Out" SortExpression="MerchantAccount" />
            <asp:BoundField DataField="MerchantPay" DataFormatString="{0:c}" HeaderText="Total Amount Paid Out to Merchant" SortExpression="MerchantPay" />
            <asp:BoundField DataField="MerchantSplit" DataFormatString="{0:c}" HeaderText="Merchant Portion Collected" SortExpression="MerchantSplit" />
            <asp:BoundField DataField="NPOSplit" DataFormatString="{0:c}" HeaderText="NPO Portion Collected" SortExpression="NPOSplit" />
            <asp:BoundField DataField="OurSplit" DataFormatString="{0:c}" HeaderText="GenerUS Portion Collected" SortExpression="OurSplit" />
            <asp:BoundField DataField="GST" DataFormatString="{0:c}" HeaderText="GST" SortExpression="GST" />
            <asp:BoundField DataField="StripeFee" DataFormatString="{0:c}" HeaderText="Stripe Fee" SortExpression="StripeFee" />
            <asp:BoundField DataField="NPOAccount" HeaderText="NPO Paid Out" SortExpression="NPOAccount" />
            <asp:TemplateField HeaderText="Refunded" SortExpression="Refunded">
                <ItemTemplate>
                    <asp:Label ID="Label1" runat="server" Text='<%# Boolean.Parse(Eval("Refunded").ToString()) ? "Yes" : "No" %>'></asp:Label>
                </ItemTemplate>
            </asp:TemplateField>
            <asp:BoundField DataField="Date" DataFormatString="{0:dd MMMM yyyy}" HeaderText="Date" SortExpression="Date"/>
        </Columns>
        <FooterStyle CssClass="Report-Footer" />
        <EmptyDataTemplate>
            <p>There were no transactions with the specified parameters. Try being less specific!</p>
        </EmptyDataTemplate>
</asp:GridView>
</asp:Content>