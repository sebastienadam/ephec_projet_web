using CSharp.Models;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Net;
using System.Net.Http;
using System.Web;
using System.Web.Http;

namespace CSharp.Controllers {
  public class DiwController : ApiController {
    [Route("api/diw/{ClientId:int}/{DishId:int}")]
    [HttpGet]
    public object Get(int ClientId, int DishId) {
      using(ProjetWEBEntities contect = new ProjetWEBEntities()) {
        return contect.DishWish.Where(dishWish => (dishWish.ClientId == ClientId) && (dishWish.DishId == DishId)).First();
      }
    }
  }
}
