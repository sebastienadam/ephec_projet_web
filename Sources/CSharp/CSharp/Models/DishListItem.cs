using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.Linq;
using System.Web;

namespace CSharp.Models {
  public class DishListItem {
    [Display(Name = "Nom")]
    public string Name { get; set; }
    public string Type { get; set; }
    public string Buttons { get; set; }
  }
}