<%@ Page Title="Register" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeFile="Register.aspx.cs" Inherits="Account_Register" %>

<asp:Content runat="server" ID="BodyContent" ContentPlaceHolderID="Main_Content">
    <script type="text/javascript">

        $(document).ready(function () {

        });

        function change() {
            if ($("#TermsCheckbox").is(':checked') == false) {
                $("#SubmitButton").attr('disabled', 'disabled');
            }
            else {
                $("#SubmitButton").removeAttr('disabled');
            }
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
                    <p class="message-info">
                    </p>

                    <p class="validation-summary-errors">
                        <asp:Literal runat="server" ID="ErrorMessage" />
                    </p>

                    <fieldset>
                        <div class="FormRow">
                            <asp:Label runat="server" AssociatedControlID="UserName">User name</asp:Label>
                            <asp:TextBox runat="server" ID="UserName" placeholder="username" />
                            <asp:RequiredFieldValidator runat="server" ControlToValidate="UserName"
                                    CssClass="field-validation-error" ErrorMessage="The user name field is required." />
                        </div>
                        <div class="FormRow">
                            <asp:Label runat="server" AssociatedControlID="Email">Email address</asp:Label>
                            <asp:TextBox runat="server" ID="Email" TextMode="Email" placeholder="joe@joesmith.com" />
                            <asp:RequiredFieldValidator runat="server" ControlToValidate="Email"
                                CssClass="field-validation-error" ErrorMessage="The email address field is required." />
                        </div>
                        <div class="FormRow">
                            <asp:Label runat="server" AssociatedControlID="Password">Password</asp:Label>
                            <asp:TextBox runat="server" ID="Password" TextMode="Password" />
                            <asp:RequiredFieldValidator runat="server" ControlToValidate="Password"
                                CssClass="field-validation-error" ErrorMessage="The password field is required." />
                        </div>
                        <div class="FormRow">
                            <asp:Label runat="server" AssociatedControlID="ConfirmPassword">Confirm password</asp:Label>
                            <asp:TextBox runat="server" ID="ConfirmPassword" TextMode="Password" />
                            <asp:RequiredFieldValidator runat="server" ControlToValidate="ConfirmPassword"
                                    CssClass="field-validation-error" Display="Dynamic" ErrorMessage="The confirm password field is required." />
                            <asp:CompareValidator runat="server" ControlToCompare="Password" ControlToValidate="ConfirmPassword"
                                    CssClass="field-validation-error" Display="Dynamic" ErrorMessage="The password and confirmation password do not match." />
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
                            <iframe src="../Content/Terms/PrivacyPolicy.txt"></iframe>
                            <iframe src="../Content/Terms/TermsOfUse.txt"></iframe>
                            <label class="large">I have read and agree to the <a href="../Content/Terms/PrivacyPolicy.pdf">Privacy Policy</a> and the <a href="../Content/Terms/TermsOfUse.pdf">Terms of Use</a></label>
                            <input type="checkbox" id="TermsCheckbox" onchange="change()" />
                        </div>
                        <div class="FormRow">
                            <asp:Button runat="server" CommandName="MoveNext" Text="Register" ID="SubmitButton" ClientIDMode="Static" />
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
                                <asp:Button ID="ContinueButton" runat="server" CausesValidation="False" CommandName="Continue" Text="Continue" ValidationGroup="RegisterUser" />
                            </td>
                        </tr>
                    </table>
                </ContentTemplate>
            </asp:CompleteWizardStep>
        </WizardSteps>
    </asp:CreateUserWizard>
</asp:Content>