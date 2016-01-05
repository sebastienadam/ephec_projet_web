using CSharp.Models;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

namespace CSharp.Helpers {
  public static class MyModelHelper {
    public static string DisplayName(this Dish model) {
      return string.Format("{0} ({1})", model.Name, model.Type);
    }
    public static string DishDisplayName(this DishWishModel model) {
      return string.Format("{0} ({1})", model.DishName, model.DishType);
    }
  }
}