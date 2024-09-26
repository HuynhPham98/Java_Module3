CREATE DATABASE QUANLYBANHANG;
USE QUANLYBANHANG;

CREATE TABLE CUSTOMERS(
      customer_id VARCHAR(4) PRIMARY KEY,
      name VARCHAR(100) NOT NULL,
      email VARCHAR(100) NOT NULL UNIQUE,
      phone VARCHAR(25) NOT NULL UNIQUE,
      address VARCHAR(255) NOT NULL
);

CREATE TABLE ORDERS(
      order_id VARCHAR(4) PRIMARY KEY,
      customer_id VARCHAR(4) NOT NULL,
      order_date DATE NOT NULL,
      total_amount DOUBLE NOT NULL,
      FOREIGN KEY(customer_id) REFERENCES customers(customer_id)
);

CREATE TABLE PRODUCTS(
      product_id VARCHAR(4) PRIMARY KEY,
      name VARCHAR(255) NOT NULL,
      description TEXT,
      price DOUBLE NOT NULL,
      status BIT(1) 
);

CREATE TABLE ORDERS_DETAILS(
      order_id VARCHAR(4) NOT NULL,
      product_id VARCHAR(4) NOT NULL,
      quantity INT(11) NOT NULL,
      price DOUBLE NOT NULL,
      FOREIGN KEY(order_id) REFERENCES orders(order_id),
      FOREIGN KEY(product_id) REFERENCES products(product_id)
);

-- B2: Thêm dữ liệu
INSERT INTO CUSTOMERS(customer_id,name,email,phone,address) VALUES
('C001', 'Nguyễn Trung Mạnh', 'manhnt@gmail.com', '984756322', 'Cầu Giấy, Hà Nội'),
('C002', 'Hồ Hải Nam', 'namhh@gmail.com', '984758926', 'Ba Đình, Hà Nội'),
('C003', 'Tô Ngọc Vũ', 'vutn@gmail.com', '904727584', 'Mỹ Châu, Sơn La'),
('C004', 'Phạm Ngọc Anh', 'anhpn@gmail.com', '984635365', 'Vinh, Nghệ An'),
('C005', 'Trương Minh Cường', 'cuongtm@gmail.com', '989735624', 'Hai Bà Trưng, Hà Nội');

INSERT INTO PRODUCTS(product_id,name,description,price,status) VALUES
('P001', 'Iphone 13 ProMax', 'Bản 512 GB, xanh lá', 22999999, 1),
('P002', 'Dell Vostro V3510', 'Core i5, RAM8GB', 14999999, 1),
('P003', 'Macbook Pro M2', 'CPU I9CPU |8GB|256GB|', 18999999, 1),
('P004', 'Apple Watch Ultra', 'Titanium Alpine Loop Small', 18999999, 1),
('P005', 'Apple Airpods 2', 'Spatial Audio', 409900, 1);

INSERT INTO ORDERS(order_id,customer_id,total_amount,order_date) VALUES
('H001', 'C001', 52999997, str_to_date('22/2/2023','%d/%c/%Y')),
('H002', 'C001', 80999987, str_to_date('11/3/2023','%d/%c/%Y')),
('H003', 'C002', 54399958, str_to_date('22/1/2023','%d/%c/%Y')),
('H004', 'C003', 102999957, str_to_date('14/3/2023','%d/%c/%Y')),
('H005', 'C003', 80999997, str_to_date('12/3/2023','%d/%c/%Y')),
('H006', 'C004', 110499994, str_to_date('1/2/2023','%d/%c/%Y')),
('H007', 'C004', 17999996, str_to_date('29/3/2023','%d/%c/%Y')),
('H008', 'C004', 29999998, str_to_date('14/2/2023','%d/%c/%Y')),
('H009', 'C005', 28999999, str_to_date('10/1/2023','%d/%c/%Y')),
('H010', 'C005', 14999994, str_to_date('1/4/2023','%d/%c/%Y'));

INSERT INTO ORDERS_DETAILS(order_id,product_id,price,quantity) VALUES
('H001', 'P002', 14999999, 1),
('H001', 'P004', 18999999, 2),
('H002', 'P001', 22999999, 1),
('H002', 'P003', 28999999, 2),
('H003', 'P004', 18999999, 2),
('H003', 'P005', 40900000, 4),
('H004', 'P002', 14999999, 3),
('H004', 'P003', 28999999, 2),
('H005', 'P001', 22999999, 1),
('H005', 'P003', 28999999, 2),
('H006', 'P005', 40900000, 5),
('H006', 'P002', 14999999, 6),
('H007', 'P004', 18999999, 3),
('H007', 'P001', 22999999, 1),
('H008', 'P002', 14999999, 2),
('H009', 'P003', 28999999, 9),
('H010', 'P003', 28999999, 4),
('H010', 'P001', 22999999, 4);

-- B3: Truy vấn dữ liệu
-- 1. Lấy ra tất cả thông tin gồm: tên, email, số điện thoại và địa chỉ trong bảng Customers

SELECT name,email,phone,address FROM customers;

-- 2. Thống kê những khách hàng mua hàng trong tháng 3/2023 (thông tin bao gồm tên, số điện 
-- thoại và địa chỉ khách hàng).

SELECT DISTINCT c.name,c.phone,c.address FROM customers AS c
JOIN orders AS o ON c.customer_id = o.customer_id
WHERE o.order_date BETWEEN '2023-03-01' AND '2023-03-31';  

-- 3. Thống kê doanh thua theo từng tháng của cửa hàng trong năm 2023 (thông tin bao gồm 
-- tháng và tổng doanh thu ).

SELECT MONTH(o.order_date) AS Month, SUM(o.total_amount) AS total_revenue
FROM orders AS o
WHERE YEAR(o.order_date) = 2023
GROUP BY o.order_date
ORDER BY Month;

-- 4. Thống kê những người dùng không mua hàng trong tháng 2/2023 (thông tin gồm tên khách 
-- hàng, địa chỉ , email và số điên thoại).

SELECT c.name,c.address,c.email,c.phone FROM customers AS c
LEFT JOIN orders AS o ON c.customer_id = o.customer_id 
AND o.order_date BETWEEN '2023-02-01' AND '2023-02-28'
WHERE o.customer_id IS NULL;

-- 5. Thống kê số lượng từng sản phẩm được bán ra trong tháng 3/2023 (thông tin bao gồm mã 
-- sản phẩm, tên sản phẩm và số lượng bán ra).

SELECT p.product_id,p.name,SUM(quantity) AS total FROM products AS p
JOIN orders_details AS od ON p.product_id = od.product_id
JOIN orders AS o ON od.order_id = o.order_id
WHERE o.order_date BETWEEN '2023-03-01' AND '2023-03-31'
GROUP BY p.product_id,p.name;

-- 6. Thống kê tổng chi tiêu của từng khách hàng trong năm 2023 sắp xếp giảm dần theo mức chi 
-- tiêu (thông tin bao gồm mã khách hàng, tên khách hàng và mức chi tiêu).

SELECT c.customer_id,c.name, SUM(o.total_amount) AS total_expenditure FROM customers AS c
JOIN orders AS o ON c.customer_id = o.customer_id
GROUP BY c.customer_id
ORDER BY total_expenditure DESC;

-- 7.Thống kê những đơn hàng mà tổng số lượng sản phẩm mua từ 5 trở lên (thông tin bao gồm 
-- tên người mua, tổng tiền , ngày tạo hoá đơn, tổng số lượng sản phẩm).

SELECT c.name,o.total_amount,o.order_date,SUM(od.quantity) AS total_quantity FROM customers AS c
JOIN orders AS o ON c.customer_id = o.customer_id
JOIN orders_details AS od ON o.order_id = od.order_id
GROUP BY o.order_id
HAVING total_quantity >= 5;

-- B4: Tạo View, Procedure
-- 1. Tạo VIEW lấy các thông tin hoá đơn bao gồm : Tên khách hàng, số điện thoại, địa chỉ, tổng tiền và ngày tạo hoá đơn

CREATE VIEW InvoiceDetails AS
      SELECT
            c.name AS 'Tên khách hàng',
            c.phone AS 'số điện thoại',
            c.address AS 'địa chỉ',
            o.total_amount AS 'tổng tiền',
            o.order_date AS 'ngày tạo hoá đơn'
      FROM customers AS c
      JOIN orders AS o ON o.customer_id = c.customer_id;
SELECT * FROM InvoiceDetails;

-- 2. Tạo VIEW hiển thị thông tin khách hàng gồm : tên khách hàng, địa chỉ, số điện thoại và tổng số đơn đã đặt

CREATE VIEW ShowInforCustomer AS
      SELECT 
            c.name AS 'Tên Khách Hàng',
            c.address AS 'Địa Chỉ',
            c.phone AS 'Số Điện Thoại',
            COUNT(o.order_id) AS 'Tổng Số Đơn Đã Đặt' 
      FROM customers AS c
      JOIN orders AS o ON c.customer_id = o.customer_id
      GROUP BY c.customer_id;
      
SELECT * FROM ShowInforCustomer;

-- 3. Tạo VIEW hiển thị thông tin sản phẩm gồm: tên sản phẩm, mô tả, giá và tổng số lượng đã bán 
-- ra của mỗi sản phẩm. 

CREATE VIEW showInforProduct AS
      SELECT
            p.name AS 'tên sản phẩm',
            p.description AS 'mô tả',
            p.price AS 'Giá',
            SUM(od.quantity) AS 'tổng số lượng đã bán'
      FROM products AS p
      JOIN ORDERS_DETAILS AS od ON p.product_id = od.product_id
      GROUP BY p.product_id;
SELECT * FROM showInforProduct; 

-- 4. Đánh Index cho trường `phone` và `email` của bảng Customer
CREATE INDEX idx_phone ON customers(phone);
CREATE INDEX idx_email ON customers(email);

-- 5. Tạo PROCEDURE lấy tất cả thông tin của 1 khách hàng dựa trên mã số khách hàng.

DELIMITER $$
CREATE PROCEDURE getInforCustomer(
      IN p_customer_id VARCHAR(4)   
)
BEGIN
      SELECT * FROM customers AS c
      WHERE p_customer_id = c.customer_id;
END $$
DELIMITER ;
CALL getInforCustomer('C003');

-- 6. Tạo PROCEDURE lấy thông tin của tất cả sản phẩm

DELIMITER $$
CREATE PROCEDURE getInforProduct()
BEGIN
     SELECT * FROM products;
END $$
DELIMITER ;
CALL getInforProduct();

-- 7. Tạo PROCEDURE hiển thị danh sách hoá đơn dựa trên mã người dùng

DELIMITER $$
CREATE PROCEDURE showOrderByCustomerId(
      p_customer_id VARCHAR(4) 
)
BEGIN
     SELECT o.* FROM orders AS o
     JOIN CUSTOMERS AS c ON o.customer_id = c.customer_id
     WHERE c.customer_id = p_customer_id;
END $$
DELIMITER ;
CALL showOrderByCustomerId('C001');

-- 8. Tạo PROCEDURE tạo mới một đơn hàng với các tham số là mã khách hàng, tổng tiền và ngày tạo hoá đơn, và hiển thị ra mã hoá đơn vừa tạo

DELIMITER $$
CREATE PROCEDURE CreateOrder(
      IN p_customer_id VARCHAR(4),
      IN p_total_amount DOUBLE,
      IN p_order_date DATE,
      OUT p_order_id VARCHAR(4)
)
BEGIN
      SET p_order_id = (
          SELECT CONCAT('H', LPAD(COALESCE(MAX(CAST(SUBSTRING(order_id, 2) AS UNSIGNED)), 0) + 1, 3, '0'))
          FROM orders
      );
      INSERT INTO orders(order_id,customer_id,total_amount,order_date) 
      VALUE(p_order_id,p_customer_id,p_total_amount,p_order_date);
END $$
DELIMITER ;

CALL CreateOrder('C003', 20555, '2024-05-25', @newOrderId);
SELECT @newOrderId;
SELECT * FROM orders;

-- 9. Tạo PROCEDURE thống kê số lượng bán ra của mỗi sản phẩm trong khoảng thời gian cụ thể với 2 tham số là ngày bắt đầu và ngày kết thúc

DELIMITER $$
CREATE PROCEDURE GetProductSalesByDateRange(
      startDate DATE,
      endDate DATE
)
BEGIN
     SELECT od.product_id,p.name, SUM(od.quantity) AS total FROM ORDERS_DETAILS AS od
     JOIN products AS p ON od.product_id = p.product_id
     JOIN orders AS o ON od.order_id = o.order_id
     WHERE o.order_date BETWEEN startDate AND endDate
     GROUP BY od.product_id;
END $$ 
DELIMITER ;
CALL GetProductSalesByDateRange('2023-01-01','2023-02-01');

-- 10. Tạo PROCEDURE thống kê số lượng của mỗi sản phẩm được bán ra theo thứ tự giảm dần của tháng đó với tham số vào là tháng và năm cần thống kê.

DELIMITER //

CREATE PROCEDURE GetMonthlyProductSales(
    IN month INT,
    IN year INT
)
BEGIN
    SELECT 
        od.product_id,
        p.name,
        COALESCE(SUM(od.quantity), 0) AS quantity_sold
    FROM 
        ORDERS_DETAILS od
    JOIN 
        PRODUCTS p ON od.product_id = p.product_id
    JOIN 
        ORDERS o ON od.order_id = o.order_id
    WHERE 
        MONTH(o.order_date) = month AND YEAR(o.order_date) = year
    GROUP BY 
        od.product_id, p.name
    ORDER BY 
        quantity_sold DESC;
END //

DELIMITER ;

CALL GetMonthlyProductSales(1,2023);