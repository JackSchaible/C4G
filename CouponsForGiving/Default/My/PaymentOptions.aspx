<%@ Page Title="Payment Options" Language="C#" MasterPageFile="~/Site.master" AutoEventWireup="true" CodeFile="PaymentOptions.aspx.cs" Inherits="Default_My_PaymentOptions" %>
<%@ Reference Control="~/Controls/MenuBar.ascx" %>

<asp:Content ID="Content1" ContentPlaceHolderID="HeadContent" Runat="Server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="Main_Content" Runat="Server">
    <script type="text/javascript">
        $(document).ready(function () {
            $("#newForm").hide();

            $("#ShowControl").click(function () {
                console.log($("#ShowControl").text());
                if ($("#ShowControl").text() == "Hide") {
                    $("#newForm").slideUp(400);
                    $("#ShowControl").text("Show");
                }
                else {
                    $("#newForm").slideDown(400);
                    $("#ShowControl").text("Hide");
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
                <asp:BoundField DataField="Name" HeaderText="Type" SortExpression="Name" />
                <asp:BoundField DataField="Last4Digits" HeaderText="Last 4 Digits" SortExpression="Last4Digits" />
                <asp:BoundField DataField="StripeToken" HeaderText="StripeToken" SortExpression="StripeToken" Visible="False" />
            </Columns>
            <EmptyDataTemplate>
                <p>You currently have no stored payment options. Add one below.</p>
            </EmptyDataTemplate>
        </asp:GridView>
        <div id="ProceedDiv">
            <asp:Label ID="ErrorLabel" runat="server"></asp:Label>
            <asp:Label ID="ProceedErrorLabel" runat="server" Text=""></asp:Label>
            <asp:Button ID="Proceed" runat="server" Text="Proceed With Checkout" OnClick="Proceed_Click" CausesValidation="False" />
        </div>
        <h1>Add a Payment Option</h1>
        <a class="btn-small" id="ShowControl">Add Now</a>
        <div id="newForm" runat="server" ClientIDMode="Static">
            <p>Note: We don't store your credit card information.</p>
            <div class="Form">
                <div class="FormRow">
                    <label>Card Type</label>
                    <asp:DropDownList ID="CardTypesDDL" 
                        runat="server" DataSourceID="CardTypesDS" DataTextField="Name" DataValueField="CardTypeID"></asp:DropDownList>
                    <asp:EntityDataSource ID="CardTypesDS" runat="server" ConnectionString="name=C4GEntities" 
                        DefaultContainerName="C4GEntities" EnableFlattening="False" EntitySetName="CardTypes">
                    </asp:EntityDataSource>
                </div>
                <div class="FormRow">
                    <label>Card Number</label>
                    <asp:TextBox ID="CCTextBox" runat="server" MaxLength="16" placeholder="****************"></asp:TextBox>
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
                    <label>Expiry Date</label>
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
                    <asp:DropDownList ID="YearDDL" runat="server"></asp:DropDownList>
                </div>
                <div class="FormRow">
                    <label>CVV Number</label>
                    <asp:TextBox ID="CVVTextBox" runat="server" MaxLength="3" placeholder="***"></asp:TextBox>
                    <asp:RequiredFieldValidator ID="RequiredFieldValidator2" runat="server" 
                        ErrorMessage="Credit Card Number is required!" Text="*" ControlToValidate="CVVTextBox">\
                    </asp:RequiredFieldValidator>
                    <asp:RegularExpressionValidator ID="RegularExpressionValidator2" runat="server" 
                        ErrorMessage="Card Number must be digits only!" ValidationExpression="^\d+$"
                        ControlToValidate="CVVTextBox">
                    </asp:RegularExpressionValidator>
                </div>
                <div class="FormRow">
                    <label>First Name</label>
                    <asp:TextBox ID="FirstNameTextBox" runat="server" placeholder="First Name"></asp:TextBox>
                    <asp:RequiredFieldValidator ID="RequiredFieldValidator3" runat="server" 
                        ErrorMessage="First Name is required." Text="*" ControlToValidate="FirstNameTextBox">
                    </asp:RequiredFieldValidator>
                </div>
                <div class="FormRow">
                    <label>Last Name</label>
                    <asp:TextBox ID="LastNameTextBox" runat="server" placeholder="Last Name"></asp:TextBox>
                    <asp:RequiredFieldValidator ID="RequiredFieldValidator4" runat="server" 
                        ErrorMessage="Last Name is required." Text="*" ControlToValidate="LastNameTextBox">
                    </asp:RequiredFieldValidator>
                </div>
                <div class="FormRow">
                    <label>Address</label>
                    <asp:TextBox ID="AddressTextBox" runat="server" placeholder="1234, 5th Street"></asp:TextBox>
                    <asp:RequiredFieldValidator ID="AddressRFV" runat="server" ControlToValidate="AddressTextBox"
                        ErrorMessage="Address is required." Text="*">
                    </asp:RequiredFieldValidator>
                </div>
                <div class="FormRow">
                    <label>City</label>
                    <asp:TextBox ID="CityTextBox" runat="server"></asp:TextBox>
                    <asp:RequiredFieldValidator ID="CitRFV" runat="server" ControlToValidate="CityTextBox"
                        ErrorMessage="City is required." Text="*"></asp:RequiredFieldValidator>
                </div>
                <div class="FormRow">
                    <label for="ProvinceTextBox">Province/State</label>
                    <asp:TextBox ID="ProvinceTextBox" runat="server"></asp:TextBox>
                    <asp:RequiredFieldValidator ID="RequiredFieldValidator5" runat="server" ControlToValidate="ProvinceTextBox"
                        ErrorMessage="Province/State is required." Text="*"></asp:RequiredFieldValidator>
                </div>
                <div class="FormRow">
                    <label for="PostalTextBox">Postal Code</label>
                    <asp:TextBox ID="PostalTextBox" runat="server" placeholder="T6L2M9, 90210, or 90210-1234"></asp:TextBox>
                    <asp:RequiredFieldValidator ID="RequiredFieldValidator6" runat="server" ControlToValidate="PostalTextBox"
                        ErrorMessage="Postal Code is required." Text="*"></asp:RequiredFieldValidator>
                    <asp:RegularExpressionValidator ID="PostalREV" runat="server" ControlToValidate="PostalTextBox"
                        ErrorMessage="Postal code must follow the format A1A 1A1 or 12345" Text="*" 
                        ValidationExpression="(^\d{5}(-\d{4})?$)|(^[ABCEGHJKLMNPRSTVXY]{1}\d{1}[A-Z]{1} *\d{1}[A-Z]{1}\d{1}$)">
                    </asp:RegularExpressionValidator>
                </div>
                <div class="FormRow">
                    <label for="CountryDDL">Country</label>
                    <asp:DropDownList ID="CountryDDL" runat="server">
                        <asp:ListItem Text="Afghanistan">Afghanistan</asp:ListItem>
                        <asp:ListItem Text="Albania">Albania</asp:ListItem>
                        <asp:ListItem Text="Algeria">Algeria</asp:ListItem>
                        <asp:ListItem Text="American Samoa">American Samoa</asp:ListItem>
                        <asp:ListItem Text="Andorra">Andorra</asp:ListItem>
                        <asp:ListItem Text="Angola">Angola</asp:ListItem>
                        <asp:ListItem Text="Anguilla">Anguilla</asp:ListItem>
                        <asp:ListItem Text="Antigua &amp; Barbuda">Antigua &amp; Barbuda</asp:ListItem>
                        <asp:ListItem Text="Argentina">Argentina</asp:ListItem>
                        <asp:ListItem Text="Armenia">Armenia</asp:ListItem>
                        <asp:ListItem Text="Aruba">Aruba</asp:ListItem>
                        <asp:ListItem Text="Australia">Australia</asp:ListItem>
                        <asp:ListItem Text="Austria">Austria</asp:ListItem>
                        <asp:ListItem Text="Azerbaijan">Azerbaijan</asp:ListItem>
                        <asp:ListItem Text="Bahamas">Bahamas</asp:ListItem>
                        <asp:ListItem Text="Bahrain">Bahrain</asp:ListItem>
                        <asp:ListItem Text="Bangladesh">Bangladesh</asp:ListItem>
                        <asp:ListItem Text="Barbados">Barbados</asp:ListItem>
                        <asp:ListItem Text="Belarus">Belarus</asp:ListItem>
                        <asp:ListItem Text="Belgium">Belgium</asp:ListItem>
                        <asp:ListItem Text="Belize">Belize</asp:ListItem>
                        <asp:ListItem Text="Benin">Benin</asp:ListItem>
                        <asp:ListItem Text="Bermuda">Bermuda</asp:ListItem>
                        <asp:ListItem Text="Bhutan">Bhutan</asp:ListItem>
                        <asp:ListItem Text="Bolivia">Bolivia</asp:ListItem>
                        <asp:ListItem Text="Bonaire">Bonaire</asp:ListItem>
                        <asp:ListItem Text="Bosnia &amp; Herzegovina">Bosnia &amp; Herzegovina</asp:ListItem>
                        <asp:ListItem Text="Botswana">Botswana</asp:ListItem>
                        <asp:ListItem Text="Brazil">Brazil</asp:ListItem>
                        <asp:ListItem Text="British Indian Ocean Ter">British Indian Ocean Ter</asp:ListItem>
                        <asp:ListItem Text="Brunei">Brunei</asp:ListItem>
                        <asp:ListItem Text="Bulgaria">Bulgaria</asp:ListItem>
                        <asp:ListItem Text="Burkina Faso">Burkina Faso</asp:ListItem>
                        <asp:ListItem Text="Burundi">Burundi</asp:ListItem>
                        <asp:ListItem Text="Cambodia">Cambodia</asp:ListItem>
                        <asp:ListItem Text="Cameroon">Cameroon</asp:ListItem>
                        <asp:ListItem Text="Canada">Canada</asp:ListItem>
                        <asp:ListItem Text="Canary Islands">Canary Islands</asp:ListItem>
                        <asp:ListItem Text="Cape Verde">Cape Verde</asp:ListItem>
                        <asp:ListItem Text="Cayman Islands">Cayman Islands</asp:ListItem>
                        <asp:ListItem Text="Central African Republic">Central African Republic</asp:ListItem>
                        <asp:ListItem Text="Chad">Chad</asp:ListItem>
                        <asp:ListItem Text="Channel Islands">Channel Islands</asp:ListItem>
                        <asp:ListItem Text="Chile">Chile</asp:ListItem>
                        <asp:ListItem Text="China">China</asp:ListItem>
                        <asp:ListItem Text="Christmas Island">Christmas Island</asp:ListItem>
                        <asp:ListItem Text="Cocos Island">Cocos Island</asp:ListItem>
                        <asp:ListItem Text="Colombia">Colombia</asp:ListItem>
                        <asp:ListItem Text="Comoros">Comoros</asp:ListItem>
                        <asp:ListItem Text="Congo">Congo</asp:ListItem>
                        <asp:ListItem Text="Cook Islands">Cook Islands</asp:ListItem>
                        <asp:ListItem Text="Costa Rica">Costa Rica</asp:ListItem>
                        <asp:ListItem Text="Cote DIvoire">Cote D'Ivoire</asp:ListItem>
                        <asp:ListItem Text="Croatia">Croatia</asp:ListItem>
                        <asp:ListItem Text="Cuba">Cuba</asp:ListItem>
                        <asp:ListItem Text="Curaco">Curacao</asp:ListItem>
                        <asp:ListItem Text="Cyprus">Cyprus</asp:ListItem>
                        <asp:ListItem Text="Czech Republic">Czech Republic</asp:ListItem>
                        <asp:ListItem Text="Denmark">Denmark</asp:ListItem>
                        <asp:ListItem Text="Djibouti">Djibouti</asp:ListItem>
                        <asp:ListItem Text="Dominica">Dominica</asp:ListItem>
                        <asp:ListItem Text="Dominican Republic">Dominican Republic</asp:ListItem>
                        <asp:ListItem Text="East Timor">East Timor</asp:ListItem>
                        <asp:ListItem Text="Ecuador">Ecuador</asp:ListItem>
                        <asp:ListItem Text="Egypt">Egypt</asp:ListItem>
                        <asp:ListItem Text="El Salvador">El Salvador</asp:ListItem>
                        <asp:ListItem Text="Equatorial Guinea">Equatorial Guinea</asp:ListItem>
                        <asp:ListItem Text="Eritrea">Eritrea</asp:ListItem>
                        <asp:ListItem Text="Estonia">Estonia</asp:ListItem>
                        <asp:ListItem Text="Ethiopia">Ethiopia</asp:ListItem>
                        <asp:ListItem Text="Falkland Islands">Falkland Islands</asp:ListItem>
                        <asp:ListItem Text="Faroe Islands">Faroe Islands</asp:ListItem>
                        <asp:ListItem Text="Fiji">Fiji</asp:ListItem>
                        <asp:ListItem Text="Finland">Finland</asp:ListItem>
                        <asp:ListItem Text="France">France</asp:ListItem>
                        <asp:ListItem Text="French Guiana">French Guiana</asp:ListItem>
                        <asp:ListItem Text="French Polynesia">French Polynesia</asp:ListItem>
                        <asp:ListItem Text="French Southern Ter">French Southern Ter</asp:ListItem>
                        <asp:ListItem Text="Gabon">Gabon</asp:ListItem>
                        <asp:ListItem Text="Gambia">Gambia</asp:ListItem>
                        <asp:ListItem Text="Georgia">Georgia</asp:ListItem>
                        <asp:ListItem Text="Germany">Germany</asp:ListItem>
                        <asp:ListItem Text="Ghana">Ghana</asp:ListItem>
                        <asp:ListItem Text="Gibraltar">Gibraltar</asp:ListItem>
                        <asp:ListItem Text="Great Britain">Great Britain</asp:ListItem>
                        <asp:ListItem Text="Greece">Greece</asp:ListItem>
                        <asp:ListItem Text="Greenland">Greenland</asp:ListItem>
                        <asp:ListItem Text="Grenada">Grenada</asp:ListItem>
                        <asp:ListItem Text="Guadeloupe">Guadeloupe</asp:ListItem>
                        <asp:ListItem Text="Guam">Guam</asp:ListItem>
                        <asp:ListItem Text="Guatemala">Guatemala</asp:ListItem>
                        <asp:ListItem Text="Guinea">Guinea</asp:ListItem>
                        <asp:ListItem Text="Guyana">Guyana</asp:ListItem>
                        <asp:ListItem Text="Haiti">Haiti</asp:ListItem>
                        <asp:ListItem Text="Hawaii">Hawaii</asp:ListItem>
                        <asp:ListItem Text="Honduras">Honduras</asp:ListItem>
                        <asp:ListItem Text="Hong Kong">Hong Kong</asp:ListItem>
                        <asp:ListItem Text="Hungary">Hungary</asp:ListItem>
                        <asp:ListItem Text="Iceland">Iceland</asp:ListItem>
                        <asp:ListItem Text="India">India</asp:ListItem>
                        <asp:ListItem Text="Indonesia">Indonesia</asp:ListItem>
                        <asp:ListItem Text="Iran">Iran</asp:ListItem>
                        <asp:ListItem Text="Iraq">Iraq</asp:ListItem>
                        <asp:ListItem Text="Ireland">Ireland</asp:ListItem>
                        <asp:ListItem Text="Isle of Man">Isle of Man</asp:ListItem>
                        <asp:ListItem Text="Israel">Israel</asp:ListItem>
                        <asp:ListItem Text="Italy">Italy</asp:ListItem>
                        <asp:ListItem Text="Jamaica">Jamaica</asp:ListItem>
                        <asp:ListItem Text="Japan">Japan</asp:ListItem>
                        <asp:ListItem Text="Jordan">Jordan</asp:ListItem>
                        <asp:ListItem Text="Kazakhstan">Kazakhstan</asp:ListItem>
                        <asp:ListItem Text="Kenya">Kenya</asp:ListItem>
                        <asp:ListItem Text="Kiribati">Kiribati</asp:ListItem>
                        <asp:ListItem Text="North Korea">North Korea</asp:ListItem>
                        <asp:ListItem Text="South Korea">South Korea</asp:ListItem>
                        <asp:ListItem Text="Kuwait">Kuwait</asp:ListItem>
                        <asp:ListItem Text="Kyrgyzstan">Kyrgyzstan</asp:ListItem>
                        <asp:ListItem Text="Laos">Laos</asp:ListItem>
                        <asp:ListItem Text="Latvia">Latvia</asp:ListItem>
                        <asp:ListItem Text="Lebanon">Lebanon</asp:ListItem>
                        <asp:ListItem Text="Lesotho">Lesotho</asp:ListItem>
                        <asp:ListItem Text="Liberia">Liberia</asp:ListItem>
                        <asp:ListItem Text="Libya">Libya</asp:ListItem>
                        <asp:ListItem Text="Liechtenstein">Liechtenstein</asp:ListItem>
                        <asp:ListItem Text="Lithuania">Lithuania</asp:ListItem>
                        <asp:ListItem Text="Luxembourg">Luxembourg</asp:ListItem>
                        <asp:ListItem Text="Macau">Macau</asp:ListItem>
                        <asp:ListItem Text="Macedonia">Macedonia</asp:ListItem>
                        <asp:ListItem Text="Madagascar">Madagascar</asp:ListItem>
                        <asp:ListItem Text="Malaysia">Malaysia</asp:ListItem>
                        <asp:ListItem Text="Malawi">Malawi</asp:ListItem>
                        <asp:ListItem Text="Maldives">Maldives</asp:ListItem>
                        <asp:ListItem Text="Mali">Mali</asp:ListItem>
                        <asp:ListItem Text="Malta">Malta</asp:ListItem>
                        <asp:ListItem Text="Marshall Islands">Marshall Islands</asp:ListItem>
                        <asp:ListItem Text="Martinique">Martinique</asp:ListItem>
                        <asp:ListItem Text="Mauritania">Mauritania</asp:ListItem>
                        <asp:ListItem Text="Mauritius">Mauritius</asp:ListItem>
                        <asp:ListItem Text="Mayotte">Mayotte</asp:ListItem>
                        <asp:ListItem Text="Mexico">Mexico</asp:ListItem>
                        <asp:ListItem Text="Midway Islands">Midway Islands</asp:ListItem>
                        <asp:ListItem Text="Moldova">Moldova</asp:ListItem>
                        <asp:ListItem Text="Monaco">Monaco</asp:ListItem>
                        <asp:ListItem Text="Mongolia">Mongolia</asp:ListItem>
                        <asp:ListItem Text="Montserrat">Montserrat</asp:ListItem>
                        <asp:ListItem Text="Morocco">Morocco</asp:ListItem>
                        <asp:ListItem Text="Mozambique">Mozambique</asp:ListItem>
                        <asp:ListItem Text="Myanmar">Myanmar</asp:ListItem>
                        <asp:ListItem Text="Nambia">Nambia</asp:ListItem>
                        <asp:ListItem Text="Nauru">Nauru</asp:ListItem>
                        <asp:ListItem Text="Nepal">Nepal</asp:ListItem>
                        <asp:ListItem Text="Netherland Antilles">Netherland Antilles</asp:ListItem>
                        <asp:ListItem Text="Netherlands">Netherlands (Holland, Europe)</asp:ListItem>
                        <asp:ListItem Text="Nevis">Nevis</asp:ListItem>
                        <asp:ListItem Text="New Caledonia">New Caledonia</asp:ListItem>
                        <asp:ListItem Text="New Zealand">New Zealand</asp:ListItem>
                        <asp:ListItem Text="Nicaragua">Nicaragua</asp:ListItem>
                        <asp:ListItem Text="Niger">Niger</asp:ListItem>
                        <asp:ListItem Text="Nigeria">Nigeria</asp:ListItem>
                        <asp:ListItem Text="Niue">Niue</asp:ListItem>
                        <asp:ListItem Text="Norfolk Island">Norfolk Island</asp:ListItem>
                        <asp:ListItem Text="Norway">Norway</asp:ListItem>
                        <asp:ListItem Text="Oman">Oman</asp:ListItem>
                        <asp:ListItem Text="Pakistan">Pakistan</asp:ListItem>
                        <asp:ListItem Text="Palau Island">Palau Island</asp:ListItem>
                        <asp:ListItem Text="Palestine">Palestine</asp:ListItem>
                        <asp:ListItem Text="Panama">Panama</asp:ListItem>
                        <asp:ListItem Text="Papua New Guinea">Papua New Guinea</asp:ListItem>
                        <asp:ListItem Text="Paraguay">Paraguay</asp:ListItem>
                        <asp:ListItem Text="Peru">Peru</asp:ListItem>
                        <asp:ListItem Text="Phillipines">Philippines</asp:ListItem>
                        <asp:ListItem Text="Pitcairn Island">Pitcairn Island</asp:ListItem>
                        <asp:ListItem Text="Poland">Poland</asp:ListItem>
                        <asp:ListItem Text="Portugal">Portugal</asp:ListItem>
                        <asp:ListItem Text="Puerto Rico">Puerto Rico</asp:ListItem>
                        <asp:ListItem Text="Qatar">Qatar</asp:ListItem>
                        <asp:ListItem Text="Republic of Montenegro">Republic of Montenegro</asp:ListItem>
                        <asp:ListItem Text="Republic of Serbia">Republic of Serbia</asp:ListItem>
                        <asp:ListItem Text="Reunion">Reunion</asp:ListItem>
                        <asp:ListItem Text="Romania">Romania</asp:ListItem>
                        <asp:ListItem Text="Russia">Russia</asp:ListItem>
                        <asp:ListItem Text="Rwanda">Rwanda</asp:ListItem>
                        <asp:ListItem Text="St Barthelemy">St Barthelemy</asp:ListItem>
                        <asp:ListItem Text="St Eustatius">St Eustatius</asp:ListItem>
                        <asp:ListItem Text="St Helena">St Helena</asp:ListItem>
                        <asp:ListItem Text="St Kitts-Nevis">St Kitts-Nevis</asp:ListItem>
                        <asp:ListItem Text="St Lucia">St Lucia</asp:ListItem>
                        <asp:ListItem Text="St Maarten">St Maarten</asp:ListItem>
                        <asp:ListItem Text="St Pierre &amp; Miquelon">St Pierre &amp; Miquelon</asp:ListItem>
                        <asp:ListItem Text="St Vincent &amp; Grenadines">St Vincent &amp; Grenadines</asp:ListItem>
                        <asp:ListItem Text="Saipan">Saipan</asp:ListItem>
                        <asp:ListItem Text="Samoa">Samoa</asp:ListItem>
                        <asp:ListItem Text="Samoa American">Samoa American</asp:ListItem>
                        <asp:ListItem Text="San Marino">San Marino</asp:ListItem>
                        <asp:ListItem Text="Sao Tome &amp; Principe">Sao Tome &amp; Principe</asp:ListItem>
                        <asp:ListItem Text="Saudi Arabia">Saudi Arabia</asp:ListItem>
                        <asp:ListItem Text="Senegal">Senegal</asp:ListItem>
                        <asp:ListItem Text="Serbia">Serbia</asp:ListItem>
                        <asp:ListItem Text="Seychelles">Seychelles</asp:ListItem>
                        <asp:ListItem Text="Sierra Leone">Sierra Leone</asp:ListItem>
                        <asp:ListItem Text="Singapore">Singapore</asp:ListItem>
                        <asp:ListItem Text="Slovakia">Slovakia</asp:ListItem>
                        <asp:ListItem Text="Slovenia">Slovenia</asp:ListItem>
                        <asp:ListItem Text="Solomon Islands">Solomon Islands</asp:ListItem>
                        <asp:ListItem Text="Somalia">Somalia</asp:ListItem>
                        <asp:ListItem Text="South Africa">South Africa</asp:ListItem>
                        <asp:ListItem Text="Spain">Spain</asp:ListItem>
                        <asp:ListItem Text="Sri Lanka">Sri Lanka</asp:ListItem>
                        <asp:ListItem Text="Sudan">Sudan</asp:ListItem>
                        <asp:ListItem Text="Suriname">Suriname</asp:ListItem>
                        <asp:ListItem Text="Swaziland">Swaziland</asp:ListItem>
                        <asp:ListItem Text="Sweden">Sweden</asp:ListItem>
                        <asp:ListItem Text="Switzerland">Switzerland</asp:ListItem>
                        <asp:ListItem Text="Syria">Syria</asp:ListItem>
                        <asp:ListItem Text="Tahiti">Tahiti</asp:ListItem>
                        <asp:ListItem Text="Taiwan">Taiwan</asp:ListItem>
                        <asp:ListItem Text="Tajikistan">Tajikistan</asp:ListItem>
                        <asp:ListItem Text="Tanzania">Tanzania</asp:ListItem>
                        <asp:ListItem Text="Thailand">Thailand</asp:ListItem>
                        <asp:ListItem Text="Togo">Togo</asp:ListItem>
                        <asp:ListItem Text="Tokelau">Tokelau</asp:ListItem>
                        <asp:ListItem Text="Tonga">Tonga</asp:ListItem>
                        <asp:ListItem Text="Trinidad &amp; Tobago">Trinidad &amp; Tobago</asp:ListItem>
                        <asp:ListItem Text="Tunisia">Tunisia</asp:ListItem>
                        <asp:ListItem Text="Turkey">Turkey</asp:ListItem>
                        <asp:ListItem Text="Turkmenistan">Turkmenistan</asp:ListItem>
                        <asp:ListItem Text="Turks &amp; Caicos Is">Turks &amp; Caicos Is</asp:ListItem>
                        <asp:ListItem Text="Tuvalu">Tuvalu</asp:ListItem>
                        <asp:ListItem Text="Uganda">Uganda</asp:ListItem>
                        <asp:ListItem Text="Ukraine">Ukraine</asp:ListItem>
                        <asp:ListItem Text="United Arab Erimates">United Arab Emirates</asp:ListItem>
                        <asp:ListItem Text="United Kingdom">United Kingdom</asp:ListItem>
                        <asp:ListItem Text="United States of America">United States of America</asp:ListItem>
                        <asp:ListItem Text="Uruguay">Uruguay</asp:ListItem>
                        <asp:ListItem Text="Uzbekistan">Uzbekistan</asp:ListItem>
                        <asp:ListItem Text="Vanuatu">Vanuatu</asp:ListItem>
                        <asp:ListItem Text="Vatican City State">Vatican City State</asp:ListItem>
                        <asp:ListItem Text="Venezuela">Venezuela</asp:ListItem>
                        <asp:ListItem Text="Vietnam">Vietnam</asp:ListItem>
                        <asp:ListItem Text="Virgin Islands (Brit)">Virgin Islands (Brit)</asp:ListItem>
                        <asp:ListItem Text="Virgin Islands (USA)">Virgin Islands (USA)</asp:ListItem>
                        <asp:ListItem Text="Wake Island">Wake Island</asp:ListItem>
                        <asp:ListItem Text="Wallis &amp; Futana Is">Wallis &amp; Futana Is</asp:ListItem>
                        <asp:ListItem Text="Yemen">Yemen</asp:ListItem>
                        <asp:ListItem Text="Zaire">Zaire</asp:ListItem>
                        <asp:ListItem Text="Zambia">Zambia</asp:ListItem>
                        <asp:ListItem Text="Zimbabwe">Zimbabwe</asp:ListItem>
                    </asp:DropDownList>
                </div>
                <div class="FormRow SubmitRow">
                    <asp:Button ID="SubmitButton" runat="server" Text="Submit" OnClick="SubmitButton_Click" />
                </div>
            </div>
        </div>
</asp:Content>