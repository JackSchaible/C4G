<%@ Page Title="Home" Language="C#" MasterPageFile="~/Site.master" AutoEventWireup="true" CodeFile="MyHome.aspx.cs" Inherits="Merchant_Home" %>
<%@ Reference Control="~/Controls/MenuBar.ascx" %>

<asp:Content ID="Content1" ContentPlaceHolderID="HeadContent" Runat="Server">
    <style type="text/css">
        #MainContent h1 {
            margin: 0 0 5% 0;
            text-align: center;
            width: 100%;
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

        #MainContent p {
            margin: 0 !important;
        }

        .Campaign {
            border-top: none !important;
            border-radius: 0;
            padding: 1%;
        }

        #Campaigns a {
            color: #FFF;
            background-color: #22bfe8;
            border-radius: 7px;
            font-family: Corbel, Arial, sans-serif;
            padding: 5px 10px;
            text-decoration: none;
        }

        #Campaigns {
            margin: 0 auto;
            width: 60%;
        }

        #Logo {
            float: right;
            margin: 30px 10% 5% 0;
            width: 33%;
        }

        #Text {
            float: left;
            padding: 0 0 0 10%;
            width: 40%;
        }

        #Featured, .Campaign {
            border: 1px solid #BBB;
        }

        #Featured {
            border-top-left-radius: 5px;
            border-top-right-radius: 5px;
            position: relative;
        }

        #Featured img {
            border-radius: 5px;
            float: left;
            margin: 0 0 0 5%;
        }

        #Featured a {
            display: inline-block;
            font-size: 40px;
            margin: 4% 0 0 9%;
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
    </style>
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="Main_Content" Runat="Server">
    <script type="text/javascript">
        var npoid = encodeURIComponent('<%: (npo == null) ? 0 : npo.NPOID %>');
        var name = encodeURIComponent('<%: (npo == null) ? "0" : npo.Name %>');
        var description = '<%:Server.UrlEncode((npo == null) ? "0" : npo.NPODescription)%>';
        var address = encodeURIComponent('<%: (npo == null) ? "0" : npo.cAddress%>');
        var cityID = encodeURIComponent('<%: (npo == null) ? 0 : npo.CityID%>');
        var postalcode = encodeURIComponent('<%: (npo == null) ? "0" : npo.PostalCode%>');
        var website = encodeURIComponent('<%: (npo == null) ? "0" : npo.Website%>');
        var phoneNumber = encodeURIComponent('<%: (npo == null) ? "0" : npo.PhoneNumber%>');
        var email = encodeURIComponent('<%: (npo == null) ? "0" : npo.Email%>');
        var statusid = encodeURIComponent('<%: (npo == null) ? 0 : npo.StatusID%>');
        var logo = encodeURIComponent('<%: (npo == null) ? "0" : npo.Logo%>');
        var url = encodeURIComponent('<%: (npo == null) ? "0" : npo.URL%>');
        var imageFile = "";
        var imageType = "";

        //3 Controls for each field: on edit click, save, and callback
        //Name functions
        function editName() {
            $("#Name").html('<input type="text" id="NameTextBox" class="Control" value="<%: (npo == null) ? "0" : npo.Name%>" /> <img class="Edit" src="../Images/save.jpg" onClick="saveName()" />');
            $("#NameTextBox").focus();
        }

        function saveName() {
            name = $("#NameTextBox").val();
            save("NameTextBox", nameCallback);
        }

        function nameCallback() {
            $("#Name").html('<h1>' + name + '</h1><img onclick="editName()" alt="Edit" class="Edit" id="NameEdit" src="../Images/edit.jpg" />');
        }

        //Description
        function editDescription() {
            $("#Description").html('<textarea class="Control" id="DescriptionTextBox"><%: (npo == null) ? "0" : npo.NPODescription%></textarea> <img class="Edit" src="../Images/save.jpg" onclick="saveDescription()" />');
            $("#DescriptionTextBox").focus();
        }

        function saveDescription() {
            description = $("#DescriptionTextBox").val();
            save("DescriptionTextBox", descriptionCallback);
        }

        function descriptionCallback() {
            $("#Description").html('<img onclick="editDescription()" alt="Edit" class="Edit" id="DescEdit" src="../Images/edit.jpg" /><p id="DescriptionText">' + description + '</p>');
        }
        
        function imgUploadStarted() {
            $("#LoadImg").html('<img alt="Loading" src="../Images/loading.gif" />');
        }

        function fileUploadComplete() {
            $("#LoadImg").html('');
        }

        //Universal save function
        function save(controlID, callbackFunction) {
            PageMethods.Save(npoid, name, description, address, cityID, postalcode, website, phoneNumber, email, statusid, logo, url, function () {
                callbackFunction();
            });
        }

        function reload() {
            __doPostBack();
        }
    </script>
    <style type="text/css">
        #MainContent .HeaderButton {
            display: inline-block;
            margin: 2% 0 2% 0;
        }

        #Name, #Description, #Image {
            position: relative;
        }

        /*Controls*/
        #NameTextBox {
            border: 1px solid #BBB;
            color: #22bfe8;
            display: inline-block;
            font-family: Ubuntu, Corbel, Arial, sans-serif;
            font-size: 30px;
            font-weight: normal;
            margin: 5px 0 5% 0;
            padding: 20px 0 5px 0;
            text-align: center;
            width: 100%;
        }

        #DescriptionTextBox {
            font-family: Ubuntu, Corbel, Arial, sans-serif;
            font-size: 20px;
            margin: 0 auto;
            text-align: justify;
        }

        .ImgEdit {
            margin: 30px 10% 0 0;
        }

        .Uploader {
            margin: 100px 0 0 0;
            position: absolute;
            top: 0;
            right: 0;
        }
    </style>
    <div id="NPO">
        <div id="Text">
            <div id="Name">
                <img onclick="editName()" alt="Edit" class="Edit" id="NameEdit" src="../Images/edit.jpg" />
                <h1><%: npo.Name %></h1>
            </div>
            <div id="Description">
                <img onclick="editDescription()" alt="Edit" class="Edit" id="DescEdit" src="../Images/edit.jpg" />
                <p id="DescriptionText"><%: npo.NPODescription %></p>
            </div>
        </div>
        <div id="Image">
            <asp:ImageButton ID="EditImageButton" runat="server" CssClass="Edit ImgEdit" OnClick="EditImageButton_Click" ImageUrl="~/Images/edit.jpg" />
            <asp:Image runat="server" alt="Our Logo" ID="Logo" ClientIDMode="Static" />
            <ajaxToolkit:AsyncFileUpload ID="ImageUpload" runat="server" OnClientUploadError="imgUploadError"
                OnClientUploadComplete="imgUploadComplete" UploaderStyle="Traditional"
                OnUploadedComplete="fileUploadComplete" Visible="false" ThrobberID="LoadingIMG"
                UploadingBackColor="#CCFFFF" OnClientUploadStarted="imgUploadStarted" CssClass="Uploader"/>
            <div id="LoadImg"></div>
            <div class="ClearFix"></div>
        </div>
    </div>
    <asp:Panel ID="Campaigns" ClientIDMode="Static" runat="server">
        <h2>Our Campaigns</h2>
        <div id="Featured">
            <asp:Panel ID="FeaturedCampaign" runat="server">
                <img class="Edit" onclick="window.location='Campaigns/Edit.aspx?cid=<%:featured.CampaignID%>'" src="../Images/edit.jpg" />
                <img alt="Featured Campaign Image" src="../<%: featured.CampaignImage %>" />
                <a href="Campaigns/View.aspx?cid=<%: featured.CampaignID %>"><%: featured.Name %></a>
                <div class="ClearFix"></div>
            </asp:Panel>
        </div>
        <%
            foreach (CouponsForGiving.Data.Campaign oc in (from c in npo.Campaigns where c.ShowOnHome == false && c.StartDate < DateTime.Now && c.EndDate > DateTime.Now select c))
                Response.Write("<div class=\"Campaign\"><a href=\"CampaignPage.aspx?nponame=" + npo.URL + "&campaign=" + Server.UrlEncode(oc.Name) + "\">" + oc.Name + "</a></div>");
        %>
        <a href="Campaigns/New.aspx" class="btn">New Campaign</a>
    </asp:Panel>
</asp:Content>