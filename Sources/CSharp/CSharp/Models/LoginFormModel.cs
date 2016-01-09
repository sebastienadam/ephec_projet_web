using System.ComponentModel.DataAnnotations;

namespace CSharp.Models {
  public class LoginFormModel {
    [Required(ErrorMessage = "Le nom d'utilisateur est requis")]
    [Display(Name = "Nom d'utilisateur")]
    [EmailAddress(ErrorMessage = "Veuillez vous identifier avec votre adresse e-mail")]
    public string UserName { get; set; }

    [Required(ErrorMessage = "Le mot de passe est requis")]
    [Display(Name = "Mot de passe")]
    public string Password { get; set; }
  }
}