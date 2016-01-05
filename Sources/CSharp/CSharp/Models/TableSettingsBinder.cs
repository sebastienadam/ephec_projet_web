using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Mvc;

namespace CSharp.Models {
  public class TableSettingsBinder : IModelBinder {
    public object BindModel(ControllerContext controllerContext, ModelBindingContext bindingContext) {
      try {
        var request = controllerContext.HttpContext.Request;
        Order sortOrder;
        if(!Enum.TryParse(Convert.ToString(request["order[0][dir]"]), true, out sortOrder)) {
          sortOrder = Order.Asc;
        }
        return new TableSettings {
          Search = Convert.ToString(request["search[value]"]),
          Draw = int.Parse(request["draw"] ?? "1"),
          Length = int.Parse(request["length"] ?? "10"),
          Start = int.Parse(request["start"] ?? "1"),
          SortOrder = sortOrder,
          SortColumn = int.Parse(request["order[0][column]"] ?? "0")
        };
      } catch {
        return null;
      }
    }
  }
}