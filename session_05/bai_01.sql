CREATE DATABASE ss05_ex01;
USE ss05_ex01;

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

-- Tạo view hiển thị tất cả customer

CREATE VIEW view_all_customers AS
SELECT * FROM customers;

-- Tạo view hiển thị tất cả order có oTotalPrice trên 150000

CREATE VIEW view_order AS
SELECT * FROM orders AS o 
WHERE o.oTotalPrice > 150000;

-- Đánh index cho bảng customer ở cột cName

CREATE INDEX idx_name ON customers(cName);
SHOW INDEX FROM customers;

-- Đánh index cho bảng product ở cột pName

CREATE INDEX idx_pName ON product(pName);

-- Tạo store procedure hiển thị ra đơn hàng có tổng tiền bé nhất

DELIMITER //
CREATE PROCEDURE GetOrderWithMinTotalPrice()
BEGIN
     SELECT o.* FROM orders AS o
     WHERE o.oTotalPrice = (
          SELECT MIN(oTotalPrice) FROM orders
     )
     LIMIT 1;
END //
DELIMITER ;
CALL GetOrderWithMinTotalPrice();

-- Tạo store procedure hiển thị người dùng nào mua sản phẩm “May Giat” ít nhất

DELIMITER //
CREATE PROCEDURE show_customer()
BEGIN
     SELECT * FROM customers AS c
     JOIN orders AS o ON c.cid = o.cid
     WHERE c.cid = (
     SELECT o.cid FROM orders AS o
     JOIN orderDetail AS od ON o.oid = od.oid
     WHERE od.odQuantity = (
     SELECT MIN(odQuantity) FROM orderDetail
     )
     LIMIT 1
     );
END //
DELIMITER ;  
 
CALL show_customer();