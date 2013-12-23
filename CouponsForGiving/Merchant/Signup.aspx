<%@ Page Title="New Account" Language="C#" MasterPageFile="~/Site.master" AutoEventWireup="true" CodeFile="Signup.aspx.cs" Inherits="Merchant_Signup" %>
<%@ Reference Control="~/Controls/MenuBar.ascx" %>

<asp:Content ID="Content1" ContentPlaceHolderID="HeadContent" Runat="Server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="Main_Content" Runat="Server">
    <script type="text/javascript">
        function notify() {
            if ($("#AutoAcceptRequestsCheckBox").checked) {
                alert('You will be notified of every not-for-profit request.');
            }
        }
    </script>
        <h1>Profile Page Setup</h1>
        <p> Set up your profile with information about your business. 
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
                <asp:TextBox ID="FirstNameTextBox" runat="server" placeholder="Joe"></asp:TextBox>
                <asp:RequiredFieldValidator ID="RequiredFieldValidator3" runat="server" ControlToValidate="FirstNameTextBox" ErrorMessage="First Name is Required">*</asp:RequiredFieldValidator>
            </div>
            <div class="FormRow">
                <asp:Label ID="Label7" runat="server" Text="Last Name" AssociatedControlID="LastNameTextBox"></asp:Label>
                <asp:TextBox ID="LastNameTextBox" runat="server" placeholder="Smith"></asp:TextBox>
                <asp:RequiredFieldValidator ID="RequiredFieldValidator4" runat="server" ControlToValidate="LastNameTextBox" ErrorMessage="Last Name is Required">*</asp:RequiredFieldValidator>
            </div>
            <div class="FormRow">
                <asp:Label ID="Label23" runat="server" Text="Phone Number" AssociatedControlID="YourPhoneNumberTextBox"></asp:Label>
                <asp:TextBox ID="YourPhoneNumberTextBox" runat="server" placeholder="555-123-4567"></asp:TextBox>
                <asp:RequiredFieldValidator ID="RequiredFieldValidator6" 
                    runat="server" ErrorMessage="We need to know your phone number."
                    Text="*" ControlToValidate="YourPhoneNumberTextBox">
                </asp:RequiredFieldValidator>
            </div>
            <div class="FormRow">
                <asp:Label ID="Label4" runat="server" Text="Name of Your Business" AssociatedControlID="BusinessNameTextBox"></asp:Label>
                <asp:TextBox ID="BusinessNameTextBox" runat="server" placeholder="Business Name"></asp:TextBox>
                <asp:RequiredFieldValidator ID="RequiredFieldValidator1" runat="server" 
                    ControlToValidate="BusinessNameTextBox" ErrorMessage="Business Name is Required">
                    *
                </asp:RequiredFieldValidator>
            </div>
            <div class="FormRow TextAreaRow">
                <asp:Label AssociatedControlID="DescriptionTextBox" ID="DescLabel" runat="server" Text="Description"></asp:Label>
                <asp:TextBox ID="DescriptionTextBox" runat="server" TextMode="MultiLine" MaxLength="200"></asp:TextBox>
                <asp:RequiredFieldValidator ID="DescriptionTextBoxRFV" runat="server"
                    ControlToValidate="DescriptionTextBox" ErrorMessage="Description is required.">
                    *
                </asp:RequiredFieldValidator>
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
                <asp:TextBox ID="ZipCodeTextBox" runat="server" MaxLength="16" placeholder="T6L2M9, 90210, or 90210-1234"></asp:TextBox>
                <asp:RequiredFieldValidator ID="postalCodeRequired" runat="server" ControlToValidate="ZipCodeTextBox" 
                    ErrorMessage="Postal / Zip Code is Required">*</asp:RequiredFieldValidator>
                <asp:RegularExpressionValidator ID="RegularExpressionValidator4" runat="server" 
                    ControlToValidate="ZipCodeTextBox" ErrorMessage="Postal / Zip Code invalid. (Ex. '90210', '90210-1234' or 'T6L2M9')" 
                    ForeColor="Black" 
                    ValidationExpression="(^\d{5}(-\d{4})?$)|(^[ABCEGHJKLMNPRSTVXYabceghjklmnprstvxy]{1}\d{1}[A-Za-z]{1} *\d{1}[A-Za-z]{1}\d{1}$)">
                    *
                </asp:RegularExpressionValidator>
            </div>
            <div class="FormRow">
                <label>Phone Number<br /><small>(if different from above)</small></label>
                <asp:TextBox ID="PhoneNumberTextBox" runat="server" MaxLength="11"></asp:TextBox>
                <ajaxToolkit:FilteredTextBoxExtender ID="FilteredTextBoxExtender1" TargetControlID="PhoneNumberTextBox"
                    FilterType="Numbers" runat="server"></ajaxToolkit:FilteredTextBoxExtender>
            </div>
            <div class="FormRow">
                <asp:Label ID="AARLabel" runat="server" Text="Accept All Not-For-Profit Partner Requests" 
                    AssociatedControlID="AutoAcceptRequestsCheckBox"></asp:Label>
                <asp:CheckBox ID="AutoAcceptRequestsCheckBox" runat="server" Checked="true" 
                    onClick="notify()" ClientIDMode="Static"/>
            </div>
            <div class="FormRow">
                <label>Email<small>(if different from the one you used to register)</small></label>
                <asp:TextBox ID="YourEmailTextBox" runat="server" TextMode="Email" placeholder="yourname@yourorganization.com"></asp:TextBox>
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
                <asp:TextBox ID="URLTextBox" runat="server" placeholder="http://www.mycompanywebsite.com"></asp:TextBox>
                <asp:RequiredFieldValidator ID="RequiredFieldValidator2" runat="server" 
                    ControlToValidate="URLTextBox" ErrorMessage="Website is required">*</asp:RequiredFieldValidator>
                <asp:RegularExpressionValidator ID="RegularExpressionValidator2" runat="server"
                    ControlToValidate="URLTextBox" ErrorMessage="Website is invalid (i.e., http://www.mywebsite.com/)"
                    ValidationExpression="(https:[/][/]|http:[/][/]|www.)[a-zA-Z0-9\-\.]+\.[a-zA-Z]{2,3}(:[a-zA-Z0-9]*)?/?([a-zA-Z0-9\-\._\?\,\'/\\\+&amp;%\$#\=~])*$">
                    *
                </asp:RegularExpressionValidator>
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
                <span class="checkbox-singlerow">
                <asp:CheckBox ID="TermsCheckBox" runat="server" class="checkbox-singlerow" />
                <label class="checkbox-singlerow-termscheckbox">I have read and agree to the Terms & Conditions.</label>
                </span>
            </div>
            <div class="FormRow">
                <asp:Button ID="Button1" runat="server" Text="Connect to Stripe!" OnClick="SubmitButton_Click" />
            </div>
            <asp:ValidationSummary ID="ValidationSummary1" runat="server" />
        </div>
</asp:Content>