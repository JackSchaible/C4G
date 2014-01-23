<%@ Page Title="Login" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeFile="Login.aspx.cs" Inherits="Account_Login" %>
<%@ Register Src="~/Account/OpenAuthProviders.ascx" TagPrefix="uc" TagName="OpenAuthProviders" %>

<asp:Content runat="server" ID="BodyContent" ContentPlaceHolderID="Main_Content">
    <h1>Log in</h1>
    <div class="half">
        <section id="loginForm">
            <h4>Log in with your Coupons4Giving account.</h4>
            <asp:Login runat="server" ViewStateMode="Disabled" RenderOuterTable="false">
                <LayoutTemplate>
                    <p class="validation-summary-errors">
                        <asp:Literal runat="server" ID="FailureText" />
                    </p>
                    <fieldset>
                        <div class="FormRow">
                            <asp:Label runat="server" AssociatedControlID="UserName">Username</asp:Label>
                            <asp:TextBox runat="server" ID="UserName" placeholder="username" />
                            <asp:RequiredFieldValidator runat="server" ControlToValidate="UserName" 
                                CssClass="field-validation-error" ErrorMessage="The user name field is required." />
                        </div>
                        <div class="FormRow">
                            <asp:Label runat="server" AssociatedControlID="Password">Password</asp:Label>
                            <asp:TextBox runat="server" ID="Password" TextMode="Password" />
                            <asp:RequiredFieldValidator runat="server" ControlToValidate="Password" CssClass="field-validation-error" ErrorMessage="The password field is required." />
                        </div>
                        <div class="FormRow">
                        	<span class="checkbox-singlerow">
                            <asp:CheckBox runat="server" ID="RememberMe" class="checkbox-singlerow" />
                            <asp:Label runat="server" AssociatedControlID="RememberMe" CssClass="checkbox-singlerow-remeberme">Remember Me?</asp:Label>
                            </span>
                        </div>
                        <div class="FormRow">
                            <asp:Button runat="server" CommandName="Login" Text="Login" />
                        </div>
                    </fieldset>
                </LayoutTemplate>
            </asp:Login>
            <p><asp:HyperLink runat="server" ID="RegisterHyperLink" ViewStateMode="Disabled"><i class="fa fa-arrow-circle-o-right"></i> Register</asp:HyperLink> if you don't have an account.</p>
        </section>
    </div>
    <div class="half dark">
        <section id="socialLoginForm">
            <h4>Use Your Social Accounts</h4>
            <img src="../Images/c4g_comingsoon.png" alt="Coming Soon" width="300px" />
            <!--<h2>Use another service to log in.</h2>
            <uc:OpenAuthProviders runat="server" ID="OpenAuthLogin" />-->
        </section>
    </div>
</asp:Content>