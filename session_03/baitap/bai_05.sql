CREATE DATABASE bai_05;
USE bai_05;

CREATE TABLE account(
id INT AUTO_INCREMENT PRIMARY KEY,
userName VARCHAR(100) NOT NULL,
password VARCHAR(255) NOT NULL,
address VARCHAR(255) NOT NULL,
status BIT(1) DEFAULT 1
);

INSERT INTO account(userName,password,address) VALUE ('Hùng','123456','Nghệ An'),('Cường','654321','Hà Nội'),('Bách','135790','Hà Nội');

CREATE TABLE bill(
id INT AUTO_INCREMENT PRIMARY KEY,
bill_type BIT(1),
acc_id INT NOT NULL,
created DATETIME NOT NULL,
auth_date DATETIME NOT NULL,
FOREIGN KEY(acc_id) REFERENCES account(id)
);

INSERT INTO bill(bill_type,acc_id,created,auth_date) VALUE 
(0,1,'2022-02-11','2022-03-12'),
(0,1,'2023-10-05','2023-10-10'),
(1,2,'2024-05-15','2024-05-20'),
(1,3,'2022-02-01','2022-02-10');

CREATE TABLE product(
id INT AUTO_INCREMENT PRIMARY KEY,
name VARCHAR(100) NOT NULL,
created DATE NOT NULL,
price DOUBLE NOT NULL CHECK(price > 0),
stock INT NOT NULL CHECK(stock > 0),
status BIT(1) DEFAULT 1
);

INSERT INTO product(name,created,price,stock) VALUE
('Quần dài','2022-03-12',1200,5),
('Áo dài','2023-03-15',1500,8),
('Mũ Cối','1999-03-08',1600,10);

CREATE TABLE bill_detail(
id INT AUTO_INCREMENT PRIMARY KEY,
bill_id INT NOT NULL,
product_id INT NOT NULL,
quantity INT NOT NULL CHECK(quantity > 0),
price DOUBLE NOT NULL CHECK(price > 0),
FOREIGN KEY(bill_id) REFERENCES bill(id),
FOREIGN KEY(product_id) REFERENCES product(id)
);

INSERT INTO bill_detail(bill_id,product_id,quantity,price) VALUE
(1,1,3,1200),
(1,2,4,1500),
(2,1,1,1200),
(3,2,4,1500),
(4,3,7,1600);

-- Hiển thị tất cả account và sắp xếp theo user_name theo chiều giảm dần

SELECT * FROM account
ORDER BY account.userName DESC;

-- Hiển thị tất cả bill từ ngày 11/2/2023 đến 15/5/2023

SELECT * FROM bill 
WHERE bill.auth_date BETWEEN '2023-02-11' AND '2023-05-15';

-- Hiển thị tất cả bill_detail theo bill_id

SELECT * FROM bill_detail bdt
ORDER BY bill_id;

-- Hiển thị tất cả product theo tên và sắp xếp theo chiều giảm dần

SELECT * FROM product
ORDER BY product.name DESC;

-- Hiển thị tất cả product có số lượng lớn hơn 10

SELECT * FROM product
WHERE product.stock >= 10;

-- Hiển thị tất cả product còn hoạt động (dựa vào product_status)

SELECT * FROM product 
WHERE product.status = 1;