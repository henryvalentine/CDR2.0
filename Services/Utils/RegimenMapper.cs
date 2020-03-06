using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;

namespace Services.Utils
{
    public static class RegimenMapper
    {
        public static string RetrieveRegimen(string regimen1, string regimen2, string regimen3)
        {
            var regimen = "";
            try
            {
                if (!string.IsNullOrEmpty(regimen1) && !string.IsNullOrEmpty(regimen2) && !string.IsNullOrEmpty(regimen3))
                {
                    regimen1 = regimen1.Replace("-", "+").Replace("/", "+").Replace("+R", "/R");
                    regimen2 = regimen2.Replace("-", "+").Replace("/", "+").Replace("+R", "/R");
                    regimen3 = regimen3.Replace("-", "+").Replace("/", "+").Replace("+R", "/R");

                    regimen = (regimen1 == regimen2 && regimen2 == regimen3) ? regimen1 : regimen1.Substring(0,3) + "+" + regimen2.Substring(0,3) + "+" + regimen3.Substring(0,3);
                }
                else if (!string.IsNullOrEmpty(regimen1) && string.IsNullOrEmpty(regimen2) && string.IsNullOrEmpty(regimen3))
                {
                    regimen1 = regimen1.Replace("-", "+").Replace("/", "+").Replace("+R", "/R");
                    if (regimen1.ToLower().Contains("mg"))
                    {
                        var rs = regimen1.Split("+").ToList();
                        rs.ForEach(r =>
                        {
                            regimen += r.Substring(0, 3) + "+";
                        });
                    }
                    else
                    {
                        regimen += regimen1;
                    }
                }
                else if (string.IsNullOrEmpty(regimen1) && !string.IsNullOrEmpty(regimen2) && string.IsNullOrEmpty(regimen3))
                {
                    regimen2 = regimen2.Replace("-", "+").Replace("/", "+").Replace("+R", "/R");
                    if (regimen2.ToLower().Contains("mg"))
                    {
                        var rs = regimen2.Split("+").ToList();
                        rs.ForEach(r =>
                        {
                            regimen += r.Substring(0, 3) + "+";
                        });
                    }
                    else
                    {
                        regimen += regimen2;
                    }
                }
                else if (string.IsNullOrEmpty(regimen1) && string.IsNullOrEmpty(regimen2) && !string.IsNullOrEmpty(regimen3))
                {
                    regimen3 = regimen3.Replace("-", "+").Replace("/", "+").Replace("+R", "/R");
                    if(regimen3.ToLower().Contains("mg"))
                    {
                        var rs = regimen3.Split("+").ToList();
                        rs.ForEach(r =>
                        {
                            regimen += r.Substring(0, 3) + "+";
                        });
                    }
                    else
                    {
                        regimen += regimen3;
                    }
                }

                regimen = regimen.TrimEnd('+');
                return regimen;
            }
            catch(Exception e)
            {
                return regimen;
            }
        }
    }
}
