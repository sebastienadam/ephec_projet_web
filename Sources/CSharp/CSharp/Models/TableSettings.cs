using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Mvc;

namespace CSharp.Models {
  public enum Order {
    Asc,
    Desc
  }

  [ModelBinder(typeof(TableSettingsBinder))]
  public class TableSettings {
    public int Draw { get; set; }
    public int Length { get; set; }
    public string Search { get; set; }
    public int SortColumn { get; set; }
    public Order SortOrder { get; set; }
    public int Start { get; set; }
    public Filter Where { get; set; }
  }
}