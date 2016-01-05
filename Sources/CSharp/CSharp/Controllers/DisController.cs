using CSharp.Models;
using System;
using System.Collections.Generic;
using System.Configuration;
using System.Linq;
using System.Net;
using System.Net.Http;
using System.Web;
using System.Web.Http;
using CSharp.Helpers;

namespace CSharp.Controllers {
  public class DisController : ApiController {
    private static IList<string> AllowedType = new List<string> { "Starter", "MainDish", "Dessert" };
    [HttpGet]
    public IEnumerable<object> Get() {
      var DishTypeQuery = HttpContext.Current.Request.QueryString["type"];
      var Target = HttpContext.Current.Request.QueryString["target"];
      IEnumerable<Dish> DishList = null;
      if(!string.IsNullOrEmpty(DishTypeQuery) && AllowedType.Contains(DishTypeQuery)) {
        var DishTypeId = Int32.Parse(ConfigurationManager.AppSettings["DishType" + DishTypeQuery]);
        using(ProjetWEBEntities context = new ProjetWEBEntities()) {
          DishList = context.Dish.Where(dish => dish.DishTypeId == DishTypeId).ToArray();
        }
      } else {
        using(ProjetWEBEntities context = new ProjetWEBEntities()) {
          DishList = context.Dish.ToArray();
        }
      }
      switch(Target) {
        case "Select":
          return (from dish in DishList
                 select new SelectOption {
                   Value = dish.DishId.ToString(),
                   Text = (String.IsNullOrEmpty(DishTypeQuery) ? dish.DisplayName() : dish.Name)
                 }).ToArray();
        //case "Grid":
        //  return (from dish in DishList
        //          select new DishListItem {
        //            Name = dish.Name,
        //            Type = dish.Type,
        //            Buttons = String.Format("<a class=\"btn btn-default\" href=\"{1}/{0}\">Modifier</a> | <a class=\"btn btn-default\" href=\"{2}/{0}\">Supprimer</a>",
        //                                    dish.DishId,
        //                                    Url.Content("~/Dish/Edit"),
        //                                    Url.Content("~/Dish/Delete")),
        //          }).ToArray();
      default:
          return DishList;
      }
    }
  }
}
