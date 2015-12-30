using CSharp.Helpers;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Http;
using System.Web.Mvc;
using System.Web.Optimization;
using System.Web.Routing;
using System.Web.Security;

namespace CSharp {
  public class MvcApplication : System.Web.HttpApplication {
    protected void Application_Start() {
      AreaRegistration.RegisterAllAreas();
      GlobalConfiguration.Configure(WebApiConfig.Register);
      FilterConfig.RegisterGlobalFilters(GlobalFilters.Filters);
      RouteConfig.RegisterRoutes(RouteTable.Routes);
      BundleConfig.RegisterBundles(BundleTable.Bundles);
    }
    protected void Application_Error(object sender, EventArgs e) {
      Exception exception = Server.GetLastError();
      ExceptionUtility.LogException(exception, sender.ToString());
      Server.ClearError();
      if(exception.GetType() == typeof(HttpException)) {
        switch(((HttpException)exception).GetHttpCode()) {
          case 404:
            Response.Redirect("~/Error/NotFound", true);
            break;
          default:
            Response.Redirect("~/Error/Index", true);
            break;
        }
      } else {
        Response.Redirect("~/Error/Index", true);
      }
    }

    protected void Application_AuthenticateRequest() {
      if(HttpContext.Current.User != null) {
        if(HttpContext.Current.User.Identity.IsAuthenticated) {
          if(HttpContext.Current.User.Identity is FormsIdentity) {
            var id = (FormsIdentity)HttpContext.Current.User.Identity;
            var ticket = FormsAuthentication.Decrypt(id.Ticket.Name);
            if(!string.IsNullOrEmpty(ticket.UserData)) {
              string userData = ticket.UserData;
              string[] roles = userData.Split(',');
              HttpContext.Current.User = new System.Security.Principal.GenericPrincipal(id, roles);
            }
          }
        }
      }
    }
  }
}

