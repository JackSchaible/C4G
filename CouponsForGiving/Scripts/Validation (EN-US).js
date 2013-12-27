//Checks to see if the provided string contains angle brackets, squigly brackets, or semicolons
function containsCode(textToEvaluate) {
    var result = false;

    if (textToEvaluate.trim().indexOf("<") != -1 || textToEvaluate.trim().indexOf(">") != -1 || textToEvaluate.trim().indexOf("{") != -1 || textToEvaluate.trim().indexOf("}") != -1 || textToEvaluate.trim().indexOf(";") != -1)
        result = true;

    return result;
}

//Matches the phone number to include (xxx) xxx-xxxx, xxxxxxxxxx, xxx xxx-xxxx or xxx xxx xxxx
function validPhoneNumber(textToEvaluate) {
    var result = true;

    if (/(\W|^)[(]{0,1}\d{3}[)]{0,1}[\s-]{0,1}\d{3}[\s-]{0,1}\d{4}(\W|$)/.test(textToEvaluate) == false)
        result = false;
    else
        result = true;

    return result;
}

//Matches the email
function validEmail(textToEvaluate) {
    var result;

    if (/^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$/.test(textToEvaluate) == false)
        result = false;
    else
        result = true;

    return result;
}

//Tests to see if the string is empty or contains only whitespace characters
function IsStringBlank(textToEvaluate) {
    var result;

    if (textToEvaluate.trim().length == 0)
        result = true;
    else
        result = false;

    return result;
}

//Tests to see if the string is longer than the provided length, excluding whitespace characters
function IsStringTooLong(textToEvaluate, length) {
    var result;

    if (textToEvaluate.trim().length > length)
        result = true;
    else
        result = false;
}

//Tests to see if the string is shorter than the provided length, excluding whitespace characters
function IsStringTooShort(textToEvaluate, length) {
    var result;

    if (textToEvaluate.trim().length < length)
        result = true;
    else
        result = false;

    return result;
}


//Tests to see if the text contains a space
function ContainsSpaces(textToEvaluate) {
    var result;

    if (textToEvaluate.indexOf(" ") == -1)
        result = false;
    else
        result = true;

    return result;
}

//Should match A1A 1A1, A1A1A1, 11111-1111, or 11111
function ValidPostalCode(textToEvaluate) {
    var result;

    if (/(^\d{5}(-\d{4})?$)|(^[ABCEGHJKLMNPRSTVXY]{1}\d{1}[A-Z]{1} *\d{1}[A-Z]{1}\d{1}$)/.test(textToEvaluate) == false)
        result = false;
    else
        result = true;

    return result;
}