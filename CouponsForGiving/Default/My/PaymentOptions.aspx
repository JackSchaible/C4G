<%@ Page Title="Payment Options" Language="C#" MasterPageFile="~/Site.master" AutoEventWireup="true" CodeFile="PaymentOptions.aspx.cs" Inherits="Default_My_PaymentOptions" %>
<%@ Reference Control="~/Controls/MenuBar.ascx" %>

<asp:Content ID="Content1" ContentPlaceHolderID="HeadContent" Runat="Server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="Main_Content" Runat="Server">
    <style type="text/css">
        input[type="number"] {
            bottom: inherit;
            margin: 0 0 0 5px;
            padding: 5px 0 5px 10px;
            position: relative;
            right: inherit;
            width: 50px;
        }

        select {
            padding: 4px;
        }

        .Form {
            width: 400px;
        }

        #ShowControl {
            cursor: pointer;
            display: inline;
            padding: 0 0 0 10px;
            width: auto;
        }

        #newForm {
            display: none;
        }

        input[type="submit"] {
            background-color: #22bfe8;
            color: #FFF;
        }

        input[type="submit"]:hover {
            background-color: #BBB;
        }
    </style>
    <script type="text/javascript">
        $(document).ready(function () {
            $("#ShowControl").click(function () {
                if ($("#ShowControl").text() == "Show") {
                    $("#newForm").slideDown(400);
                    $("#ShowControl").text("Hide");
                }
                else {
                    $("#newForm").slideUp(400);
                    $("#ShowControl").text("Show");
                }
            });
        });
    </script>
        <h1>Select a Payment Option</h1>
        <asp:GridView ID="PaymentOptionsGV" runat="server" AutoGenerateColumns="False" DataKeyNames="PaymentOptionID" OnRowDeleting="PaymentOptionsGV_RowDeleting">
            <Columns>
                <asp:CommandField ShowDeleteButton="True" />
                <asp:TemplateField HeaderText="Select">
                    <ItemTemplate>
                        <input name="PaymentTypeButton" type="radio" value='<%# Eval("PaymentOptionID") %>' />
                    </ItemTemplate>
                </asp:TemplateField>
                <asp:BoundField DataField="Name" HeaderText="Type Name" SortExpression="Name" />
                <asp:BoundField DataField="Last4Digits" HeaderText="Last 4 Digits" SortExpression="Last4Digits" />
                <asp:BoundField DataField="StripeToken" HeaderText="StripeToken" SortExpression="StripeToken" Visible="False" />
            </Columns>
            <EmptyDataTemplate>
                <p>You currently have no stored payment options. Add one below.</p>
            </EmptyDataTemplate>
        </asp:GridView>
        <h1>Or Add a New One</h1>
        <p id="ShowControl">Show</p>
        <div id="newForm" runat="server">
            <p>Note: We don't store your credit card information.</p>
            <div class="Form">
                <div class="FormRow">
                    <asp:Label ID="Label1" runat="server" Text="Card Type"></asp:Label>
                    <asp:DropDownList ID="CardTypesDDL" 
                        runat="server" DataSourceID="CardTypesDS" DataTextField="Name" DataValueField="CardTypeID"></asp:DropDownList>
                    <asp:EntityDataSource ID="CardTypesDS" runat="server" ConnectionString="name=C4GEntities" 
                        DefaultContainerName="C4GEntities" EnableFlattening="False" EntitySetName="CardTypes">
                    </asp:EntityDataSource>
                </div>
                <div class="FormRow">
                    <asp:Label ID="Label2" runat="server" Text="Card Number"></asp:Label>
                    <asp:TextBox ID="CCTextBox" runat="server" MaxLength="16"></asp:TextBox>
                    <asp:RequiredFieldValidator ID="RequiredFieldValidator1" runat="server" 
                        ErrorMessage="Credit Card Number is required!" Text="*" ControlToValidate="CCTextBox">
                    </asp:RequiredFieldValidator>
                    <asp:CustomValidator ID="CustomValidator1" runat="server" ErrorMessage="Card Number must be exactly 16 digits!"
                        OnServerValidate="CustomValidator1_ServerValidate">
                    </asp:CustomValidator>
                    <asp:RegularExpressionValidator ID="RegularExpressionValidator1" runat="server" 
                        ErrorMessage="Card Number must be digits only!" ValidationExpression="^\d+$"
                        ControlToValidate="CCTextBox">
                    </asp:RegularExpressionValidator>
                </div>
                <div class="FormRow">
                    <asp:Label ID="Label3" runat="server" Text="Expiry Date"></asp:Label>
                    <asp:TextBox ID="YearTextBox" runat="server" TextMode="Number"></asp:TextBox>
                    <asp:DropDownList ID="MonthDropdown" runat="server">
                        <asp:ListItem>January</asp:ListItem>
                        <asp:ListItem>February</asp:ListItem>
                        <asp:ListItem>March</asp:ListItem>
                        <asp:ListItem>April</asp:ListItem>
                        <asp:ListItem>May</asp:ListItem>
                        <asp:ListItem>June</asp:ListItem>
                        <asp:ListItem>July</asp:ListItem>
                        <asp:ListItem>August</asp:ListItem>
                        <asp:ListItem>September</asp:ListItem>
                        <asp:ListItem>October</asp:ListItem>
                        <asp:ListItem>November</asp:ListItem>
                        <asp:ListItem>December</asp:ListItem>
                    </asp:DropDownList>
                </div>
                <div class="FormRow">
                    <asp:Label ID="Label4" runat="server" Text="CVV Number"></asp:Label>
                    <asp:TextBox ID="CVVTextBox" runat="server" TextMode="Number"></asp:TextBox>
                    <asp:RequiredFieldValidator ID="RequiredFieldValidator2" runat="server" 
                        ErrorMessage="Credit Card Number is required!" Text="*" ControlToValidate="CVVTextBox">\
                    </asp:RequiredFieldValidator>
                    <asp:RegularExpressionValidator ID="RegularExpressionValidator2" runat="server" 
                        ErrorMessage="Card Number must be digits only!" ValidationExpression="^\d+$"
                        ControlToValidate="CVVTextBox">
                    </asp:RegularExpressionValidator>
                </div>
                <div class="FormRow">
                    <asp:Label ID="Label6" runat="server" Text="First Name"></asp:Label>
                    <asp:TextBox ID="FirstNameTextBox" runat="server"></asp:TextBox>
                    <asp:RequiredFieldValidator ID="RequiredFieldValidator3" runat="server" 
                        ErrorMessage="First Name is required." Text="*" ControlToValidate="FirstNameTextBox">
                    </asp:RequiredFieldValidator>
                </div>
                <div class="FormRow">
                    <asp:Label ID="Label7" runat="server" Text="Last Name"></asp:Label>
                    <asp:TextBox ID="LastNameTextBox" runat="server"></asp:TextBox>
                    <asp:RequiredFieldValidator ID="RequiredFieldValidator4" runat="server" 
                        ErrorMessage="Last Name is required." Text="*" ControlToValidate="LastNameTextBox">
                    </asp:RequiredFieldValidator>
                </div>
                <div class="FormRow SubmitRow">
                    <asp:Label ID="ErrorLabel" runat="server"></asp:Label>
                    <asp:Button ID="SubmitButton" runat="server" Text="Submit" OnClick="SubmitButton_Click" />
                </div>
            </div>
        </div>
        <div id="ProceedDiv">
            <asp:Label ID="ProceedErrorLabel" runat="server" Text=""></asp:Label>
            <asp:Button ID="Proceed" runat="server" Text="Proceed With Checkout" OnClick="Proceed_Click" CausesValidation="False" />
        </div>
</asp:Content>