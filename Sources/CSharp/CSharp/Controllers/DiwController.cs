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
    public object Get() {
      var ClientIdQuery = HttpContext.Current.Request.QueryString["clientid"];
      var DishIdQuery = HttpContext.Current.Request.QueryString["dishid"];
      var UnwishedQuery = HttpContext.Current.Request.QueryString["unwished"];
      var Target = HttpContext.Current.Request.QueryString["target"];
      var DishTypeQuery = HttpContext.Current.Request.QueryString["type"];
      int ClientId;
      int DishId;
      int DishTypeId;
      if(!Int32.TryParse(ClientIdQuery, out ClientId)) {
        ClientId = -1;
      }
      if(!Int32.TryParse(DishIdQuery, out DishId)) {
        DishId = -1;
      }
      if(!string.IsNullOrEmpty(DishTypeQuery) && AllowedType.Contains(DishTypeQuery)) {
        DishTypeId = Int32.Parse(ConfigurationManager.AppSettings["DishType" + DishTypeQuery]);
      } else {
        DishTypeId = -1;
      }
      IEnumerable<DishWishModel> list = null;
      bool Unwished = !string.IsNullOrEmpty(UnwishedQuery) && (ClientId >= 0);
      bool Wished = string.IsNullOrEmpty(UnwishedQuery) && (ClientId >= 0);
      bool Single = !string.IsNullOrEmpty(Target) && Target.Equals("Single") && (ClientId >= 0) && (DishId >= 0);
      if(Unwished) {
        list = GetUnwished(ClientId);
      } else if(Single) {
        list = GetDishWish(ClientId, DishId);
      } else if(Wished) {
        list = Getwished(ClientId);
      } else {
        list = GetDishWishes();
      }
      if(list != null) {
        if(DishTypeId >= 0 && !Single) {
          list = list.Where(dw => dw.DishTypeId == DishTypeId).ToArray();
        }
        if(list.Count() == 0) {
          return new { Message = "EMPTY" };
        } else {
          switch(Target) {
            case "Select":
              return (from dw in list
                      select new SelectOption {
                        Value = dw.DishId.ToString(),
                        Text = ((DishTypeId < 0) ? dw.DishDisplayName() : dw.DishName)
                      }).ToArray();
            case "Single":
              return list.First();
            default:
              return list;
          }
        }
      } else {
        return new { Message = "FAIL" };
      }
    }

    [HttpPost]
    public object Create([FromBody]DishWishModel model) {
      try {
        using(ProjetWEBEntities context = new ProjetWEBEntities()) {
          context.NewWishedDish(model.ClientId, model.DishId, model.FeelingTypeId, model.ModifiedBy);
        }
        return new { Message = "OK" };
      } catch(Exception ex) {
        ExceptionUtility.LogException(ex, HttpContext.Current.Request.RawUrl);
        return new { Message = "FAIL" };
      }
    }

    [HttpPut]
    public object Update([FromBody]DishWishModel model) {
      try {
        using(ProjetWEBEntities context = new ProjetWEBEntities()) {
          context.UpdateWishedDish(model.ClientId, model.DishId, model.FeelingTypeId, model.ModifiedAt, model.ModifiedBy);
        }
        return new { Message = "OK" };
      } catch(Exception ex) {
        ExceptionUtility.LogException(ex, HttpContext.Current.Request.RawUrl);
        return new { Message = "FAIL" };
      }
    }

    private IEnumerable<DishWishModel> Getwished(int ClientId) {
      try {
        using(ProjetWEBEntities context = new ProjetWEBEntities()) {
          var result = from dw in context.GetWishedDish(ClientId, null)
                       select new DishWishModel {
                         DishId = dw.DishId,
                         DishName = dw.DishName,
                         DishType = dw.DishType,
                         DishTypeId = dw.DishTypeId,
                         Feeling = dw.Feeling,
                         FeelingTypeId = dw.FeelingTypeId,
                         ModifiedAt = dw.ModifiedAt,
                         ModifiedBy = dw.ModifiedBy
                       };
          return (result == null) ? null : result.ToArray();
        }
      } catch(Exception ex) {
        ExceptionUtility.LogException(ex, HttpContext.Current.Request.RawUrl);
        return null;
      }
    }

    private IEnumerable<DishWishModel> GetUnwished(int ClientId) {
      try {
        using(ProjetWEBEntities context = new ProjetWEBEntities()) {
          var result = from dw in context.GetUnwishedDish(ClientId)
                       select new DishWishModel {
                         DishId = dw.DishId,
                         DishName = dw.Name,
                         DishType = dw.Type,
                         DishTypeId = dw.DishTypeId
                       };
          return (result == null) ? null : result.ToArray();
        }
      } catch(Exception ex) {
        ExceptionUtility.LogException(ex, HttpContext.Current.Request.RawUrl);
        return null;
      }
    }

    private IEnumerable<DishWishModel> GetDishWish(int ClientId, int DishId) {
      try {
        using(ProjetWEBEntities context = new ProjetWEBEntities()) {
          var result = from dw in context.DishWish
                       where dw.ClientId == ClientId && dw.DishId == DishId
                       select new DishWishModel {
                         ClientFirstName = dw.ClientFirstName,
                         ClientId = dw.ClientId,
                         ClientLastName = dw.ClientLastName,
                         DishId = dw.DishId,
                         DishName = dw.DishName,
                         DishType = dw.DishType,
                         DishTypeId = dw.DishTypeId,
                         Feeling = dw.Feeling,
                         FeelingTypeId = dw.FeelingTypeId,
                         ModifiedAt = dw.ModifiedAt,
                         ModifiedBy = dw.ModifiedBy
                       };
          return (result == null) ? null : result.ToArray();
        }
      } catch(Exception ex) {
        ExceptionUtility.LogException(ex, HttpContext.Current.Request.RawUrl);
        return null;
      }
    }

    private IEnumerable<DishWishModel> GetDishWishes() {
      try {
        using(ProjetWEBEntities context = new ProjetWEBEntities()) {
          var result = from dw in context.DishWish
                       select new DishWishModel {
                         ClientFirstName = dw.ClientFirstName,
                         ClientId = dw.ClientId,
                         ClientLastName = dw.ClientLastName,
                         DishId = dw.DishId,
                         DishName = dw.DishName,
                         DishType = dw.DishType,
                         DishTypeId = dw.DishTypeId,
                         Feeling = dw.Feeling,
                         FeelingTypeId = dw.FeelingTypeId,
                         ModifiedAt = dw.ModifiedAt,
                         ModifiedBy = dw.ModifiedBy
                       };
          return (result == null) ? null : result.ToArray();
        }
      } catch(Exception ex) {
        ExceptionUtility.LogException(ex, HttpContext.Current.Request.RawUrl);
        return null;
      }
    }
  }
}
