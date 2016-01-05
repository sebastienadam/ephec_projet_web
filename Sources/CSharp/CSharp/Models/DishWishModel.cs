using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

namespace CSharp.Models {
  public class DishWishModel {
    public string ClientFirstName { get; set; }
    public string ClientLastName { get; set; }
    public string Feeling { get; set; }
    public string DishType { get; set; }
    public string DishName { get; set; }
    public int ClientId { get; set; }
    public int DishId { get; set; }
    public int DishTypeId { get; set; }
    public int FeelingTypeId { get; set; }
    public Nullable<System.DateTime> ModifiedAt { get; set; }
    public string ModifiedBy { get; set; }
  }
}