using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Mvc;
using CSharp.Models;
using CSharp.Helpers;

namespace CSharp.Controllers {
  public class DishWishController : Controller {
    // GET: DishWish
    public ActionResult Index() {
      return View();
    }

    [Authorize(Roles = "Manager, Client")]
    public JsonResult ToGrid(TableSettings settings) {
      int ClientId;
      IEnumerable<DishWish> DishWishList = null;
      int recordsTotal;
      int recordsFiltered;
      int draw;
      try {
        ClientId = Int32.Parse(Session["ClientId"].ToString());
        using(ProjetWEBEntities contect = new ProjetWEBEntities()) {
          DishWishList = contect.DishWish.Where(dishWish => dishWish.ClientId == ClientId).ToArray();
          recordsTotal = DishWishList.Count();
        }
        if(settings != null) {
          DishWishList = Filter(DishWishList, settings.Search);
          DishWishList = Order(DishWishList, settings.SortColumn, settings.SortOrder);
          recordsFiltered = DishWishList.Count();
          if(settings.Length > 0) {
            DishWishList = DishWishList.Skip(settings.Start).Take(settings.Length).ToArray();
          }
          draw = settings.Draw;
        } else {
          recordsFiltered = DishWishList.Count();
          draw = 1;
        }
        var data = ConvertDishWishTable(DishWishList);
        return Json(new { data = data, draw = draw, recordsTotal = recordsTotal, recordsFiltered = recordsFiltered }, JsonRequestBehavior.AllowGet);
      } catch(Exception ex) {
        ExceptionUtility.LogException(ex, Request.RawUrl);
        return Json(new { draw = settings.Draw, error = "Une erreur est survenue lors de la récupération des données" });
      }
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
                                string.Format("<button class=\"btn btn-default btn-detail\" id=\"DishWishDetailButton_{0}\">Détails</button>",
                                              dw.DishId),
                                string.Format("<button class=\"btn btn-default btn-edit\" id=\"DishWishEditButton_{0}\">Modifier</button>",
                                              dw.DishId),
                                string.Format("<button class=\"btn btn-default btn-delete\" id=\"DishWishDeleteButton_{0}\">Supprimer</button>",
                                              dw.DishId))
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