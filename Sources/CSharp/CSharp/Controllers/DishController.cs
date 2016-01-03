using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Mvc;

namespace CSharp.Controllers {
  public class DishController : Controller {
    // GET: Dish
    public ActionResult Index() {
      return View();
    }
  }
}