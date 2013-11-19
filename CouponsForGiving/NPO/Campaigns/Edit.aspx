<%@ Page Title="Edit a Campaign" Language="C#" MasterPageFile="~/Site.master" AutoEventWireup="true" CodeFile="Edit.aspx.cs" Inherits="NPO_Campaigns_Edit" %>
<%@ Reference Control="~/Controls/MenuBar.ascx" %>

<asp:Content ID="Content1" ContentPlaceHolderID="HeadContent" Runat="Server">
    <style type="text/css">
        .TopContent {
            padding: 5px 0 0 0;
            width: 100%;
        }

        .TopContent img{
            width: 20%;
        }

        .TopContent h1 {
            display: block !important;
            padding: 0 0 20px 0 !important;
        }

        .FloatRight {
            float: right;
            padding: 0 0 0 2%;
            position: relative;
            width: 68%;
        }

        .FloatRight h1 {
            padding: 0 !important;
        }

        .FloatRight p {
            margin: 0 0 0 2% !important;
            width: auto !important;
        }

        #LeftContent {
            float: left;
            padding: 45px 0 0 0;
            width: 80%;
        }

        #Campaign {
            float: right;
            width: 20%;
        }

        #PG {
            bottom: 110px;
            left: 59px;
            position: absolute;
            width: 78px;
        }

        #FG {
            left: 60px;
            position: absolute;
            top: 40px;
        }

        #Thermo {
            padding: 0 0 0 30px;
            position: relative;
            width: 136px;
        }

        footer {
            clear: both;
        }

        #MainContent h2 {
            display: block;
            margin: 50px 0 0 0;
            text-align: center;
        }

        #MainContent h3 {
            font-size: 25px;
            text-align: center;
        }

        .FundingGoals {
            margin: 0 0 10px 70px !important;
        }

        #Campaign p {
            width: 200px;
        }

        .Campaign {
            margin: 50px 0 0 0;
        }

        .Campaign img {
            float: left;
            margin: 0 35px 0 0;
            width: 180px;
        }

        .Campaign h4 {
            display: block;
            text-align: center;
        }

        .Left, .Right {
            text-align: center;
            width: 50%;
        }

        .Left p, .Right p {
            width: auto !important;
        }

        .Left {
            float: left;
        }

        .Right {
            float: right;
        }

        #MidRow {
            min-height: 150px;
        }

        #topText {
            color: #333;
            font-style: italic;
            margin: 0 !important;
            opacity: 0.4;
            vertical-align: top;
            width: auto !important;
        }

        #MerchName {
            color: #18bee6;
            font-style: italic;
            font-weight: bolder !important;
            padding: 0 !important;
        }

        #Pricing {
            clear: both;
            min-height: 40px;
            width: 30%;
        }

        .priceUnit {
            float: left;
            width: 33%;
        }

        .priceUnit p {
            font-size: 140%;
            font-style: italic;
            margin: 0 !important;
            text-align: center;
            width: auto !important;
        }

        .tiny {
            color: #18bee6;
            font-size: 75% !important;
        }

        .BigLeft {
            float: left;
            position: relative;
            width: 80%;
        }

        #SocialText {
            padding: 35px 0 0 0;
            width: auto !important;
        }

        #CampaignImage {
            width: 150px;
        }

        #Deals {
        }

        #Deals img {
            width: 33%;
        }

        .Logo {
            width: 100% !important;
        }

        #Deals h3 {
            font-size: 15px;
        }

        td a {
            display: block;
            width: 64px;
        }

        .Offer {
            width: 25%;
        }

        #MainContent tr {
            border: 1px solid #BBB;
        }

        .Edit {
            cursor: pointer;
            position: absolute;
            right: -15px;
            top: 5px;
            width: 15px;
            z-index: 5;
        }

        .Control {
            position: relative;
            z-index: 5;
        }

        .EditDiv {
            display: inline-block;
            position: relative;
        }
    </style>
    <script type="text/javascript">
        var campaignID = encodeURIComponent('<%:(campaign == null) ? 0 : campaign.CampaignID%>');
        var username = encodeURIComponent('<%:(campaign == null) ? "0" : npo.cUsers.FirstOrDefault<CouponsForGiving.Data.cUser>().Username%>');
        var campaignName = encodeURIComponent('<%:(campaign == null) ? "0" : campaign.Name%>');
        var startDate = encodeURIComponent('<%:(campaign == null) ? DateTime.Now : campaign.StartDate%>');
        var endDate = encodeURIComponent('<%:(campaign == null) ? DateTime.Now : campaign.EndDate%>');
        var desc = encodeURIComponent('<%:(campaign == null) ? "0" : campaign.CampaignDescription%>');
        var fundraisingGoal = encodeURIComponent('<%:(campaign == null) ? 0 : campaign.FundraisingGoal%>');
        var image = encodeURIComponent('<%:(campaign == null) ? "0" : campaign.CampaignImage%>');
        var featured = encodeURIComponent('<%:(campaign == null) ? false : campaign.ShowOnHome%>');
        var goal = encodeURIComponent('<%:(campaign == null) ? "0" : campaign.CampaignGoal%>');

        window.setInterval(function () {
            Save();
        },
        120000);

        function Save() {
            PageMethods.SaveCampaign(campaignID, username, campaignName, startDate, endDate, desc,
                fundraisingGoal, image, featured, goal, function (result, userContext, methodName) {
                }
            );
        }

        function addDeal(dealInstanceID, name) {
            PageMethods.SaveCampaign(campaignID, username, campaignName, startDate, endDate, desc, fundraisingGoal,
                image, featured, goal, function (result, userContext, methodName) {
                   PageMethods.AddDealInstance(result, dealInstanceID, function (result, userContext, methodName) {
                       if (result != "false") {
                           __doPostBack();
                       }
                   });
               }
            );
        }

        function removeDeal(dealInstanceID) {
            PageMethods.RemoveDealInstance(dealInstanceID, $("#CampaignID").val(), function (result, userContext, methodName) {
                __doPostBack();
            });
        }

        //Functions for dynamic edit controls
        //Universal save fn
        function saveCampaign(callbackFunction) {
            PageMethods.SaveCampaign(campaignID, username, campaignName, startDate, endDate, desc, fundraisingGoal,
                image, featured, goal, function () {
                    callbackFunction();
                }
            );
        }

        //Campaign Name
        function editName() {
            $("#CampaignName").html('<input type="text" id="NameTextBox" style="border: 1px solid #BBB; padding: 0; color: #22bfe8; display: inline-block; font-family: Ubuntu, Corbel, Arial, sans-serif; font-size: 30px; font-weight: normal;" class="Control" value="<%: (campaign == null) ? "0" : campaign.Name %>" /><img class="Edit" src="../../Images/save.jpg" onClick="saveName()" />');
            $("#NameTextBox").focus();
        }

        function saveName() {
            campaignName = $("#NameTextBox").val();
            saveCampaign(nameCallback);
        }

        function nameCallback(result) {
            $("#CampaignName").html('<h1>' + campaignName + '</h1><img alt="Edit" class="Edit" src="../../Images/Edit.jpg" onclick="editName()">');
        }

        //Campaign Description
        function editDescription() {
            $("#CampaignDescription").html('<textarea id="DescriptionTextBox" style="border: 1px solid #BBB;" class="Control"><%: (campaign == null) ? "0" : campaign.CampaignDescription %></textarea><img class="Edit" src="../../Images/save.jpg" onClick="saveName()" />');
            $("#DescriptionTextBox").focus();
        }

        function saveDescription() {
            desc = $("#DescriptionTextBox").val();
            saveCampaign(descriptionCallback);
        }

        function descriptionCallback(result) {
            $("#CampaignDescription").html('<p>' + desc + '</p><img alt="Edit" class="Edit" src="../../Images/Edit.jpg" onclick="editDescription()">');
        }
    </script>
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="Main_Content" Runat="Server">
    <asp:HiddenField ID="CampaignID" ClientIDMode="Static" Value='<%: campaign.CampaignID %>' runat="server"/>
    <div class="TopContent">
            <a href="../MyHome.aspx">
                <h1><%: npo.Name %></h1>
                <img alt="Logo" src="../../<%: npo.Logo %>"/>
            </a>
        </div>
        <div id="LeftContent">
            <div id="CImage" class="EditDiv">
                <asp:ImageButton ID="EditImageButton" runat="server" CssClass="Edit ImgEdit" OnClick="EditImageButton_Click" ImageUrl="~/Images/edit.jpg" />
                <asp:Image runat="server" alt="Our Logo" ID="CampaignImage" ClientIDMode="Static" />
                <ajaxToolkit:AsyncFileUpload ID="ImageUpload" runat="server" OnClientUploadError="imgUploadError"
                    OnClientUploadComplete="imgUploadComplete" UploaderStyle="Traditional"
                    OnUploadedComplete="fileUploadComplete" Visible="false" ThrobberID="LoadingIMG"
                    UploadingBackColor="#CCFFFF" OnClientUploadStarted="imgUploadStarted" CssClass="Uploader"/>
                <div id="LoadImg"></div>
                <div class="ClearFix"></div>
            </div>
            <div class="FloatRight">
                <div id="CampaignName" class="EditDiv">
                    <h1><%: campaign.Name %></h1>
                    <img alt="Edit" class="Edit" src="../../Images/Edit.jpg" onclick="editName()" />
                </div>
                <div id="CampaignDescription" class="EditDiv">
                    <p><%: campaign.CampaignDescription %></p>
                    <img alt="Edit" class="Edit" src="../../Images/Edit.jpg" onclick="editDescription()" />
                </div>
            </div>
            <div id="MidRow">
                <div class="Left">
                    <h3>About Our Campaign</h3>
                    <p><%: campaign.CampaignDescription %></p>
                </div>
                <div class="Right">
                    <h3>Running Until</h3>
                    <p style="text-align: center;"><%: ((DateTime)(campaign.EndDate)).ToString("dddd, MMM dd, yyyy") %></p>
                </div>
                <div class="ClearFix"></div>
            </div>
            <div id="Deals">
                <h1>Purchase A Deal Now to Help Us Reach Our Goal!</h1>
                <asp:GridView ID="DealsGV" runat="server" DataKeyNames="CampaignID,DealInstanceID" 
                    AutoGenerateColumns="False">
                    <Columns>
                        <asp:HyperLinkField DataNavigateUrlFields="MerchantName,DealName" 
                            DataNavigateUrlFormatString="DealPage.aspx?merchantname={0}&amp;deal={1}" Text="More Info" />
                        <asp:TemplateField HeaderText="Merchant Partner">
                            <ItemTemplate>
                                    <h3><%# Eval("MerchantName") %></h3>
                                    <img class="Logo" alt="" src='../../<%# Eval("SmallLogo") %>' />
                            </ItemTemplate>
                        </asp:TemplateField>
                        <asp:BoundField DataField="DealName" HeaderText="Offer">
                            <ItemStyle CssClass="Offer"></ItemStyle>
                        </asp:BoundField>
                        <asp:ImageField DataImageUrlField="DealImage" DataImageUrlFormatString="../../{0}"></asp:ImageField>
                        <asp:BoundField DataField="Savings" DataFormatString="{0:c}" HeaderText="Savings"></asp:BoundField>
                        <asp:BoundField DataField="Price" DataFormatString="{0:c}" HeaderText="Price"></asp:BoundField>
                        <asp:CommandField SelectText="Buy Now!" ShowSelectButton="True"></asp:CommandField>
                    </Columns>
                </asp:GridView>
                <asp:Label ID="ErrorLabel" runat="server"></asp:Label>
            </div>
        </div>
        <div id="Campaign" ClientIDMode="static" runat="server">
            <div id="Thermo">
                <img ClientIDMode="static" runat="server" id="BG" alt="ThermoBG" src="../../Images/Thermo-BG.png" />
                <img ClientIDMode="static" runat="server" id="PG" alt="ThermoPG" src="../../Images/Thermo-Red.png" />
                <img ClientIDMode="static" runat="server" id="FG" alt="ThermoFG" src="../../Images/Thermo-FG.png" />
            </div>
            <p class="FundingGoals">$<%=(from po in campaign.PurchaseOrders select po.NPOSplit).Sum() %>/$<%=campaign.FundraisingGoal %></p>
        </div>
</asp:Content>