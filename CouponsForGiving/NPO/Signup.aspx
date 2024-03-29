﻿<%@ Page Title="New Account" Language="C#" MasterPageFile="~/Site.master" AutoEventWireup="true" CodeFile="Signup.aspx.cs" Inherits="NPO_newNPO" %>
<%@ Reference Control="~/Controls/MenuBar.ascx" %>

<asp:Content ID="Content1" ContentPlaceHolderID="HeadContent" Runat="Server">
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="Main_Content" Runat="Server">
    <h1>Set Up Your Profile</h1>
    <h3>Are you looking to fundraise for your organization?</h3>
    <p><img src="../images/c4g_npos.png" class="circle_image_right" />Set up your profile with information about your organization. This page will now be your public page you can share with your network of donors and supporters. You can include images and your social media channels. You do not need to be a registered charity to sign up, but you do need to have a Not-For-Profit organization looking to raise money for a cause or campaign. As a Not-for-Profit with Coupons4Giving you will receive up to 25% from every offer purchased from the Coupons4Giving offers registered to your campaign.</p>
    <p>Your organization's profile page is what the public will see when you start promoting your campaigns. You will now have a Coupons4Giving URL for both your public profile page and each live campaign page.</p>
    <p>To ensure the best experience for all, <strong>the Coupons4Giving team will review and approve all registrations</strong>.</p>
    <h3>Tell us about your organization:</h3>
    <hr>
    <div class="Form">
        <div class="FormRow">
            <asp:Label ID="Label1" runat="server" Text="Name of Your Organization" AssociatedControlID="newNPOName"></asp:Label>
            <asp:TextBox ID="newNPOName" runat="server" MaxLength="256" placeholder="Organization Name"></asp:TextBox>
            <asp:RequiredFieldValidator ID="nameRequired" runat="server" ControlToValidate="newNPOName" 
                ErrorMessage="Name is Required" ForeColor="Red">*</asp:RequiredFieldValidator>
        </div>
        <div class="FormRow">
            <asp:Label ID="Label4" runat="server" Text="Your Organization's Address" AssociatedControlID="newNPOAddress"></asp:Label>
            <asp:TextBox ID="newNPOAddress" runat="server" MaxLength="256" placeholder="1234, 5th Street"></asp:TextBox>
            <asp:RequiredFieldValidator ID="addressRequired" runat="server" ControlToValidate="newNPOAddress" 
                ErrorMessage="Address is Required" ForeColor="Red">*</asp:RequiredFieldValidator>
        </div>
        <div class="FormRow">
            <label>City<br /><small>Keep typing until your city appears in the dropdown.</small></label>
            <asp:TextBox ID="CityTextBox" runat="server"></asp:TextBox>
            <ajaxToolkit:AutoCompleteExtender ID="CityAutoCompleteExtender" runat="server"
                TargetControlID="CityTextBox" UseContextKey="True" ServiceMethod="GetCompletionList" 
                CompletionInterval="0" MinimumPrefixLength="1">
            </ajaxToolkit:AutoCompleteExtender>
        </div>
        <div class="FormRow">
            <asp:Label ID="Label6" runat="server" Text="Postal/Zip Code" AssociatedControlID="newNPOPostalCode"></asp:Label>
            <asp:TextBox ID="newNPOPostalCode" runat="server" MaxLength="16" placeholder="T6L2M9, 90210, or 90210-1234"></asp:TextBox>
            <asp:RequiredFieldValidator ID="postalCodeRequired" runat="server" ControlToValidate="newNPOPostalCode" ErrorMessage="Postal / Zip Code is Required" ForeColor="Red">*</asp:RequiredFieldValidator>
            <asp:RegularExpressionValidator ID="RegularExpressionValidator4" runat="server" ControlToValidate="newNPOPostalCode" ErrorMessage="Postal / Zip Code invalid. (Ex. '90210', '90210-1234' or 'T6L2M9')" ForeColor="Red" ValidationExpression="(^\d{5}(-\d{4})?$)|(^[ABCEGHJKLMNPRSTVXYabceghjklmnprstvxy]{1}\d{1}[A-Za-z]{1} *\d{1}[A-Za-z]{1}\d{1}$)">*</asp:RegularExpressionValidator>
        </div>
        <div class="FormRow">
            <asp:Label ID="Label7" runat="server" Text="Phone Number" AssociatedControlID="newNPOPhoneNumber"></asp:Label>
            <asp:TextBox ID="newNPOPhoneNumber" runat="server" MaxLength="11" placeholder="555-123-4567"></asp:TextBox>
            <asp:RequiredFieldValidator ID="phoneNumberRequired" runat="server" ControlToValidate="newNPOPhoneNumber"
                    ErrorMessage="Phone Number is Required" ForeColor="Red">*</asp:RequiredFieldValidator>
                <asp:RegularExpressionValidator ID="RegularExpressionValidator2" runat="server"
                        ControlToValidate="newNPOPhoneNumber"
                        ErrorMessage="Please enter a valid, 10-digit phone number. (ex. 7809980120)" 
                    ForeColor="Red" ValidationExpression="^[0-9]{10,11}$">*</asp:RegularExpressionValidator>
                <ajaxToolkit:FilteredTextBoxExtender ID="FilteredTextBoxExtender1" TargetControlID="newNPOPhoneNumber" 
                    FilterType="Numbers" runat="server"></ajaxToolkit:FilteredTextBoxExtender>
        </div>
        <div class="FormRow">
            <label>Email<br /><small>(if different from the one you used to register)</small></label>
            <asp:TextBox ID="newNPOEmail" runat="server" MaxLength="256" placeholder="yourname@yourorganization.com"></asp:TextBox>
        </div>
        <div class="FormRow TextAreaRow">
            <label>Describe Your Organization<br /><small>Maximum length 200 characters.</small></label>
            <asp:TextBox ID="newNPODescription" runat="server" TextMode="MultiLine" MaxLength="200"></asp:TextBox>
            <asp:RequiredFieldValidator ID="RequiredFieldValidator1" runat="server" ControlToValidate="newNPODescription" 
                ErrorMessage="Description is Required" ForeColor="Red">*</asp:RequiredFieldValidator>
        </div>
        <div class="FormRow">
            <label>Upload Your Logo<br /><small>Images must be no larger than 4MB</small></label>
            <asp:FileUpload ID="newNPOLogo" runat="server" />
            <p><%: (hasImage) ? "You have already uploaded an image." : "" %></p>
        </div>
        <div class="FormRow">
            <label>Organization Website</label>
            <asp:TextBox ID="newNPOWebsite" runat="server" MaxLength="256" placeholder="http://www.yourorganization.com"></asp:TextBox>
            <asp:RequiredFieldValidator ID="websiteRequired" runat="server" ControlToValidate="newNPOWebsite" 
                ErrorMessage="Website is Required" ForeColor="Red">*</asp:RequiredFieldValidator>
            <asp:RegularExpressionValidator ID="RegularExpressionValidator3" runat="server" ControlToValidate="newNPOWebsite"
                ErrorMessage="Website invalid. (Ex. 'http://www.mywebsite.com')" ForeColor="Red" 
                ValidationExpression="(https:[/][/]|http:[/][/]|www.)[a-zA-Z0-9\-\.]+\.[a-zA-Z]{2,3}(:[a-zA-Z0-9]*)?/?([a-zA-Z0-9\-\._\?\,\'/\\\+&amp;%\$#\=~])*$">
                *
            </asp:RegularExpressionValidator>
        </div>
        <div class="FormRow">
            <iframe name="termsAndConditions" style="width: 100%;" src="../Content/Terms/NPOServicesAgreement.txt"></iframe>
            <label class="checkbox-singlerow">I have read and understand the <a target="_blank" href="../Content/Terms/NPOServiceAgreement.pdf">terms and conditions.</a></label>
            <asp:CheckBox ID="TermsCheckbox" runat="server" class="checkbox-singlerow"/>
        </div>
        <div class="FormRow">
            <asp:Button ID="newNPOSubmit" runat="server" Text="Submit" OnClick="newNPOSubmit_Click" />
        </div>
    </div>
    <asp:ValidationSummary ID="ValidationSummary1" runat="server" ForeColor="Red" />
    <asp:Label ID="newNPOMessage" runat="server"></asp:Label>
</asp:Content>