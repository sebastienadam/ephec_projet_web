//------------------------------------------------------------------------------
// <auto-generated>
//     This code was generated from a template.
//
//     Manual changes to this file may cause unexpected behavior in your application.
//     Manual changes to this file will be overwritten if the code is regenerated.
// </auto-generated>
//------------------------------------------------------------------------------

namespace CSharp
{
    using System;
    using System.Collections.Generic;
    
    public partial class C_DISHTYPE
    {
        [System.Diagnostics.CodeAnalysis.SuppressMessage("Microsoft.Usage", "CA2214:DoNotCallOverridableMethodsInConstructors")]
        public C_DISHTYPE()
        {
            this.C_DISH = new HashSet<C_DISH>();
        }
    
        public int DTY_ID { get; set; }
        public string DTY_NAME { get; set; }
    
        [System.Diagnostics.CodeAnalysis.SuppressMessage("Microsoft.Usage", "CA2227:CollectionPropertiesShouldBeReadOnly")]
        public virtual ICollection<C_DISH> C_DISH { get; set; }
    }
}
