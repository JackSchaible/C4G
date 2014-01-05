<%@ Page Title="Register" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeFile="Register.aspx.cs" Inherits="Account_Register" %>

<asp:Content runat="server" ID="BodyContent" ContentPlaceHolderID="Main_Content">
    <script type="text/javascript">
        $(document).ready(initForm);

        function initForm() {
            checkForm();
        }

        function checkUsername(write) {
            var name = $("#UserName").val();
            var errors = new Array();
            var length = arguments.length;

            if (IsStringBlank(name))
                errors.push('<%: strings.SelectSingleNode("/SiteText/Pages/Register/ErrorMessages/NullUsername").InnerText %>');

            if (IsStringTooShort(name, 4))
                errors.push('<%: strings.SelectSingleNode("/SiteText/Pages/Register/ErrorMessages/UsernameTooShort").InnerText %>');

            if (IsStringTooLong(name, 32))
                errors.push('<%: strings.SelectSingleNode("/SiteText/Pages/Register/ErrorMessages/UsernameTooLong").InnerText %>');

            if (containsCode(name))
                errors.push('<%: strings.SelectSingleNode("/SiteText/Pages/Register/ErrorMessages/UsernameInvalidCharacters").InnerText %>');

            var taken = false;

            PageMethods.UsernameTaken(name, function (result) {
                if (result)
                    errors.push('<%: strings.SelectSingleNode("/SiteText/Pages/Register/ErrorMessages/UsernameTaken").InnerText %>');

                if (length == 0) {
                    writeErrors("UsernameErrors", errors);
                    checkForm();
                }

                return errors;
            });
        }

        function checkEmail(write) {
            var email = $("#Email").val();
            var errors = new Array();

            if (IsStringBlank(email))
                errors.push('<%: strings.SelectSingleNode("/SiteText/Pages/Register/ErrorMessages/NullEmail").InnerText %>');
            
            if (IsStringTooShort(email, 6))
                errors.push('<%: strings.SelectSingleNode("/SiteText/Pages/Register/ErrorMessages/EmailTooShort").InnerText %>');

            if (IsStringTooLong(email, 64))
                errors.push('<%: strings.SelectSingleNode("/SiteText/Pages/Register/ErrorMessages/EmailTooLong").InnerText %>');

            if (containsCode(email))
                errors.push('<%: strings.SelectSingleNode("/SiteText/Pages/Register/ErrorMessages/EmailInvalidCharacters").InnerText %>');

            if (arguments.length == 0) {
                writeErrors("EmailErrors", errors);
                checkForm();
            }

            return errors;
        }

        function checkPassword(write) {
            var password = $("#Password").val();
            var errors = new Array();

            if (IsStringBlank(password))
                errors.push('<%: strings.SelectSingleNode("/SiteText/Pages/Register/ErrorMessages/NullPassword").InnerText %>');

            if (IsStringTooShort(password, 6))
                errors.push('<%: strings.SelectSingleNode("/SiteText/Pages/Register/ErrorMessages/PasswordTooShort").InnerText %>');

            if (IsStringTooLong(password, 32))
                errors.push('<%: strings.SelectSingleNode("/SiteText/Pages/Register/ErrorMessages/PasswordTooLong").InnerText %>');

            if (containsCode(password))
                errors.push('<%: strings.SelectSingleNode("/SiteText/Pages/Register/ErrorMessages/PasswordInvalidCharacters").InnerText %>');

            if (arguments.length == 0) {
                writeErrors("PasswordErrors", errors);
                checkForm();
            }

            return errors;
        }

        function checkConfirmPassword(write) {
            var password = $("#Password").val();
            var confirmPassword = $("#ConfirmPassword").val();
            var errors = Array();

            if (IsStringBlank(confirmPassword))
                errors.push('<%: strings.SelectSingleNode("/SiteText/Pages/Register/ErrorMessages/NullConfirmPassword").InnerText %>');

            if (IsStringTooShort(confirmPassword, 6))
                errors.push('<%: strings.SelectSingleNode("/SiteText/Pages/Register/ErrorMessages/ConfirmPasswordTooShort").InnerText %>');

            if (IsStringTooLong(confirmPassword, 32))
                errors.push('<%: strings.SelectSingleNode("/SiteText/Pages/Register/ErrorMessages/ConfirmPasswordTooLong").InnerText %>');

            if (containsCode(confirmPassword))
                errors.push('<%: strings.SelectSingleNode("/SiteText/Pages/Register/ErrorMessages/ConfirmPasswordInvalidCharacters").InnerText %>'); 

            if (confirmPassword != password)
                errors.push('<%: strings.SelectSingleNode("/SiteText/Pages/Register/ErrorMessages/ConfirmPasswordMatch").InnerText %>'); 


            if (arguments.length == 0) {
                writeErrors("ConfirmPasswordErrors", errors);
                checkForm();
            }

            return errors;
        }

        function checkTermsCheckbox(write) {
            var errors = Array();

            if ($("#TermsCheckbox").is(':checked') == false)
                errors.push('You need to agree to the terms and conditions and the privacy policy.');
            
            if (arguments.length == 0) {
                writeErrors('TermsErrors', errors);
                checkForm();
            }

            return errors;
        }

        function checkForm() {
            var errors = new Array();

            errors.push.apply(errors, checkUsername(false));
            errors.push.apply(errors, checkEmail(false));
            errors.push.apply(errors, checkPassword(false));
            errors.push.apply(errors, checkConfirmPassword(false));

            if (errors.length > 0)
                $("#SubmitButton").attr('disabled', 'disabled');
            else
                $("#SubmitButton").removeAttr('disabled');
        }
    </script>
    <h1>Sign up for a Coupons4Giving account today!</h1>
    <p>It’s easy and you can get started with your <strong>fundraising campaign</strong>, <strong>buying coupons</strong> or <strong>set up your merchant/e-tailer</strong> offers right away! As a fundraising group or merchant/e-tailer, you are automatically signed up as a customer so you can also purchase great deals!</p>
    <asp:CreateUserWizard runat="server" ID="RegisterUser" ViewStateMode="Disabled" OnCreatedUser="RegisterUser_CreatedUser">
        <LayoutTemplate>
            <asp:PlaceHolder runat="server" ID="wizardStepPlaceholder" />
            <asp:PlaceHolder runat="server" ID="navigationPlaceholder" />
        </LayoutTemplate>
        <WizardSteps>
            <asp:CreateUserWizardStep runat="server" ID="RegisterUserWizardStep">
                <ContentTemplate>
                    <fieldset>
                        <div class="FormRow">
                            <asp:Label runat="server" AssociatedControlID="UserName">User name</asp:Label>
                            <asp:TextBox runat="server" ID="UserName" ClientIDMode="Static" placeholder="username" onkeyup="checkUsername()" 
                                onblur="checkUsername()" oninput="checkUsername()"/>
                            <div class="ErrorDiv" id="UsernameErrors"></div>
                        </div>
                        <div class="FormRow">
                            <asp:Label runat="server" AssociatedControlID="Email">Email address</asp:Label>
                            <asp:TextBox runat="server" ID="Email" TextMode="Email" ClientIDMode="Static" placeholder="yourname@yourwebsite.com" 
                                onkeyup="checkEmail()" onblur="checkEmail()" oninput="checkEmail()" />
                            <div class="ErrorDiv" id="EmailErrors"></div>
                        </div>
                        <div class="FormRow">
                            <asp:Label runat="server" AssociatedControlID="Password">Password</asp:Label>
                            <asp:TextBox runat="server" ID="Password" TextMode="Password" ClientIDMode="Static"
                                onkeyup="checkPassword()" onblur="checkPassword()" oninput="checkPassword()"/>
                            <div class="ErrorDiv" id="PasswordErrors"></div>
                        </div>
                        <div class="FormRow">
                            <asp:Label runat="server" AssociatedControlID="ConfirmPassword">Confirm password</asp:Label>
                            <asp:TextBox runat="server" ID="ConfirmPassword" TextMode="Password" ClientIDMode="Static"
                                onkeyup="checkConfirmPassword()" onblur="checkConfirmPassword()" oninput="checkConfirmPassword()" />
                            <div class="ErrorDiv" id="ConfirmPasswordErrors"></div>
                        </div>
                        <div class="FormRow">
                            <asp:Label runat="server" AssociatedControlID="RoleRBL">What are you looking to do? (Select one)</asp:Label>
                            <asp:RadioButtonList ID="RoleRBL" runat="server">
                                <asp:ListItem Value="NPO" class="inline-radio">Fundraise for your organization</asp:ListItem>
                                <asp:ListItem Value="Merchant" class="inline-radio">Set up Merchant or E-Tailer offers</asp:ListItem>
                                <asp:ListItem Value="Customer" Selected="True" class="inline-radio">Purchase deals to support your favorite causes</asp:ListItem>
                            </asp:RadioButtonList>
                        </div>
                        <div class="FormRow">
                            <iframe src="../Content/Terms/pptou.txt"></iframe>
                            
                            <span class="checkbox-singlerow">
                            <label class="checkbox-singlerow ">I have read and agree to the <a href="../Content/Terms/PrivacyPolicy.pdf">Privacy Policy</a> and the <a href="../Content/Terms/TermsOfUse.pdf">Terms of Use</a></label>
                            <input type="checkbox" id="TermsCheckbox" onchange="checkTermsCheckbox()" class="checkbox-singlerow "/>
                            </span>
                            <div class="ErrorDiv" id="TermsErrors"></div>
                        </div>
                        <div class="FormRow">
                            <asp:Button runat="server" CommandName="MoveNext" Text="Register" ID="SubmitButton" ClientIDMode="Static" OnClientClick="checkForm()" />
                        </div>
                    </fieldset>
                </ContentTemplate>
                <CustomNavigationTemplate />
            </asp:CreateUserWizardStep>
            <asp:CompleteWizardStep runat="server">
                <ContentTemplate>
                    <table>
                        <tr>
                            <td align="center" colspan="2">Complete</td>
                        </tr>
                        <tr>
                            <td>Your account has been successfully created.</td>
                        </tr>
                        <tr>
                            <td align="right" colspan="2">
                                <asp:Button ID="ContinueButton" runat="server" CausesValidation="False" 
                                    CommandName="Continue" Text="Continue" ValidationGroup="RegisterUser" />
                            </td>
                        </tr>
                    </table>
                </ContentTemplate>
            </asp:CompleteWizardStep>
        </WizardSteps>
    </asp:CreateUserWizard>
    <asp:Panel ID="ServerErrorDiv" runat="server" CssClass="ServerErrors" ClientIDMode="Static" >
        <p>Please contact us at <a href="mailto:support@coupons4giving.com">support@coupons4giving.ca</a> and reference the error below. We'll get back to you as soon as possible.</p>
    </asp:Panel>
>>>>>>> eac7824f91db02d5b20f96c87e399cdc26008452
</asp:Content>