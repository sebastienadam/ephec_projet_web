using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Mvc;

namespace CSharp.Controllers {
  public class ReceptionController : Controller {
    [Authorize(Roles = "Manager")]
    public ActionResult Index() {
      IList<Reception> model;
      using(ProjetWEBEntities context = new ProjetWEBEntities()) {
        model = context.Reception.ToList();
      }
      return View(model);
    }
  }
}