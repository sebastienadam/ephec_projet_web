using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.Linq;
using System.Web;

namespace CSharp.Models {
  public class DishWishListItem {
    [Display(Name = "Préférence")]
    public string Feeling { get; set; }
    [Display(Name = "Type")]
    public string DishType { get; set; }
    [Display(Name = "Plat")]
    public string DishName { get; set; }
    public string Buttons { get; set; }
  }
}