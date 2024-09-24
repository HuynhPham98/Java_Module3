CREATE DATABASE ss05_ex02;
USE ss05_ex02;

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

-- Tạo store procedure hiển thị tất cả thông tin account mà đã tạo ra 5 đơn hàng trở lên

DELIMITER //
CREATE PROCEDURE Show_all_infor_account()
BEGIN
     SELECT a.* FROM account AS a
     JOIN bill AS b ON a.id = b.acc_id
     GROUP BY a.id
     HAVING COUNT(b.id) >= 5;
END //
DELIMITER ;

CALL Show_all_infor_account();

-- Tạo store procedure hiển thị tất cả sản phẩm chưa được bán

DELIMITER //
CREATE PROCEDURE show_all_product()
BEGIN
     SELECT * FROM product AS p
     LEFT JOIN bill_detail AS bd ON p.id = bd.product_id
     WHERE bd.product_id IS NULL;
END //
DELIMITER ;

-- Tạo store procedure hiển thị top 2 sản phẩm được bán nhiều nhất

DELIMITER //
CREATE PROCEDURE show_product()
BEGIN
     SELECT p.*, SUM(bd.quantity) AS total FROM product AS p
     JOIN bill_detail AS bd ON p.id = bd.product_id
     GROUP BY p.id
     ORDER BY total DESC
     LIMIT 2;
END //
DELIMITER ;  

-- Tạo store procedure thêm tài khoản   

DELIMITER //
CREATE PROCEDURE add_new_account(
      IN p_userName VARCHAR(100),
      IN p_password VARCHAR(255),
      IN p_address VARCHAR(255),
	  IN status BIT(1)
)
BEGIN
     IF EXISTS(SELECT * FROM account WHERE userName = p_userName) THEN
     SIGNAL SQLSTATE '45000'
     SET MESSAGE_TEXT = 'Username already exists.';
     ELSE
         INSERT INTO account(userName,password,address,status)
         VALUE(p_userName,p_password,p_address,status);
     END IF;   
END //
DELIMITER ;

-- Tạo store procedure truyền vào bill_id và sẽ hiển thị tất cả bill_detail của bill_id đó

DELIMITER //
CREATE PROCEDURE view_bill_detail(
    IN p_bill_id INT
)
BEGIN
     IF EXISTS(SELECT * FROM bill WHERE id = p_bill_id) THEN
     SELECT id,bill_id,product_id,quantity,price FROM bill_detail 
     WHERE bill_id = p_bill_id;
     ELSE
     SIGNAL SQLSTATE '45000' 
        SET MESSAGE_TEXT = 'Invalid bill_id.';
    END IF;
END //
DELIMITER ;
CALL getBillDetails(1); 

-- Tạo ra store procedure thêm mới bill và trả về bill_id vừa mới tạo   

DELIMITER //
CREATE PROCEDURE get_bill_id(
      IN p_bill_type BIT(1),
      IN p_acc_id INT,
      IN p_created DATETIME,
      IN p_auth_date DATETIME,
      OUT p_bill_id INT
)
BEGIN
     INSERT INTO bill(bill_type,acc_id,created,auth_date) 
     VALUE (p_bill_type,p_acc_id,p_created,p_auth_date);
     SET p_bill_id = last_insert_id();
END //
DELIMITER ;  

-- Tạo store procedure hiển thị tất cả sản phẩm đã được bán trên 5 sản phẩm

DELIMITER //
CREATE PROCEDURE view_product()
BEGIN 
    SELECT p.*, SUM(bd.quantity) AS total FROM product AS p
    JOIN bill_detail AS bd ON p.id = bd.product_id
    GROUP BY p.id
    HAVING total > 5
    ORDER BY total;
END //
DELIMITER ;    