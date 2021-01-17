DROP DATABASE IF EXISTS 180101042_26may2020;
CREATE DATABASE IF NOT EXISTS 180101042_26may2020;
USE 180101042_26may2020;

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



