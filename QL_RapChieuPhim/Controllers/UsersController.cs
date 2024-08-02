using QL_RapChieuPhim.Models;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Mvc;

namespace QL_RapChieuPhim.Controllers
{
    public class UsersController : Controller
    {
        QL_RapChieuPhimDataContext data = new QL_RapChieuPhimDataContext();
        public ActionResult Index()
        {
            return View();
        }
        [HttpGet]
        public ActionResult DangKy()
        {
            return View();
        }
        [HttpPost]
        public ActionResult DangKy(FormCollection collection, KhachHang kh)
        {
            var hoten = collection["TenKhachHang"];
            var email = collection["Email"];
            var dienthoai = collection["DienThoai"];
            var diachi = collection["DiaChi"];
            var matkhau = collection["MatKhau"];
            var nhaplaimatkhau = collection["MatKhauNhapLai"];          
            
            if (String.IsNullOrEmpty(hoten))
            {
                ViewData["Loi1"] = "Họ tên không được để trống";
            }            
            else if (String.IsNullOrEmpty(email))
            {
                ViewData["Loi2"] = "Email không được để trống";
            }
            else if (String.IsNullOrEmpty(dienthoai))
            {
                ViewData["Loi3"] = "Số điện thoại không được để trống";
            }
            else if (String.IsNullOrEmpty(diachi))
            {
                ViewData["Loi4"] = "Địa chỉ không được để trống";
            }
            else if (String.IsNullOrEmpty(matkhau))
            {
                ViewData["Loi5"] = "Mật khẩu không được để trống";
            }
            else if (String.IsNullOrEmpty(nhaplaimatkhau))
            {
                ViewData["Loi6"] = "Nhập lại mật khẩu không được để trống";
            }
            else
            {
                kh.TenKhachHang = hoten;                
                kh.Email = email;
                kh.SoDienThoai = dienthoai;
                kh.DiaChi = diachi;                
                kh.MatKhau = matkhau;
                data.KhachHangs.InsertOnSubmit(kh);
                data.SubmitChanges();

                return RedirectToAction("DangNhap");
            }
            return this.DangKy();
        }
        [HttpGet]
        public ActionResult DangNhap()
        {
            return View();
        }
        [HttpPost]
        public ActionResult DangNhap(FormCollection collection)
        {
            var email = collection["Email"];
            var matkhau = collection["MatKhau"];
            if (String.IsNullOrEmpty(email))
                ViewData["Loi2"] = "Thiếu Email Đăng Nhập";
            else if (String.IsNullOrEmpty(matkhau))
                ViewData["Loi5"] = "Thiếu Mật Khẩu";

            KhachHang kh = data.KhachHangs.SingleOrDefault(n => n.Email == email && n.MatKhau == matkhau);
            if (kh != null)
            {
                Session["CustomerID"] = kh.MaKhachHang;
                Session["Email"] = kh.Email; // Lưu email vào Session
                return RedirectToAction("Index", "Phims");
            }
            else
            {
                ViewBag.ThongBao = "Tên đăng nhập hoặc mật khẩu không đúng";
            }
            return View();
        }

        public ActionResult DangXuat()
        {
            Session.Clear();
            return RedirectToAction("Index", "Phims");
        }

        [HttpGet]
        public ActionResult DoiMatKhau()
        {
            return View();
        }

        [HttpPost]
        public ActionResult DoiMatKhau(FormCollection collection)
        {
            var email = Session["Email"]?.ToString();
            var matkhaucu = collection["MatKhauCu"];
            var matkhaumoi = collection["MatKhauMoi"];
            var nhaplaimatkhaumoi = collection["NhapLaiMatKhauMoi"];

            if (String.IsNullOrEmpty(matkhaucu))
            {
                ViewData["Loi1"] = "Mật khẩu cũ không được để trống";
            }
            else if (String.IsNullOrEmpty(matkhaumoi))
            {
                ViewData["Loi2"] = "Mật khẩu mới không được để trống";
            }
            else if (String.IsNullOrEmpty(nhaplaimatkhaumoi))
            {
                ViewData["Loi3"] = "Nhập lại mật khẩu mới không được để trống";
            }
            else if (matkhaumoi != nhaplaimatkhaumoi)
            {
                ViewData["Loi4"] = "Mật khẩu mới và Nhập lại mật khẩu mới không khớp";
            }
            else
            {
                try
                {
                    KhachHang kh = data.KhachHangs.SingleOrDefault(n => n.Email == email && n.MatKhau == matkhaucu);
                    if (kh != null)
                    {
                        kh.MatKhau = matkhaumoi;
                        data.SubmitChanges();
                        ViewBag.ThongBao = "Đổi mật khẩu thành công";
                    }
                    else
                    {
                        ViewData["Loi5"] = "Mật khẩu cũ không đúng";
                    }
                }
                catch (Exception ex)
                {
                    // Ghi nhật ký lỗi
                    System.Diagnostics.Debug.WriteLine($"Error: {ex.Message}");
                    ViewBag.ThongBao = "Có lỗi xảy ra trong quá trình đổi mật khẩu. Vui lòng thử lại.";
                }
            }
            return View();
        }
    }
}
