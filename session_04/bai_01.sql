CREATE DATABASE ss04_ex01;
USE ss04_ex01;

CREATE TABLE class(
classId INT AUTO_INCREMENT PRIMARY KEY,
className VARCHAR(100) NOT NULL,
startDate VARCHAR(255) NOT NULL,
status BIT(1)
);

INSERT INTO class(className,startDate,status) VALUES
('HN_JV231103','2023-11-03',1),
('HN_JV231229','2023-12-29',1),
('HN_JV230615','2023-06-15',1);

CREATE TABLE student(
studentId INT AUTO_INCREMENT PRIMARY KEY,
studentName VARCHAR(100) NOT NULL,
address VARCHAR(255) NOT NULL,
phone VARCHAR(11) NOT NULL,
class_id INT NOT NULL,
status BIT(1),
FOREIGN KEY(class_id) REFERENCES class(classId)
);

INSERT INTO student(studentName,address,phone,class_id,status) VALUES
('Hồ Da Hùng','Hà Nội','0987654321',1,1),
('Phan Văn Giang','Đà Nẵng','0967811255',1,1),
('Dương Mỹ Huyền','Hà Nội','0385546611',2,1),
('Hoàng Minh Hiếu','Nghệ An','0964425633',2,1),
('Nguyễn Vịnh','Hà Nội','0975123552',3,1),
('Nam Cao','Hà Tĩnh','0919191919',1,1),
('Nguyễn Du','Nghệ An','0353535353',3,1);

CREATE TABLE subject(
subjectId INT AUTO_INCREMENT PRIMARY KEY,
subjectName VARCHAR(100) NOT NULL,
credit INT NOT NULL CHECK(credit > 0),
status BIT(1)
);

INSERT INTO subject(subjectName,credit,status) VALUES
('Toán',3,1),
('Văn',3,1),
('Anh',2,1);

CREATE TABLE mark(
markId INT AUTO_INCREMENT PRIMARY KEY,
student_id INT NOT NULL,
subject_id INT NOT NULL,
mark DOUBLE NOT NULL CHECK(mark >= 0),
examTime DATETIME NOT NULL,
FOREIGN KEY(student_id) REFERENCES student(studentId),
FOREIGN KEY(subject_id) REFERENCES subject(subjectId)
);

INSERT INTO mark(student_id,subject_id,mark,examTime) VALUES
(1,1,7,'2024-05-12'),
(1,1,7,'2024-03-15'),
(2,2,8,'2024-05-15'),
(2,3,9,'2024-03-08'),
(3,3,9,'2024-02-11');

-- Hiển thị số lượng sinh viên theo từng địa chỉ nơi ở.

SELECT s.address,COUNT(*) AS total FROM student s
GROUP BY s.address;

-- Hiển thị các thông tin môn học có điểm thi lớn nhất.

SELECT sub.*,MAX(m.mark) as max_mark FROM subject sub
JOIN mark m ON sub.subjectId = subject_id
GROUP BY sub.subjectId,sub.subjectName,sub.credit,sub.status
ORDER BY max_mark DESC;

-- Tính điểm trung bình các môn học của từng học sinh

SELECT s.studentId,s.studentName,AVG(mark.mark) as dtb FROM student s
JOIN mark ON s.studentId = mark.student_id
JOIN subject sub ON mark.subject_id= sub.subjectid
GROUP BY s.studentId,s.studentName
ORDER BY dtb;

-- Hiển thị những bạn học viên có điểm trung bình các môn học nhỏ hơn bằng 7

SELECT s.studentId,s.studentName,AVG(mark.mark) as dtb FROM student s
JOIN mark ON s.studentId = mark.student_id
JOIN subject sub ON mark.subject_id = sub.subjectid
GROUP BY s.studentId,s.studentName
HAVING dtb <= 7
ORDER BY dtb;

-- Hiển thị thông tin học viên có điểm trung bình các môn lớn nhất.

SELECT s.*,avgMark.dtb FROM student s
JOIN(
  SELECT student_id,AVG(mark.mark) as dtb
  FROM mark
  GROUP BY student_id
) avgMark ON s.studentid = avgMark.student_id 
WHERE avgMark.dtb = (
  SELECT MAX(dtb) 
  FROM(
  SELECT AVG(mark) AS dtb
  FROM mark
  GROUP BY student_id
  ) AS subquery
);

-- Hiển thị các thông tin sinh viên và điểm trung bình của mỗi sinh viên, xếp hạng theo thứ tự điểm giảm dần

SELECT s.*,AVG(mark.mark) dtb FROM student s
JOIN mark ON s.studentid = mark.student_id
GROUP BY s.studentid,s.studentName,s.address
ORDER BY dtb DESC;