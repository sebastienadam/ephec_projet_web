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
    
    public partial class C_SIT
    {
        public int SIT_TAB_ID { get; set; }
        public int SIT_CLI_ID { get; set; }
        public Nullable<System.DateTime> SIT_UPDATE_AT { get; set; }
        public string SIT_UPDATE_BY { get; set; }
    
        public virtual C_CLIENT C_CLIENT { get; set; }
        public virtual C_TABLE C_TABLE { get; set; }
    }
}
