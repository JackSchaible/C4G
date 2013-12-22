<%@ Page Title="Register" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeFile="Register.aspx.cs" Inherits="Account_Register" %>

<asp:Content runat="server" ID="BodyContent" ContentPlaceHolderID="Main_Content">
    <script type="text/javascript">
        $(document).ready(initForm);

        function initForm() {
        }

        function checkUsername() {
            var name = $("#UserName").val();
            var errors = new Array();

            if (name.length < 4)
                errors.push('Your username needs to be longer than 4 characters.');

            var taken = false;

            PageMethods.UsernameTaken(name, function (result) {
                if (result)
                    errors.push('Your username is taken.');

                writeErrors("UsernameErrors", errors);

                return errors;
            });
        }

        function checkEmail() {
            var email = $("#Email").val();
            var errors = new Array();

            var emailPattern = /^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$/;

            if (!emailPattern.test(email))
                errors.push('Your email address needs to match the pattern \"joe@joesmith.com\".');
            
            writeErrors("EmailErrors", errors);
            return errors;
        }

        function checkPassword() {
            var password = $("#Password").val();
            var errors = new Array();

            if (password.length < 6)
                errors.push('Your password needs to be longer than 6 characters.');

            writeErrors("PasswordErrors", errors);
            return errors;
        }

        function checkConfirmPassword() {
            var password = $("#Password");
            var confirmPassword = $("#ConfirmPassword");
            var errors = Array();

            if (confirmPassword.trim().length == 0)
                errors.push('You need to provide a confirmation password.');

            if (password != confirmPassword)
                errors.push('Your confirm password needs to match your regular password.');

            writeErrors("ConfirmPasswordErrors", errors);
            return errors;
        }

        function checkTermsCheckbox() {
            var errors = Array();

            if ($("#TermsCheckbox").is(':checked') == false)
                errors.push('You need to agree to the terms and conditions and the privacy policy.');
            
            writeErrors('TermsErrors', errors);
            return errors;
        }

        function checkForm() {
            var errors = Array();

            errors.push(checkUsername());
            errors.push(checkEmail());
            errors.push(checkPassword());
            errors.push(checkConfirmPassword());
            errors.push(checkTermsCheckbox());
            console.log(errors);
            if (errors.length > 0) {
                $("#SubmitButton").attr('disabled', 'disabled');
            }
            else {
                $("#SubmitButton").removeAttr('disabled', '');
            }
            
            return errors;
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
<<<<<<< HEAD
=======
                    <p class="message-info">
                    </p>

                    <p class="validation-summary-errors">
                        <asp:Literal runat="server" ID="ErrorMessage" />
                    </p>
                    
                    <div class="ErrorDiv" id="GeneralJQueryErrors">
                    
                    </div>

>>>>>>> c7b8f291a4262abbdb8ef6e203967d55ba918c88
                    <fieldset>
                        <div class="FormRow">
                            <asp:Label runat="server" AssociatedControlID="UserName">User name</asp:Label>
                            <asp:TextBox runat="server" ID="UserName" ClientIDMode="Static" placeholder="username" onkeyup="checkUsername()" 
                                onblur="checkUsername()" oninput="checkUsername()"/>
                            <div class="ErrorDiv" id="UsernameErrors"></div>
                        </div>
                        <div class="FormRow">
                            <asp:Label runat="server" AssociatedControlID="Email">Email address</asp:Label>
                            <asp:TextBox runat="server" ID="Email" TextMode="Email" ClientIDMode="Static" placeholder="joe@joesmith.com" 
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
                            <input type="checkbox" id="TermsCheckbox" onchange="change()" class="checkbox-singlerow "/>
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
</asp:Content>