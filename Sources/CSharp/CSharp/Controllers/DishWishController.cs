using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Mvc;
using CSharp.Models;

namespace CSharp.Controllers {
  public class DishWishController : Controller {
    // GET: DishWish
    public ActionResult Index() {
      return View();
    }

    [Authorize(Roles = "Manager, Client")]
    public JsonResult ToGrid(TableSettings settings) {
      int ClientId = Int32.Parse(Session["ClientId"].ToString());
      IEnumerable<DishWish> DishWishList = null;
      int recordsTotal;
      using(ProjetWEBEntities contect = new ProjetWEBEntities()) {
        DishWishList = contect.DishWish.Where(dishWish => dishWish.ClientId == ClientId).ToArray();
        recordsTotal = DishWishList.Count();
      }
      if(settings != null) {
        DishWishList = Filter(DishWishList, settings.Search);
        DishWishList = Order(DishWishList, settings.SortColumn, settings.SortOrder);
        if(settings.Length > 0) {
          DishWishList = DishWishList.Skip(settings.Start).Take(settings.Length).ToArray();
        }
      }
      var data = ConvertDishWishTable(DishWishList);
      var draw = settings.Draw;
      var recordsFiltered = data.Count();
      return Json(new { data = data, draw = draw, recordsTotal = recordsTotal, recordsFiltered = recordsFiltered }, JsonRequestBehavior.AllowGet);
    }

    private string[][] ConvertDishWishTable(IEnumerable<DishWish> DishWishList) {
      if(DishWishList == null || !DishWishList.Any()) {
        return (from i in new List<DishWish>()
                select new string[] { }).ToArray();
      } else {
        return (from dw in DishWishList
                select new string [] {
                  dw.Feeling,
                  dw.DishType,
                  dw.DishName,
                  string.Format("{0} | {1} | {2}",
                                string.Format("<a class=\"btn btn-default\" href=\"{0}\">Détails</a>",
                                              Url.Action("Get", "DishWish", new { ClientId = dw.ClientId, DishId = dw.DishId})),
                                string.Format("<a class=\"btn btn-default\" href=\"{0}\">Modifier</a>",
                                              Url.Action("Post", "DishWish", new { ClientId = dw.ClientId, DishId = dw.DishId })),
                                string.Format("<a class=\"btn btn-default\" href=\"{0}\">Supprimer</a>",
                                              Url.Action("Delete", "DishWish", new { ClientId = dw.ClientId, DishId = dw.DishId })))
                }).ToArray();
      }
    }

    private IEnumerable<DishWish> Filter(IEnumerable<DishWish> DishWishList, string search) {
      if(!string.IsNullOrEmpty(search)) {
        DishWishList = DishWishList.Where(dw => (!string.IsNullOrEmpty(dw.Feeling) && dw.Feeling.Contains(search)) ||
                                                (!string.IsNullOrEmpty(dw.DishType) && dw.DishType.Contains(search)) ||
                                                (!string.IsNullOrEmpty(dw.DishName) && dw.DishName.Contains(search)));
      }
      return DishWishList;
    }

    private IEnumerable<DishWish> Order(IEnumerable<DishWish> DishWishList, int column, Order order) {
      if(DishWishList.Any()) {
        switch(column) {
          case 0:
            DishWishList = (order == Models.Order.Asc)
                           ? DishWishList.OrderBy(dw => dw.Feeling)
                           : DishWishList.OrderByDescending(dw => dw.Feeling);
            break;
          case 1:
            DishWishList = (order == Models.Order.Asc)
                           ? DishWishList.OrderBy(dw => dw.DishTypeId)
                           : DishWishList.OrderByDescending(dw => dw.DishTypeId);
            break;
          case 2:
            DishWishList = (order == Models.Order.Asc)
                           ? DishWishList.OrderBy(dw => dw.DishName)
                           : DishWishList.OrderByDescending(dw => dw.DishName);
            break;
        }
      }
      return DishWishList;
    }
  }
}