﻿<%@ Page Title="New Account" Language="C#" MasterPageFile="~/Site.master" AutoEventWireup="true" CodeFile="Signup.aspx.cs" Inherits="Merchant_Signup" %>
<%@ Reference Control="~/Controls/MenuBar.ascx" %>

<asp:Content ID="Content1" ContentPlaceHolderID="HeadContent" Runat="Server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="Main_Content" Runat="Server">
    <script type="text/javascript">
        $(document).ready(initForm);

        function initForm() {
            checkForm();
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

            if (name.trim().length == 0)
                errors.push('<%: strings.SelectSingleNode("/SiteText/Pages/Signup/ErrorMessages/NullBusinessName").InnerText %>');

            if (arguments.length == 0) {
                writeErrors("BusinessNameTextBoxErrors", errors);
                checkForm();
            }

            return errors;
        }

        function checkDescription(write) {
            var description = $("#DescriptionTextBox").val();
            var errors = new Array();

            if (description.trim().length == 0)
                errors.push('<%: strings.SelectSingleNode("/SiteText/Pages/Signup/ErrorMessages/NullDescription").InnerText %>');

            if (description.trim().length > 200)
                errors.push('<%: strings.SelectSingleNode("/SiteText/Pages/Signup/ErrorMessages/DescriptionTooLong").InnerText %>');

            if (description.trim().length < 10)
                errors.push('<%: strings.SelectSingleNode("/SiteText/Pages/Signup/ErrorMessages/DescriptionTooShort").InnerText %>');

            if (containsCode(description))
                errors.push('<%: strings.SelectSingleNode("/SiteText/Pages/Signup/ErrorMessages/DescriptionInvalidCharacters").InnerText %>');

            if (description.trim().indexOf(" ") == -1)
                errors.push('<%: strings.SelectSingleNode("/SiteText/Pages/Signup/ErrorMessages/DescriptionOneWord").InnerText %>');

            if (arguments.length == 0) {
                writeErrors("DescriptionTextBoxErrors", errors);
                checkForm();
            }

            return errors;
        }

        function checkForm() {
            var errors = new Array();
            errors.push.apply(errors, checkFirstName(false));
            errors.push.apply(errors, checkLastName(false));
            errors.push.apply(errors, checkYourPhoneNumber(false));
            errors.push.apply(errors, checkBusinessName(false));
            errors.push.apply(errors, checkDescription(false));

            if (errors.length > 0)
                $("#SubmitButton").attr('disabled', 'disabled');
            else
                $("#SubmitButton").removeAttr('disabled');
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
            <h3>Tell Us About Yourself and Your Business:</h3>
            <p><asp:Label ID="newMerchantMessage" runat="server"></asp:Label></p>
            <div class="FormRow">
                <asp:Label ID="Label6" runat="server" Text="First Name" AssociatedControlID="FirstNameTextBox"></asp:Label>
                <asp:TextBox ID="FirstNameTextBox" ClientIDMode="Static" runat="server" placeholder="Joe" onkeyup="checkFirstName()"
                    onblur="checkFirstName()" oninput="checkFirstName()" MaxLength="64"></asp:TextBox>
                <div class="ErrorDiv" id="FirstNameTextBoxErrors"></div>
            </div>
            <div class="FormRow">
                <asp:Label ID="Label7" runat="server" Text="Last Name" AssociatedControlID="LastNameTextBox"></asp:Label>
                <asp:TextBox ID="LastNameTextBox" ClientIDMode="Static" runat="server" placeholder="Smith"
                    onkeyup="checkLastName()" onblur="checkLastName()" oninput="checkLastName()" MaxLength="64"></asp:TextBox>
                <div class="ErrorDiv" id="LastNameTextBoxErrors"></div>
            </div>
            <div class="FormRow">
                <asp:Label ID="Label23" runat="server" Text="Phone Number" AssociatedControlID="YourPhoneNumberTextBox"></asp:Label>
                <asp:TextBox ID="YourPhoneNumberTextBox" ClientIDMode="Static" runat="server" placeholder="555-123-4567" onkeyup="checkYourPhoneNumber()"
                    onblur="checkYourPhoneNumber()" oninput="checkYourPhoneNumber()" MaxLength="20"></asp:TextBox>
                <div class="ErrorDiv" id="YourPhoneNumberTextBoxErrors"></div>
            </div>
            <div class="FormRow">
                <asp:Label ID="Label4" runat="server" Text="Name of Your Business" AssociatedControlID="BusinessNameTextBox"></asp:Label>
                <asp:TextBox ID="BusinessNameTextBox" ClientIDMode="Static" runat="server" placeholder="Business Name"
                    onkeyup="checkBusinessName()" onblur="checkBusinessName()" oninput="checkBusinessName()" MaxLength="64"></asp:TextBox>
                <div class="ErrorDiv" id="BusinessNameTextBoxErrors"></div>
            </div>
            <div class="FormRow TextAreaRow">
                <asp:Label AssociatedControlID="DescriptionTextBox" ID="DescLabel" runat="server" Text="Description"></asp:Label>
                <asp:TextBox ID="DescriptionTextBox" ClientIDMode="Static" runat="server" TextMode="MultiLine" MaxLength="200"
                    onkeyup="checkDescription()" onblur="checkDescription()" oninput="checkDescription()"></asp:TextBox>
                <div class="ErrorDiv" id="DescriptionTextBoxErrors"></div>
            </div>
            <h4>Contact Information:</h4>
            <div class="FormRow">
                <asp:Label ID="Label9" runat="server" Text="Street Address"
                   AssociatedControlID="AddressTextBox"></asp:Label>
                <asp:TextBox ID="AddressTextBox" runat="server" placeholder="1234, 5th Street"></asp:TextBox>
            </div>
            <div class="FormRow">
                <label>City <small>Please select from the dropdown.</small></label>
                <asp:TextBox ID="CityTextBox" runat="server"></asp:TextBox>
                <ajaxToolkit:AutoCompleteExtender ID="CityACE" runat="server" 
                    CompletionInterval="0" MinimumPrefixLength="1" UseContextKey="True" 
                    TargetControlID="CityTextBox" ServiceMethod="GetCompletionList">
                </ajaxToolkit:AutoCompleteExtender>
                <div class="ClearFix"></div>
            </div>
            <div class="FormRow">
                <asp:Label ID="Label11" runat="server" Text="Postal/Zip Code" AssociatedControlID="ZipCodeTextBox"></asp:Label>
                <asp:TextBox ID="ZipCodeTextBox" runat="server" MaxLength="16"></asp:TextBox>
            </div>
            <div class="FormRow">
                <label>Phone Number<br /><small>(if different from above)</small></label>
                <asp:TextBox ID="PhoneNumberTextBox" runat="server" MaxLength="11"></asp:TextBox>
            </div>
            <div class="FormRow">
                <asp:Label ID="AARLabel" runat="server" Text="Accept All Not-For-Profit Partner Requests" 
                    AssociatedControlID="AutoAcceptRequestsCheckBox"></asp:Label>
                <asp:CheckBox ID="AutoAcceptRequestsCheckBox" runat="server" Checked="true" 
                    onClick="notify()" ClientIDMode="Static"/>
            </div>
            <div class="FormRow">
                <label>Email<small>(if different from the one you used to register)</small></label>
                <asp:TextBox ID="YourEmailTextBox" runat="server" TextMode="Email"></asp:TextBox>
            </div>
            <div class="FormRow">
                <asp:Label ID="Label5" runat="server" Text="Business Type" AssociatedControlID="BusinessTypeDDL"></asp:Label>
                <asp:DropDownList ID="BusinessTypeDDL" runat="server">
                    <asp:ListItem Value="corporation">Corporation</asp:ListItem>
                    <asp:ListItem Value="sole_prop">Sole Proprietorship</asp:ListItem>
                    <asp:ListItem Value="partnership">Partnership</asp:ListItem>
                    <asp:ListItem Value="llc">Limited-Liability Company</asp:ListItem>
                </asp:DropDownList>
            </div>
            <div class="FormRow">
                <asp:Label ID="Label13" runat="server" Text="Physical Product" 
                    AssociatedControlID="PhysicalProductRBL"></asp:Label>
                <asp:RadioButtonList ID="PhysicalProductRBL" runat="server">
                    <asp:ListItem Value="true">Yes</asp:ListItem>
                    <asp:ListItem Value="false">No</asp:ListItem>
                </asp:RadioButtonList>
                <div class="ClearFix"></div>
            </div>
            <div class="FormRow">
                <asp:Label ID="Label15" runat="server" Text="What type of product do you deal with?" 
                    AssociatedControlID="ProductTypesDDL"></asp:Label>
                <asp:DropDownList ID="ProductTypesDDL" runat="server">
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
                <label>Website</label>
                <asp:TextBox ID="URLTextBox" runat="server"></asp:TextBox>
            </div>
            <div class="FormRow">
                <label>Logo<br /><small>This will be the large logo on your Coupons4Giving Profile page.</small></label>
                <asp:FileUpload ID="newMerchantLargeLogo" runat="server" />
                <p><%: (hasLargeLogo) ? "You have already uploaded a large logo." : "" %></p>
            </div>
            <h4>Additional Information (For Stripe)</h4>
            <div class="FormRow">
                <asp:Label ID="Label8" runat="server" Text="Birth Date" AssociatedControlID="BirthDate"></asp:Label>
                <UC:DateControl ID="BirthDate" runat="server" />
            </div>
            <div class="FormRow">
                <asp:Label ID="Label19" runat="server" Text="Currency" AssociatedControlID="CurrencyRBL"></asp:Label>
                <asp:RadioButtonList ID="CurrencyRBL" runat="server" DataSourceID="CurrenciesXDS" DataTextField="name" DataValueField="code"></asp:RadioButtonList>
                <asp:XmlDataSource ID="CurrenciesXDS" runat="server" DataFile="~/SupportedCurrencies.xml"></asp:XmlDataSource>
                <div class="ClearFix"></div>
            </div>
            <div class="FormRow">
                <iframe src="../Content/Terms/MerchantServicesAgreement.txt" style="width: 100%;"></iframe>
                <label class="checkbox-singlerow">I have read and agree to the Terms & Conditions.</label>
                <asp:CheckBox ID="TermsCheckBox" runat="server" class="checkbox-singlerow" />
            </div>
            <div class="FormRow">
                <asp:Button ID="SubmitButton" ClientIDMode="Static" runat="server" Text="Connect to Stripe!" OnClick="SubmitButton_Click" />
            </div>
            <asp:ValidationSummary ID="ValidationSummary1" runat="server" />
        </div>
</asp:Content>