using CSharp.Helpers;
using CSharp.Models;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Mvc;
using System.Web.Security;

namespace CSharp.Controllers {
  public class HomeController : Controller {
    public ActionResult Index() {
      return View();
    }

    public ActionResult Login() {
      return View();
    }

    [AllowAnonymous]
    [HttpPost]
    public ActionResult Login(LoginFormModel model, string ReturnUrl) {
      C_CLIENT logged;
      if(ModelState.IsValid) {
        using(ProjetWEBEntities context = new ProjetWEBEntities()) {
          try {
            logged = context.C_CLIENT.Where(client => client.CLI_ACRONYM.Equals(model.UserName) && client.CLI_PASSWORD.Equals(model.Password)).First();
          } catch {
            logged = null;
          }
        }
        if(logged != null) {
          Session.Clear();
          var ticket = LoginHelper.CreateAuthenticationTicket(logged.CLI_ACRONYM, logged.CLI_GROUP, false);
          var encrypetedTicket = FormsAuthentication.Encrypt(ticket);
          FormsAuthentication.SetAuthCookie(encrypetedTicket, false);
          if(String.IsNullOrEmpty(ReturnUrl)) {
            return RedirectToAction("Index", "Home");
          } else {
            return RedirectToRoute(ReturnUrl);
          }
        } else {
          ModelState.AddModelError("", "Nom d'utilisateur ou mot de passe incorrect");
          return View(model);
        }
      } else {
        return View(model);
      }
    }

    [Authorize]
    public ActionResult Logout() {
      Session.Clear();
      FormsAuthentication.SignOut();
      return RedirectToAction("Index", "Home");
    }
  }
}