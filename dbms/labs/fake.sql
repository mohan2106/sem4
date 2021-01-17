drop DATABASE lab8;
CREATE DATABASE lab8;
USE lab8;


CREATE TABLE cources (
    course_id VARCHAR(12) NOT NULL PRIMARY KEY,
    course_name VARCHAR(255) NOT NULL
);


CREATE TABLE students (
    student_name VARCHAR(255),
    roll_no INT(12),
    PRIMARY KEY (roll_no)
);


CREATE TABLE register (
    roll_no INT(12),
    course_id VARCHAR(12),
    PRIMARY KEY (roll_no , course_id),
    FOREIGN KEY(roll_no) REFERENCES students(roll_no) ON DELETE CASCADE ON UPDATE CASCADE,
    FOREIGN KEY(course_id) REFERENCES cources(course_id) ON DELETE CASCADE ON UPDATE CASCADE
);


DELIMITER $$
CREATE TRIGGER student_add 
AFTER INSERT
ON students
FOR EACH ROW
BEGIN
    DECLARE c_id VARCHAR(12) DEFAULT "NULL";
    DECLARE finished INTEGER DEFAULT 0;
    DECLARE course_cur CURSOR FOR 
    SELECT course_id FROM cources;
    DECLARE CONTINUE HANDLER FOR NOT FOUND SET finished = 1;
    OPEN course_cur;
    get_loop: LOOP
    FETCH course_cur INTO c_id;
    IF finished = 1
    THEN
    LEAVE get_loop;
    END IF;
    INSERT INTO register VALUES(NEW.roll_no,c_id);
    END LOOP get_loop;
    CLOSE course_cur;
END;
$$
DELIMITER ;


DELIMITER $$
CREATE TRIGGER limit_student_table
AFTER INSERT
ON register
FOR EACH ROW
BEGIN
    DECLARE total INT DEFAULT 0;
    SET total =  (SELECT COUNT(roll_no) from register WHERE course_id='CS245');
    IF total > 200 THEN
        DELETE FROM register WHERE roll_no = NEW.roll_no and course_id = NEW.course_id;
    END IF;
END;
$$
DELIMITER ;

drop trigger trigger3;

delimiter $$
create trigger trigger3 
after insert on cources
for each row
begin
	declare t_roll INT(10); 
	declare last_d INT default 0;
	declare e_sem INT default 0;
	declare finished INT default 0;
	declare cur_s cursor for
	select roll_no from students
	where (mod(roll_no,2)=0);
	declare continue handler for not found set finished=1;
	set last_d=cast((select right(new.course_id,1)) as unsigned);
	set e_sem= cast((select substring(new.course_id,3,1)) as unsigned); 
	if (t_cid='HS%' and mod(last_d,2)=1 and mod(e_sem,2)=0)
	then 
		open cur_s;
		getroll: loop
			fetch cur_s into t_roll;
			if finished=1
			then 
				leave getroll;
			end if;
 			insert into register values (t_roll,new.course_id);
		end loop getroll;
		close cur_s;
	end if;
end $$
delimiter ;


drop trigger trigger2;
DELIMITER $$
CREATE TRIGGER trigger2
AFTER INSERT
ON cources
FOR EACH ROW
BEGIN
    DECLARE course_id VARCHAR(12);
    DECLARE student_roll VARCHAR(12);
    DECLARE last_digit INT(2) DEFAULT 0;
    DECLARE finished INTEGER DEFAULT 0;
    DECLARE even_sem INT DEFAULT 0;
    declare even_stud int DEFAULT 0;
    DECLARE student_cur CURSOR FOR 
    SELECT roll_no from students;
    DECLARE CONTINUE HANDLER FOR NOT FOUND SET finished = 1;
    set course_id = NEW.course_id;
    set last_digit = cast((SELECT RIGHT(NEW.course_id,1)) as unsigned);
    if (NEW.course_id like 'HS%')
    THEN
        set even_sem = CAST((SELECT SUBSTRING(NEW.course_id,3,1)) AS unsigned);
        OPEN student_cur;
        get_loop: LOOP
        FETCH student_cur INTO student_roll;
        set even_stud = cast((SELECT RIGHT(student_roll,1)) as unsigned);
        IF finished = 1
        THEN
        LEAVE get_loop;
        END IF;
        IF ((MOD(even_sem,2)=1) AND (MOD(even_stud,2)=1) AND (MOD(last_digit,2)=0)) 
        THEN
        INSERT INTO register VALUES (student_roll,NEW.course_id);
        END IF;
        END LOOP get_loop;
        CLOSE  student_cur;
    end if;
END;
$$
DELIMITER ;
