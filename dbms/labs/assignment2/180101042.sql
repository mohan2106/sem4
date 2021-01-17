DROP DATABASE IF EXISTS 180101042_19may2020;
CREATE DATABASE IF NOT EXISTS 180101042_19may2020;
USE 180101042_19may2020;

DROP TABLE IF EXISTS cc;
CREATE TABLE IF NOT EXISTS cc(
    cid varchar(10) PRIMARY KEY,
    credit int(1) NOT NULL
);

drop table if EXISTS ett;
CREATE TABLE IF NOT EXISTS ett(
    cid varchar(10) NOT NULL,
    exam_date DATE NOT NULL,
    start_time TIME,
    end_time TIME,
    FOREIGN KEY(cid) REFERENCES cc(cid) ON DELETE CASCADE
    ON UPDATE CASCADE
);

drop table if EXISTS cwsl;
CREATE TABLE IF NOT EXISTS cwsl(
    roll varchar(12) NOT NULL,
    cid varchar(10) NOT NULL,
    name varchar(100) NOT NULL,
    email varchar(100) NOT NULL,
    FOREIGN KEY(cid) REFERENCES cc(cid) ON DELETE CASCADE 
    ON UPDATE CASCADE
);

-- load data from course credit file into cc table
LOAD DATA LOCAL INFILE './course-credits.csv'
INTO TABLE cc
FIELDS TERMINATED BY ','
LINES TERMINATED BY '\n';

-- load data from exam time table into corresponding file
LOAD DATA LOCAL INFILE './exam-time-table.csv'
INTO TABLE ett
FIELDS TERMINATED BY ','
LINES TERMINATED BY '\n';

-- for inserting data into cwsl I am using c++ code.
-- source load-from_csv.sql;
LOAD DATA LOCAL INFILE './load_data.csv'
INTO TABLE cwsl
FIELDS TERMINATED BY ','
LINES TERMINATED BY '\n';

DELIMITER $$
DROP PROCEDURE IF EXISTS tt_voilation;
CREATE PROCEDURE tt_voilation()
BEGIN
    DECLARE finished int DEFAULT 0;
    DECLARE num int DEFAULT 0;
    DECLARE t_roll VARCHAR(12);
    DECLARE t_name VARCHAR(100);
    DECLARE cid_1 VARCHAR(10);
    DECLARE cid_2 VARCHAR(10);
    DECLARE cur CURSOR FOR 
    SELECT DISTINCT T1.roll, T1.name, T1.cid,T2.cid 
    FROM (SELECT C1.roll, C1.name, C1.cid , C2.exam_date,C2.start_time,C2.end_time
        FROM cwsl as C1 JOIN ett as C2 
        ON C1.cid = C2.cid) AS T1
        JOIN 
        (SELECT C1.roll, C1.name, C1.cid , C2.exam_date,C2.start_time,C2.end_time
        FROM cwsl as C1 JOIN ett as C2 
        ON C1.cid = C2.cid) AS T2
        ON T1.roll = T2.roll
        WHERE T1.exam_date=T2.exam_date and T1.start_time=T2.start_time 
        and T1.end_time=T2.end_time and T1.cid <> T2.cid;
    DECLARE CONTINUE HANDLER FOR NOT FOUND SET finished = 1;
    CREATE TABLE temp(roll VARCHAR(12),name VARCHAR(100),
                    fcid VARCHAR(10),scid VARCHAR(10));
    OPEN cur;
    LOOP1: LOOP
        FETCH cur into t_roll,t_name,cid_1,cid_2;
        IF finished=1 THEN
        LEAVE LOOP1;
        END IF;
        SET num = (SELECT count(*) FROM temp WHERE roll=t_roll and
        name=t_name and fcid=cid_2 and scid=cid1);
        IF num = 0 THEN
            INSERT INTO temp VALUES (t_roll,t_name,cid_1,cid_2);
        END IF;
        SET num=0;
    end loop loop1;
    close cur;
    SELECT * from temp;
END;
$$
DELIMITER ;



DELIMITER $$
DROP PROCEDURE IF EXISTS count_credits $$
CREATE PROCEDURE count_credits()
BEGIN
    DECLARE l_roll VARCHAR(12);
    DECLARE l_name VARCHAR(100);
    DECLARE l_credit INT DEFAULT 0;
    DECLARE finished INT DEFAULT 0;
    DECLARE cur CURSOR FOR 
    SELECT roll, name, sum(credit)
    FROM cwsl join cc
    WHERE cwsl.cid = cc.cid
    GROUP BY roll,name
    HAVING SUM(credit)>40;
    DECLARE CONTINUE HANDLER FOR NOT FOUND SET finished=1;
    CREATE TABLE temp2(roll varchar(12),name varchar(100),credit int);
    OPEN cur;
    LOOP1: LOOP
    FETCH cur INTO l_roll,l_name,l_credit;
    IF finished=1 THEN
        LEAVE LOOP1;
    END IF;
    -- SELECT l_roll,l_name,l_credit;
    INSERT INTO temp2 VALUES(l_roll,l_name,l_credit);
    END LOOP LOOP1;
    close cur;
    SELECT * FROM temp2;
END;
$$
DELIMITER ;

CALL tt_voilation();
-- CALL count_credits();
-- SELECT * from cc;


