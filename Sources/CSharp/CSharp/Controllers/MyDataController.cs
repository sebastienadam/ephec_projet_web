using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Mvc;

namespace CSharp.Controllers {
  /*[Authorize(Roles = "Manager,Client")]*/
  public class MyDataController : Controller {
    // GET: MyData
    public ActionResult Index() {
      return View();
    }
    public ActionResult Reservation() {
      return View();
    }
    public ActionResult Client() {
      return View();
    }
  }
}