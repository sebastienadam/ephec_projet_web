using CSharp.Attribute;
using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.Linq;
using System.Web;

namespace CSharp.Models {
  public class NewReceptionModel {
    [Display(Name = "Nom")]
    [Required(AllowEmptyStrings =false,ErrorMessage ="Veuillez donner un nom pour la réception")]
    public string Name { get; set; }
    [Display(Name = "Date - heure")]
    [DisplayFormat(DataFormatString ="dd/MM/yyyy HH:mm")]
    [Required(ErrorMessage = "Veuillez donner une date pour la réception")]
    public DateTime Date { get; set; }
    [Display(Name = "Fin des inscriptions")]
    [DisplayFormat(DataFormatString = "dd/MM/yyyy HH:mm")]
    [Required(ErrorMessage = "Veuillez donner une date de fin des inscription")]
    [DateTimeLessThanOrEqual("Date")]
    public DateTime BookingClosingDate { get; set; }
    [Display(Name = "Capacité")]
    [Required(ErrorMessage = "Veuillez donner un nombre maximal de convives")]
    public int Capacity { get; set; }
    [Display(Name = "Personnes par tables")]
    [Required(ErrorMessage = "Veuillez donner le nombre de personnes par tables")]
    public int SeatsPerTable { get; set; }
    [Display(Name = "Entrée")]
    [Required(ErrorMessage = "Veuillez donner au moins une entrée")]
    public int[] StartersId { get; set; }
    [Display(Name = "Plat principal")]
    [Required(ErrorMessage = "Veuillez donner au moins un plat principal")]
    public int[] MainCoursesId { get; set; }
    [Display(Name = "Dessert")]
    [Required(ErrorMessage = "Veuillez donner au moins un dessert")]
    public int[] DessertsId { get; set; }
  }
}