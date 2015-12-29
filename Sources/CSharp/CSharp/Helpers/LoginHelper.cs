using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Security;

namespace CSharp.Helpers {
  public class LoginHelper {
    public static FormsAuthenticationTicket CreateAuthenticationTicket(string userName, string commaSeperatedRoles, bool createPersistentCookie) {
      var cookiePath = FormsAuthentication.FormsCookiePath;
      const int expirationMinutes = 30;
      var ticket = new FormsAuthenticationTicket(1, userName, DateTime.Now, DateTime.Now.AddMinutes(expirationMinutes), createPersistentCookie, commaSeperatedRoles, cookiePath);
      return ticket;
    }
  }
}