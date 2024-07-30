CREATE DATABASE QL_RapChieuPhim
USE QL_RapChieuPhim

-- Bảng TheLoai
CREATE TABLE TheLoai (
    MaTheLoai INT PRIMARY KEY IDENTITY(1,1),
    TenTheLoai NVARCHAR(50) NOT NULL
);
-- Bảng Phim
CREATE TABLE Phim (
    MaPhim INT PRIMARY KEY IDENTITY(1,1),
    TenPhim NVARCHAR(255) NOT NULL,
    MaTheLoai INT,
    DaoDien NVARCHAR(100),
    ThoiLuong INT,
    TomTat NVARCHAR(255),
    NgayKhoiChieu DATE,
	HinhAnh VARCHAR(255)
	FOREIGN KEY (MaTheLoai) REFERENCES TheLoai(MaTheLoai)
);

-- Bảng RapChieuPhim
CREATE TABLE RapChieuPhim (
    MaRap INT PRIMARY KEY IDENTITY(1,1),
    TenRap NVARCHAR(100) NOT NULL,
    ViTri NVARCHAR(255),
    TongGhe INT
);

-- Bảng ManHinhChieu
CREATE TABLE ManHinhChieu (
    MaManHinh INT PRIMARY KEY IDENTITY(1,1),
    MaRap INT,
    SoManHinh INT,
    TongSoGhe INT,
    FOREIGN KEY (MaRap) REFERENCES RapChieuPhim(MaRap)
);

-- Bảng SuatChieu
CREATE TABLE SuatChieu (
    MaSuatChieu INT PRIMARY KEY IDENTITY(1,1),
    MaPhim INT,
    MaManHinh INT,
    ThoiGianChieu DATETIME,
    SoGheTrong INT,
    FOREIGN KEY (MaPhim) REFERENCES Phim(MaPhim),
    FOREIGN KEY (MaManHinh) REFERENCES ManHinhChieu(MaManHinh)
);

-- Bảng KhachHang
CREATE TABLE KhachHang (
    MaKhachHang INT PRIMARY KEY IDENTITY(1,1),
    TenKhachHang NVARCHAR(100) NOT NULL,
    Email VARCHAR(100) UNIQUE,
    SoDienThoai VARCHAR(20) UNIQUE,
    DiaChi NVARCHAR(255),
	MatKhau NVARCHAR(255)
);
--Bảng Ghế
CREATE TABLE Ghe (
    MaGhe INT PRIMARY KEY IDENTITY(1,1),
    MaManHinh INT,
    SoGhe VARCHAR(10) NOT NULL,
    TrangThai BIT NOT NULL DEFAULT 0,
    FOREIGN KEY (MaManHinh) REFERENCES ManHinhChieu(MaManHinh)
);
-- Bảng Vé
CREATE TABLE Ve (
    MaVe INT PRIMARY KEY IDENTITY(1,1),
    MaSuatChieu INT,
    MaKhachHang INT,
	MaGhe INT,
    SoGhe VARCHAR(10),
    Gia DECIMAL(10, 2),
    NgayDatVe DATETIME,
    FOREIGN KEY (MaSuatChieu) REFERENCES SuatChieu(MaSuatChieu),
    FOREIGN KEY (MaKhachHang) REFERENCES KhachHang(MaKhachHang),
	FOREIGN KEY (MaGhe) REFERENCES Ghe(MaGhe)
);

-- Bảng Thanh Toán
CREATE TABLE ThanhToan (
    MaThanhToan INT PRIMARY KEY IDENTITY(1,1),
    MaVe INT,
    NgayThanhToan DATETIME,
    SoTien DECIMAL(10, 2),
    PhuongThucThanhToan NVARCHAR(50),
    FOREIGN KEY (MaVe) REFERENCES Ve(MaVe)
);

-- Bảng Nhân Viên
CREATE TABLE NhanVien (
    MaNhanVien INT PRIMARY KEY IDENTITY(1,1),
    TenNhanVien NVARCHAR(100) NOT NULL,
    ChucVu NVARCHAR(50),
    Luong DECIMAL(10, 2),
    NgayTuyenDung DATE,
	TenDangNhap NVARCHAR(50),
    MatKhau NVARCHAR(255),
    MaRap INT,
    FOREIGN KEY (MaRap) REFERENCES RapChieuPhim(MaRap)
);

-- Bảng Khuyến Mãi
CREATE TABLE KhuyenMai (
    MaKhuyenMai INT PRIMARY KEY IDENTITY(1,1),
    TieuDe NVARCHAR(100),
    MoTa NVARCHAR(255),
    GiamGia DECIMAL(5, 2),
    NgayBatDau DATE,
    NgayKetThuc DATE
);

-- Bảng Áp Dụng Khuyến Mãi
CREATE TABLE ApDungKhuyenMai (
    MaApDung INT PRIMARY KEY IDENTITY(1,1),
    MaKhuyenMai INT,
    MaVe INT,
    FOREIGN KEY (MaKhuyenMai) REFERENCES KhuyenMai(MaKhuyenMai),
    FOREIGN KEY (MaVe) REFERENCES Ve(MaVe)
);

-- Bảng Đánh Giá Phim
CREATE TABLE DanhGiaPhim (
    MaDanhGia INT PRIMARY KEY IDENTITY(1,1),
    MaPhim INT,
    MaKhachHang INT,
    DiemDanhGia INT,
    BinhLuan NVARCHAR(255),
    NgayDanhGia DATETIME,
    FOREIGN KEY (MaPhim) REFERENCES Phim(MaPhim),
    FOREIGN KEY (MaKhachHang) REFERENCES KhachHang(MaKhachHang)
);

-- Bảng Mặt Hàng Thức Ăn
CREATE TABLE ThucAn (
    MaMatHang INT PRIMARY KEY IDENTITY(1,1),
    TenMatHang NVARCHAR(100) NOT NULL,
    LoaiMatHang NVARCHAR(50), -- Ví dụ: Đồ ăn nhẹ, Đồ uống
    Gia DECIMAL(10, 2),
    MoTa NVARCHAR(255),
    SoLuongTon INT,
    NgayNhapHangCuoi DATETIME
);


-- Bảng Đơn Hàng Thức Ăn
CREATE TABLE DonHangThucAn (
    MaDonHang INT PRIMARY KEY IDENTITY(1,1),
    MaKhachHang INT,
    NgayDatHang DATETIME,
    TongTien DECIMAL(10, 2),
    FOREIGN KEY (MaKhachHang) REFERENCES KhachHang(MaKhachHang)
);

-- Bảng Chi Tiết Đơn Hàng Thức Ăn
CREATE TABLE ChiTietDonHangThucAn (
    MaChiTiet INT PRIMARY KEY IDENTITY(1,1),
    MaDonHang INT,
    MaMatHang INT,
    SoLuong INT,
    Gia DECIMAL(10, 2),
    FOREIGN KEY (MaDonHang) REFERENCES DonHangThucAn(MaDonHang),
    FOREIGN KEY (MaMatHang) REFERENCES ThucAn(MaMatHang)
);
-- Bảng NhomNguoiDung
CREATE TABLE NhomNguoiDung (
    MaNhomNguoiDung INT PRIMARY KEY IDENTITY(1,1),
    TenNhom NVARCHAR(50) NOT NULL
);
-- Bảng NguoiDungNhomNguoiDung
CREATE TABLE NguoiDungNhomNguoiDung (
    MaNhanVien INT,
    MaNhomNguoiDung INT,
	FOREIGN KEY (MaNhanVien) REFERENCES NhanVien(MaNhanVien),
	FOREIGN KEY (MaNhomNguoiDung) REFERENCES NhomNguoiDung(MaNhomNguoiDung)
);
-- Bảng ManHinh
CREATE TABLE ManHinh (
    MaManHinh INT PRIMARY KEY IDENTITY(1,1),
	TenManHinh NVARCHAR(50) NOT NULL
);
-- Bảng PhanQuyen
CREATE TABLE PhanQuyen (
    MaNhomNguoiDung INT,
	MaManHinh INT,
    CoQuyen BIT
	FOREIGN KEY (MaNhomNguoiDung) REFERENCES NhomNguoiDung(MaNhomNguoiDung),
	FOREIGN KEY (MaManHinh) REFERENCES ManHinh(MaManHinh)
);


--INSERT dữ liệu vào bảng TheLoai
INSERT INTO TheLoai (TenTheLoai)
VALUES 
    (N'Hoạt hình'),
    (N'Hành động'),
    (N'Chính kịch'),
    (N'Phiêu lưu'),
    (N'Hài kịch'),
    (N'Lịch sử'),
    (N'Tình cảm'),
	(N'Chính kịch'),
    (N'Lãng mạn');
-- INSERT dữ liệu vào bảng Phim
SET DATEFORMAT DMY
INSERT INTO Phim (TenPhim, MaTheLoai, DaoDien, ThoiLuong, TomTat, NgayKhoiChieu, HinhAnh)
VALUES 
    (N'Despicable me 4', 1, N'Chris Renaud', 162, N'Gru phải đối mặt với kẻ thù mới là Maxime Le Mal và Valentina đang lên kế hoạch trả thù anh, buộc gia đình anh phải lẩn trốn đi nơi khác.', '2024-07-05', 'minion4.jpg'),
    (N'Inception', 2, N'Christopher Nolan', 148, N'Một tên trộm bước vào giấc mơ của người khác để đánh cắp bí mật.', '2010-07-16', 'inception.jpg'),
    (N'Avengers: Endgame', 2, N'Anthony Russo, Joe Russo', 181, N'Sau các sự kiện tàn khốc của Avengers: Infinity War, các Avengers tập hợp một lần nữa để đảo ngược hành động của Thanos và khôi phục lại sự cân bằng cho vũ trụ.', '2019-04-26', 'endgame.jpg'),
    (N'Interstellar', 8, N'Christopher Nolan', 169, N'Một nhóm nhà thám hiểm du hành qua lỗ sâu trong không gian nhằm đảm bảo sự sống còn của nhân loại.', '2014-11-07', 'interstellar.jpg'),
    (N'Joker', 8, N'Todd Phillips', 122, N'Tại thành phố Gotham, diễn viên hài bị bệnh tâm thần Arthur Fleck bị xã hội coi thường và ngược đãi. Sau đó anh ta rơi vào con đường sa ngã và trở thành biểu tượng Joker.', '2019-10-04', 'joker.jpg'),
    (N'Parasite', 5, N'Bong Joon-ho', 132, N'Gia đình Kim sống trong cảnh nghèo khó, lên kế hoạch xâm nhập vào gia đình Park giàu có bằng cách từng người một vào làm việc tại nhà họ.', '2019-10-11', 'parasite.jpg'),
    (N'The Matrix', 2, N'Lana Wachowski, Lilly Wachowski', 136, N'Một hacker máy tính học từ những kẻ nổi loạn bí ẩn về bản chất thực sự của thực tại và vai trò của anh ta trong cuộc chiến chống lại những người điều khiển nó.', '1999-03-31', 'matrix.jpg'),
    (N'Fight Club', 3, N'David Fincher', 139, N'Một nhân viên văn phòng mất ngủ và một người bán xà phòng xây dựng một tổ chức toàn cầu để giúp giải phóng cơn tức giận của nam giới.', '1999-10-15', 'fightclub.jpg'),
    (N'Pulp Fiction', 3, N'Quentin Tarantino', 154, N'Cuộc sống của hai tên sát thủ mafia, một võ sĩ quyền anh, vợ của một tên gangster và một cặp đôi cướp tiệm ăn đan xen trong bốn câu chuyện về bạo lực và sự chuộc tội.', '1994-10-14', 'pulpfiction.jpg'),
    (N'The Shawshank Redemption', 3, N'Frank Darabont', 142, N'Hai người đàn ông bị giam cầm cùng nhau tạo dựng một mối quan hệ thân thiết qua nhiều năm, tìm thấy sự an ủi và chuộc lỗi thông qua những hành động tử tế thường nhật.', '1994-09-23', 'shawshank.jpg'),
    (N'Gladiator', 2, N'Ridley Scott', 155, N'Một cựu tướng quân La Mã tìm cách trả thù hoàng đế tham nhũng đã giết gia đình anh ta và đày anh ta vào chế độ nô lệ.', '2000-05-05', 'gladiator.jpg'),
	(N'The Godfather', 3, N'Francis Ford Coppola', 175, N'Bộ phim xoay quanh gia đình tội phạm Corleone ở New York, tập trung vào sự kế thừa quyền lực từ Vito Corleone sang con trai của ông, Michael.', '1972-03-24', 'godfather.jpg'),
    (N'The Dark Knight', 2, N'Christopher Nolan', 152, N'Batman phải đối mặt với Joker, một kẻ thù mới đầy nguy hiểm, đe dọa đến thành phố Gotham.', '2008-07-18', 'darkknight.jpg'),
    (N'Schindlers List', 3, N'Steven Spielberg', 195, N'Câu chuyện về Oskar Schindler, người đã cứu hàng ngàn người Do Thái khỏi cái chết trong Thế chiến II.', '1993-12-15', 'schindlerslist.jpg'),
    (N'Titanic', 7, N'James Cameron', 195, N'Câu chuyện tình lãng mạn giữa Jack và Rose trên con tàu Titanic định mệnh.', '1997-12-19', 'titanic.jpg'),
    (N'Forrest Gump', 9, N'Robert Zemeckis', 142, N'Cuộc đời đầy phi thường của Forrest Gump, người có trí tuệ hạn chế nhưng đã trải qua nhiều sự kiện lịch sử quan trọng.', '1994-07-06', 'forrestgump.jpg');
-- INSERT dữ liệu vào bảng RapChieuPhim
INSERT INTO RapChieuPhim (TenRap, ViTri, TongGhe)
VALUES 
    (N'Rạp 1', N'Tầng 3, Trung tâm thương mại Saigon Centre', 150),
    (N'Rạp 2', N'Tầng 4, Trung tâm thương mại Saigon Garden', 200),
    (N'Rạp 3', N'Tầng 5, TTTM Vạn Hạnh Mall', 180),
    (N'Rạp 4', N'Tầng 2, TTTM Giga Mall Thủ Đức', 220),
    (N'Rạp 5', N'Tầng 1, TTTM Aeon Mall Tân Phú', 170);

-- INSERT dữ liệu vào bảng ManHinhChieu
INSERT INTO ManHinhChieu (MaRap, SoManHinh, TongSoGhe)
VALUES 
    (1, 1, 150),
    (2, 1, 200),
    (3, 1, 180),
    (4, 1, 220),
    (5, 1, 170);

	select * from SuatChieu
-- INSERT dữ liệu vào bảng SuatChieu
INSERT INTO SuatChieu (MaPhim, MaManHinh, ThoiGianChieu, SoGheTrong)
VALUES 
    (10, 1, '2024-07-05 14:00:00', 150),
    (12, 2, '2024-07-05 16:00:00', 200),
    (3, 3, '2024-07-05 18:00:00', 180),
    (4, 4, '2024-07-05 20:00:00', 220),
    (5, 5, '2024-07-05 22:00:00', 170);

-- INSERT dữ liệu vào bảng KhachHang
INSERT INTO KhachHang (TenKhachHang, Email, SoDienThoai, DiaChi,MatKhau)
VALUES 
    (N'Nguyễn Tâm Anh', N'tamanh1212@gmail.com', N'0912345678', N'123 Đường Lê Trọng Tấn, Quận Tân Phú, TP.Hồ Chí Minh','tamanh'),
    (N'Nguyễn Thế Kiệt', N'thekietbaby@gmail.com', N'0987654321', N'456 Đường Phan Văn Trị, Quận 5, TP.Hồ Chí Minh','thekiet'),
    (N'Lê Văn Cường', N'lvcuong312@gmail.com', N'0911111111', N'789 Đường C1, Quận Bình Tân, TP.Hồ Chí Minh','cuonglv'),
    (N'Phạm Hoàng Dũng', N'phamdunggg@gmail.com', N'0922222222', N'123 Đường Ngô Gia Tự, Quận Long Biên, Hà Nội','dunggg'),
    (N'Phan Tuấn Kiệt', N'kietphan8347@gmail.com', N'0933333333', N'456 Đường Lê Đức Thọ, Quận Cầu Giấy, Hà Nội','kiet');

-- Insert một số dữ liệu mẫu vào bảng Ghe
INSERT INTO Ghe (MaManHinh, SoGhe)
VALUES 
    (1, 'A1'), (1, 'A2'), (1, 'A3'), (1, 'A4'), (1, 'A5'),
    (1, 'B1'), (1, 'B2'), (1, 'B3'), (1, 'B4'), (1, 'B5'),
    (1, 'C1'), (1, 'C2'), (1, 'C3'), (1, 'C4'), (1, 'C5'),
    (1, 'D1'), (1, 'D2'), (1, 'D3'), (1, 'D4'), (1, 'D5'),
    (1, 'E1'), (1, 'E2'), (1, 'E3'), (1, 'E4'), (1, 'E5'),
    (2, 'A1'), (2, 'A2'), (2, 'A3'), (2, 'A4'), (2, 'A5'),
    (2, 'B1'), (2, 'B2'), (2, 'B3'), (2, 'B4'), (2, 'B5'),
    (2, 'C1'), (2, 'C2'), (2, 'C3'), (2, 'C4'), (2, 'C5'),
    (2, 'D1'), (2, 'D2'), (2, 'D3'), (2, 'D4'), (2, 'D5'),
    (2, 'E1'), (2, 'E2'), (2, 'E3'), (2, 'E4'), (2, 'E5'),
    (3, 'A1'), (3, 'A2'), (3, 'A3'), (3, 'A4'), (3, 'A5'),
    (3, 'B1'), (3, 'B2'), (3, 'B3'), (3, 'B4'), (3, 'B5'),
    (3, 'C1'), (3, 'C2'), (3, 'C3'), (3, 'C4'), (3, 'C5'),
    (3, 'D1'), (3, 'D2'), (3, 'D3'), (3, 'D4'), (3, 'D5'),
    (3, 'E1'), (3, 'E2'), (3, 'E3'), (3, 'E4'), (3, 'E5');

-- INSERT dữ liệu vào bảng Vé
INSERT INTO Ve (MaSuatChieu, MaKhachHang, MaGhe, Gia, NgayDatVe)
VALUES 
    (1, 1, 1, 100000, '2024-07-01 10:00:00'),  -- MaGhe = 1 tương ứng với (1, 'A1')
    (1, 1, 2, 100000, '2024-07-01 10:00:00'),  -- MaGhe = 2 tương ứng với (1, 'A2')
    (2, 2, 6, 120000, '2024-07-02 11:00:00'),  -- MaGhe = 6 tương ứng với (2, 'B1')
    (3, 3, 11, 150000, '2024-07-03 12:00:00'), -- MaGhe = 11 tương ứng với (3, 'C1')
    (4, 4, 16, 130000, '2024-07-04 13:00:00'), -- MaGhe = 16 tương ứng với (4, 'D1')
    (5, 5, 21, 140000, '2024-07-05 14:00:00'); -- MaGhe = 21 tương ứng với (5, 'E1')



-- INSERT dữ liệu vào bảng ThanhToan
INSERT INTO ThanhToan (MaVe, NgayThanhToan, SoTien, PhuongThucThanhToan)
VALUES 
    (1, '2024-07-01 15:00:00', 200000, N'Tiền mặt'),
    (2, '2024-07-02 16:00:00', 120000, N'Thẻ tín dụng'),
    (3, '2024-07-03 17:00:00', 150000, N'Thẻ ngân hàng'),
    (4, '2024-07-04 18:00:00', 130000, N'Ví điện tử'),
    (5, '2024-07-05 19:00:00', 140000, N'Tiền mặt');


-- INSERT dữ liệu vào bảng NhânViên
INSERT INTO NhanVien (TenNhanVien, ChucVu, Luong, NgayTuyenDung, TenDangNhap, MatKhau, MaRap)
VALUES 
    (N'Nguyễn Kim Anh', N'Quản lý', 15000000, '2022-01-01','kimanh','123456', 1),
    (N'Trần Mỹ Tâm', N'Nhân viên bán vé', 7000000, '2022-02-01','mytam','123', 2),
    (N'Lê Minh Tâm', N'Nhân viên bán vé', 5000000, '2022-03-01','minhtam','123', 3),
    (N'Phạm Mỹ Dung', N'Nhân viên bán vé', 6000000, '2022-04-01','mydung','123', 4),
    (N'Hoàng Kim Mai', N'Quản lý', 14000000, '2022-05-01','kimmai','123456', 5);

-- INSERT dữ liệu vào bảng KhuyenMai
INSERT INTO KhuyenMai (TieuDe, MoTa, GiamGia, NgayBatDau, NgayKetThuc)
VALUES 
    (N'Giảm giá sinh nhật', N'Giảm 20% cho các khách hàng sinh nhật tháng này', 20.0, '2024-07-01', '2024-07-31'),
    (N'Mùa hè sôi động', N'Giảm giá 30% cho các suất chiếu vào buổi chiều', 30.0, '2024-07-15', '2024-08-15');

-- INSERT dữ liệu vào bảng ApDungKhuyenMai
INSERT INTO ApDungKhuyenMai (MaKhuyenMai, MaVe)
VALUES 
    (1, 1),
    (2, 2);

-- INSERT dữ liệu vào bảng DanhGiaPhim
SET DATEFORMAT YMD
INSERT INTO DanhGiaPhim (MaPhim, MaKhachHang, DiemDanhGia, BinhLuan, NgayDanhGia)
VALUES 
    (10, 1, 4, N'Phim hay nhưng hơi dài', '2024-07-18 14:30:00'),
    (12, 2, 5, N'Phim rất hấp dẫn, kết thúc bất ngờ', '2024-07-18 16:45:00'),
    (10, 1, 5, N'Tuyệt vời!', '2024-07-01 10:00:00'),
    (12, 2, 4, N'Rất hay!', '2024-07-02 20:15:00'),
    (3, 3, 3, N'Phim hay nhưng còn vài chỗ khá buồn.', '2024-07-03 08:30:00');
	
-- INSERT dữ liệu vào bảng ThucAn
INSERT INTO ThucAn (TenMatHang, LoaiMatHang, Gia, MoTa, SoLuongTon, NgayNhapHangCuoi)
VALUES 
    (N'Hotdog', N'Đồ ăn nhẹ', 30000, N'Hotdog truyền thống', 30, '2024-07-01 09:00:00'),
	(N'Bỏng ngô', N'Đồ ăn nhẹ', 20000, N'Bỏng ngô vị ngọt', 100, '2024-07-01 09:00:00'),
    (N'Pepsi', N'Đồ uống', 15000, N'Pepsi chai 500ml', 50, '2024-07-01 09:00:00'),
	(N'Khoai tây chiên', N'Đồ ăn nhẹ', 25000, N'Khoai tây chiên giòn', 100, '2024-07-03 11:00:00'),
    (N'Thịt gà viên', N'Đồ ăn nhẹ', 35000, N'Thịt gà viên chiên giòn', 80, '2024-07-03 11:00:00'),
    (N'Xúc xích', N'Đồ ăn nhẹ', 20000, N'Xúc xích nướng', 120, '2024-07-03 11:00:00'),
    (N'Chả cá trứng cút', N'Đồ ăn nhẹ', 30000, N'Chả cá kèm trứng cút', 70, '2024-07-03 11:00:00'),
    (N'Xúc xích hồ lô', N'Đồ ăn nhẹ', 25000, N'Xúc xích hồ lô kiểu Trung Quốc', 90, '2024-07-03 11:00:00');


-- INSERT dữ liệu vào bảng DonHangThucAn
INSERT INTO DonHangThucAn (MaKhachHang, NgayDatHang, TongTien)
VALUES 
    (1, '2024-07-01 10:00:00', 65000),
    (2, '2024-07-02 11:00:00', 45000),
    (3, '2024-07-03 12:00:00', 30000);

-- INSERT dữ liệu vào bảng ChiTietDonHangThucAn
INSERT INTO ChiTietDonHangThucAn (MaDonHang, MaMatHang, SoLuong, Gia)
VALUES 
    (1, 1, 2, 20000),
    (1, 2, 1, 15000),
    (2, 2, 2, 15000),
    (3, 3, 1, 30000);

-- INSERT dữ liệu vào bảng NhomNguoiDung
INSERT INTO NhomNguoiDung (TenNhom)
VALUES 
    (N'Quản lý hệ thống'),
    (N'Nhân viên bán vé'),
    (N'Nhân viên thu ngân');

-- INSERT dữ liệu vào bảng NguoiDungNhomNguoiDung
INSERT INTO NguoiDungNhomNguoiDung (MaNhanVien, MaNhomNguoiDung)
VALUES 
    (1, 1),
    (2, 2),
    (3, 2),
    (4, 2),
    (5, 1);

-- INSERT dữ liệu vào bảng ManHinh
INSERT INTO ManHinh (TenManHinh)
VALUES 
    (N'Màn hình quản lý phim'),
    (N'Màn hình bán vé'),
    (N'Màn hình thu ngân');

INSERT INTO PhanQuyen (MaNhomNguoiDung, MaManHinh, CoQuyen)
VALUES 
    (1, 1, 1), -- Quản lý hệ thống có quyền quản lý phim
    (1, 2, 1), -- Quản lý hệ thống có quyền bán vé
    (1, 3, 1), -- Quản lý hệ thống có quyền thu ngân
    (2, 2, 1), -- Nhân viên bán vé có quyền bán vé
    (3, 3, 1); -- Nhân viên thu ngân có quyền thu ngân
	