<%@ Page Title="" Language="C#" MasterPageFile="~/Site.master" AutoEventWireup="true" CodeFile="Edit.aspx.cs" Inherits="Merchant_Edit" %>
<%@ Reference Control="~/Controls/MenuBar.ascx" %>

<asp:Content ID="Content4" ContentPlaceHolderID="Main_Content" Runat="Server">
    <script type="text/javascript">
        $(document).ready(function () {
            document.getElementById("Image").addEventListener('change', checkImage, false);
        });

        function checkImage(evt) {
            var file = evt.target.files[0];
            var errors = new Array();

            if (file != undefined) {
                if (!IsImage(file))
                    errors.push('Your image is an invalid type. Images must be a jpg, png, gif, pjpeg, or svg.');

                if (!IsImageProfileSized(file))
                    errors.push('Your image is an invalid size.');

                writeErrors('ImageErrors', errors);

                if (errors.length == 0)
                    $("#UploadButton").removeAttr('disabled');
                else
                    $("#UploadButton").attr('disabled', 'disabled');
            }
        }

        function uploadImage() {
            var file = $("#Image")[0].files[0];

            if (file != undefined) {

                $.ajax({
                    url: '../ImageUploader.ashx',
                    type: 'POST',
                    xhr: function () {
                        var myxhr = $.ajaxSettings.xhr();

                        if (myxhr.upload)
                            myxhr.upload.addEventListener('progress', 'progressHandler', false);

                        return myxhr;
                    },
                    beforeSend: function () {
                        $("#Loading").css('display', 'block');
                    },
                    success: function () {
                        $("#Loading").css('display', 'none');
                        var folderPath = '../tmp/Images/Signup';
                        var fileName = '<%: HttpContext.Current.User.Identity.Name + "logo" %>';
                        var ext = '';
                        var contentType = file.type;

                        switch (contentType) {
                            case "image/gif":
                                ext = ".gif";
                                break;

                            case "image/jpeg":
                                ext = ".jpg";
                                break;

                            case "image/png":
                                ext = ".png";
                                break;

                            case "image/pjpeg":
                                ext = ".jpg";
                                break;

                            case "image/svg+xml":
                                ext = ".svg";
                                break;

                            default:
                                ext = ".jpg";
                                break;
                        }

                        var filePath = folderPath + "/" + fileName + ext;
                        $("#UploadedImage").html('<img onclick="removeImage()" alt="Your profile image" src="' + filePath + '" />');
                        $("#ImageURL").val(filePath);
                    },
                    error: uploadError,
                    data: file,
                    cache: false,
                    contentType: false,
                    processData: false
                });
            }
        }

        function removeImage() {
            $("#UploadedImage").html('<img src="../Images/c4g_home_step4.png" alt="DefaultProfilePic" />');
            window.imagePath = '../Images/c4g_home_step4.png';
        }

        function uploadError() {
            var errors = new Array();
            errors.push('There was an error uploading your image.');
            writeErrors('ImageErrors', errors);
        }
    </script>
    <h1>Edit My Profile</h1>
    <div class="Form">
        <div class="FormRow">
            <label>Name</label>
            <asp:TextBox ID="NameTextBox" runat="server" 
                placeholder="First Name" MaxLength="64"></asp:TextBox>
            <asp:RequiredFieldValidator ID="RequiredFieldValidator1"
                runat="server" ErrorMessage="Name is required." 
                ControlToValidate="NameTextBox">
            </asp:RequiredFieldValidator>
        </div>
        <div class="FormRow">
            <label>Profile Image</label>
            <input id="Image" name="files[]" type="file" />
            <div class="centered">
                <input id="UploadButton" type="button" onclick="uploadImage()" value="Upload" disabled="disabled" />
                <div id="ImageErrors" class="ErrorDiv"></div>
                <div id="Loading" class="hide"><img src="../Images/loading.gif" alt="Loading"/><p>Loading...</p></div>
                <div class="clear"></div>
                <div id="UploadedImage"><asp:Image ID="ProfileImage" runat="server" /></div>
            </div>
            <asp:HiddenField ID="ImageURL" ClientIDMode="Static" 
                runat="server" />
        </div>
        <div class="FormRow">
            <label>Address</label>
            <asp:TextBox ID="AddressTextBox" runat="server" 
                placeholder="First Name" MaxLength="64"></asp:TextBox>
            <asp:RequiredFieldValidator ID="RequiredFieldValidator2"
                runat="server" ErrorMessage="Address is required." 
                ControlToValidate="AddressTextBox">
            </asp:RequiredFieldValidator>
        </div>
        <div class="FormRow">
                <label>Select a Country</label>
                <asp:DropDownList ID="CountryDDL" runat="server" AutoPostBack="true"
                    DataTextField="Name" DataValueField="CountryCode">
                </asp:DropDownList>
        </div>
        <div class="FormRow">
            <label>Select a Province or State</label>
            <asp:DropDownList ID="PDDDL" runat="server" AutoPostBack="true"
                DataTextField="Name" DataValueField="PoliticalDivisionID">
            </asp:DropDownList>
        </div>
        <div class="FormRow">
            <label>Select a City</label>
            <asp:DropDownList ID="CityDDL" runat="server"
                DataTextField="Name" DataValueField="CityID">
            </asp:DropDownList>
        </div>
        <div class="FormRow">
            <label>Postal Code</label>
            <asp:TextBox ID="PostalTextBox" runat="server"
                MaxLength="16" 
                placeholder="T6L2M9, 90210, or 90210-1234">
            </asp:TextBox>
            <asp:RequiredFieldValidator 
                ID="RequiredFieldValidator3" runat="server" 
                ErrorMessage="Postal code is required."
                ControlToValidate="PostalTextBox">
            </asp:RequiredFieldValidator>
        </div>
        <div class="FormRow">
            <label>Phone Number</label>
            <asp:TextBox ID="PhoneNumberTextBox" runat="server"
                MaxLength="20" placeholder="555-123-4567">
            </asp:TextBox>
            <asp:RequiredFieldValidator 
                ID="RequiredFieldValidator4" runat="server" 
                ErrorMessage="Postal code is required."
                ControlToValidate="PhoneNumberTextBox">
            </asp:RequiredFieldValidator>
        </div>
        <div class="FormRow">
            <label>Website</label>
            <asp:TextBox ID="WebsiteTextBox" runat="server"
                placeholder="http://www.mycompanywebsite.com">
            </asp:TextBox>
            <asp:RequiredFieldValidator 
                ID="RequiredFieldValidator5" runat="server" 
                ErrorMessage="Website is required."
                ControlToValidate="WebsiteTextBox">
            </asp:RequiredFieldValidator>
        </div>
        <div class="FormRow">
            <label>Email</label>
            <asp:TextBox ID="EmailTextBox" runat="server"
                placeholder="yourname@yourorganization.com">
            </asp:TextBox>
            <asp:RequiredFieldValidator 
                ID="RequiredFieldValidator6" runat="server" 
                ErrorMessage="Email is required."
                ControlToValidate="EmailTextBox">
            </asp:RequiredFieldValidator>
        </div>
        <div class="FormRow">
            <asp:Label ID="ErrorLabel" runat="server"></asp:Label>
            <asp:Button ID="SubmitButton" 
                runat="server" Text="Submit" 
                OnClick="SubmitButton_Click" />
        </div>
    </div>
</asp:Content>