using QL_RapChieuPhim.Models;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Web.Mvc;

namespace QL_RapChieuPhim.Controllers
{
    public class PhimsController : Controller
    {
        QL_RapChieuPhimDataContext data = new QL_RapChieuPhimDataContext();

        public List<Phim> LayPhim(int count)
        {
            return data.Phims.OrderByDescending(a => a.TenPhim).Take(count).ToList();
        }
        // GET: Phims
        public ActionResult Index()
        {
            var phims = data.Phims.ToList();
            return View(phims);
        }
        public ActionResult Details(int id)
        {
            var phim = data.Phims.SingleOrDefault(p => p.MaPhim == id);
            if (phim == null)
            {
                return HttpNotFound();
            }

            var phimInfos = data.Phims.Select(p => new PhimInfo
            {
                MaPhim = p.MaPhim,
                TenPhim = p.TenPhim,
                TheLoai = p.TheLoai.TenTheLoai,
                DaoDien = p.DaoDien,
                HinhAnh=p.HinhAnh
            }).ToList();

            var danhGiaPhims = data.DanhGiaPhims.ToList();
            var ratings = data.DanhGiaPhims.Where(dg => dg.MaPhim == id).ToList();
            ViewBag.Ratings = ratings;
            var collaborativeFiltering = new CollaborativeFiltering(phimInfos, danhGiaPhims);
            var recommendedPhims = collaborativeFiltering.Recommend(id);

            ViewBag.RecommendedPhims = recommendedPhims;

            return View(phim);
        }


        public ActionResult LoaiPhim()
        {
            var loaiphim = from lp in data.TheLoais select lp;
            return PartialView(loaiphim);
        }

        public ActionResult SPTheoLoaiPhim(int id)
        {
            var phim = from ph in data.Phims where ph.MaTheLoai == id select ph;
            return View(phim.ToList());
        }
        public ActionResult Search(string query)
        {
            var movies = from p in data.Phims
                         where p.TenPhim.Contains(query)
                         select p;

            return View(movies.ToList());
        }


        public ActionResult DanhGia(int id)
        {
            var phim = data.Phims.SingleOrDefault(p => p.MaPhim == id);
            if (phim == null)
            {
                return HttpNotFound();
            }

            return View(phim);
        }

        [HttpPost]
        public ActionResult DanhGia(int id, int rating, string review)
        {
            if (Session["MaKhachHang"] == null || !int.TryParse(Session["MaKhachHang"].ToString(), out int maKhachHang))
            {
                return RedirectToAction("DangNhap", "Users"); 
            }

            var danhGia = new DanhGiaPhim
            {
                MaPhim = id,
                DiemDanhGia = rating,
                BinhLuan = review,
                NgayDanhGia = DateTime.Now,
                MaKhachHang = maKhachHang
            };

            data.DanhGiaPhims.InsertOnSubmit(danhGia);
            data.SubmitChanges();

            return RedirectToAction("Details", "Phims", new { id = id });
        }
    }
}