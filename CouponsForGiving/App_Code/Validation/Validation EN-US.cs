using System;
using System.Collections.Generic;
using System.Linq;
using System.Text.RegularExpressions;
using System.Web;

/// <summary>
/// Summary description for Validation_EN_US_
/// </summary>
public class Validation_EN_US : Validation
{
    public Validation_EN_US()
        : base()
    {

    }

    public override bool ValidPhoneNumber(string textToEvaluate)
    {
        return new Regex(@"(\W|^)[(]{0,1}\d{3}[)]{0,1}[\s-]{0,1}\d{3}[\s-]{0,1}\d{4}(\W|$)").IsMatch(textToEvaluate);
    }
}