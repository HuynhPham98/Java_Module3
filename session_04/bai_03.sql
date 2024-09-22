CREATE DATABASE ss04_ex03;
USE ss04_ex03;

CREATE TABLE VatTu(
maVT INT AUTO_INCREMENT PRIMARY KEY,
tenVT VARCHAR(255) UNIQUE
);

INSERT INTO VatTu(tenVT) VALUES('Vật tư A'),('Vật tư B'),('Vật tư C'),('Vật tư D'),('Vật tư E');

CREATE TABLE PhieuXuat(
soPx INT AUTO_INCREMENT PRIMARY KEY,
ngayXuat DATETIME
);

INSERT INTO PhieuXuat(ngayXuat) VALUES('2024-09-01 08:00:00'),('2024-09-02 09:30:00'),('2024-09-03 10:45:00'),('2024-09-04 11:00:00'),('2024-09-05 14:15:00');

CREATE TABLE PhieuNhap(
soPn INT AUTO_INCREMENT PRIMARY KEY,
ngayNhap DATETIME
);

INSERT INTO PhieuNhap(ngayNhap) VALUES('2024-08-15 08:00:00'),('2024-08-16 09:30:00'),('2024-08-17 10:45:00'),('2024-08-18 11:00:00'),('2024-08-19 14:15:00');

CREATE TABLE NgayCungCap(
maNCC INT AUTO_INCREMENT PRIMARY KEY,
tenNCC VARCHAR(255),
diaChi VARCHAR(255),
soDienThoai VARCHAR(11) UNIQUE
);

INSERT INTO NgayCungCap(tenNCC,diaChi,soDienThoai) VALUES
('Nhà cung cấp 1', 'Địa chỉ 1', '0912345678'),
('Nhà cung cấp 2', 'Địa chỉ 2', '0923456789'),
('Nhà cung cấp 3', 'Địa chỉ 3', '0934567890'),
('Nhà cung cấp 4', 'Địa chỉ 4', '0945678901'),
('Nhà cung cấp 5', 'Địa chỉ 5', '0956789012');

CREATE TABLE PhieuXuatChiTiet(
soPx INT,
maVT INT,
donGiaXuat DOUBLE,
soLuongXuat INT CHECK(soLuongXuat > 0),
FOREIGN KEY(soPx) REFERENCES PhieuXuat(soPx),
FOREIGN KEY(maVT) REFERENCES VatTu(maVT) 
);

INSERT INTO PhieuXuatChiTiet(soPx,maVT,donGiaXuat,soLuongXuat) VALUES(1, 1, 100, 10),(1, 2, 150, 5),(2, 3, 200, 7),(2, 4, 250, 3),(3, 5, 300, 6);

CREATE TABLE PhieuNhapChiTiet(
soPn INT,
maVT INT,
donGiaNhap DOUBLE CHECK(donGiaNhap > 0),
soLuongNhap INT check(soLuongNhap > 0),
FOREIGN KEY(soPn) REFERENCES PhieuNhap(soPn),
FOREIGN KEY(maVT) REFERENCES VatTu(maVT)
);

INSERT INTO PhieuNhapChiTiet (soPn, maVT, donGiaNhap, soLuongNhap) VALUES 
(1, 1, 90.0, 15),
(1, 2, 140.0, 10),
(2, 3, 190.0, 8),
(2, 4, 240.0, 4),
(3, 5, 290.0, 12);

CREATE TABLE ChiTietDonDatHang(
maVT INT,
soDH INT AUTO_INCREMENT PRIMARY KEY,
FOREIGN KEY(maVT) REFERENCES VatTu(maVT)
);

INSERT INTO ChiTietDonDatHang (maVT) VALUES 
(1),
(2),
(3),
(4),
(5);

CREATE TABLE DonDatHang(
soDH INT,
maNCC INT,
ngayDH DATETIME,
FOREIGN KEY(soDH) REFERENCES ChiTietDonDatHang(soDH),
FOREIGN KEY(maNCC) REFERENCES NgayCungCap(maNCC)
);

INSERT INTO DonDatHang (soDH, maNCC, ngayDH) VALUES 
(1, 1, '2024-08-20 10:00:00'),
(2, 2, '2024-08-21 11:30:00'),
(3, 3, '2024-08-22 14:00:00'),
(4, 4, '2024-08-23 09:00:00'),
(5, 5, '2024-08-24 13:30:00');

-- Hiển thị tất cả vật tự dựa vào phiếu xuất có số lượng lớn hơn 10

SELECT v.*,SUM(pxct.soLuongXuat) AS total FROM vattu AS v
JOIN phieuxuatchitiet AS pxct ON v.mavt = pxct.mavt
GROUP BY v.mavt,v.tenvt
HAVING total > 10
;

-- Hiển thị tất cả vật tư mua vào ngày 12/2/2023

SELECT v.*,pn.ngaynhap FROM vattu AS v
JOIN phieunhapchitiet AS pnct ON v.mavt = pnct.mavt
JOIN phieunhap AS pn ON pnct.sopn = pn.sopn
WHERE DATE(pn.ngaynhap) = '2023-02-12';

-- Hiển thị tất cả vật tư được nhập vào với đơn giá lớn hơn 1.200.000

SELECT v.*,pnct.dongianhap,pn.ngaynhap FROM vattu AS v 
JOIN phieunhapchitiet AS pnct ON v.mavt = pnct.mavt
JOIN phieunhap AS pn ON pnct.sopn = pn.sopn
WHERE pnct.dongianhap > 1200000;

-- Hiển thị tất cả vật tư được dựa vào phiếu xuất có số lượng lớn hơn 5

SELECT vt.*,SUM(pxct.soluongxuat) AS total FROM vattu AS vt
JOIN phieuxuatchitiet AS pxct ON vt.mavt = pxct.mavt
GROUP BY vt.mavt,vt.tenvt
HAVING total > 5;

-- Hiển thị tất cả nhà cung cấp ở long biên có SoDienThoai bắt đầu với 09

SELECT * FROM ngaycungcap AS ncc
WHERE diachi = 'long biên' AND sodienthoai LIKE '09%';