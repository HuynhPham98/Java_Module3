CREATE DATABASE bai_02;
USE bai_02;

CREATE TABLE customers(
cId INT AUTO_INCREMENT PRIMARY KEY,
cName VARCHAR(255) NOT NULL,
cAge INT NOT NULL
);

INSERT INTO customers(cName,cAge) VALUES('Minh Quan',10),('Ngoc Oanh',20),('Hong Ha',50);

CREATE TABLE product(
pId INT AUTO_INCREMENT PRIMARY KEY,
pName VARCHAR(255) UNIQUE,
pPrice DOUBLE CHECK(pPrice > 0)
);

INSERT INTO product(pName,pPrice) VALUES('May Giat',300),('Tu Lanh',500),('Dieu Hoa',700),('Quat',100),('Bep Dien',200),('May Hut Mui',500);

CREATE TABLE orders(
oId INT AUTO_INCREMENT PRIMARY KEY,
cId INT NOT NULL,
oDate DATETIME,
oTotalPrice DOUBLE,
FOREIGN KEY(cId) REFERENCES customers(cId)
);

INSERT INTO orders(cId,oDate,oTotalPrice) VALUES(1,'2006-03-21',150000),(2,'2006-03-23',200000),(1,'2006-03-16',170000);

CREATE TABLE orderDetail(
oId INT,
pId INT,
odQuantity INT NOT NULL,
FOREIGN KEY(oId) REFERENCES orders(oId),
FOREIGN KEY(pId) REFERENCES product(pId)
);

INSERT INTO orderdetail(oId,pId,odQuantity) VALUES(1,1,3),(1,3,7),(1,4,2),(2,1,1),(3,1,8),(2,5,4),(2,3,3);

-- Hiển thị các thông tin gồm oID, oDate, oPrice của tất cả các hóa đơn trong bảng Order

SELECT*FROM orders;

-- Hiển thị danh sách các khách hàng đã mua hàng, và danh sách sản phẩm được mua bởi các khách hàng đó.

SELECT orders.oId,customers.cName,product.pName 
FROM orderDetail
JOIN orders ON orders.oId = orderDetail.oId
JOIN customers ON customers.cId = orders.cId
JOIN product ON product.pId = orderDetail.pId;

-- Hiển thị tên những khách hàng không mua bất kỳ một sản phẩm nào

SELECT customers.cId,customers.cName,customers.cAge
FROM customers
LEFT JOIN orders ON orders.cId = customers.cId
WHERE orders.oId IS NULL;

-- Hiển thị mã hóa đơn, ngày bán và giá tiền của từng hóa đơn (giá một hóa đơn được tính bằng tổng giá bán của từng loại mặt hàng xuất hiện trong hóa đơn.
-- Giá bán của từng loại được tính = odQTY * pPrice)

SELECT orders.oId,orders.oDate, SUM(orderDetail.odQuantity* product.pPrice) AS totalPrice
FROM orders
JOIN orderDetail ON orders.oId = orderDetail.oId
JOIN product ON orderDetail.pId = product.pId
GROUP BY orders.oId,orders.oDate;