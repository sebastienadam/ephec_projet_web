using CSharp.Helpers;
using System;
using System.Collections.Generic;
using System.Configuration;
using System.Linq;
using System.Net;
using System.Net.Http;
using System.Web;
using System.Web.Http;

namespace CSharp.Controllers {
  public class StaController : ApiController {
    private static IList<string> AllowedType = new List<string> { "Starter", "MainDish", "Dessert" };

    [HttpGet]
    public object Get() {
      var Source = HttpContext.Current.Request.QueryString["src"];
      switch(Source) {
        case "Dish":
          return ApiGetDishStat();
        default:
          return new { Message = "UNKNOWN" };
      }
    }

    private object ApiGetDishStat() {
      var Target = HttpContext.Current.Request.QueryString["target"];
      var DishTypeQuery = HttpContext.Current.Request.QueryString["type"];
      IEnumerable<DishStatistic> Stats = GetDishesStatistic();
      int DishTypeId;
      if(!string.IsNullOrEmpty(DishTypeQuery) && AllowedType.Contains(DishTypeQuery)) {
        DishTypeId = Int32.Parse(ConfigurationManager.AppSettings["DishType" + DishTypeQuery]);
      } else {
        DishTypeId = -1;
      }
      if(Stats == null) {
        return new { Message = "FAIL" };
      } else {
        if(DishTypeId >= 0) {
          Stats = Stats.Where(ds => ds.DishTypeId == DishTypeId).ToArray();
        }
        if(Stats.Count() == 0) {
          return new { Message = "EMPTY" };
        } else {
          switch(Target) {
            case "HeadTab":
              List<object> result = new List<object>();
              result.Add(new object[] { "Plat", "Proposé", "Choisi", "Aimé", "Non aimé" });
              foreach(DishStatistic ds in Stats) {
                result.Add(new object[] { (DishTypeId < 0) ? string.Format("{0} ({1})", ds.Name, ds.Type) : ds.Name,
                                          ds.Offered,
                                          ds.Chosen,
                                          ds.Liked,
                                          ds.Disliked
                                        });
              }
              return result;
            default:
              return Stats;
          }
        }
      }
    }

    private IEnumerable<DishStatistic> GetDishesStatistic() {
      try {
        using(ProjetWEBEntities context = new ProjetWEBEntities()) {
          return context.DishStatistic.ToArray();
        }
      } catch(Exception ex) {
        ExceptionUtility.LogException(ex, HttpContext.Current.Request.RawUrl);
        return null;
      }
    }
  }
}
