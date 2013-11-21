﻿<%@ Page Title="New Campaign" Language="C#" MasterPageFile="~/Site.master" AutoEventWireup="true" CodeFile="New.aspx.cs" Inherits="NPO_newCampaign" %>
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
                           $("#EndDate>#DayDDL").prop('disabled', 'disabled');
                           $("#EndDate>#MonthDDL").prop('disabled', 'disabled');
                           $("#EndDate>#YearDDL").prop('disabled', 'disabled');
                       }
                   });
               }
            );
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

                if ($("#DealInstances").html() == "") {

                    var day = $("#EndDate>#DayDDL").val();
                    var month = $("#EndDate>#MonthDDL").val();
                    var year = $("#EndDate>#YearDDL").val();
                    var date = month + " " + day + ", " + year;

                    PageMethods.GetGridView(date, function (result) {
                        $("#Offers").html(result);
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
    <img src="../../<%:npo.Logo %>" alt="Logo" />
    <p>Set up a campaign and include information like:</p>
    <ul>
        <li>What your campaign is all about?</li>
        <li>How much you want to raise?</li>
        <li>What will the funds will be use for?</li>
        <li>How long do you want to run your campaign?</li>
        <li>You can add photos and links directly to your social networks such as Facebook, Twitter, and LinkedIn</li>
        <li>Then add your merchant partners. You can invite as many merchants partners as you want to help you reach your goals. In other words, you can have multiple coupons listed on your campaign page.</li>
        <li>Your campaign page even has a thermometer to help measure your progress</li>
    </ul>
    <p>Your campaign page will also be your public page you can share with your network of donors and supporters.</p>
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
        <div class="FormRow">
            <label>Tell us about your Campaign</label>
            <asp:TextBox ID="newCampaignDescription" ClientIDMode="Static" runat="server" TextMode="MultiLine"></asp:TextBox>
            <div class="ClearFix"></div>
        </div>
        <div class="FormRow">
            <label>What will the funds be used for?</label>
            <asp:TextBox ID="newCampaignGoal" runat="server" ClientIDMode="Static" TextMode="MultiLine"></asp:TextBox>
            <div class="ClearFix"></div>
        </div>
        <div class="FormRow">
            <label>How long will your Campaign run for?</label>
        </div>
        <div class="FormRow">
            <label>Start Date</label>
            <UC:DateControl ID="StartDate" runat="server" AcceptPastDates="false" />
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
            <div id="Offers">
                <p><%: CouponsForGiving.Data.Classes.NPOs.HasMerchantPartners(User.Identity.Name) ? "There are no deals from your merchant partners whose dates coincide with yours. Consider revising the End Date of your campaign." : "You have not yet added any Merchant partners! <a href='../Partners/Add.aspx'>Click here</a> to add some to see their great deals." %></p>
            </div>
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