using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

namespace CSharp.Models {
  public class NewDishWish {
    public int ClientId { get; set; }
    public int DishId { get; set; }
    public int Feeling { get; set; }
    public string ModifiedBy { get; set; }
  }
}