using System;
using System.Text.RegularExpressions;

namespace Services.Utils
{
    public static class RegexConvert
    {
        public static string GetAlphaNumeric(string input)
        {
            Regex rgx = new Regex("[^A-Za-z0-9]+");
            return rgx.Replace(input, string.Empty);
        }

        public static string GetAlpha(string input)
        {
            Regex rgx = new Regex("[^a-zA-Z]+");
            return rgx.Replace(input, string.Empty);
        }

        public static string GetNumeric(string input)
        {
            Regex rgx = new Regex("[^0-9]+");
            return rgx.Replace(input, string.Empty);
        }
    }
}