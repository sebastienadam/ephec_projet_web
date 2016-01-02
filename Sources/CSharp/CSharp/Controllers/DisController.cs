using System;
using System.Collections.Generic;
using System.Configuration;
using System.Linq;
using System.Net;
using System.Net.Http;
using System.Web;
using System.Web.Http;

namespace CSharp.Controllers {
  public class DisController : ApiController {
    private IList<string> AllowedType = new List<string> { "Starter", "MainDish", "Dessert" };
    [HttpGet]
    public IEnumerable<Dish> Get() {
      var DishTypeQuery = HttpContext.Current.Request.QueryString["type"];
      if((DishTypeQuery != null) && AllowedType.Contains(DishTypeQuery)) {
        var DishTypeId = Int32.Parse(ConfigurationManager.AppSettings["DishType" + DishTypeQuery]);
        using(ProjetWEBEntities context = new ProjetWEBEntities()) {
          return context.Dish.Where(dish => dish.DishTypeId == DishTypeId).ToArray();
        }
      } else {
        using(ProjetWEBEntities context = new ProjetWEBEntities()) {
          return context.Dish.ToArray();
        }
      }
    }
  }
}
