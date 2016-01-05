using CSharp.Helpers;
using CSharp.Models;
using System;
using System.Collections.Generic;
using System.Configuration;
using System.Linq;
using System.Net;
using System.Net.Http;
using System.Web;
using System.Web.Http;

namespace CSharp.Controllers {
  public class DiwController : ApiController {
    private static IList<string> AllowedType = new List<string> { "Starter", "MainDish", "Dessert" };

    [HttpGet]
    public IEnumerable<object> Get() {
      var ClientIdQuery = HttpContext.Current.Request.QueryString["clientid"];
      var DishIdQuery = HttpContext.Current.Request.QueryString["dishid"];
      var UnwishedQuery = HttpContext.Current.Request.QueryString["unwished"];
      var Target = HttpContext.Current.Request.QueryString["target"];
      var DishTypeQuery = HttpContext.Current.Request.QueryString["type"];
      int ClientId = -1;
      int DishTypeId = -1;
      IEnumerable<DishWishModel> list = null;
      bool Unwished = !string.IsNullOrEmpty(UnwishedQuery) && !string.IsNullOrEmpty(ClientIdQuery) && Int32.TryParse(ClientIdQuery, out ClientId);
      bool Wished = string.IsNullOrEmpty(UnwishedQuery) && !string.IsNullOrEmpty(ClientIdQuery) && Int32.TryParse(ClientIdQuery, out ClientId);
      if(Unwished) {
        list = GetUnwished(ClientId);
      } else if(Wished)  {
        // TODO: retrouver les préférences de plat désirés par le client
      } else {
        // TODO: retourner toutes les préférences de plats
      }
      if(!string.IsNullOrEmpty(DishTypeQuery) && AllowedType.Contains(DishTypeQuery)) {
        DishTypeId = Int32.Parse(ConfigurationManager.AppSettings["DishType" + DishTypeQuery]);
        list = list.Where(dw => dw.DishTypeId == DishTypeId).ToArray();
      }
      switch(Target) {
        case "Select":
          return (from dw in list
                  select new SelectOption {
                    Value = dw.DishId.ToString(),
                    Text = ((DishTypeId < 0) ? dw.DishDisplayName() : dw.DishName)
                  }).ToArray();
        default:
          return list;
      }
    }
    [HttpPost]
    public object Create([FromBody]NewDishWish data) {
      try {
        using(ProjetWEBEntities context = new ProjetWEBEntities()) {
          context.NewWishedDish(data.ClientId, data.DishId, data.Feeling, data.ModifiedBy);
        }
        return new { Message = "OK" };
      } catch(Exception) {
        return new { Message = "FAIL" };
      }
    }

    private IEnumerable<DishWishModel> GetUnwished(int ClientId) {
      using(ProjetWEBEntities context = new ProjetWEBEntities()) {
        var result = context.GetUnwishedDish(ClientId);
        return (result == null) ? null : (from dw in result
                                          select new DishWishModel {
                                            DishId = dw.DishId,
                                            DishName = dw.Name,
                                            DishType = dw.Type,
                                            DishTypeId = dw.DishTypeId
                                          }).ToArray();
      }
    }
  }
}
