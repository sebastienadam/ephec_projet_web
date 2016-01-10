using CSharp.Helpers;
using CSharp.Models;
using System;
using System.Collections.Generic;
using System.Data.Entity.Core.Objects;
using System.Linq;
using System.Web;
using System.Web.Mvc;

namespace CSharp.Controllers {
  public class ReceptionController : Controller {
    [Authorize(Roles = "Manager")]
    public ActionResult Index() {
      IList<Reception> model = new List<Reception>();
      using(ProjetWEBEntities context = new ProjetWEBEntities()) {
        model = context.Reception.ToList();
      }
      return View(model);
    }

    [Authorize(Roles = "Manager")]
    public ActionResult Create() {
      SetViewBagCreate();
      return View();
    }

    [Authorize(Roles = "Manager")]
    [HttpPost]
    public ActionResult Create(NewReceptionModel model) {
      if(ModelState.IsValid) {
        try {
          using(ProjetWEBEntities context = new ProjetWEBEntities()) {
            var Acronym = Session["Acronym"].ToString();
            string imgname = "";
            string imgdirpath = Server.MapPath("~/Content/images/");
            ObjectParameter RecId = new ObjectParameter("RecId", typeof(int));
            if(model.Poster.ContentLength > 0) {
              imgname = model.Poster.FileName;
              int i = 1;
              while(System.IO.File.Exists(imgdirpath + imgname)) {
                imgname = i.ToString() + '_' + model.Poster.FileName;
                i++;
              }
              model.Poster.SaveAs(imgdirpath + imgname);
            }
            context.NewReception(model.Name,
                                 model.Date,
                                 model.BookingClosingDate,
                                 model.Capacity,
                                 model.SeatsPerTable,
                                 ((model.Poster.ContentLength > 0) ? imgname : null),
                                 Acronym,
                                 RecId);
            foreach(int DishId in model.StartersId) {
              context.NewMenu((int)RecId.Value, DishId, Acronym);
            }
            foreach(int DishId in model.MainCoursesId) {
              context.NewMenu((int)RecId.Value, DishId, Acronym);
            }
            foreach(int DishId in model.DessertsId) {
              context.NewMenu((int)RecId.Value, DishId, Acronym);
            }
          }
          return RedirectToAction("Index", "Reception");
        } catch(Exception ex) {
          ExceptionUtility.LogException(ex, Request.RawUrl);
          return RedirectToAction("Index", "Error");
        }
      } else {
        SetViewBagCreate();
        return View(model);
      }
    }

    private void SetViewBagCreate() {
      List<SelectListItem> SelectListCapacity = new List<SelectListItem>();
      List<SelectListItem> SelectListSeatsPerTable = new List<SelectListItem>();
      SelectListItem SelectListItem;
      int Selected;
      Selected = 1;
      for(int i = 0; i < 5; i++) {
        SelectListItem = new SelectListItem();
        SelectListItem.Text = (i * 2 + 4).ToString();
        SelectListItem.Value = SelectListItem.Text;
        SelectListItem.Selected = i == Selected;
        SelectListSeatsPerTable.Add(SelectListItem);
      }
      Selected = 4;
      for(int i = 0; i < 9; i++) {
        SelectListItem = new SelectListItem();
        SelectListItem.Text = (i * 25 + 50).ToString();
        SelectListItem.Value = SelectListItem.Text;
        SelectListItem.Selected = i == Selected;
        SelectListCapacity.Add(SelectListItem);
      }
      ViewBag.SelectListCapacity = SelectListCapacity.ToArray<SelectListItem>();
      ViewBag.SelectListSeatsPerTable = SelectListSeatsPerTable.ToArray<SelectListItem>();
    }
  }
}