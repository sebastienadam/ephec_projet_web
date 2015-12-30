using System;
using System.Collections.Generic;
using System.ComponentModel;
using System.ComponentModel.DataAnnotations;
using System.Linq;
using System.Web;

namespace CSharp {
  [MetadataType(typeof(Models.ReceptionModel))]
  public partial class Reception {
  }
}

namespace CSharp.Models {
  public class ReceptionModel {
    [Display(Name = "Nom")]
    public string Name { get; set; }
    [Display(Name = "Date - heure")]
    public System.DateTime Date { get; set; }
    [Display(Name = "Fin des inscriptions")]
    public System.DateTime BookingClosingDate { get; set; }
    [Display(Name = "Capacité")]
    public int Capacity { get; set; }
    [Display(Name = "Personnes par tables")]
    public int SeatsPerTable { get; set; }
    [Display(Name = "Valide")]
    public bool IsValid { get; set; }
    [Display(Name = "ID")]
    public int ReceptionId { get; set; }
    [Display(Name = "Date modification")]
    public Nullable<System.DateTime> ModifiedAt { get; set; }
    [Display(Name = "Modifié par")]
    public string ModifiedBy { get; set; }
  }
}