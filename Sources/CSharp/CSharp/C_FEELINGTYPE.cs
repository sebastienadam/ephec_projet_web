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
    
    public partial class C_FEELINGTYPE
    {
        [System.Diagnostics.CodeAnalysis.SuppressMessage("Microsoft.Usage", "CA2214:DoNotCallOverridableMethodsInConstructors")]
        public C_FEELINGTYPE()
        {
            this.C_FEEL_CLI_CLI = new HashSet<C_FEEL_CLI_CLI>();
            this.C_FEEL_CLI_DIS = new HashSet<C_FEEL_CLI_DIS>();
        }
    
        public int FTY_ID { get; set; }
        public string FTY_NAME { get; set; }
    
        [System.Diagnostics.CodeAnalysis.SuppressMessage("Microsoft.Usage", "CA2227:CollectionPropertiesShouldBeReadOnly")]
        public virtual ICollection<C_FEEL_CLI_CLI> C_FEEL_CLI_CLI { get; set; }
        [System.Diagnostics.CodeAnalysis.SuppressMessage("Microsoft.Usage", "CA2227:CollectionPropertiesShouldBeReadOnly")]
        public virtual ICollection<C_FEEL_CLI_DIS> C_FEEL_CLI_DIS { get; set; }
    }
}
