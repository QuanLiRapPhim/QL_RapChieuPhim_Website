using QL_RapChieuPhim.Models;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Mvc;

namespace QL_RapChieuPhim.Controllers
{
    public class DatVeController : Controller
    {
        QL_RapChieuPhimDataContext data = new QL_RapChieuPhimDataContext();

        // GET: DatVe
        public ActionResult Index()
        {
            var movies = data.Phims.ToList();
            foreach (var movie in movies)
            {
                movie.TheLoai = data.TheLoais.FirstOrDefault(tl => tl.MaTheLoai == movie.MaTheLoai);
            }
            return View(movies);
        }

        public ActionResult ShowTimes(int id)
        {
            var showTimes = data.SuatChieus.Where(sc => sc.MaPhim == id).ToList();
            foreach (var showTime in showTimes)
            {
                showTime.Phim = data.Phims.FirstOrDefault(p => p.MaPhim == showTime.MaPhim);
                showTime.ManHinhChieu = data.ManHinhChieus.FirstOrDefault(mh => mh.MaManHinh == showTime.MaManHinh);
            }
            return View(showTimes);
        }

        public ActionResult SelectSeats(int id)
        {
            if (Session["MaKhachHang"] == null)
            {
                return RedirectToAction("DangNhap", "Users");
            }

            var showTime = data.SuatChieus.FirstOrDefault(sc => sc.MaSuatChieu == id);

            if (showTime == null)
            {
                return HttpNotFound();
            }

            var manHinhId = showTime.ManHinhChieu?.MaManHinh;
            IEnumerable<Ghe> seats = Enumerable.Empty<Ghe>();

            if (manHinhId.HasValue)
            {
                seats = data.Ghes.Where(g => g.MaManHinh == manHinhId.Value).ToList();
            }
            ViewBag.Seats = seats; 
            ViewBag.ShowTimeId = id;

            return View(showTime);
        }

        [HttpPost]
        public ActionResult BookTickets(int showTimeId, int[] seatIds)
        {
            if (Session["MaKhachHang"] == null)
            {
                return RedirectToAction("DangNhap", "Users");
            }

            var customerId = (int)Session["MaKhachHang"];

            if (seatIds == null || seatIds.Length == 0)
            {
                return new HttpStatusCodeResult(400, "Chưa chọn ghế.");
            }

            var showTime = data.SuatChieus.FirstOrDefault(sc => sc.MaSuatChieu == showTimeId);
            if (showTime == null)
            {
                return new HttpStatusCodeResult(400, "Suất chiếu không tồn tại.");
            }

            var seats = data.Ghes.Where(g => seatIds.Contains(g.MaGhe) && g.TrangThai == false).ToList();
            if (seats.Count != seatIds.Length)
            {
                return new HttpStatusCodeResult(400, "Một số ghế đã được đặt trước.");
            }

            if (!data.KhachHangs.Any(kh => kh.MaKhachHang == customerId))
            {
                return new HttpStatusCodeResult(400, "Không tìm thấy khách hàng.");
            }

            foreach (var seat in seats)
            {
                seat.TrangThai = true;
                var ticket = new Ve
                {
                    MaSuatChieu = showTimeId,
                    MaKhachHang = customerId,
                    MaGhe = seat.MaGhe,
                    SoGhe = seat.SoGhe,
                    Gia = showTime.Gia,
                    NgayDatVe = DateTime.Now
                };

                data.Ves.InsertOnSubmit(ticket);
            }

            try
            {
                data.SubmitChanges();
            }
            catch (Exception ex)
            {
                return new HttpStatusCodeResult(500, "Lỗi khi đặt vé.");
            }
            return RedirectToAction("Confirmation", new { customerId = customerId, showTimeId });
        }
        [HttpPost]
        public ActionResult CancelTickets(int[] ticketIds, int showTimeId)
        {
            if (Session["MaKhachHang"] == null)
            {
                return RedirectToAction("DangNhap", "Users");
            }

            var customerId = (int)Session["MaKhachHang"];

            if (ticketIds == null || ticketIds.Length == 0)
            {
                return new HttpStatusCodeResult(400, "Chưa chọn vé để hủy.");
            }

            var tickets = data.Ves.Where(v => ticketIds.Contains(v.MaVe) && v.MaKhachHang == customerId).ToList();

            if (tickets.Count == 0)
            {
                return new HttpStatusCodeResult(400, "Không tìm thấy vé để hủy.");
            }

            foreach (var ticket in tickets)
            {
                var seat = data.Ghes.FirstOrDefault(g => g.MaGhe == ticket.MaGhe);
                if (seat != null)
                {
                    seat.TrangThai = false;
                }

                data.Ves.DeleteOnSubmit(ticket);
            }

            try
            {
                data.SubmitChanges();
            }
            catch (Exception ex)
            {
                return new HttpStatusCodeResult(500, "Lỗi khi hủy vé.");
            }

            return RedirectToAction("Confirmation", new { customerId = customerId, showTimeId = showTimeId });
        }
        public ActionResult Confirmation(int? customerId, int? showTimeId)
        {
            if (!customerId.HasValue || !showTimeId.HasValue)
            {
                return new HttpStatusCodeResult(400, "Thông tin không hợp lệ.");
            }

            var tickets = data.Ves
                .Where(v => v.MaKhachHang == customerId.Value && v.MaSuatChieu == showTimeId.Value)
                .ToList();

            foreach (var ticket in tickets)
            {
                var seat = data.Ghes.FirstOrDefault(g => g.MaGhe == ticket.MaGhe);
                ticket.Ghe = seat;
                ticket.SuatChieu = data.SuatChieus.FirstOrDefault(sc => sc.MaSuatChieu == ticket.MaSuatChieu);
                ticket.KhachHang = data.KhachHangs.FirstOrDefault(kh => kh.MaKhachHang == ticket.MaKhachHang);
            }

            ViewBag.Message = "Bạn đã hủy vé thành công.";
            ViewBag.ShowTimeId = showTimeId.Value;
            return View(tickets);
        }

    }
}
