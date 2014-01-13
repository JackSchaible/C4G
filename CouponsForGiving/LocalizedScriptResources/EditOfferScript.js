$(document).ready(function () {
    calcSplit();
    checkForm();

    //Bind events
    document.getElementById("Image").addEventListener('change', checkImage, false);
    var startDay = $("#StartDate select[id$='DayDDL']").change(checkStartDate);
    var startMonth = $("#StartDate select[id$='MonthDDL']").change(checkStartDate);
    var startYear = $("#StartDate select[id$='YearDDL']").change(checkStartDate);
    var endDay = $("#EndDate select[id$='DayDDL']").change(checkEndDate);
    var endMonth = $("#EndDate select[id$='MonthDDL']").change(checkEndDate);
    var endYear = $("#EndDate select[id$='YearDDL']").change(checkEndDate);
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

function calcSplit(value) {
    if (!isNaN(value)) {
        var vat = (value * 0.029) + 0.3;
        var tax = (value * 0.2) * 0.05;
        var split = (value * 0.54) - (vat + tax);

        if ((isNaN(vat) || isNaN(tax) || isNaN(split)) || (vat == 0) || (tax == 0) || (split == 0) || value == undefined) {
            $("#SplitOutput").hide();
        }
        else {
            $("#SplitOutput").show();
            $("#VAT").text("$" + vat.toFixed(2).replace(/(\d)(?=(\d{3})+\.)/g, '$1,'));
            $("#Tax").text("$" + tax.toFixed(2).replace(/(\d)(?=(\d{3})+\.)/g, '$1,'));

            //IMPORTANT: MUST BE THE SAME AS THE FORMULA IN ShoppingCart.cs
            $("#SplitTotal").text("$" + split.toFixed(2).replace(/(\d)(?=(\d{3})+\.)/g, '$1,'));
        }
    }
    else {
        $("#SplitOutput").hide();
    }
}

function checkName(write) {
    var name = $("#OfferNameTextBox").val();
    var errors = new Array();

    if (IsStringBlank(name)) {
        errors.push('You need to enter a name for your offer.');
    }

    if (IsStringTooShort(name, 5))
        errors.push('Your offer name is too short. Offer names need to be at least 5 characters long.');

    if (IsStringTooLong(name, 50))
        errors.push('Your offer name is too long. Offer names need to be less than 50 characters long.');

    if (containsCode(name))
        errors.push('Your offer name contains invalid characters. Please ensure it does not contain any of the following: &lt;, &gt;, {, }, or ;.');

    if (arguments.length == 0) {
        PageMethods.CheckName(name, function (message) {
            if (message == "true") {
                $("#OfferTaken").css('display', 'block');
                $("#OfferTaken").html('<ul><li>Sorry, but you already have an offer with that name. Offer names need to be unique. Please enter a different name.</li></ul>');
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
        errors.push('You need to enter a description for your offer.');

    if (!ContainsSpaces(description))
        errors.push('Your offer description needs to be more than one word.');

    if (IsStringTooLong(description, 200))
        errors.push('Your offer description is too long. Offer descriptions need to be less than 200 characters long.');

    if (IsStringTooShort(description, 10))
        errors.push('Your offer description is too short. Offers descriptions need to be at least 10 characters long.');

    if (containsCode(description))
        errors.push('Your offer description contains invalid characters. Please ensure it does not contain any of the following: &lt;, &gt;, {, }, or ;.');

    if (arguments.length == 0) {
        writeErrors('DescriptionTextBoxErrors', errors);
        checkForm();
    }

    return errors;
}

function checkStartDate(write) {
    var startDay = $("#StartDate select[id$='DayDDL'] option:selected").text();
    var startMonth = $("#StartDate select[id$='MonthDDL'] option:selected").val();
    var startYear = $("#StartDate select[id$='YearDDL'] option:selected").text();

    var endDay = $("#EndDate select[id$='DayDDL'] option:selected").text();
    var endMonth = $("#EndDate select[id$='MonthDDL'] option:selected").val();
    var endYear = $("#EndDate select[id$='YearDDL'] option:selected").text();

    var startDate = new Date(startYear, startMonth, startDay);
    var endDate = new Date(endYear, endMonth, endDay);
    var errors = new Array();
    var errors2 = new Array();

    if (startDate >= endDate) {
        errors.push('The start date of your offer needs to be before its end date.');
        errors2.push('The end date of your offer needs to be after its start date.');
    }

    if (arguments[0] != false) {
        writeErrors('StartDateErrors', errors);
        writeErrors('EndDateErrors', errors2);
        checkForm();
    }

    return errors;
}

function checkEndDate(write) {
    var startDay = $("#StartDate select[id$='DayDDL'] option:selected").text();
    var startMonth = $("#StartDate select[id$='MonthDDL'] option:selected").val();
    var startYear = $("#StartDate select[id$='YearDDL'] option:selected").text();

    var endDay = $("#EndDate select[id$='DayDDL'] option:selected").text();
    var endMonth = $("#EndDate select[id$='MonthDDL'] option:selected").val();
    var endYear = $("#EndDate select[id$='YearDDL'] option:selected").text();

    var startDate = new Date(startYear, startMonth, startDay);
    var endDate = new Date(endYear, endMonth, endDay);
    var errors = new Array();
    var errors2 = new Array();

    if (startDate >= endDate) {
        errors.push('The end date of your offer needs to be after its start date.');
        errors2.push('The start date of your offer needs to be before its end date.');
    }

    if (endDate < new Date())
        errors.push('The end date of your offer needs to be later than today&apos;s date.');

    if (arguments[0] != false) {
        writeErrors('EndDateErrors', errors);
        writeErrors('StartDateErrors', errors2);
        checkForm();
    }

    return errors;
}

function checkAbsCouponLimit(write) {
    var limit = Number($("#AbsoluteCouponLimitTextBox").val());
    var limitPerCustomer = Number($("#LimitPerCustomerTextBox").val());
    var errors = new Array();
    var errors2 = new Array();

    if (!IsNumber(limit))
        errors.push('Your absolute coupon limit needs to be a number. For example, 2500.');
    else {
        if (Is0(limit))
            errors.push('You need to enter an absolute limit for your offer. This is how many coupons you wish to sell overall.');
        else {
            console.log(limit);
            if (limit > 9999) {
                errors.push('The absolute limit of coupons to sell needs to be less than 10, 000.');
            }
            else {
                if (IsNumberLargerOrEqual(limit, 0)) {
                    errors.push('Your absolute coupon limit needs to be greater than 0.');
                }
                else {
                    if (IsNumber(limitPerCustomer)) {
                        if (!Is0(limitPerCustomer)) {
                            if (limit < limitPerCustomer) {
                                errors.push('The absolute limit of coupons to sell must be greater than or equal to the limit per customer.');
                                errors2.push('The limit of coupons per customer must be less than than or equal to the absolute limit of coupons to sell.');
                            }
                        }
                    }
                    else {
                        errors2.push('Your coupon limit per customer needs to be a number. For example, 2500.');
                    }
                }
            }
        }
    }

    if (arguments.length == 0) {
        writeErrors('AbsoluteCouponLimitTextBoxErrors', errors);
        writeErrors('LimitPerCustomerTextBoxErrors', errors2);
        checkForm();
    }

    return errors;
}

function checkPCCouponLimit(write) {
    var absLimit = Number($("#AbsoluteCouponLimitTextBox").val());
    var limitPerCustomer = Number($("#LimitPerCustomerTextBox").val());
    var errors = new Array();
    var errors2 = new Array();

    if (!IsNumber(limitPerCustomer))
        errors.push('Your coupon limit per customer needs to be a number. For example, 2500.');
    else {
        if (Is0(limitPerCustomer))
            errors.push('You need to enter a limit per customer for your offer. This is how many coupons each individual customer is allowed to buy.');
        else {
            if (IsNumberLargerOrEqual(limitPerCustomer, 0))
                errors.push('Your coupon limit per customer needs to be greater than 0.');
            else {
                if (IsNumber(absLimit)) {
                    if (!Is0(absLimit)) {
                        if (absLimit < limitPerCustomer) {
                            errors.push('The limit of coupons per customer must be less than than or equal to the absolute limit of coupons to sell.');
                            errors2.push('The absolute limit of coupons to sell must be greater than or equal to the limit per customer.');
                        }
                    }
                }
                else {
                    errors2.push('Your absolute coupon limit needs to be a number. For example, 2500.');
                }
            }
        }
    }

    if (arguments.length == 0) {
        writeErrors('LimitPerCustomerTextBoxErrors', errors);
        writeErrors('AbsoluteCouponLimitTextBoxErrors', errors2);
        checkForm();
    }

    return errors;
}

function checkRetailValue(write) {
    var retailValue = Number($("#RetailValueTextBox").val());
    var giftValue = Number($("#GiftValueTextBox").val());
    var errors = new Array();
    var errors2 = new Array();

    if (!IsNumber(retailValue))
        errors.push('Your retail value needs to be a number. For example, 25.00.');
    else {
        if (Is0(retailValue))
            errors.push('You need to enter a retail value for your offer. This is how much your product or service typically costs.');
        else {
            if (retailValue <= 1)
                errors.push('Your retail value needs to be greater than $1.00.');
            else {
                if (IsNumber(giftValue)) {
                    if (!Is0(giftValue)) {
                        if (retailValue < giftValue) {
                            errors.push('The retail value of your offer must be greater than than its gift value.');
                            errors2.push('The gift value of your offer must be less than than its retail value.');
                        }
                    }
                }
                else {
                    errors2.push('Your gift value needs to be a number. For example, 25.00.');
                }
            }
        }
    }

    if (arguments.length == 0) {
        writeErrors('RetailValueTextBoxErrors', errors);
        writeErrors('GiftValueTextBoxErrors', errors2);
        checkForm();
    }

    return errors;
}

function checkGiftValue(write) {
    var retailValue = Number($("#RetailValueTextBox").val());
    var giftValue = ($("#GiftValueTextBox").val());
    var errors = new Array();
    var errors2 = new Array();

    calcSplit(giftValue);

    if (!IsNumber(giftValue))
        errors.push('Your gift value needs to be a number. For example, 25.00.');
    else {
        if (Is0(giftValue))
            errors.push('You need to enter a gift value for your offer. This is how much you this coupon will cost to purchase.');
        else {
            if (IsNumberLargerOrEqual(giftValue, 0))
                errors.push('Your gift value needs to be greater than $1.00.');
            else {
                if (IsNumber(retailValue)) {
                    if (!Is0(retailValue)) {
                        if (retailValue < giftValue) {
                            errors.push('The retail value of your offer must be greater than than its gift value.');
                            errors2.push('The gift value of your offer must be less than than its retail value.');
                        }
                    }
                }
                else {
                    errors2.push('Your retail value needs to be a number. For example, 25.00.');
                }
            }
        }
    }

    if (arguments.length == 0) {
        writeErrors('RetailValueTextBoxErrors', errors2);
        writeErrors('GiftValueTextBoxErrors', errors);
        checkForm();
    }

    return errors;
}

function checkRedemptionDetails(write) {
    var redeemDetails = $("#AdditionalRedemptionDetailsTextBox").val();
    var errors = new Array();

    if (IsStringTooLong(redeemDetails, 500))
        errors.push('Your additional redeem details need to be less than 500 characters long.');

    if (containsCode(redeemDetails))
        errors.push('Your additional redeem details contains invalid characters. Please ensure it does not contain any of the following: &lt;, &gt;, {, }, or ;.');

    if (arguments.length == 0) {
        writeErrors('AdditionalRedemptionDetailsTextBoxErrors', errors);
        checkForm();
    }

    return errors;
}

function submitForm() {
    var errors = checkForm(false);

    if (errors.length > 0) {
        errors.splice(0, 0, 'There were some errors with your form submission. Please review the following errors and try again.');
        writeErrors('FormErrors', errors);
    }
    else {
        var name = $("#OfferNameTextBox").val();
        var description = $("#DescriptionTextBox").val();
        var startDay = Number($("#StartDate select[id$='DayDDL'] option:selected").text());
        var startMonth = Number($("#StartDate select[id$='MonthDDL'] option:selected").val()) - 1;
        var startYear = Number($("#StartDate select[id$='YearDDL'] option:selected").text());

        var endDay = Number($("#EndDate select[id$='DayDDL'] option:selected").text());
        var endMonth = Number($("#EndDate select[id$='MonthDDL'] option:selected").val()) - 1;
        var endYear = Number($("#EndDate select[id$='YearDDL'] option:selected").text());

        var startDate = new Date(startYear, startMonth, startDay);
        var endDate = new Date(endYear, endMonth, endDay);

        console.log(endDay);
        console.log(endMonth);
        console.log(endYear);
        console.log(endDate);

        var limit = $("#AbsoluteCouponLimitTextBox").val();
        var limitPerCustomer = $("#LimitPerCustomerTextBox").val();
        var giftValue = $("#GiftValueTextBox").val();
        var retailValue = $("#RetailValueTextBox").val();
        var redeemDetails = new Array();
        $("#FinePrintList input:checked").each(function () {
            redeemDetails.push(this.value);
        });
        var additionalRedeemDetails = $("#AdditionalRedemptionDetailsTextBox").val();

        PageMethods.CreateOffer(name, description, startDate, endDate,
            limit, limitPerCustomer, retailValue, giftValue, redeemDetails, additionalRedeemDetails,
            function (message) {
                window.location.replace(message);
            },
            function (message) {
                $("#FormErrors").css('display', 'block');
                $("#FormErrors").html('' + message._message + '');
            });
    }
}

function checkForm(disableButton) {
    var errors = new Array();

    errors.push.apply(errors, checkName(false));
    errors.push.apply(errors, checkDescription(false));
    errors.push.apply(errors, checkStartDate(false));
    errors.push.apply(errors, checkEndDate(false));
    errors.push.apply(errors, checkAbsCouponLimit(false));
    errors.push.apply(errors, checkPCCouponLimit(false));
    errors.push.apply(errors, checkRetailValue(false));
    errors.push.apply(errors, checkGiftValue(false));

    if (arguments.length == 0) {
        if (errors.length > 0) {
            $("#SubmitButton").attr("disabled", "disabled");
        }
        else {
            $("#SubmitButton").removeAttr("disabled");
        }
    }

    return errors;
}

//Supporting form functions
function checkImage(evt) {
    var file = evt.target.files[0];
    var errors = new Array();

    if (!IsImage(file))
        errors.push('The file you uploaded is an incorrect file type. Supported types include: GIF, JPEG, Progressive JPEG, PNG, and SVG. Please select another file.');

    if (!IsImageProfileSized(file))
        errors.push('The image you uploaded appears to be too large. We require images to be x pixels wide by y pixels high in order to display properly. Please select another image.');

    writeErrors('ImageErrors', errors);

    if (errors.length == 0)
        $("#UploadButton").removeAttr('disabled');
    else
        $("#UploadButton").attr('disabled', 'disabled');
}

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
            var folderPath = '../../tmp/Images/Offers';
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

function removeImage() {
    $("#UploadedImage").html('<img src="../../Images/c4g_home_step4.png" alt="DefaultProfilePic" />');
    window.imagePath = '../../Images/c4g_home_step4.png';
}

function uploadError() {
    var errors = new Array();
    errors.push('There was a problem uploading your image. Please try again.');
    writeErrors('ImageErrors', errors);
}