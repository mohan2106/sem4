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

CALL count_credits();



