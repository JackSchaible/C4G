<%@ Page Title="New Campaign" Language="C#" MasterPageFile="~/Site.master" AutoEventWireup="true" CodeFile="New.aspx.cs" Inherits="NPO_newCampaign" %>
<%@ Reference Control="~/Controls/MenuBar.ascx" %>
<%@ Reference Control="~/Controls/DateControl.ascx" %>

<asp:Content ID="Content2" ContentPlaceHolderID="Main_Content" Runat="Server">
    <script type="text/javascript">
        function addDeal(dealInstanceID, name) {
            var startDate = $("#StartDate>#DayDDL").val() + '-' + $("#StartDate>#MonthDDL").val() + '-' + $("#StartDate>#YearDDL").val();
            var endDate = $("#EndDate>#DayDDL").val() + '-' + $("#EndDate>#MonthDDL").val() + '-' + $("#EndDate>#YearDDL").val();

            console.log(startDate);
            console.log(endDate);

            PageMethods.SaveCampaign($("#CampaignID").val(), $("#Username").val(), $("#newCampaignName").val(), $("#newCampaignDescription").val(), startDate, endDate,
               $("#newCampaignFundraisingGoal").val(), $("#newCampaignShowOnHome").val(), $("#newCampaignGoal").val(), function (result, userContext, methodName) {
                   $("#CampaignID").val(result);

                   PageMethods.AddDealInstance(result, dealInstanceID, function(result, userContext, methodName) {
                       if (result != "false") {
                           $("#DealInstances").append("<input id=\"" + dealInstanceID + "\" class=\"JoinButton\" type=\"button\" onclick=\"removeDeal(" + dealInstanceID + ")\" value=\"" + decodeURIComponent(name) + "\" />");
                           $("#EndDate>#DayDDL").prop('disabled', 'disabled');
                           $("#EndDate>#MonthDDL").prop('disabled', 'disabled');
                           $("#EndDate>#YearDDL").prop('disabled', 'disabled');
                           $("#OfferMessage").hide();
                       }
                   });
               }
            );

            $("#DealAddConfirmation").show();
            window.setInterval(function () {
                $("#DealAddConfirmation").hide();
            }, 5000);
        }

        function removeDeal(dealInstanceID) {
            PageMethods.RemoveDealInstance(dealInstanceID, $("#CampaignID").val(), function(result, userContext, methodName) {
                if (result == "Success!")
                    $("#" + dealInstanceID).remove();

                if ($("#DealInstances").html() == "") {
                    $("#EndDate>#DayDDL").prop('disabled', false);
                    $("#EndDate>#MonthDDL").prop('disabled', false);
                    $("#EndDate>#YearDDL").prop('disabled', false);
                }
            });
        }

        $(document).ready(function () {

            $("#EndDate>select").change(function (e) {

                if ($("#DealInstances").html().indexOf("<table>") == -1) {
                    var day = $("#EndDate>#DayDDL").val();
                    var month = $("#EndDate>#MonthDDL").val();
                    var year = $("#EndDate>#YearDDL").val();
                    var date = month + " " + day + ", " + year;

                    PageMethods.GetGridView(date, function (result) {
                        $("#Offers").append(result);
                    });

                }

            });

        });

    </script>
    <style type="text/css">
        #MainContent img {
            float: right;
            width: 30%;
        }
    </style>
    <h1>New <%: npo.Name %> Campaign</h1>
    <img src="../../<%: npo.Logo %>" class="campaign_logo" />
    <p>Set up a campaign and include information like:</p>
    <div class="actionList">
        <ul>
            <li class="info">What your campaign is all <strong>about?</strong></li>
            <li class="info">How much you want to <strong>raise?</strong></li>
            <li class="info">What will the funds will be <strong>use for?</strong></li>
            <li class="info">How long do you want to run your <strong>campaign?</strong></li>
            <li class="info">You can add photos and links directly to your social networks such as <strong>Facebook</strong>, <strong>Twitter</strong>, and <strong>LinkedIn</strong></li>
            <li class="info">Then <strong>add your merchant partners</strong>. You can invite as many merchants partners as you want to help you reach your goals. In other words, you can have multiple coupons listed on your campaign page.</li>
            <li class="info">Your campaign page even has a thermometer to help <strong>measure your progress</strong></li>
        </ul>
    </div>
    <hr>
    <h2>Build Your Campaign Page</h2>
    <p>Your campaign page will also be your public page you can <strong>share with your network of donors and supporters</strong>.</p>
    <asp:Label ID="ErrorLabel" runat="server"></asp:Label>
    <ul>
        <%
            foreach (string item in Errors)
                Response.Write(String.Format("<li>{0}</li>", item));
        %>
    </ul>
    <div id="Form" style="width: 600px;">
        <div class="FormRow">
            <label>What is the name of your Campaign?</label>
            <asp:TextBox ID="newCampaignName" ClientIDMode="Static" runat="server" MaxLength="256"></asp:TextBox>
        </div>
        <div class="FormRow TextAreaRow">
            <label>Tell us about your Campaign</label>
            <asp:TextBox ID="newCampaignDescription" ClientIDMode="Static" runat="server" TextMode="MultiLine" MaxLength="200"></asp:TextBox>
            <div class="ClearFix"></div>
        </div>
        <div class="FormRow TextAreaRow">
            <label>What will the funds be used for?</label>
            <asp:TextBox ID="newCampaignGoal" runat="server" ClientIDMode="Static" TextMode="MultiLine"></asp:TextBox>
            <div class="ClearFix"></div>
        </div>
        <div class="FormRow">
            <label>How long will your Campaign run for?</label>
        </div>
        <div class="FormRow">
            <label>Start Date</label>
            <UC:DateControl ID="StartDate" runat="server" AcceptPastDates="false" ClientIDMode="Static" />
            <div class="ClearFix"></div>
        </div>
        <div class="FormRow">
            <label>End Date <small>You will be unable to change this if you have any deals selected.</small></label>
            <UC:DateControl ID="EndDate" runat="server" AcceptPastDates="false" ClientIDMode="Static" />
            <div class="ClearFix"></div>
        </div>
        <div class="FormRow">
            <asp:Label ID="Label6" runat="server" Text="Upload a Campaign Image: "></asp:Label>
            <asp:FileUpload ID="newCampaignImage" runat="server" />
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
            <p style="display:none;" id="DealAddConfirmation">You have successfully added a deal to your campaign.</p>
            <div id="Offers">
                <% Response.Write(CouponsForGiving.Data.Classes.NPOs.HasMerchantPartners(User.Identity.Name) ? "<p>There are no deals from your merchant partners whose dates coincide with yours. Consider revising the End Date of your campaign.</p>" : "<p>You have not yet added any Merchant partners! <a href='../Partners/Add.aspx'>Click here</a> to add some to see their great deals.</p>"); %>
            </div>
            <div id="DealInstances">
                <p>These are your current campaign offers. Click to remove.</p>
            </div>
            <div class="ClearFix"></div>
        </div>
        <div class="FormRow">
            <asp:Label ID="Label8" runat="server" Text="Make this my featured campaign"></asp:Label>
            <asp:CheckBox ID="newCampaignShowOnHome" ClientIDMode="Static" runat="server" Checked="false" />
            <div class="ClearFix"></div>
        </div>
        <div class="FormRow">
            <p id="OfferMessage">Don't forget to add your eligible deals before you save!</p>
            <asp:Button ID="newCampaignSubmit" runat="server" Text="Save" OnClick="newCampaignSubmit_Click" />
        </div>
    </div>
    <asp:HiddenField ID="CampaignID" ClientIDMode="Static" runat="server" />
    <asp:HiddenField ID="Username" ClientIDMode="Static" runat="server" />
    <asp:ValidationSummary ID="ValidationSummary1" runat="server" ForeColor="Red" />
</asp:Content>