CREATE DATABASE test;
USE test;

CREATE TABLE architect (
  id INT AUTO_INCREMENT PRIMARY KEY,
  name VARCHAR(255),
  birthday INT(4),
  sex TINYINT(1) DEFAULT 0 COMMENT '1: Nam, 0: Nữ',
  place VARCHAR(255),
  address VARCHAR(255)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

INSERT INTO architect (id, name, birthday, sex, place, address) VALUES
(1, 'le thanh tung', 1956, 1, 'tp hcm', '25 duong 3/2 tp bien hoa'),
(2, 'le kim dung', 1952, 0, 'ha noi', '18/5 phan van tri tp can tho'),
(3, 'nguyen anh thu', 1970, 0, 'new york', 'khu 2 dhct tp can tho'),
(4, 'nguyen song do quyen', 1970, 0, 'can tho', '73 tran hung dao tp hcm'),
(5, 'truong minh thai', 1950, 1, 'paris france', '12/2/5 tran phu tp hanoi');

CREATE TABLE building (
  id INT AUTO_INCREMENT PRIMARY KEY,
  name VARCHAR(255),
  address VARCHAR(255),
  city VARCHAR(255),
  cost FLOAT,
  start DATE,
  host_id INT NOT NULL,
  contractor_id INT NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

INSERT INTO building (id, name, address, city, cost, start, host_id, contractor_id) VALUES
(1, 'khach san quoc te', '5 nguyen an ninh', 'can tho', 450, '1994-12-13', 1, 1),
(2, 'cong vien thieu nhi', '100 nguyen thai hoc', 'can tho', 200, '1994-05-08', 2, 1),
(3, 'hoi cho nong nghiep', 'bai cat', 'vinh long', 1000, '1994-06-10', 1, 1),
(4, 'truong mg mang non', '48 cm thang 8', 'can tho', 30, '1994-07-10', 3, 3),
(5, 'khoa trong trot dhct', 'khu ii dhct', 'can tho', 3000, '1994-06-19', 4, 3),
(6, 'van phong bitis', '25 phan dinh phung', 'ha noi', 40, '1994-05-10', 5, 3),
(7, 'nha rieng 1', '124/5 nguyen trai', 'tp hcm', 65, '1994-11-15', 6, 2),
(8, 'nha rieng 2', '76 chau van liem', 'ha noi', 200, '1994-06-09', 7, 4);

CREATE TABLE IF NOT EXISTS contractor (
  id INT AUTO_INCREMENT PRIMARY KEY,
  name VARCHAR(255),
  phone VARCHAR(45),
  address VARCHAR(255)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

INSERT INTO contractor (id, name, phone, address) VALUES
(1, 'cty xd so 6', '567456', '5 phan chu trinh'),
(2, 'phong dich vu so xd', '206481', '2 le van sy'),
(3, 'le van son', '028374', '12 tran nhan ton'),
(4, 'tran khai hoan', '658432', '20 nguyen thai hoc');

CREATE TABLE IF NOT EXISTS design (
  building_id INT NOT NULL,
  architect_id INT NOT NULL,
  benefit FLOAT,
  PRIMARY KEY (building_id, architect_id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

INSERT INTO design (building_id, architect_id, benefit) VALUES
(1, 1, 25),
(1, 5, 12),
(2, 4, 6),
(3, 3, 12),
(4, 2, 20),
(5, 5, 30),
(6, 2, 40),
(6, 5, 27),
(7, 1, 10),
(8, 2, 18);

CREATE TABLE IF NOT EXISTS host (
  id INT AUTO_INCREMENT PRIMARY KEY,
  name VARCHAR(255),
  address VARCHAR(255)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

INSERT INTO host (id, name, address) VALUES
(1, 'so t mai du lich', '54 xo viet nghe tinh'),
(2, 'so van hoa thong tin', '101 hai ba trung'),
(3, 'so giao duc', '29 duong 3/2'),
(4, 'dai hoc can tho', '56 duong 30/4'),
(5, 'cty bitis', '29 phan dinh phung'),
(6, 'nguyen thanh ha', '45 de tham'),
(7, 'phan thanh liem', '48/6 huynh thuc khan');

CREATE TABLE IF NOT EXISTS work (
  building_id INT NOT NULL,
  worker_id INT NOT NULL,
  date DATE,
  total INT,
  PRIMARY KEY (building_id, worker_id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

INSERT INTO work (building_id, worker_id, date, total) VALUES
(1, 1, '1994-12-15', 5),
(1, 3, '1994-12-18', 6),
(1, 6, '1994-09-14', 7),
(2, 1, '1994-05-08', 20),
(2, 4, '1994-05-10', 10),
(2, 5, '1994-12-16', 5),
(3, 4, '1994-10-06', 10),
(3, 7, '1994-10-06', 18),
(4, 1, '1994-09-07', 20),
(4, 6, '1994-05-12', 7);

CREATE TABLE IF NOT EXISTS worker (
  id INT AUTO_INCREMENT PRIMARY KEY,
  name VARCHAR(45),
  birthday INT(4),
  year INT(4),
  skill VARCHAR(45)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

INSERT INTO worker (id, name, birthday, year, skill) VALUES
(1, 'nguyen thi suu', 1945, 1960, 'ho'),
(2, 'vi chi a', 1966, 1987, 'moc'),
(3, 'le manh quoc', 1956, 1971, 'son'),
(4, 'vo van chin', 1940, 1952, 'dien'),
(5, 'le quyet thang', 1954, 1974, 'han'),
(6, 'nguyen hong van', 1950, 1970, 'dien'),
(7, 'dang van son', 1948, 1965, 'dien');

-- ex_06
--  Hiển thị thông tin công trình có chi phí cao nhất

SELECT * FROM building AS bd 
WHERE bd.cost = (
SELECT MAX(bd.cost) FROM building AS bd
);

-- Hiển thị thông tin công trình có chi phí lớn hơn tất cả các công trình được xây dựng ở Cần Thơ
SELECT * FROM building AS bd
WHERE bd.cost > (
SELECT MAX(cost) FROM building
WHERE city = 'can tho'
);

-- Hiển thị thông tin công trình có chi phí lớn hơn một trong các công trình được xây dựng ở Cần Thơ

SELECT * FROM building AS bd
WHERE bd.cost > ANY (
SELECT cost FROM building
WHERE city = 'can tho'
);

-- Hiển thị thông tin công trình chưa có kiến trúc sư thiết kế

SELECT * FROM building AS bd
JOIN design AS d ON bd.id = d.building_id
WHERE d.architect_id IS NULL;

-- ex_07
-- Hiển thị thù lao trung bình của từng kiến trúc sư

SELECT a.*,AVG(d.benefit) AS 'thù lao trung bình' FROM architect AS a
JOIN design AS d ON a.id = d.architect_id
GROUP BY a.id;

-- Hiển thị chi phí đầu tư cho các công trình ở mỗi thành phố

SELECT city,SUM(cost) as total_cost FROM building AS bd
GROUP BY city;

-- Tìm các công trình có chi phí trả cho kiến trúc sư lớn hơn 50

SELECT * FROM building AS bd
JOIN design AS d ON bd.id = d.building_id
WHERE d.benefit > 50;

-- ex_08
-- Hiển thị tên công trình, tên chủ nhân và tên chủ thầu của công trình đó

SELECT h.name,bd.name, c.name FROM building AS bd
JOIN host AS h ON bd.host_id = h.id
JOIN contractor AS c ON bd.contractor_id = c.id;

-- Hiển thị tên công trình (building), tên kiến trúc sư (architect) và thù lao của kiến trúc sư ở mỗi công trình (design)

SELECT bd.name, a.name, d.benefit FROM building AS bd
JOIN design AS d ON bd.id = d.building_id
JOIN architect AS a ON d.architect_id = a.id;

-- Hiển thị những năm sinh có thể có của các kiến trúc sư

SELECT a.name,a.birthday FROM architect AS a;

-- Hiển thị danh sách các kiến trúc sư (họ tên và năm sinh) (giá trị năm sinh tăng dần)

SELECT a.name,a.birthday FROM architect AS a
ORDER BY a.birthday;

-- Hãy cho biết tên và địa chỉ công trình (building) do chủ thầu Công ty xây dựng số 6 thi công (contractor)

SELECT bd.name,bd.address FROM building AS bd
JOIN contractor AS c ON bd.contractor_id = c.id
WHERE c.name = 'cty xd so 6';

-- Tìm tên và địa chỉ liên lạc của các chủ thầu (contractor) thi công công trình ở Cần Thơ (building) 
-- do kiến trúc sư Lê Kim Dung thiết kế (architect, design)

SELECT c.name,c.address FROM contractor AS c
JOIN building AS bd ON c.id = bd.contractor_id
JOIN design AS d ON bd.id = d.building_id 
JOIN architect AS a ON d.architect_id = a.id
WHERE bd.city = 'can tho'AND a.name = 'le kim dung';

-- Hãy cho biết nơi tốt nghiệp của các kiến trúc sư (architect) đã thiết kế (design) công trình Khách Sạn Quốc Tế ở Cần Thơ (building)

SELECT a.*,bd.name AS buildingName, bd.city FROM architect AS a
JOIN design AS d ON a.id = d.architect_id
JOIN building AS bd ON d.building_id = bd.id
WHERE bd.name = 'khach san quoc te' AND bd.city = 'can tho';

-- Cho biết họ tên, năm sinh, năm vào nghề của các công nhân có chuyên môn hàn 
-- hoặc điện (worker) đã tham gia các công trình (work) mà chủ thầu Lê Văn Sơn (contractor) đã trúng thầu (building) 

SELECT worker.name,worker.birthday,worker.year FROM worker
JOIN work AS w ON worker.id = w.worker_id
JOIN building AS bd ON w.building_id = bd.id
JOIN contractor AS c ON bd.contractor_id = c.id
WHERE c.name = 'le van son'
 AND (worker.skill = 'han' OR worker.skill = 'dien');
 
-- Những công nhân nào (worker) đã bắt đầu tham gia công trình Khách sạn Quốc Tế ở Cần Thơ (building) 
-- trong giai đoạn từ ngày 15/12/1994 đến 31/12/1994 (work) số ngày tương ứng là bao nhiêu

SELECT worker.id,worker.name,w.total FROM worker
JOIN work AS w ON worker.id = w.worker_id
JOIN building AS bd ON w.building_id = bd.id
WHERE bd.name = 'khach san quoc te' AND bd.city = 'can tho'
AND (w.date BETWEEN '1994-12-15' AND '1994-12-31');

-- Cho biết họ tên và năm sinh của các kiến trúc sư đã tốt nghiệp ở TP Hồ Chí Minh (architect) 
-- và đã thiết kế ít nhất một công trình (design) có kinh phí đầu tư trên 400 triệu đồng (building)

SELECT a.name,a.birthday FROM architect AS a
JOIN design AS d ON a.id = d.architect_id
JOIN building AS bd ON d.building_id = bd.id
WHERE a.address = 'tp hcm'
AND bd.cost > 400;

-- Cho biết tên công trình có kinh phí cao nhất

SELECT bd.id,bd.name,MAX(bd.cost) AS Max_cost FROM building AS bd
GROUP BY bd.id
ORDER BY bd.cost DESC
LIMIT 1;

-- Cho biết tên các kiến trúc sư (architect) vừa thiết kế các công trình (design) do Phòng dịch vụ sở xây dựng (contractor) 
-- thi công vừa thiết kế các công trình do chủ thầu Lê Văn Sơn thi công

SELECT DISTINCT a.id,a.name FROM architect AS a
JOIN design AS d ON a.id = d.architect_id
JOIN building AS bd ON d.building_id = bd.id
JOIN contractor AS c ON bd.contractor_id = c.id
WHERE c.name = 'phong dich vu so xd' or c.name = 'le van son';

