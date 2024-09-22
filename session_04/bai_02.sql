CREATE DATABASE ss04_ex02;
USE ss04_ex02;

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

-- Hiển thị tất cả customer có đơn hàng trên 150000

SELECT c.*,o.oTotalPrice FROM customers AS c
JOIN orders AS o ON c.cId = o.cid
WHERE o.oTotalPrice > 150000;

-- Hiển thị sản phẩm chưa được bán cho bất cứ ai

SELECT p.* FROM product AS p
JOIN orderDetail AS od ON p.pid = od.pid
WHERE od.pid IS NULL;

-- Hiển thị tất cả đơn hàng mua trên 2 sản phẩm

SELECT od.oid,COUNT(od.pid) AS count FROM orderDetail AS od
JOIN product AS p ON od.pid = p.pid
GROUP BY od.oid
HAVING count >2
ORDER BY od.oid;

-- Hiển thị đơn hàng có tổng giá tiền lớn nhất

SELECT * FROM orders AS o
WHERE o.oTotalPrice = (
   SELECT MAX(oTotalPrice)
   FROM orders
);

-- Hiển thị sản phẩm có giá tiền lớn nhất

SELECT * FROM product AS p
WHERE p.pPrice = (
 SELECT MAX(pPrice)
 FROM product
);

-- Hiển thị người dùng nào mua nhiều sản phẩm “Bep Dien” nhất

SELECT c.*,p.pname,COUNT(od.pid) AS count FROM customers AS c
JOIN orders AS o ON c.cid = o.cid
JOIN orderDetail AS od ON o.oid = od.oid
JOIN product AS p ON od.pid = p.pid
WHERE p.pName = 'Bep Dien'
GROUP BY c.cid
ORDER BY count DESC
LIMIT 1;