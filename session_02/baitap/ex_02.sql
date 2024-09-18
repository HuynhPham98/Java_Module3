CREATE DATABASE ex_02;
USE ex_02;

CREATE TABLE customers(
cId INT AUTO_INCREMENT PRIMARY KEY,
cName VARCHAR(255) NOT NULL,
cAge INT NOT NULL
);

CREATE TABLE product(
pId INT AUTO_INCREMENT PRIMARY KEY,
pName VARCHAR(255) UNIQUE,
pPrice DOUBLE CHECK(pPrice > 0)
);

CREATE TABLE orders(
oId INT AUTO_INCREMENT PRIMARY KEY,
cId INT NOT NULL,
oDate DATETIME,
oTotalPrice DOUBLE,
FOREIGN KEY(cId) REFERENCES customers(cId)
);

CREATE TABLE orderDetail(
oId INT,
pId INT,
odQuantity INT NOT NULL,
FOREIGN KEY(oId) REFERENCES orders(oId),
FOREIGN KEY(pId) REFERENCES product(pId)
);

INSERT INTO customers(cName,cAge) VALUES('John', 28);
SELECT * FROM customers;

INSERT INTO product(pName,pPrice) VALUES('Sữa tươi', 20000),('Bánh mì',10000);
SELECT * FROM product;
INSERT INTO orders(cId,oDate,oTotalPrice) VALUES(1,'2024-09-18',50000);
SELECT * FROM orders;
INSERT INTO orderDetail(oId,pId,odQuantity) VALUES (1,1,2),(1,1,1);
SELECT * FROM orderDetail;