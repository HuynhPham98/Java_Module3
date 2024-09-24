CREATE DATABASE ss05_ex03;
USE ss05_ex03;

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

-- Tạo store procedure lấy ra tất cả lớp học có số lượng học sinh lớn hơn 5

DELIMITER //
CREATE PROCEDURE view_class()
BEGIN
     SELECT c.*,COUNT(s.studentId) AS total_student FROM class AS c
     JOIN student AS s ON c.classId = s.class_id
     GROUP BY c.classId
     HAVING total_student > 5
     ORDER BY total_student ASC;
END //
DELIMITER ;    

CALL view_class();

-- Tạo store procedure hiển thị ra danh sách môn học có điểm thi là 10

DELIMITER //
CREATE PROCEDURE view_subject()
BEGIN
     select sub.*,m.mark from subject as sub 
     join mark as m on sub.subjectId = m.subject_id
     where m.mark = 10;
end //
delimiter ;

call view_subject();
DROP PROCEDURE IF EXISTS view_subject;    

-- Tạo store procedure hiển thị thông tin các lớp học có học sinh đạt điểm 10

DELIMITER //
CREATE PROCEDURE view_class1()
begin
     select c.*,m.mark from class as c
     join student as s on c.classId = s.class_id
     join mark as m on s.studentId = m.student_id
     where m.mark = 10;
end //
DELIMITER ;

call view_class1();

-- Tạo store procedure thêm mới student và trả ra id vừa mới thêm

delimiter //
create procedure show_student_id(
       new_studentName VARCHAR(100),
       new_address VARCHAR(255),
       new_phone VARCHAR(11),
       class_id INT,
       out new_id INT
)
begin
     insert into student(studentName,address,phone,class_id) 
     value (new_studentName,new_address,new_phone,class_id);
     
     set new_id = LAST_INSERT_ID();
end //
delimiter ;

call show_student_id('Dương Mỹ Huyền','Hà Nội','0385546611',2,@new_id);
select @new_id as studentId;   

-- Tạo store procedure hiển thị subject chưa được ai thi

delimiter //
create procedure show_subject()
begin 
     select sub.* from subject as sub
     left join mark as m on sub.subjectId = m.subject_id
     where m.subject_id is null;
end //
delimiter ;

call show_subject();     