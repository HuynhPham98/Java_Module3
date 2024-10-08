CREATE DATABASE ex_03;
USE ex_03;

CREATE TABLE VatTu(
maVT INT AUTO_INCREMENT PRIMARY KEY,
tenVT VARCHAR(255) UNIQUE
);

CREATE TABLE PhieuXuat(
soPx INT AUTO_INCREMENT PRIMARY KEY,
ngayXuat DATETIME
);

CREATE TABLE PhieuNhap(
soPn INT AUTO_INCREMENT PRIMARY KEY,
ngayNhap DATETIME
);

CREATE TABLE NgayCungCap(
maNCC INT AUTO_INCREMENT PRIMARY KEY,
tenNCC VARCHAR(255),
diaChi VARCHAR(255),
soDienThoai VARCHAR(11) UNIQUE
);

CREATE TABLE PhieuXuatChiTiet(
soPx INT,
maVT INT,
donGiaXuat DOUBLE,
soLuongXuat INT CHECK(soLuongXuat > 0),
FOREIGN KEY(soPx) REFERENCES PhieuXuat(soPx),
FOREIGN KEY(maVT) REFERENCES VatTu(maVT) 
);

CREATE TABLE PhieuNhapChiTiet(
soPn INT,
maVT INT,
donGiaNhap DOUBLE CHECK(donGiaNhap > 0),
soLuongNhap INT check(soLuongNhap > 0),
FOREIGN KEY(soPn) REFERENCES PhieuNhap(soPn),
FOREIGN KEY(maVT) REFERENCES VatTu(maVT)
);

CREATE TABLE ChiTietDonDatHang(
maVT INT,
soDH INT AUTO_INCREMENT PRIMARY KEY,
FOREIGN KEY(maVT) REFERENCES VatTu(maVT)
);

CREATE TABLE DonDatHang(
soDH INT,
maNCC INT,
ngayDH DATETIME,
FOREIGN KEY(soDH) REFERENCES ChiTietDonDatHang(soDH),
FOREIGN KEY(maNCC) REFERENCES NgayCungCap(maNCC)
);
