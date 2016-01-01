using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.Linq;
using System.Web;

namespace CSharp.Attribute {
  public class DateTimeLessThanOrEqualAttribute : CompareAttribute {

    public DateTimeLessThanOrEqualAttribute(string otherProperty) : base(otherProperty) { }
    protected override ValidationResult IsValid(object value, ValidationContext validationContext) {
      var OtherPropertyInfo = validationContext.ObjectType.GetProperty(OtherProperty);
      if(OtherPropertyInfo != null) {
        DateTime thisDate = (DateTime)value;
        DateTime otherDate = (DateTime)OtherPropertyInfo.GetValue(validationContext.ObjectInstance, null);
        if(thisDate.CompareTo(otherDate) > 0) {
          ErrorMessage = String.Format("La valeur doit être inférieure ou égale à {0}", otherDate.ToString("dd/MM/yyyy HH:mm"));
          return new ValidationResult(ErrorMessage);
        } else {
          return ValidationResult.Success;
        }
      } else {
        ErrorMessage = String.Format("Impossible de trouver l'attribut {0}", OtherProperty);
        return new ValidationResult(ErrorMessage);
      }
    }
  }
}