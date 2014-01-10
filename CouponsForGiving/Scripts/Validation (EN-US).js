function Is0(textToEvaluate) {
    return textToEvaluate == 0;
}

//Checks to see if string is a number
function IsNumber(textToEvaluate) {
    return !isNaN(textToEvaluate);
}

//Checks to see if number is greater than the specified number
function IsNumberLarger(textToEvaluate, number) {
    var result = false;
    console.log("Abs: " + textToEvaluate + ", LPC: " + number);

    if (textToEvaluate == "" || number == "")
        throw "Arguments blank";

    if (textToEvaluate < number)
        result = true;
    
    return result;
}

//Checks to see if number is greater than or equal to the specified number
function IsNumberLargerOrEqual(textToEvaluate, number) {
    var result = false;

    if (textToEvaluate <= number)
        result = true;

    return result;
}

//Checks to see if number is smaller than the specified number
function IsNumberSmaller(textToEvaluate, number) {
    var result = false;

    if (textToEvaluate < number)
        result = true;

    return result;
}

//Checks to see if number is smaller than or equal to the specified number
function IsNumberSmallerOrEqual(textToEvaluate, number) {
    var result = false;

    if (textToEvaluate <= number)
        result = true;

    return result;
}

//Checks a file's MIME Type
function IsImage(file) {
    var fType = file.type;
    var result = false;

    if (fType.toLowerCase() == "image/gif".toLowerCase())
        result = true;

    if (fType.toLowerCase() == "image/jpeg".toLowerCase())
        result = true;

    if (fType.toLowerCase() == "image/png".toLowerCase())
        result = true;

    if (fType.toLowerCase() == "image/pjpeg".toLowerCase())
        result = true;

    if (fType.toLowerCase() == "image/svg+xml".toLowerCase())
        result = true;

    return result;
}

//Checks to make sure the image is roughly sized for the profile page
function IsImageProfileSized(file) {
    var result = true;

    //Add logic here

    return result;
}

//Checks to see if the provided string contains angle brackets, squigly brackets, or semicolons
function containsCode(textToEvaluate) {
    var result = false;

    if (!textToEvaluate)
        result = false;
    else {
        if (textToEvaluate.trim().indexOf("<") != -1 || textToEvaluate.trim().indexOf(">") != -1 || textToEvaluate.trim().indexOf("{") != -1 || textToEvaluate.trim().indexOf("}") != -1 || textToEvaluate.trim().indexOf(";") != -1)
            result = true;
    }
    return result;
}

//Matches the phone number to include (xxx) xxx-xxxx, xxxxxxxxxx, xxx xxx-xxxx or xxx xxx xxxx
function validPhoneNumber(textToEvaluate) {
    var result = true;

    if (!textToEvaluate)
        result = false;
    else {
        if (/(\W|^)[(]{0,1}\d{3}[)]{0,1}[\s-]{0,1}\d{3}[\s-]{0,1}\d{4}(\W|$)/.test(textToEvaluate) == false)
            result = false;
        else
            result = true;
    }

    return result;
}

//Matches the email
function validEmail(textToEvaluate) {
    var result;

    if (!textToEvaluate)
        result = false;
    else {
        if (/^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$/.test(textToEvaluate) == false)
            result = false;
        else
            result = true;
    }

    return result;
}

//Matches a website
function validWebsite(textToEvaluate) {
    var result;

    if (!textToEvaluate)
        result = false;
    else {
        if (/(http|ftp|https):\/\/[\w-]+(\.[\w-]+)+([\w.,@?^=%&amp;:\/~+#-]*[\w@?^=%&amp;\/~+#-])?/.test(textToEvaluate) == false)
            result = false;
        else
            result = true;
    }

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

    if (!textToEvaluate)
        result = false;
    else {
        if (textToEvaluate.trim().length > length)
            result = true;
        else
            result = false;
    }

    return result;
}

//Tests to see if the string is shorter than the provided length, excluding whitespace characters
function IsStringTooShort(textToEvaluate, length) {
    var result;

    if (!textToEvaluate)
        result = false;
    else {
        if (textToEvaluate.trim().length < length)
            result = true;
        else
            result = false;
    }

    return result;
}


//Tests to see if the text contains a space
function ContainsSpaces(textToEvaluate) {
    var result;

    if (!textToEvaluate)
        result = false;
    else {
        if (textToEvaluate.indexOf(" ") == -1)
            result = false;
        else
            result = true;
    }

    return result;
}

//Should match A1A 1A1, A1A1A1, 11111-1111, or 11111
function ValidPostalCode(textToEvaluate) {
    var result;

    if (!textToEvaluate)
        result = false;
    else {
        if (/(^\d{5}(-\d{4})?$)|(^[ABCEGHJKLMNPRSTVXY]{1}\d{1}[A-Z]{1} *\d{1}[A-Z]{1}\d{1}$)/.test(textToEvaluate) == false)
            result = false;
        else
            result = true;
    }

    return result;
}