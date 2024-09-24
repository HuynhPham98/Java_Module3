CREATE DATABASE QUANLYDIEMTHI;
USE QUANLYDIEMTHI;

CREATE TABLE subject(
      subjectId VARCHAR(4) PRIMARY KEY NOT NULL,
      subjectName VARCHAR(45) NOT NULL,
      priority INT NOT NULL
);

CREATE TABLE student(
      studentId VARCHAR(4) PRIMARY KEY NOT NULL,
      studentName VARCHAR(100) NOT NULL,
      birthday DATE NOT NULL,
      gender BIT(1) NOT NULL,
      address TEXT NOT NULL,
      phoneNumber VARCHAR(45)
);

CREATE TABLE mark(
      subjectId VARCHAR(4) NOT NULL,
      studentId VARCHAR(4) NOT NULL,
      point DOUBLE NOT NULL,
      FOREIGN KEY(studentId) REFERENCES student(studentId),
      FOREIGN KEY(subjectId) REFERENCES subject(subjectId)
);

INSERT INTO student (studentId, studentName, birthday, gender, address, phoneNumber) VALUES
('S001', 'Nguyễn Thế Anh', '1999-01-11', 1, 'Hà Nội', '984678082'),
('S002', 'Đặng Bảo Trâm', '1998-12-22', 0, 'Lào Cai', '904982654'),
('S003', 'Trần Hà Phương', '2000-05-05', 0, 'Nghệ An', '947645363'),
('S004', 'Đỗ Tiến Mạnh', '1999-03-26', 1, 'Hà Nội', '983665353'),
('S005', 'Phạm Duy Nhất', '1998-10-04', 1, 'Tuyên Quang', '987242678'),
('S006', 'Mai Văn Thái', '2002-06-22', 1, 'Nam Định', '982654268'),
('S007', 'Giang Gia Hân', '1996-11-10', 0, 'Phú Thọ', '982364753'),
('S008', 'Nguyễn Ngọc Bảo My', '1999-01-22', 0, 'Hà Nam', '927867453'),
('S009', 'Nguyễn Tiến Đạt', '1998-08-07', 1, 'Tuyên Quang', '989274678'),
('S010', 'Nguyễn Thiều Quang', '2000-09-18', 1, 'Hà Nội', '984378291');

INSERT INTO subject (subjectId, subjectName, priority) VALUES
('MH01', 'Toán', 2),
('MH02', 'Vật Lý', 2),
('MH03', 'Hoá Học', 1),
('MH04', 'Ngữ Văn', 1),
('MH05', 'Tiếng Anh', 2);

INSERT INTO mark (subjectId, studentId, point) VALUES
-- Marks for Nguyễn Thế Anh (S001)
('MH01', 'S001', 8.5),
('MH02', 'S001', 7),
('MH03', 'S001', 9),
('MH04', 'S001', 9),
('MH05', 'S001', 5),

-- Marks for Đặng Bảo Trâm (S002)
('MH01', 'S002', 9),
('MH02', 'S002', 8),
('MH03', 'S002', 6.5),
('MH04', 'S002', 8),
('MH05', 'S002', 6),

-- Marks for Trần Hà Phương (S003)
('MH01', 'S003', 7.5),
('MH02', 'S003', 8),
('MH03', 'S003', 8),
('MH04', 'S003', 7),
('MH05', 'S003', 7.5),

-- Marks for Đỗ Tiến Mạnh (S004)
('MH01', 'S004', 6),
('MH02', 'S004', 7),
('MH03', 'S004', 6.5),
('MH04', 'S004', 6.5),
('MH05', 'S004', 8),

-- Marks for Phạm Duy Nhất (S005)
('MH01', 'S005', 5.5),
('MH02', 'S005', 6),
('MH03', 'S005', 8),
('MH04', 'S005', 7.5),
('MH05', 'S005', 5),

-- Marks for Mai Văn Thái (S006)
('MH01', 'S006', 8),
('MH02', 'S006', 10),
('MH03', 'S006', 9),
('MH04', 'S006', 7.5),
('MH05', 'S006', 6.5),

-- Marks for Giang Gia Hân (S007)
('MH01', 'S007', 9.5),
('MH02', 'S007', 9),
('MH03', 'S007', 8.5),
('MH04', 'S007', 9),
('MH05', 'S007', 9),

-- Marks for Nguyễn Ngọc Bảo My (S008)
('MH01', 'S008', 8),
('MH02', 'S008', 8),
('MH03', 'S008', 8.5),
('MH04', 'S008', 9.5),
('MH05', 'S008', 9.5),

-- Marks for Nguyễn Tiến Đạt (S009)
('MH01', 'S009', 7.5),
('MH02', 'S009', 9),
('MH03', 'S009', 6),
('MH04', 'S009', 8),
('MH05', 'S009', 10),

-- Marks for Nguyễn Thiều Quang (S010)
('MH01', 'S010', 6.5),
('MH02', 'S010', 8),
('MH03', 'S010', 5.5),
('MH04', 'S010', 4),
('MH05', 'S010', 7); 

SELECT 
    *
FROM
    student;
SELECT 
    *
FROM
    subject;
SELECT 
    *
FROM
    mark;

-- 2. Cập nhật dữ liệu

-- Sửa tên sinh viên có mã `S004` thành “Đỗ Đức Mạnh”.
UPDATE student
SET 
   studentName = 'Đỗ Đức Mạnh' 
WHERE studentId = 'S004';

-- Sửa tên và hệ số môn học có mã 'MH05' thành 'Ngoại Ngữ' và hệ số là 1
UPDATE subject
SET 
   subjectName = 'Ngoại Ngữ',
   priority = 1
WHERE subjectId = 'MH05';   

-- Cập nhật lại điểm của học sinh có mã 'S009' thành (MH01: 8.5, MH02: 7, MH03: 5.5, MH04: 6, MH05: 9)

UPDATE mark
SET 
    point = 8.5
WHERE 
    studentId = 'S009' AND subjectId = 'MH01';

UPDATE mark 
SET 
    point = 7
WHERE 
    studentId = 'S009' AND subjectId = 'MH02';   

UPDATE mark
SET
    point = 5.5
WHERE
    studentId = 'S009' AND subjectId = 'MH03';  
    
UPDATE mark
SET
    point = 6
WHERE
    studentId = 'S009' AND subjectId = 'MH04';
    
UPDATE mark
SET
    point = 9
WHERE
    studentId = 'S009' AND subjectId = 'MH05';
    
-- 3. Xoá toàn bộ thông tin của học sinh có mã `S010` bao gồm điểm thi ở bảng MARK và thông tin học sinh này ở bảng STUDENT

DELETE FROM mark 
WHERE studentId = 'S010';

DELETE FROM student
WHERE studentId = 'S010'; 

-- B3: Truy vẫn dữ liệu
-- 1. Lấy ra tất cả thông tin của sinh viên trong bảng Student

SELECT studentId,studentName,birthday, 
       CASE
           WHEN gender = 1 then 'Nam'
           WHEN gender = 0 then 'Nữ'
           ELSE 'Unknown'
       END AS gender,address,phoneNumber   
       FROM student AS s;
       
-- 2. Hiển thị tên và mã môn học của những môn có hệ số bằng 1 

SELECT * FROM subject WHERE priority = 1;

-- Hiển thị thông tin học sinh bào gồm: mã học sinh, tên học sinh, tuổi (bằng năm hiện tại trừ 
-- năm sinh) , giới tính (hiển thị nam hoặc nữ) và quê quán của tất cả học sinh. 

SELECT studentId,studentName,YEAR(curdate())- YEAR(birthday) AS age,
      CASE
          WHEN gender = 1 THEN 'Nam'
          WHEN gender = 0 THEN 'Nữ'
          ELSE 'Unknown'
      END AS gender,address    
 FROM student AS s;
 
-- 4. Hiển thị thông tin bao gồm: tên học sinh, tên môn học , điểm thi của tất cả học sinh của môn Toán và sắp xếp theo điểm giảm dần

SELECT s.studentName,sub.subjectName,m.point FROM student AS s
JOIN mark AS m ON s.studentId = m.studentId
JOIN subject AS sub ON m.subjectId = sub.subjectId
WHERE sub.subjectName = 'Toán'
ORDER BY m.point DESC;

-- 5. Thống kê số lượng học sinh theo giới tính ở trong bảng (Gồm 2 cột: giới tính và số lượng). 
SELECT 
      CASE
          WHEN gender = 1 THEN 'Nam'
          WHEN gender = 0 THEN 'Nữ'
          ELSE 'Other'
      END AS gender,
      COUNT(*) AS total
FROM student
GROUP BY gender;

-- 6. Tính tổng điểm và điểm trung bình của các môn học theo từng học sinh (yêu cầu sử dụng hàm 
-- để tính toán) , bảng gồm mã học sinh, tên hoc sinh, tổng điểm và điểm trung bình.

SELECT s.studentId,s.studentName, SUM(m.point) AS total_point, AVG(m.point) AS avg_point FROM student AS s
JOIN mark AS m ON s.studentId = m.studentId
JOIN subject AS sub ON m.subjectId = sub.subjectId
GROUP BY s.studentId; 

-- B4: Tạo view, Index, Procedure
-- 1. Tạo VIEW có tên STUDENT_VIEW lấy thông tin sinh viên bao gồm : mã học sinh, tên học sinh, giới tính , quê quán .

CREATE VIEW view_students AS
SELECT studentId,studentName,
      CASE
          WHEN gender = 1 THEN 'Name' ELSE 'Nữ' END AS gender,
          address
 FROM student;
 
SELECT * FROM view_students;

-- 2. Tạo VIEW có tên AVERAGE_MARK_VIEW lấy thông tin gồm:mã học sinh, tên học sinh, điểm trung bình các môn học .

CREATE VIEW AVERAGE_MARK_VIEW AS
SELECT s.studentId,s.studentName, AVG(m.point) AS avg_point FROM student AS s
JOIN mark AS m ON s.studentId = m.studentId
GROUP BY s.studentId;

SELECT * FROM AVERAGE_MARK_VIEW;

-- 3. Đánh Index cho trường phoneNumber của bảng STUDENT.

CREATE INDEX idx_phoneNumber ON student(phoneNumber);

-- 4. Tạo các PROCEDURE sau: 
-- Tạo PROC_INSERTSTUDENT dùng để thêm mới 1 học sinh bao gồm tất cả thông tin học sinh đó.

DELIMITER //
CREATE PROCEDURE pro_insertStudent(
      IN p_studentId VARCHAR(4),
      IN p_studentName VARCHAR(100),
      IN p_birthday DATE,
      IN p_gender BIT(1),
      IN p_address TEXT,
      IN p_phoneNumber VARCHAR(45)
)
BEGIN
     INSERT INTO student(studentId, studentName, birthday, gender, address, phoneNumber) 
     VALUE(p_studentId,p_studentName,p_birthday,p_gender,p_address,p_phoneNumber);
END //
DELIMITER ; 

CALL pro_insertStudent('S011', 'Nguyen Van A', '2001-01-01', 1, 'Ha Noi', '0123456789');

SELECT * FROM student;

--  Tạo PROC_UPDATESUBJECT dùng để cập nhật tên môn học theo mã môn học.

DELIMITER //
CREATE PROCEDURE PROC_UPDATESUBJECT(
      IN p_subjectId VARCHAR(4),
      IN p_subjectName VARCHAR(45)
)
BEGIN
      UPDATE subject
      SET subjectName = p_subjectName 
      WHERE subjectId = p_subjectId;
END //
DELIMITER ; 

CALL PROC_UPDATESUBJECT('MH05', 'Ngoại Ngữ');  
SELECT * FROM subject;

-- Tạo PROC_DELETEMARK dùng để xoá toàn bộ điểm các môn học theo mã học sinh 

DELIMITER //
CREATE PROCEDURE PROC_DELETEMARK(
      IN p_studentId VARCHAR(4)
)
BEGIN
     DELETE FROM mark
     WHERE studentId = p_studentId;
END //
DELIMITER ;

CALL PROC_DELETEMARK('S009'); 
SELECT * FROM mark;