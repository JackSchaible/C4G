<%@ Page Title="New Account" Language="C#" MasterPageFile="~/Site.master" AutoEventWireup="true" CodeFile="Signup.aspx.cs" Inherits="Merchant_Signup" %>
<%@ Reference Control="~/Controls/MenuBar.ascx" %>

<asp:Content ID="Content1" ContentPlaceHolderID="HeadContent" Runat="Server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="Main_Content" Runat="Server">
    <script type="text/javascript">
        $(document).ready(initForm);

        function initForm() {
            checkForm(true);
        }

        function checkFirstName(write) {
            var firstName = $("#FirstNameTextBox").val();
            var errors = new Array();

            if (IsStringBlank(firstName))
                errors.push('<%: strings.SelectSingleNode("/SiteText/Pages/Signup/ErrorMessages/NullFirstName").InnerText %>');

            if (IsStringTooLong(firstName, 64))
                errors.push('<%: strings.SelectSingleNode("/SiteText/Pages/Signup/ErrorMessages/FirstNameTooLong").InnerText %>');

            if (containsCode(firstName)) {
                errors.push('<%: strings.SelectSingleNode("/SiteText/Pages/Signup/ErrorMessages/FirstNameInvalidCharacters").InnerText %>');
            }

            if (arguments.length == 0) {
                writeErrors("FirstNameTextBoxErrors", errors);
                checkForm();
            }

            return errors;
        }

        function checkLastName(write) {
            var lastName = $("#LastNameTextBox").val();
            var errors = new Array();

            if (IsStringBlank(lastName))
                errors.push('<%: strings.SelectSingleNode("/SiteText/Pages/Signup/ErrorMessages/NullLastName").InnerText %>');

            if (IsStringTooLong(lastName, 64))
                errors.push('<%: strings.SelectSingleNode("/SiteText/Pages/Signup/ErrorMessages/LastNameTooLong").InnerText %>');

            if (containsCode(lastName)) {
                errors.push('<%: strings.SelectSingleNode("/SiteText/Pages/Signup/ErrorMessages/LastNameInvalidCharacters").InnerText %>');
            }

            if (arguments.length == 0) {
                writeErrors("LastNameTextBoxErrors", errors);
                checkForm();
            }

            return errors;
        }

        function checkYourPhoneNumber(write) {
            var phoneNumber = $("#YourPhoneNumberTextBox").val();
            var errors = new Array();

            if (IsStringBlank(phoneNumber))
                errors.push('<%: strings.SelectSingleNode("/SiteText/Pages/Signup/ErrorMessages/NullPhoneNumber").InnerText %>');

            if (!validPhoneNumber(phoneNumber))
                errors.push('<%: strings.SelectSingleNode("/SiteText/Pages/Signup/ErrorMessages/InvalidPhoneNumber").InnerText %>');

            if (IsStringTooLong(phoneNumber, 20))
                errors.push('<%: strings.SelectSingleNode("/SiteText/Pages/Signup/ErrorMessages/PhoneNumberTooLong").InnerText %>');

            if (containsCode(phoneNumber)) {
                errors.push('<%: strings.SelectSingleNode("/SiteText/Pages/Signup/ErrorMessages/PhoneNumberInvalidCharacters").InnerText %>');
            }

            if (arguments.length == 0) {
                writeErrors("YourPhoneNumberTextBoxErrors", errors);
                checkForm();
            }

            return errors;
        }

        function checkBusinessName(write) {
            var name = $("#BusinessNameTextBox").val();
            var errors = new Array();

            if (IsStringBlank(name))
                errors.push('<%: strings.SelectSingleNode("/SiteText/Pages/Signup/ErrorMessages/NullBusinessName").InnerText %>');

            if (IsStringTooLong(name, 64))
                errors.push('<%: strings.SelectSingleNode("/SiteText/Pages/Signup/ErrorMessages/BusinessNameTooLong").InnerText %>');

            if (containsCode(name))
                errors.push('<%: strings.SelectSingleNode("/SiteText/Pages/Signup/ErrorMessages/BusinessNameInvalidCharacters").InnerText %>');

            if (arguments.length == 0) {

                PageMethods.IsNameTaken(name, function (message) {
                    if (message == "true") {
                        $("#BusinessNameTextBoxErrors").css('display', 'block');
                        $("#BusinessNameTextBoxErrors").html('<ul><li><%: strings.SelectSingleNode("/SiteText/Pages/Signup/ErrorMessages/BusinessNameTaken").InnerText %></li></ul>');
                        $("#SubmitButton").attr('disabled', 'disabled');
                        checkForm();
                    }
                    else {
                        $("#BusinessNameTextBoxErrors").css('display', 'none');
                        $("#SubmitButton").removeAttr('disabled');
                        checkForm();
                    }
                });

                writeErrors("BusinessNameTextBoxErrors", errors);
                checkForm();
            }

            return errors;
        }

        function checkDescription(write) {
            var description = $("#DescriptionTextBox").val();
            var errors = new Array();

            if (IsStringBlank(description))
                errors.push('<%: strings.SelectSingleNode("/SiteText/Pages/Signup/ErrorMessages/NullDescription").InnerText %>');

            if (IsStringTooLong(description, 160))
                errors.push('<%: strings.SelectSingleNode("/SiteText/Pages/Signup/ErrorMessages/DescriptionTooLong").InnerText %>');

            if (IsStringTooShort(description, 10))
                errors.push('<%: strings.SelectSingleNode("/SiteText/Pages/Signup/ErrorMessages/DescriptionTooShort").InnerText %>');

            if (containsCode(description))
                errors.push('<%: strings.SelectSingleNode("/SiteText/Pages/Signup/ErrorMessages/DescriptionInvalidCharacters").InnerText %>');

            if (!ContainsSpaces(description))
                errors.push('<%: strings.SelectSingleNode("/SiteText/Pages/Signup/ErrorMessages/DescriptionOneWord").InnerText %>');

            if (arguments.length == 0) {
                writeErrors("DescriptionTextBoxErrors", errors);
                checkForm();
            }

            return errors;
        }

        function checkAddress(write) {
            var address = $("#AddressTextBox").val();
            var errors = new Array();

            if (IsStringBlank(address))
                errors.push('<%: strings.SelectSingleNode("/SiteText/Pages/Signup/ErrorMessages/NullAddress").InnerText %>');

            if (arguments.length == 0) {
                writeErrors("AddressTextBoxErrors", errors);
                checkForm();
            }

            return errors;
        }

        function checkCity(write) {
            var city = $("#SelectedCity").html();
            var errors = new Array();

            if (IsStringBlank(city))
                errors.push('<%: strings.SelectSingleNode("/SiteText/Pages/Signup/ErrorMessages/NullCity").InnerText %>');

            if (arguments.length == 0) {
                writeErrors('CityError', errors);
                checkForm();
            }

            return errors;
        }

        function goPostal(write) {
            var postal = $("#ZipCodeTextBox").val();
            var errors = new Array();

            if (IsStringBlank(postal))
                errors.push('<%: strings.SelectSingleNode("/SiteText/Pages/Signup/ErrorMessages/NullPostal").InnerText %>');

            if (IsStringTooShort(postal, 5))
                errors.push('<%: strings.SelectSingleNode("/SiteText/Pages/Signup/ErrorMessages/PostalTooShort").InnerText %>');

            if (arguments.length == 0) {
                writeErrors("ZipCodeTextBoxErrors", errors);
                checkForm();
            }

            return errors;
        }

        function checkBusinessPhone(write) {
            var phoneNumber = $("#PhoneNumberTextBox").val();
            var errors = new Array();

            if (!IsStringBlank(phoneNumber)) {
                if (IsStringBlank(phoneNumber))
                    errors.push('<%: strings.SelectSingleNode("/SiteText/Pages/Signup/ErrorMessages/NullPhoneNumber").InnerText %>');

                if (!validPhoneNumber(phoneNumber))
                    errors.push('<%: strings.SelectSingleNode("/SiteText/Pages/Signup/ErrorMessages/InvalidPhoneNumber").InnerText %>');

                if (IsStringTooLong(phoneNumber, 20))
                    errors.push('<%: strings.SelectSingleNode("/SiteText/Pages/Signup/ErrorMessages/PhoneNumberTooLong").InnerText %>');

                if (containsCode(phoneNumber)) {
                    errors.push('<%: strings.SelectSingleNode("/SiteText/Pages/Signup/ErrorMessages/PhoneNumberInvalidCharacters").InnerText %>');
                }

                if (arguments.length == 0) {
                    writeErrors("PhoneNumberTextBoxErrors", errors);
                    checkForm();
                }
            }

            return errors;
        }

        function checkYourEmail(write) {
            var email = $("#YourEmailTextBox").val();
            var errors = new Array();

            if (!IsStringBlank(email)) {

                if (IsStringBlank(email))
                    errors.push('<%: strings.SelectSingleNode("/SiteText/Pages/Signup/ErrorMessages/NullEmail").InnerText %>');

                if (IsStringTooShort(email, 6))
                    errors.push('<%: strings.SelectSingleNode("/SiteText/Pages/Signup/ErrorMessages/EmailTooShort").InnerText %>');

                if (IsStringTooLong(email, 64))
                    errors.push('<%: strings.SelectSingleNode("/SiteText/Pages/Signup/ErrorMessages/EmailTooLong").InnerText %>');

                if (containsCode(email))
                    errors.push('<%: strings.SelectSingleNode("/SiteText/Pages/Signup/ErrorMessages/EmailInvalidCharacters").InnerText %>');

                if (arguments.length == 0) {
                    writeErrors('YourEmailTextBoxErrors', errors);
                    checkForm();
                }
            }

            return errors;
        }

        function checkWebsite(write) {
            var website = $("#URLTextBox").val();
            var errors = new Array();

            if (IsStringBlank(website))
                errors.push('<%: strings.SelectSingleNode("/SiteText/Pages/Signup/ErrorMessages/NullWebsite").InnerText %>');

            if (IsStringTooShort(website, 8))
                errors.push('<%: strings.SelectSingleNode("/SiteText/Pages/Signup/ErrorMessages/WebsiteTooShort").InnerText %>');

            if (arguments.length == 0) {
                writeErrors('URLTextBoxErrors', errors);
                checkForm(); 
            }

            return errors;
        }

        function checkTermsCheckBox(write) {
            var checked = $("#TermsCheckBox").is(":checked");
            var errors = new Array();

            if (!checked)
                errors.push('<%: strings.SelectSingleNode("/SiteText/Pages/Signup/ErrorMessages/AgreeToTerms").InnerText %>');

            if (arguments.length == 0) {
                writeErrors('TermsCheckBoxErrors', errors);
                checkForm();
            }

            return errors;
        }

        function submitForm() {
            var errors = checkForm(false);

            if (errors.length > 0) {
                errors.splice(0, 0, '<%: strings.SelectSingleNode("/SiteText/Pages/Signup/ErrorMessages/FormErrors").InnerText %>');
                writeErrors('FormErrors', errors);
            }
            else {
                var firstName = $("#FirstNameTextBox").val();
                var lastName = $("#LastNameTextBox").val();
                var phone = $("#YourPhoneNumberTextBox").val();
                var businessName = $("#BusinessNameTextBox").val();
                var description = $("#DescriptionTextBox").val();
                var address = $("#AddressTextBox").val();
                var city = $("#SelectedCity").html();
                var postal = $("#ZipCodeTextBox").val();
                var contactPhone = $("#PhoneNumberTextBox").val();
                var contactEmail = $("#YourEmailTextBox").val();
                var website = $("#URLTextBox").val();
                var globalMerchant = $("#GlobalMarketplaceCheckBox").is(":checked");
                var autoAccept = $("#AutoAcceptRequestsCheckBox").is(":checked");
                var businessType = $("#BusinessTypeDDL option:selected").text();
                var birthDate = $("#DayDDL").val() + "/" + $("#MonthDDL").val() + "/" + $("#YearDDL").val();
                var physicalProduct = $('input:radio[name$="PhysicalProductRBL"]:checked').val();
                var productType = $("#ProductTypesDDL option:selected").text();
                var currency = $('input:radio[name$="CurrencyRBL"]:checked').val();

                PageMethods.ConnectToStripe(firstName, lastName, phone, businessName, description,
                    address, city, postal, contactPhone, contactEmail, website, globalMerchant,
                    autoAccept, businessType, birthDate, physicalProduct, productType, currency,
                    function (message) {
                        window.location.replace(message);
                    },
                    function (message) {
                        $("#FormErrors").css('display', 'block');
                        $("#FormErrors").html('' + message._message + '');
                    });
            }
        }

        function checkForm(disableButton) {
            var errors = new Array();
            errors.push.apply(errors, checkFirstName(false));
            errors.push.apply(errors, checkLastName(false));
            errors.push.apply(errors, checkYourPhoneNumber(false));
            errors.push.apply(errors, checkBusinessName(false));
            errors.push.apply(errors, checkDescription(false));
            errors.push.apply(errors, checkAddress(false));
            errors.push.apply(errors, checkCity(false));
            errors.push.apply(errors, goPostal(false));
            errors.push.apply(errors, checkBusinessPhone(false));
            errors.push.apply(errors, checkYourEmail(false));
            errors.push.apply(errors, checkWebsite(false));
            errors.push.apply(errors, checkTermsCheckBox(false));

            if (arguments.length == 0) {
                if (errors.length > 0)
                    $("#SubmitButton").attr('disabled', 'disabled');
                else
                    $("#SubmitButton").removeAttr('disabled');
            }

            return errors;
        }
    </script>
    <%--Supporting form functions--%>
    <script>
        var reader;
        var progress = document.querySelector('.percent');

        $(document).ready(function () {
            PageMethods.GetCities('', function (data) {
                window.cities = data.split(';');
            });
            window.imagePath = '../Images/c4g_home_step4.png';
            document.getElementById("Image").addEventListener('change', checkImage, false);
        });

        function getCities() {
            var text = $("#CityTextBox").val();

            if (text.length > 2) {
                var cities = new Array();
                var output = "";

                for (var i = 0; i < window.cities.length; i++)
                    if (window.cities[i].toLowerCase().indexOf(text.toLowerCase()) != -1)
                        cities.push(window.cities[i]);

                output += "<ul>";

                if (cities.length < 1)
                    output += "<li><%: strings.SelectSingleNode("/SiteText/Pages/Signup/ErrorMessages/NoCity").InnerText %></li>";
                else
                    for (var i2 = 0; i2 < cities.length; i2++)
                        output += "<li><a onclick='setCity(\"" + cities[i2] + "\")'>" + cities[i2] + "</a></li>";

                output += "</ul>";

                $("#CitiesAutoCompleteBox").html(output);
            }
        }

        function setCity(city) {
            $("#SelectedCity").html('<p>' + city + '</p>');
            $("#CityID").html(city);
            $("#CityTextBox").val(city);
            $("#CitiesAutoCompleteBox").html('');

            $("#SelectedCity").click(function () {
                $("#SelectedCity").html('');

                $("#CityID").html('');
            });
        }

        function notify() {
            if ($("#AutoAcceptRequestsCheckBox").is(':checked'))
                $("#AARErrors").html('<ul><li><%: strings.SelectSingleNode("/SiteText/Pages/Signup/ErrorMessages/AARNotification").InnerText %></li></ul>');
            else
                $("#AARErrors").html('');
        }

        function checkImage(evt) {
            var file = evt.target.files[0];
            var errors = new Array();

            if (file != undefined) {
                if (!IsImage(file))
                    errors.push('<%: strings.SelectSingleNode("/SiteText/Pages/Signup/ErrorMessages/ImageTypeInvalid").InnerText %>');

                if (!IsImageProfileSized(file))
                    errors.push('<%: strings.SelectSingleNode("/SiteText/Pages/Signup/ErrorMessages/ImageSizeInvalid").InnerText %>');

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
                        window.imagePath = filePath;
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
            errors.push('<%: strings.SelectSingleNode("/SiteText/Pages/Signup/ErrorMessages/UploadError").InnerText %>');
            writeErrors('ImageErrors', errors);
        }
    </script>
        <h1>Profile Page Setup</h1>
        <p> 
            Set up your profile with information about your business. 
            This page will now be your public page so that customers 
            and not-for-profits can learn about you. You can include 
            images and your social media channels.You can share with 
            your social network causes  you are supporting. 
        </p>
        <p>To ensure the best experience for all, <strong>the Coupons4Giving will review and approve all registrations</strong>.</p>
        <p>When you register with Coupons4Giving, we automatically set you up with <a href="https://stripe.com/ca" target="_blank">Stripe</a>. Stripe is an easy and effective payment processor and will deposit directly into your bank account.</p>
        <h2>Payment Terms:</h2>
        <p><strong>You must have a bank account and business number (GST or Tax ID number)</strong> in order to set up a Stripe account. Stripe directly deposits money into your account.</p>
        <p>Tell us about your organization:</p>
        <hr>
        <div class="Form">
            <%--Basic Information --%>
            <h3>Tell Us About Yourself and Your Business:</h3>
            <p><asp:Label ID="newMerchantMessage" runat="server"></asp:Label></p>
            <div class="FormRow">
                <label>First Name</label>
                <asp:TextBox ID="FirstNameTextBox" ClientIDMode="Static" runat="server" placeholder="First Name" onkeyup="checkFirstName()"
                    onblur="checkFirstName()" oninput="checkFirstName()" MaxLength="64"></asp:TextBox>
                <div class="ErrorDiv" id="FirstNameTextBoxErrors"></div>
            </div>
            <div class="FormRow">
                <label>Last Name</label>
                <asp:TextBox ID="LastNameTextBox" ClientIDMode="Static" runat="server" placeholder="Last Name"
                    onkeyup="checkLastName()" onblur="checkLastName()" oninput="checkLastName()" MaxLength="64"></asp:TextBox>
                <div class="ErrorDiv" id="LastNameTextBoxErrors"></div>
            </div>
            <div class="FormRow">
                <label>Phone Number</label>
                <asp:TextBox ID="YourPhoneNumberTextBox" ClientIDMode="Static" runat="server" placeholder="555-123-4567" onkeyup="checkYourPhoneNumber()"
                    onblur="checkYourPhoneNumber()" oninput="checkYourPhoneNumber()" MaxLength="20"></asp:TextBox>
                <div class="ErrorDiv" id="YourPhoneNumberTextBoxErrors"></div>
            </div>
            <div class="FormRow">
                <label>Name of Your Business</label>
                <asp:TextBox ID="BusinessNameTextBox" ClientIDMode="Static" runat="server" placeholder="Business Name"
                    onkeyup="checkBusinessName()" onblur="checkBusinessName()" oninput="checkBusinessName()" MaxLength="64"></asp:TextBox>
                <div class="ErrorDiv" id="BusinessNameTextBoxErrors"></div>
            </div>
            <div class="FormRow TextAreaRow">
                <label>Description</label>
                <asp:TextBox ID="DescriptionTextBox" ClientIDMode="Static" runat="server" TextMode="MultiLine" MaxLength="200"
                    onkeyup="checkDescription()" onblur="checkDescription()" oninput="checkDescription()"></asp:TextBox>
                <div class="ErrorDiv" id="DescriptionTextBoxErrors"></div>
                <div class="ClearFix"></div>
            </div>
            <div class="FormRow">
                <label>Logo<br /><small>This will be your logo on Coupons4Giving.</small></label>
                <input id="Image" name="files[]" type="file" />
                <div class="centered">
                	<input id="UploadButton" type="button" onclick="uploadImage()" value="Upload" disabled="disabled" />
                	<div id="ImageErrors" class="ErrorDiv"></div>
                	<div id="Loading" class="hide"><img src="../Images/loading.gif" alt="Loading"/><p>Loading...</p></div>
                	<div class="clear"></div>
                	<div id="UploadedImage"><img src="../Images/c4g_home_step4.png" alt="DefaultProfilePic" /></div>
                </div>
            </div>
            <%--Contact Information --%>
            <h4>Contact Information:</h4>
            <div class="FormRow">
                <label>Street Address</label>
                <asp:TextBox ID="AddressTextBox" ClientIDMode="Static" runat="server" placeholder="1234, 5th Street" onkeyup="checkAddress()"
                    onblur="checkAddress()" oninput="checkAddress()"></asp:TextBox>
                <div class="ErrorDiv" id="AddressTextBoxErrors"></div>
            </div>
            <div class="FormRow">
                <label>City<br /><small>Please select from the list below.</small></label>
                <asp:TextBox ID="CityTextBox" runat="server" ClientIDMode="Static" onkeyup="getCities()"></asp:TextBox>
                <div id="CitiesAutoCompleteBox" class="AutoCompleteBox"></div>
                <div id="SelectedCity" class="hide"></div>
                <div id="CityID" class="hide"></div>
                <div class="ErrorDiv" id="CityError"></div>
                <div class="ClearFix"></div>
            </div>
            <div class="FormRow">
                <label>Postal/Zip Code</label>
                <asp:TextBox ID="ZipCodeTextBox" runat="server" ClientIDMode="Static" MaxLength="16" placeholder="T6L2M9, 90210, or 90210-1234"
                    onkeyup="goPostal()" onblur="goPostal()" oninput="goPostal()"></asp:TextBox>
                <div class="ErrorDiv" id="ZipCodeTextBoxErrors"></div>
            </div>
            <div class="FormRow">
                <label>Phone Number<br /><small>(if different from above)</small></label>
                <asp:TextBox ID="PhoneNumberTextBox" runat="server" onkeyup="checkBusinessPhone()" onblur="checkBusinessPhone()" 
                    oninput="checkBusinessPhone()" ClientIDMode="Static"></asp:TextBox>
                <div id="PhoneNumberTextBoxErrors" class="ErrorDiv"></div>
            </div>
            <div class="FormRow">
                <label>Email<small>(if different from the one you used to register)</small></label>
                <asp:TextBox ID="YourEmailTextBox" runat="server" TextMode="Email" placeholder="yourname@yourorganization.com"
                    ClientIDMode="Static" onkeyup="checkYourEmail()" onblur="checkYourEmail()" oninput="checkYourEmail()"></asp:TextBox>
                <div id="YourEmailTextBoxErrors" class="ErrorDiv"></div>
            </div>
            <div class="FormRow">
                <label>Website</label>
                <asp:TextBox ID="URLTextBox" ClientIDMode="Static" runat="server" 
                    placeholder="http://www.mycompanywebsite.com" onkeyup="checkWebsite()" onblur="checkWebsite()"
                    oninput="checkWebsite()"></asp:TextBox>
                <div id="URLTextBoxErrors" class="ErrorDiv"></div>
            </div>
            <%-- Additional Settings --%>
            <h4>Additional Settings</h4>
            <div class="FormRow">
                <asp:Label ID="AARLabel" runat="server" Text="Accept All Not-For-Profit Partner Requests" 
                    AssociatedControlID="AutoAcceptRequestsCheckBox"></asp:Label>
                <asp:CheckBox ID="AutoAcceptRequestsCheckBox" runat="server" Checked="true" 
                    onClick="notify()" ClientIDMode="Static"/>
                <div id="AARErrors" class="ErrorDiv"></div>
            </div>
            <div class="FormRow">
                <label>Are you an online-only merchant or e-Tailer?</label>
                <input id="GlobalMarketplaceCheckBox" type="checkbox" />
            </div>
            <%--Additional Information --%>
            <h4>Additional Information (For Stripe)</h4>
            <div class="FormRow">
                <asp:Label ID="Label5" runat="server" Text="Business Type" AssociatedControlID="BusinessTypeDDL"></asp:Label>
                <asp:DropDownList ID="BusinessTypeDDL" runat="server" ClientIDMode="Static">
                    <asp:ListItem Value="corporation">Corporation</asp:ListItem>
                    <asp:ListItem Value="sole_prop">Sole Proprietorship</asp:ListItem>
                    <asp:ListItem Value="partnership">Partnership</asp:ListItem>
                    <asp:ListItem Value="llc">Limited-Liability Company</asp:ListItem>
                </asp:DropDownList>
            </div>
            <div class="FormRow">
                <label>Do you sell a physical product?</label>
                <asp:RadioButtonList ID="PhysicalProductRBL" runat="server" ClientIDMode="Static">
                    <asp:ListItem Value="true">Yes</asp:ListItem>
                    <asp:ListItem Value="false">No</asp:ListItem>
                </asp:RadioButtonList>
                <div class="ClearFix"></div>
            </div>
            <div class="FormRow">
                <asp:Label ID="Label15" runat="server" Text="What type of product do you deal with?" 
                    AssociatedControlID="ProductTypesDDL"></asp:Label>
                <asp:DropDownList ID="ProductTypesDDL" runat="server" ClientIDMode="Static">
                    <asp:ListItem Value="art_and_graphic_design">Arts &amp; Graphic Design</asp:ListItem>
                    <asp:ListItem Value="advertising">Advertising</asp:ListItem>
                    <asp:ListItem Value="clothing_and_accessories">Clothing &amp; Accessories</asp:ListItem>
                    <asp:ListItem Value="consulting">Consulting</asp:ListItem>
                    <asp:ListItem Value="clubs_and_membership_organizations">Clubs &amp; Membership Organizations</asp:ListItem>
                    <asp:ListItem Value="education">Education</asp:ListItem>
                    <asp:ListItem Value="events_and_ticketing">Events &amp; Ticketing</asp:ListItem>
                    <asp:ListItem Value="food_and_restaurants">Food &amp; Restaurants</asp:ListItem>
                    <asp:ListItem Value="software">Software</asp:ListItem>
                    <asp:ListItem Value="professional_services">Professional Services</asp:ListItem>
                    <asp:ListItem Value="tourism_and_travel">Tourism &amp; Travel</asp:ListItem>
                    <asp:ListItem Value="web_development">Web Development</asp:ListItem>
                    <asp:ListItem Value="other">Other</asp:ListItem>
                </asp:DropDownList>
            </div>
            <div class="FormRow">
                <asp:Label ID="Label8" runat="server" Text="Birth Date" AssociatedControlID="BirthDate"></asp:Label>
                <UC:DateControl ID="BirthDate" runat="server" />
            </div>
            <div class="FormRow">
                <asp:Label ID="Label19" runat="server" Text="Currency" AssociatedControlID="CurrencyRBL"></asp:Label>
                <asp:RadioButtonList ID="CurrencyRBL" runat="server" DataSourceID="CurrenciesXDS" DataTextField="name" DataValueField="code"
                    ClientIDMode="Static" CssClass="Currencies"></asp:RadioButtonList>
                <asp:XmlDataSource ID="CurrenciesXDS" runat="server" DataFile="~/SupportedCurrencies.xml"></asp:XmlDataSource>
                <div class="ClearFix"></div>
            </div>
            <div class="FormRow">
                <iframe src="../Content/Terms/MerchantServicesAgreement.txt" style="width: 100%;"></iframe>
                <span class="checkbox-singlerow">
                <asp:CheckBox ID="TermsCheckBox" ClientIDMode="Static" runat="server" class="checkbox-singlerow" onchange="checkTermsCheckBox()"/>
                <label class="checkbox-singlerow-termscheckbox">I have read and agree to the Terms & Conditions.</label>
                </span>
                <div id="TermsCheckBoxErrors" class="ErrorDiv"></div>
            </div>
            <div class="FormRow">
                <input type="button" id="SubmitButton" value="Connect To Stripe!" onclick="submitForm()">
                <div id="FormErrors" class="ErrorDiv"></div>
            </div>
        </div>
</asp:Content>