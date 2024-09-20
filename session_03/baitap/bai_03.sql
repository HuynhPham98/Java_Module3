CREATE DATABASE bai_03;
USE bai_03;

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

INSERT INTO NgayCungCap(tenNCC,diaChi,soDienThoai) VALUES('Nhà cung cấp 1', 'Địa chỉ 1', '0912345678'),
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

-- Tìm danh sách vật tư bán chạy nhất

SELECT VatTu.maVT,VatTu.tenVT, SUM(PhieuXuatChiTiet.soLuongXuat) AS TongSoLuongXuat
FROM PhieuXuatChiTiet
JOIN VatTu ON PhieuXuatChiTiet.maVT = VatTu.maVT
GROUP BY VatTu.maVT, VatTu.tenVT
ORDER BY TongSoLuongXuat DESC;

-- Tìm danh sách vật tư có trong kho nhiều nhất

SELECT VatTu.maVT,VatTu.tenVT,
SUM(PhieuNhapChiTiet.soLuongNhap) - SUM(PhieuXuatChiTiet.soLuongXuat) AS soLuongTonKho
FROM VatTu
LEFT JOIN PhieuNhapChiTiet ON VatTu.maVT = PhieuNhapChiTiet.maVT
LEFT JOIN PhieuXuatChiTiet ON VatTu.maVT = PhieuXuatChiTiet.maVT
GROUP BY VatTu.maVT,VatTu.tenVT
HAVING soLuongTonKho > 0
ORDER BY soLuongTonKho DESC;

-- Tìm ra danh sách nhà cung cấp có đơn hàng từ ngày 12/8/2024 đến 22/8/2024

SELECT NgayCungCap.maNCC,NgayCungCap.tenNCC,NgayCungCap.diaChi,NgayCungCap.soDienThoai
FROM DonDatHang
JOIN NgayCungCap ON NgayCungCap.maNCC = DonDatHang.maNCC
WHERE DonDatHang.ngayDH BETWEEN '2024-08-12' AND '2024-8-22';

-- Tìm ra danh sách vật tư đươc mua ở nhà cung cấp từ ngày 11/09/2024 đến 22/09/2024

SELECT VatTu.maVT,VatTu.tenVT,NgayCungCap.tenNCC,DonDatHang.ngayDH
FROM ChiTietDonDatHang
JOIN VatTu ON ChiTietDonDatHang.maVT = VatTu.maVT
JOIN DonDatHang ON ChiTietDonDatHang.soDH = DonDatHang.soDH
JOIN NgayCungCap ON DonDatHang.maNCC = NgayCungCap.maNCC
WHERE DonDatHang.ngayDH BETWEEN '2024-09-11' AND '2024-09-22';