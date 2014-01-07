<%@ Page Title="New Deal" Language="C#" MasterPageFile="~/Site.master" AutoEventWireup="true" CodeFile="New.aspx.cs" Inherits="Merchant_Deals_New" %>
<%@ Reference Control="~/Controls/MenuBar.ascx" %>

<asp:Content ID="Content1" ContentPlaceHolderID="HeadContent" Runat="Server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="Main_Content" Runat="Server">
    <script type="text/javascript">
        $(document).ready(function () {
            calcSplit();
            checkForm();
        });

        function addLocation(locationID, name) {
            PageMethods.AddLocation(locationID, function () {
                $("#SelectedItems").append("<button id='" + locationID + "Button' onClick='removeLocation(" + locationID + ")>" + name + "</button>)");
            });
        }

        function removeLocation(locationID) {
            PageMethods.RemoveLocation(locationID, function () {
                $(locationID + "Button").remove();
            });
        }

        function calcSplit() {
            var value = $("#newDealGiftValue").val();
            var vat = (value * 0.029) + 0.3;
            var tax = (value * 0.2) * 0.05;
            var split = (value * 0.54) - (vat + tax);

            $("#VAT").text("$" + vat.toFixed(2).replace(/(\d)(?=(\d{3})+\.)/g, '$1,'));
            $("#Tax").text("$" + tax.toFixed(2).replace(/(\d)(?=(\d{3})+\.)/g, '$1,'));

            //IMPORTANT: MUST BE THE SAME AS THE FORMULA IN ShoppingCart.cs
            $("#SplitTotal").text("$" + split.toFixed(2).replace(/(\d)(?=(\d{3})+\.)/g, '$1,'));
        }

        function checkName(write) {
            var name = $("#OfferNameTextBox").val();
            var errors = new Array();

            console.log(name);

            if (IsStringBlank(name)) {
                console.log('String is blank');
                errors.push('<%: strings.SelectSingleNode("/SiteText/Pages/New/ErrorMessages/NullOfferName").InnerText %>');
            }
            
            if (IsStringTooShort(name, 5))
                errors.push('<%: strings.SelectSingleNode("/SiteText/Pages/New/ErrorMessages/OfferNameTooShort").InnerText %>');

            if (IsStringTooLong(name, 50))
                errors.push('<%: strings.SelectSingleNode("/SiteText/Pages/New/ErrorMessages/OfferNameTooLong").InnerText %>');

            if (containsCode(name))
                errors.push('<%: strings.SelectSingleNode("/SiteText/Pages/New/ErrorMessages/OfferNameInvalidCharacters").InnerText %>');

            if (arguments.length == 0) {
                PageMethods.CheckName(name, function (message) {
                    console.log(message);
                    if (message == "true") {
                        $("#OfferTaken").css('display', 'block');
                        $("#OfferTaken").html('<ul><li><%: strings.SelectSingleNode("/SiteText/Pages/New/ErrorMessages/OfferNameTaken").InnerText %></li></ul>');
                        $("#SubmitButton").attr('disabled', 'disabled');
                        checkForm();
                    }
                    else {
                        $("#OfferTaken").css('display', 'none');
                        $("#SubmitButton").removeAttr('disabled');
                        checkForm();
                    }
                });

                writeErrors('OfferNameTextBoxErrors', errors);
                checkForm();
            }
            return errors;
        }

        function checkDescription(write) {
            var description = $("#DescriptionTextBox").val();
            var errors = new Array();

            if (IsStringBlank(description))
                errors.push('<%: strings.SelectSingleNode("/SiteText/Pages/New/ErrorMessages/NullDescription").InnerText %>');

            if (ContainsSpaces(description))
                errors.push('<%: strings.SelectSingleNode("/SiteText/Pages/New/ErrorMessages/DescriptionOneWord").InnerText %>');

            if (IsStringTooLong(description, 200))
                errors.push('<%: strings.SelectSingleNode("/SiteText/Pages/New/ErrorMessages/DescriptionTooLong").InnerText %>');

            if (IsStringTooShort(description, 10))
                errors.push('<%: strings.SelectSingleNode("/SiteText/Pages/New/ErrorMessages/DescriptionTooShort").InnerText %>');

            if (containsCode(description))
                errors.push('<%: strings.SelectSingleNode("/SiteText/Pages/New/ErrorMessages/DescriptionInvalidCharacters").InnerText %>');

            if (arguments.length == 0) {
                writeErrors('DescriptionTextBoxErrors', errors);
                checkForm();
            }
        }

        function checkStartDate() {

        }

        function checkEndDate() {
        }

        function checkForm() {
            var errors = new Array();

            errors.push.apply(errors, checkName(false));
            errors.push.apply(errors, checkDescription(false));

            if (errors.length > 0) {
                $("#SubmitButton").attr("disabled", "disabled");
            }
            else {
                $("#SubmitButton").removeAttr("disabled");
            }

            return errors;
        }

        //Supporting form functions
        function uploadImage() {
            var file = $("#Image")[0].files[0];

            $.ajax({
                url: 'OfferImageUploader.ashx',
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
                    var folderPath = '../tmp/Images/Offers';
                    var fileName = '<%: HttpContext.Current.User.Identity.Name + "OfferLogo" %>';
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
    </script>
    <h1>Offer Creation Page</h1>
    <p>To set up an offer you will need to have the following information:</p>
    <ul>
        <li>What product or service are you offering at a discounted or special rate?</li>
        <li>How long you want to make your offer available for?</li>
        <li>How many offers you want to sell?</li>
        <li>Any special rules of use</li>
        <li>Images of the product or service your are promoting</li>
        <li>Your offer as well as your profile page will now be available for not-for-profits to add to their campaign pages.</li>
    </ul>
    <h1>New <%: merch.Name %> Offer</h1>
    <div class="Form">
        <%--<asp:Panel CssClass="FormRow" ID="LocationsPanel" runat="server">
            <div id="FormRow">
                <p>Your Merchant Locations</p>
                <asp:GridView ID="LocationsGV" runat="server" DataKeyNames="LocationID" AutoGenerateColumns="false">
                    <Columns>
                        <asp:TemplateField>
                            <ItemTemplate>
                                <button onclick="addLocation(<%# Eval("LocationID") %>, '<%# Eval("Address") %> <%# Eval("LocationCity") %>, <%# Eval("ShortProvince") %>, <%# Eval("ShortCountry") %>')">Add Location</button>
                            </ItemTemplate>
                        </asp:TemplateField>
                        <asp:BoundField DataField="Address" HeaderText="Address"></asp:BoundField>
                        <asp:BoundField DataField="LocationCity" HeaderText="City"></asp:BoundField>
                        <asp:BoundField DataField="Province" HeaderText="Province/State"></asp:BoundField>
                        <asp:BoundField DataField="Country" HeaderText="Country"></asp:BoundField>
                        <asp:BoundField DataField="Phone" HeaderText="Phone Number"></asp:BoundField>
                    </Columns>
                </asp:GridView>
                <div id="SelectedItems">
                </div>
            </div>
        </asp:Panel>--%>
        <div class="FormRow">
            <label>Name</label>
            <input id="OfferNameTextBox" type="text" maxlength="50" placeholder="Offer Name" onkeyup="checkName()"
                onblur="checkName()" oninput="checkName()"/>
            <div id="OfferTaken" class="ErrorDiv"></div>
            <div id="OfferNameTextBoxErrors" class="ErrorDiv"></div>
        </div>
        <div class="FormRow TextAreaRow">
            <label>Description</label>
            <textarea ID="DescriptionTextBox" maxlength="200" placeholder="Offer Description" onkeyup="checkDescription()"
                onblur="checkDescription()" oninput="checkDescription()"></textarea>
            <div id="DescriptionTextBoxErrors" class="ErrorDiv"></div>
        </div>
        <div class="FormRow">
            <label>Offer Image<br /><small>This will be the image associated with your deal. It should represent the product or service.</small></label>
            <input id="Image" name="files[]" type="file" />
            <input id="UploadButton" type="button" onclick="uploadImage()" value="Upload" disabled="disabled" />
            <div id="ImageErrors" class="ErrorDiv"></div>
            <div id="Loading" class="hide"><img src="../../Images/loading.gif" alt="Loading"/><p>Loading...</p></div>
            <div id="UploadedImage"><img src="../../Images/c4g_home_step4.png" alt="DefaultProfilePic" /></div>
        </div>
        <div class="FormRow">
            <label>Start Date</label>
            <div id="StartDateDiv">
                <UC:DateControl ID="StartDate" runat="server" AcceptPastDates="false"/>
            </div>
        </div>
        <div class="FormRow">
            <label>End Date</label>
            <div id="EndDateDiv">
                <UC:DateControl ID="EndDate" runat="server" AcceptPastDates="false" />
            </div>
        </div>
        <div class="FormRow">
            <label>Total Coupon Limit</label>
            <input type="text" ID="AbsoluteCouponLimitTextBox" maxlength="10" placeholder="25" onkeyup="checkAbsCouponLimit()"
                onblur="checkAbsCouponLimit()" oninput="checkAbsCouponLimit()"/>
            <div id="AbsoluteCouponLimitTextBoxErrors" class="ErrorDiv"></div>
        </div>
        <div class="FormRow">
            <label>Coupon Limit Per Customer</label>
            <input type="text" ID="LimitPerCustomerTextBox" maxlength="10" placeholder="5" onkeyup="checkPCCouponLimit()"
                onblur="checkPCCouponLimit()" oninput="checkPCCouponLimit()"/>
            <div id="LimitPerCustomerTextBoxErrors" class="ErrorDiv"></div>
        </div>
        <div class="FormRow">
            <label>Retail Value<br /><small>The regular price of the product/service.</small></label>
            $<input type="text" ID="RetailValueTextBox" maxlength="10" placeholder="10.00" onkeyup="checkRetailValue()"
                onblur="checkRetailValue()" oninput="checkRetailValue()"/>
            <div id="RetailValueTextBoxErrors" class="ErrorDiv"></div>
        </div>
        <div class="FormRow">
            <label>Gift Value<br /><small>The Sale Price</small></label>
            <input type="text" ID="GiftValueTextBox" maxlength="10" onkeyup="checkGiftValue()"
                onblur="checkGiftValue()" oninput="checkGiftValue()"/>
            <div id="GiftValueTextBoxErrors" class="ErrorDiv"></div>
            <br />
            <p>Processing Fee (2.9% + $0.30) = <strong id="VAT">$0.00</strong></p>
            <br />
            <p>5% Tax on Coupons4Giving Fee = <strong id="Tax">$0.00</strong></p>
            <br />
            <p>Your Split on Each Purchase = <strong id="SplitTotal">$0.00</strong></p>
        </div>
        <div class="FormRow">
            <h4>Redemption Details</h4>
            <p>
                This is <strong>optional</strong> information that may help buyers with the redemption process, 
                explain restrictions, and tell them anything else they should know about your deal. This will 
                show up as fine print on the bottom of your offer page.
            </p>
            <asp:CheckBoxList ID="FinePrintList" ClientIDMode="Static" runat="server" DataSourceID="FinePrintEDS" DataTextField="Content" DataValueField="FinePrintID">
            </asp:CheckBoxList>
            <asp:EntityDataSource ID="FinePrintEDS" runat="server" ConnectionString="name=C4GEntities" DefaultContainerName="C4GEntities" 
                EnableFlattening="False" EntitySetName="FinePrints">
            </asp:EntityDataSource>
        </div>
        <div class="FormRow TextAreaRow">
            <label>Additional Redemption Details</label>
            <textarea id="AdditionalRedemptionDetailsTextBox" maxlength="500" onkeyup="checkRedemptionDetails()"
                onblur="checkRedemptionDetails()" oninput="checkRedemptionDetails()"></textarea>
        </div>
        <div class="FormRow">
            <input type="button" id="SubmitButton" value="Submit" onclick="submitForm()" />
            <div id="FormErrors" class="ErrorDiv"></div>
        </div>
    </div>
</asp:Content>