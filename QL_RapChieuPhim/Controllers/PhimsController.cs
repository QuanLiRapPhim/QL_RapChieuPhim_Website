using QL_RapChieuPhim.Models;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
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

            // Fetch ratings for the movie
            var ratings = data.DanhGiaPhims.Where(dg => dg.MaPhim == id).ToList();
            ViewBag.Ratings = ratings;
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


        // List movies with ratings
        public ActionResult RatedMovies()
        {
            var moviesWithRatings = data.Phims
                .Select(p => new
                {
                    Phim = p,
                    AverageRating = data.DanhGiaPhims
                        .Where(dg => dg.MaPhim == p.MaPhim)
                        .Average(dg => (double?)dg.DiemDanhGia) // Ensure proper type conversion
                })
                .OrderByDescending(m => m.AverageRating)
                .ToList();

            ViewBag.MoviesWithRatings = moviesWithRatings;
            return View();
        }
    }
}