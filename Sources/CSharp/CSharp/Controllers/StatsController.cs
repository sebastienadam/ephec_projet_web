using CSharp.Helpers;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Mvc;

namespace CSharp.Controllers {
  public class StatsController : Controller {
    // GET: Stats
    public ActionResult Index() {
      return View();
    }

    public ActionResult Dish() {
      return View();
    }
  }
}