<%@ Page Title="New Campaign" Language="C#" MasterPageFile="~/Site.master" AutoEventWireup="true" CodeFile="New.aspx.cs" Inherits="NPO_newCampaign" %>
<%@ Reference Control="~/Controls/MenuBar.ascx" %>
<%@ Reference Control="~/Controls/DateControl.ascx" %>

<asp:Content ID="Content1" ContentPlaceHolderID="HeadContent" Runat="Server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="Main_Content" Runat="Server">
    <script type="text/javascript">
        //window.setInterval(function () {
        //    PageMethods.SaveCampaign($("#CampaignID").val(), $("#Username").val(), $("#newCampaignName").val(), $("#newCampaignStartDate").val(),
        //        $("#newCampaignEndDate").val(), $("#newCampaignDescription").val(), $("#newCampaignFundraisingGoal").val(),
        //        $("#newCampaignShowOnHome").val(), $("#newCampaignGoal").val(), function (result, userContext, methodName) {
        //            $("#CampaignID").val(result);
        //        }
        //    );
        //},
        //120000);

        function addDeal(dealInstanceID, name) {
            PageMethods.SaveCampaign($("#CampaignID").val(), $("#Username").val(), $("#newCampaignName").val(), $("#newCampaignDescription").val(), '', '',
               $("#newCampaignFundraisingGoal").val(), $("#newCampaignShowOnHome").val(), $("#newCampaignGoal").val(), function (result, userContext, methodName) {
                   $("#CampaignID").val(result);

                   PageMethods.AddDealInstance(result, dealInstanceID, function(result, userContext, methodName) {
                       if (result != "false") {
                           $("#DealInstances").append("<input id=\"" + dealInstanceID + "\" class=\"JoinButton\" type=\"button\" onclick=\"removeDeal(" + dealInstanceID + ")\" value=\"" + decodeURIComponent(name) + "\" />");
                       }
                   });
               }
            );
        }

        function removeDeal(dealInstanceID) {
            PageMethods.RemoveDealInstance(dealInstanceID, $("#CampaignID").val(), function(result, userContext, methodName) {
                if (result == "Success!")
                    $("#" + dealInstanceID).remove();
            });
        }
    </script>
    <style type="text/css">
        #MainContent img {
            float: right;
            width: 30%;
        }
    </style>
    <h1>New <%: npo.Name %> Campaign</h1>
    <img src="../../<%:npo.Logo %>" alt="Logo" />
    <p>
        <asp:Label ID="ErrorLabel" runat="server"></asp:Label>
    </p>
    <div id="Form" style="width: 600px;">
        <div class="FormRow">
            <asp:Label ID="Label1" runat="server" Text="What is the name of your Campaign? "></asp:Label>
            <asp:TextBox ID="newCampaignName" ClientIDMode="Static" runat="server" MaxLength="256"></asp:TextBox>
        </div>
        <div class="FormRow">
            <asp:Label ID="Label4" runat="server" Text="Tell us about your Campaign: "></asp:Label>
            <asp:TextBox ID="newCampaignDescription" ClientIDMode="Static" runat="server" TextMode="MultiLine"></asp:TextBox>
            <div class="ClearFix"></div>
        </div>
        <div class="FormRow">
            <asp:Label ID="Label6" runat="server" Text="Upload a Campaign Image: "></asp:Label>
            <asp:FileUpload ID="newCampaignImage" runat="server" />
            <div class="ClearFix"></div>
        </div>
        <div class="FormRow">
            <asp:Label ID="Label9" runat="server" Text="What will the funds be used for? "></asp:Label>
            <asp:TextBox ID="newCampaignGoal" runat="server" ClientIDMode="Static" TextMode="MultiLine"></asp:TextBox>
            <div class="ClearFix"></div>
        </div>
        <div class="FormRow">
            <asp:Label ID="Label10" runat="server" Text="How long will your Campaign run for? "></asp:Label>
        </div>
        <div class="FormRow"></div>
            <asp:Label ID="Label2" runat="server" Text="Start Date: "></asp:Label>
            <UC:DateControl ID="StartDate" runat="server" AcceptPastDates="false" AutoPostBack="true" />
            <div class="ClearFix"></div>
        </div>
        <div class="FormRow">
            <asp:Label ID="Label3" runat="server" Text="End Date: "></asp:Label>
            <UC:DateControl ID="EndDate" runat="server" AcceptPastDates="false" AutoPostBack="true" />
            <div class="ClearFix"></div>
        </div>
        <div class="FormRow">
            <asp:Label ID="Label5" runat="server" Text="What is your Target Fundraising Goal?"></asp:Label>
            <asp:TextBox ID="newCampaignFundraisingGoal" ClientIDMode="Static" runat="server" MaxLength="15"></asp:TextBox>
            <ajaxToolkit:FilteredTextBoxExtender ID="FilteredTextBoxExtender1" TargetControlID="newCampaignFundraisingGoal" FilterType="Numbers" runat="server"></ajaxToolkit:FilteredTextBoxExtender>
            <div class="ClearFix"></div>
        </div>
        <div class="FormRow">
            <asp:Label ID="Label11" runat="server" Text="Your Eligible Deals:"></asp:Label>
            <asp:GridView ID="EligibleDeals_GV" runat="server" AutoGenerateColumns="False" Width="530px" AllowPaging="True" AllowSorting="True" OnPageIndexChanging="EligibleDeals_GV_PageIndexChanging" PageSize="5" DataKeyNames="DealInstanceID">
                <Columns>
                    <asp:TemplateField ShowHeader="False">
                        <ItemTemplate>
                            <input style="cursor: pointer;" type="button" onclick="addDeal(<%# Eval("DealInstanceID") %>, '<%# Server.UrlEncode(Eval("Name").ToString()).Replace("+", "%20") %>')" value="Add Deal" />
                        </ItemTemplate>
                    </asp:TemplateField>
                    <asp:HyperLinkField DataNavigateUrlFields="MerchantName,Name" DataNavigateUrlFormatString="../../Default/DealPage.aspx?merchantname={0}&amp;deal={1}" Text="View" />
                    <asp:BoundField DataField="MerchantName" HeaderText="Merchant" />
                    <asp:BoundField DataField="Name" HeaderText="Deal" />
                    <asp:BoundField DataField="StartDate" DataFormatString="{0:MMM dd, yyyy}" HeaderText="Start Date" />
                    <asp:BoundField DataField="EndDate" DataFormatString="{0:MMM dd, yyyy}" HeaderText="End Date" />
                </Columns>
                <EmptyDataTemplate>
                    <p><%: CouponsForGiving.Data.Classes.NPOs.HasMerchantPartners(User.Identity.Name) ? "There are no deals from your merchant partners whose dates coincide with yours. Consider revising the End Date of your campaign." : "You have not yet added any Merchant partners! <a href='../Partners/Add.aspx'>Click here</a> to add some to see their great deals." %></p>
                </EmptyDataTemplate>
            </asp:GridView>
            <div id="DealInstances"></div>
            <div class="ClearFix"></div>
        </div>
        <div class="FormRow">
            <asp:Label ID="Label8" runat="server" Text="Make this my featured campaign"></asp:Label>
            <asp:CheckBox ID="newCampaignShowOnHome" ClientIDMode="Static" runat="server" Checked="false" />
            <div class="ClearFix"></div>
        </div>
        <div class="FormRow">
            <asp:Label ID="Label7" runat="server" Text="Link to Your Social Networks: "></asp:Label>
            <p>Coming Soon!</p>
            <!--<asp:ImageButton ID="Facebook" runat="server" ImageUrl="~/Images/fb.png" OnClick="Facebook_Click"/>
            <asp:ImageButton ID="Twitter" runat="server" ImageUrl="~/Images/twitter.png" OnClick="Twitter_Click" />-->
            <div class="ClearFix"></div>
        </div>
        <div class="FormRow">
            <asp:Button ID="newCampaignSubmit" runat="server" Text="Save" OnClick="newCampaignSubmit_Click" />
        </div>
    </div>
    <asp:HiddenField ID="CampaignID" ClientIDMode="Static" runat="server" />
    <asp:HiddenField ID="Username" ClientIDMode="Static" runat="server" />
    <asp:ValidationSummary ID="ValidationSummary1" runat="server" ForeColor="Red" />
</asp:Content>