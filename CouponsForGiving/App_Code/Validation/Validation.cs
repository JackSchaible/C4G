using System;
using System.Collections.Generic;
using System.Globalization;
using System.Linq;
using System.Text.RegularExpressions;
using System.Web;
using System.Web.UI.HtmlControls;

/// <summary>
/// Summary description for Validation
/// </summary>
public abstract class Validation
{
	public Validation()
	{
	}

    abstract public bool ValidPhoneNumber(string textToEvaluate);

    public bool ContainsCode(string textToEvaluate)
    {
        bool result = false;

        if (textToEvaluate.Contains("<"))
            result = true;
        else
            if (textToEvaluate.Contains(">"))
                result = true;
            else
                if (textToEvaluate.Contains("{"))
                    result = true;
                else
                    if (textToEvaluate.Contains("}"))
                        result = true;
                    else
                        if (textToEvaluate.Contains(";"))
                            result = true;

        return result;
    }

    public bool ContainsSpaces(string textToEvaluate)
    {
        return textToEvaluate.Contains(' ');
    }

    public bool IsValidEmail(string strIn)
    {
        bool invalid = false;
        if (String.IsNullOrEmpty(strIn))
            return false;

        // Use IdnMapping class to convert Unicode domain names. 
        try 
        {
            strIn = Regex.Replace(strIn, @"(@)(.+)$", this.DomainMapper,
                                RegexOptions.None, TimeSpan.FromMilliseconds(200));
        }
        catch (RegexMatchTimeoutException) {
            return false;
        }

        if (invalid) 
            return false;

        // Return true if strIn is in valid e-mail format. 
        try {
            return Regex.IsMatch(strIn, 
                @"^(?("")(""[^""]+?""@)|(([0-9a-z]((\.(?!\.))|[-!#\$%&'\*\+/=\?\^`\{\}\|~\w])*)(?<=[0-9a-z])@))" + 
                @"(?(\[)(\[(\d{1,3}\.){3}\d{1,3}\])|(([0-9a-z][-\w]*[0-9a-z]*\.)+[a-z0-9]{2,24}))$", 
                RegexOptions.IgnoreCase, TimeSpan.FromMilliseconds(250));
        }  
        catch (RegexMatchTimeoutException) {
            return false;
        }
    }

    private string DomainMapper(Match match)
   {
       // IdnMapping class with default property values.
       IdnMapping idn = new IdnMapping();

       string domainName = match.Groups[2].Value;
       domainName = idn.GetAscii(domainName);

       return match.Groups[1].Value + domainName;
   }

    public bool IsStringBlank(string textToEvaluate)
    {
        bool result = false;

        if (String.IsNullOrEmpty(textToEvaluate.Trim()))
            result = true;
        else
            if (String.IsNullOrWhiteSpace(textToEvaluate.Trim()))
                result = true;

        return result;
    }

    public bool IsStringTooLong(string textToEvaluate, int length)
    {
        bool result = false;

        if (textToEvaluate.Trim().Length > length)
            result = true;

        return result;
    }

    public bool IsStringTooShort(string textToEvaluate, int length)
    {
        bool result = false;

        if (textToEvaluate.Trim().Length < length)
            result = true;

        return result;
    }

    public HtmlGenericControl WriteErrorsList(List<string> errors)
    {
        HtmlGenericControl result = new HtmlGenericControl();

        result.TagName = "ul";

        HtmlGenericControl li = new HtmlGenericControl();
        

        foreach (string item in errors)
        {
            li = new HtmlGenericControl();
            li.TagName = "li";
            li.InnerText = item;
            result.Controls.Add(li);
        }

        return result;
    }

    public string WriteClientErrorsList(List<string> errors)
    {
        string result = "";

        if (errors.Count > 0)
        {
            result = "<ul>";

            foreach (string item in errors)
                result += String.Format("<li>{0}</li>", item);

            result += "</ul>";
        }

        return result;
    }
}