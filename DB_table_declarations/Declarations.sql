USE db2

CREATE TABLE Course(
  COURSEID varchar(15) PRIMARY KEY,
  DEPARTMENT varchar(15),
  UNITMIN int NOT NULL,
  UNITMAX int NOT NULL,
  GRADETYPE varchar(10) NOT NULL,
  PREREQS varchar(10) NOT NULL,
  LABREQ varchar(10) NOT NULL,
  CONSENTREQ varchar(10) NOT NULL,
  CATEGORY varchar(10) NULL
);

CREATE TABLE Class(
  CLASSID varchar(15) REFERENCES Course(COURSEID) ON UPDATE CASCADE ON DELETE CASCADE,
  NAME varchar(50) NOT NULL,
  QUARTER varchar(15) NULL,
  YEAR int NULL
);

CREATE TABLE Faculty(
  FACULTYID varchar(50) UNIQUE NOT NULL,
  NAME varchar(50) PRIMARY KEY,
  TITLE varchar(50) NULL,
  DEPARTMENT varchar(50) NOT NULL,
);

CREATE TABLE ClassesTaught(
  NAME varchar(50) NOT NULL,
  COURSEID varchar(15) NOT NULL,
  SECTIONID varchar(15) NOT NULL,
  QUARTER varchar(10) NOT NULL,
  YEAR int NOT NULL,
  FOREIGN KEY(NAME) REFERENCES Faculty (NAME),
  FOREIGN KEY(COURSEID) REFERENCES Course (COURSEID),
  FOREIGN KEY(SECTIONID) REFERENCES Section (SECTIONID),
);

CREATE TABLE Degree(
  DEGREEID varchar(15) PRIMARY KEY,
  DEPARTMENT varchar(20) NOT NULL,
  LEVEL varchar(10) NOT NULL,
  TYPE varchar(5) NOT NULL,
  TOTALUNITS int NOT NULL,
  AVGGRADEREQ varchar(5) NULL,
  CONCENTRATION varchar(5) NULL,
  NAME varchar(10) NULL
);

CREATE TABLE Enrolled(
  STUDENTID varchar(15) NOT NULL,
  COURSEID varchar(15) NOT NULL,
  SECTIONID varchar(50) NULL,
  UNITS int NULL,
  GRADETYPE varchar(50) NOT NULL,
  QUARTER varchar(10) NULL,
  YEAR int NULL,
  FOREIGN KEY(COURSEID) REFERENCES Course (COURSEID) ON UPDATE CASCADE ON DELETE CASCADE,
  FOREIGN KEY(STUDENTID) REFERENCES Student (STUDENTID) ON DELETE CASCADE
);

CREATE TABLE PastClasses(
  STUDENTID varchar(15) NOT NULL,
  COURSEID varchar(15) NOT NULL,
  SECTIONID varchar(15) NOT NULL,
  QUARTER varchar(10) NOT NULL,
  YEAR int NOT NULL,
  GRADE varchar(5) NOT NULL,
  GRADETYPE varchar(10) NULL,
  FOREIGN KEY(COURSEID) REFERENCES Course (COURSEID) ON UPDATE CASCADE ON DELETE CASCADE,
  FOREIGN KEY(SECTIONID) REFERENCES Section (SECTIONID) ON UPDATE CASCADE ON DELETE CASCADE,
  FOREIGN KEY(STUDENTID) REFERENCES Student (STUDENTID) ON DELETE CASCADE
);

CREATE TABLE Probation(
  STUDENTID varchar(15) NOT NULL,
  REASON varchar(250) NOT NULL,
  START varchar(10) NOT NULL,
  [END] varchar(10) NOT NULL,
  FOREIGN KEY(STUDENTID) REFERENCES Student (STUDENTID)
);

CREATE TABLE ReviewSession(
  SECTIONID varchar(15) NOT NULL,
  DATE date NULL,
  TIME time(7) NULL,
  BUILDING varchar(15) NULL,
  ROOMNO int NULL,
  FOREIGN KEY(SECTIONID) REFERENCES Section (SECTIONID)
);

CREATE TABLE Section(
  CLASSID varchar(15) NOT NULL,
  SECTIONID varchar(15) PRIMARY KEY,
  INSTRUCTOR varchar(50) NOT NULL,
  ENROLL_LIMIT int NOT NULL,
  FOREIGN KEY(CLASSID) REFERENCES Course (COURSEID) ON UPDATE CASCADE ON DELETE CASCADE,
  FOREIGN KEY(INSTRUCTOR) REFERENCES Faculty (NAME)
);

CREATE TABLE ThesisCommittee(
  STUDENTID varchar(15) NOT NULL,
  DEPARTMENT varchar(20) NOT NULL,
  ADVISOR1 varchar(50) NOT NULL,
  ADVISOR2 varchar(50) NOT NULL,
  ADVISOR3 varchar(50) NOT NULL,
  ADVISOR4 varchar(50) NULL,
  FOREIGN KEY(ADVISOR1) REFERENCES Faculty (NAME),
  FOREIGN KEY(ADVISOR2) REFERENCES Faculty (NAME),
  FOREIGN KEY(ADVISOR3) REFERENCES Faculty (NAME),
  FOREIGN KEY(STUDENTID) REFERENCES Student (STUDENTID)
);

CREATE TABLE WeeklyMeeting(
  SECTIONID varchar(15) NOT NULL,
  TYPE varchar(15) NOT NULL,
  DAY varchar(10) NOT NULL,
  TIME time(7) NOT NULL,
  BUILDING varchar(15) NOT NULL,
  ROOMNO int NOT NULL,
  FOREIGN KEY(SECTIONID) REFERENCES Section (SECTIONID) ON DELETE CASCADE ON UPDATE CASCADE
);

CREATE TABLE Student(SSN integer NOT NULL UNIQUE, STUDENTID varchar(15) PRIMARY KEY, FIRSTNAME varchar(25) NOT NULL, MIDDLENAME varchar(25), LASTNAME varchar(25) NOT NULL, RESIDENCY varchar(20) NOT NULL, STUDENTTYPE varchar(15) NOT NULL, ENROLLED varchar(15), STARTDATE varchar(15), ENDDATE varchar(15)); 

CREATE TABLE Undergrad(STUDENTID varchar(15) FOREIGN KEY REFERENCES Student (STUDENTID) ON DELETE CASCADE ON UPDATE CASCADE, MAJOR varchar(15), MINOR varchar(15), COLLEGE varchar(15), YEAR varchar(15));

CREATE TABLE GraduateMS(STUDENTID varchar(15) FOREIGN KEY REFERENCES Student (STUDENTID) ON DELETE CASCADE ON UPDATE CASCADE, UNITS integer, DEPARTMENT varchar(20));

CREATE TABLE Phd(STUDENTID varchar(15) FOREIGN KEY REFERENCES Student (STUDENTID) ON DELETE CASCADE ON UPDATE CASCADE, UNITS integer, CANDIDACY varchar(20));

CREATE TABLE PrevDegrees(STUDENTID varchar(15) REFERENCES Student (STUDENTID) ON DELETE CASCADE ON UPDATE CASCADE, TYPE varchar(15), TITLE varchar(15), COLLEGE varchar(30), DEGREEID integer PRIMARY KEY);

CREATE TABLE Prereq(REQID varchar(15) PRIMARY KEY, COURSEID varchar(15) REFERENCES Course (COURSEID) ON DELETE CASCADE ON UPDATE CASCADE, PREREQID varchar(15));

-- added for milestone 3
CREATE TABLE CourseDegreeReq(COURSEID varchar(15) REFERENCES Course(COURSEID) ON DELETE CASCADE ON UPDATE CASCADE, DEGREEID varchar(15) REFERENCES Degree(DEGREEID) ON DELETE CASCADE ON UPDATE CASCADE;
CREATE TABLE Category(NAME varchar(25), DEGREEID REFERENCES Degree(DEGREEID) ON DELETE CASCADE ON UPDATE CASCADE, UNITS int);
CREATE TABLE CategoryCourseReq(CATEGORY varchar(25), COURSEID varchar(15) REFERENCES Course(COURSEID) ON DELETE CASCADE ON UPDATE CASCADE);
CREATE TABLE ConcCourseReq(CONCNAME varchar(15), COURSEID varchar(15) REFERENCES Course(COURSEID) ON DELETE CASCADE ON UPDATE CASCADE);
CREATE TABLE Concentrations(NAME varchar(15), DEGREEID varchar(15) REFERENCES Degree(DEGREEID) ON DELETE CASCADE ON UPDATE CASCADE, MINGPA float, MINUNITS int);
CREATE TABLE FutureClasses(COURSEID varchar(15) REFERENCES Course(COURSEID) ON DELETE CASCADE ON UPDATE CASCADE, NAME varchar(50), QUARTER varchar(15), YEAR int);
CREATE TABLE Times(STARTTIME time(7), ENDTIME time(7));

-- added for milestone 4/5
CREATE TABLE CurrentlyTeaching(FACULTYNAME varchar(50) REFERENCES Faculty(NAME), SECTIONID varchar(15) REFERENCES Section(SECTIONID));
CREATE TABLE lettergrades(grade char(6), signedgrade char(2));
create table waitlisted (studentid varchar(15) references student(studentid), courseid varchar(15) references course(courseid), sectionid varchar(15) references section(sectionid), units int, gradetype varchar(10));

CREATE TABLE Calendar(
  [DATE]       DATE PRIMARY KEY, 
  [DAY]        AS DATEPART(DAY,      [date]),
  [MONTH]      AS DATEPART(MONTH,    [date]),
  [MONTHNAME]  AS DATENAME(MONTH,    [date]),
  [WEEKDAY]  AS DATEPART(WEEKDAY,  [date]),
  WEEKDAYNAME varchar(7) NULL
);

create table GRADE_CONVERSION
( LETTER_GRADE CHAR(2) NOT NULL,
NUMBER_GRADE DECIMAL(2,1)
);

-- Begin insert statements

insert into grade_conversion values('A+', 4.0);
insert into grade_conversion values('A', 4.0);
insert into grade_conversion values('A-', 3.7);
insert into grade_conversion values('B+', 3.3);
insert into grade_conversion values('B', 3.0);
insert into grade_conversion values('B-', 2.7);
insert into grade_conversion values('C+', 2.3);
insert into grade_conversion values('C', 2.0);
insert into grade_conversion values('C-', 1.7);
insert into grade_conversion values('D', 1.0);
insert into grade_conversion values('F', 0.0);

insert into lettergrades values ('A', 'A-'),('A', 'A'),('A', 'A+'),
  ('B', 'B-'),('B', 'B'),('B', 'B+'),
  ('C', 'C-'),('C', 'C'),('C', 'C+'),
  ('D', 'D-'),('D', 'D'),('D', 'D+'),
  ('other', 'F'),('other', 'P'),('other', 'NP'),
  ('other', 'S'),('other', 'U');

insert into Times values ('8:00 AM', '9:00 AM', NULL);
insert into Times values ('9:00 AM', '10:00 AM', NULL);
insert into Times values ('10:00 AM', '11:00 AM', NULL);
insert into Times values ('11:00 AM', '12:00 AM', NULL);
insert into Times values ('12:00 AM', '1:00 PM', NULL);
insert into Times values ('1:00 PM', '2:00 PM', NULL);
insert into Times values ('2:00 PM', '3:00 PM', NULL);
insert into Times values ('3:00 PM', '4:00 PM', NULL);
insert into Times values ('4:00 PM', '5:00 PM', NULL);
insert into Times values ('5:00 PM', '6:00 PM', NULL);
insert into Times values ('6:00 PM', '7:00 PM', NULL);
insert into Times values ('7:00 PM', '8:00 PM', NULL);
insert into Times values ('8:00 PM', '9:00 PM', NULL);


-- insert into the master fuckin calendar table
insert into Calendar values ('1/1/2016', NULL), ('1/2/2016', NULL), ('1/3/2016', NULL), ('1/4/2016', NULL),
('1/5/2016', NULL), ('1/6/2016', NULL), ('1/7/2016', NULL), ('1/8/2016', NULL), ('1/9/2016', NULL),
('1/10/2016', NULL), ('1/11/2016', NULL), ('1/12/2016', NULL), ('1/13/2016', NULL), ('1/14/2016', NULL), 
('1/15/2016', NULL), ('1/16/2016', NULL), ('1/17/2016', NULL), ('1/18/2016', NULL), ('1/19/2016', NULL), 
('1/20/2016', NULL), ('1/21/2016', NULL), ('1/22/2016', NULL), ('1/23/2016', NULL), ('1/24/2016', NULL), 
('1/25/2016', NULL), ('1/26/2016', NULL), ('1/27/2016', NULL), ('1/28/2016', NULL), ('1/29/2016', NULL), 
('1/30/2016', NULL), ('1/31/2016', NULL),
('2/1/2016', NULL), ('2/2/2016', NULL), ('2/3/2016', NULL), ('2/4/2016', NULL),
('2/5/2016', NULL), ('2/6/2016', NULL), ('2/7/2016', NULL), ('2/8/2016', NULL), ('2/9/2016', NULL),
('2/10/2016', NULL), ('2/11/2016', NULL), ('2/12/2016', NULL), ('2/13/2016', NULL), ('2/14/2016', NULL), 
('2/15/2016', NULL), ('2/16/2016', NULL), ('2/17/2016', NULL), ('2/18/2016', NULL), ('2/19/2016', NULL), 
('2/20/2016', NULL), ('2/21/2016', NULL), ('2/22/2016', NULL), ('2/23/2016', NULL), ('2/24/2016', NULL), 
('2/25/2016', NULL), ('2/26/2016', NULL), ('2/27/2016', NULL), ('2/28/2016', NULL), ('2/29/2016', NULL), 
('3/1/2016', NULL), ('3/2/2016', NULL), ('3/3/2016', NULL), ('3/4/2016', NULL),
('3/5/2016', NULL), ('3/6/2016', NULL), ('3/7/2016', NULL), ('3/8/2016', NULL), ('3/9/2016', NULL),
('3/10/2016', NULL), ('3/11/2016', NULL), ('3/12/2016', NULL), ('3/13/2016', NULL), ('3/14/2016', NULL), 
('3/15/2016', NULL), ('3/16/2016', NULL), ('3/17/2016', NULL), ('3/18/2016', NULL), ('3/19/2016', NULL), 
('3/20/2016', NULL), ('3/21/2016', NULL), ('3/22/2016', NULL), ('3/23/2016', NULL), ('3/24/2016', NULL), 
('3/25/2016', NULL), ('3/26/2016', NULL), ('3/27/2016', NULL), ('3/28/2016', NULL), ('3/29/2016', NULL), 
('3/30/2016', NULL), ('3/31/2016', NULL),
('4/1/2016', NULL), ('4/2/2016', NULL), ('4/3/2016', NULL), ('4/4/2016', NULL),
('4/5/2016', NULL), ('4/6/2016', NULL), ('4/7/2016', NULL), ('4/8/2016', NULL), ('4/9/2016', NULL),
('4/10/2016', NULL), ('4/11/2016', NULL), ('4/12/2016', NULL), ('4/13/2016', NULL), ('4/14/2016', NULL), 
('4/15/2016', NULL), ('4/16/2016', NULL), ('4/17/2016', NULL), ('4/18/2016', NULL), ('4/19/2016', NULL), 
('4/20/2016', NULL), ('4/21/2016', NULL), ('4/22/2016', NULL), ('4/23/2016', NULL), ('4/24/2016', NULL), 
('4/25/2016', NULL), ('4/26/2016', NULL), ('4/27/2016', NULL), ('4/28/2016', NULL), ('4/29/2016', NULL), 
('4/30/2016', NULL), 
('5/1/2016', NULL), ('5/2/2016', NULL), ('5/3/2016', NULL), ('5/4/2016', NULL),
('5/5/2016', NULL), ('5/6/2016', NULL), ('5/7/2016', NULL), ('5/8/2016', NULL), ('5/9/2016', NULL),
('5/10/2016', NULL), ('5/11/2016', NULL), ('5/12/2016', NULL), ('5/13/2016', NULL), ('5/14/2016', NULL), 
('5/15/2016', NULL), ('5/16/2016', NULL), ('5/17/2016', NULL), ('5/18/2016', NULL), ('5/19/2016', NULL), 
('5/20/2016', NULL), ('5/21/2016', NULL), ('5/22/2016', NULL), ('5/23/2016', NULL), ('5/24/2016', NULL), 
('5/25/2016', NULL), ('5/26/2016', NULL), ('5/27/2016', NULL), ('5/28/2016', NULL), ('5/29/2016', NULL), 
('5/30/2016', NULL), ('5/31/2016', NULL),
('6/1/2016', NULL), ('6/2/2016', NULL), ('6/3/2016', NULL), ('6/4/2016', NULL),
('6/5/2016', NULL), ('6/6/2016', NULL), ('6/7/2016', NULL), ('6/8/2016', NULL), ('6/9/2016', NULL),
('6/10/2016', NULL), ('6/11/2016', NULL), ('6/12/2016', NULL), ('6/13/2016', NULL), ('6/14/2016', NULL), 
('6/15/2016', NULL), ('6/16/2016', NULL), ('6/17/2016', NULL), ('6/18/2016', NULL), ('6/19/2016', NULL), 
('6/20/2016', NULL), ('6/21/2016', NULL), ('6/22/2016', NULL), ('6/23/2016', NULL), ('6/24/2016', NULL), 
('6/25/2016', NULL), ('6/26/2016', NULL), ('6/27/2016', NULL), ('6/28/2016', NULL), ('6/29/2016', NULL), 
('6/30/2016', NULL);

update Calendar SET WEEKDAYNAME = 'SUN' WHERE [WEEKDAY] = 1;
update Calendar SET WEEKDAYNAME = 'M' WHERE [WEEKDAY] = 2;
update Calendar SET WEEKDAYNAME = 'TU' WHERE [WEEKDAY] = 3;
update Calendar SET WEEKDAYNAME = 'W' WHERE [WEEKDAY] = 4;
update Calendar SET WEEKDAYNAME = 'TH' WHERE [WEEKDAY] = 5;
update Calendar SET WEEKDAYNAME = 'F' WHERE [WEEKDAY] = 6;
update Calendar SET WEEKDAYNAME = 'SAT' WHERE [WEEKDAY] = 7;

-- Data given for Milestone 3
  -- ssn, studentid, first, middle, last, residency, studenttype, enrolled, startdate, enddate
insert into Student values ('1', 'A1', 'Benjamin', NULL, 'B', 'CA', 'Undergrad', 'Yes', 'fall 2012', 'present');
insert into Student values ('2', 'A2', 'Kristen', NULL, 'W', 'CA', 'Undergrad', 'Yes', 'fall 2012', 'present');
insert into Student values ('3', 'A3', 'Daniel', NULL, 'F', 'CA', 'Undergrad', 'Yes', 'fall 2012', 'present');
insert into Student values ('4', 'A4', 'Claire', NULL, 'J', 'CA', 'Undergrad', 'Yes', 'fall 2012', 'present');
insert into Student values ('5', 'A5', 'Julie', NULL, 'C', 'CA', 'Undergrad', 'Yes', 'fall 2012', 'present');
insert into Student values ('6', 'A6', 'Kevin', NULL, 'L', 'CA', 'Undergrad', 'Yes', 'fall 2012', 'present');
insert into Student values ('7', 'A7', 'Michael', NULL, 'B', 'CA', 'Undergrad', 'Yes', 'fall 2012', 'present');
insert into Student values ('8', 'A8', 'Joseph', NULL, 'J', 'CA', 'Undergrad', 'Yes', 'fall 2012', 'present');
insert into Student values ('9', 'A9', 'Devin', NULL, 'P', 'CA', 'Undergrad', 'Yes', 'fall 2012', 'present');
insert into Student values ('10', 'A10', 'Logan', NULL, 'F', 'CA', 'Undergrad', 'Yes', 'fall 2012', 'present');
insert into Student values ('11', 'A11', 'Vikram', NULL, 'N', 'CA', 'Undergrad', 'Yes', 'fall 2012', 'present');
insert into Student values ('12', 'A12', 'Rachel', NULL, 'Z', 'CA', 'Undergrad', 'Yes', 'fall 2012', 'present');
insert into Student values ('13', 'A13', 'Zach', NULL, 'M', 'CA', 'Undergrad', 'Yes', 'fall 2012', 'present');
insert into Student values ('14', 'A14', 'Justin', NULL, 'H', 'CA', 'Undergrad', 'Yes', 'fall 2012', 'present');
insert into Student values ('15', 'A15', 'Rahul', NULL, 'R', 'CA', 'Undergrad', 'Yes', 'fall 2012', 'present');

insert into Student values ('16', 'A16', 'Dave', NULL, 'C', 'CA', 'Grad', 'Yes', 'fall 2012', 'present');
insert into Student values ('17', 'A17', 'Nelson', NULL, 'H', 'CA', 'Grad', 'Yes', 'fall 2012', 'present');
insert into Student values ('18', 'A18', 'Andrew', NULL, 'P', 'CA', 'Grad', 'Yes', 'fall 2012', 'present');
insert into Student values ('19', 'A19', 'Nathan', NULL, 'S', 'CA', 'Grad', 'Yes', 'fall 2012', 'present');
insert into Student values ('20', 'A20', 'John', NULL, 'H', 'CA', 'Grad', 'Yes', 'fall 2012', 'present');
insert into Student values ('21', 'A21', 'Anwell', NULL, 'W', 'CA', 'Grad', 'Yes', 'fall 2012', 'present');
insert into Student values ('22', 'A22', 'Tim', NULL, 'K', 'CA', 'Grad', 'Yes', 'fall 2012', 'present');

  -- studentid, major, minor, units, college, year
insert into Undergrad values('A1', 'BS in CSE', 'none', 'WARREN', 'SENIOR');
insert into Undergrad values('A2', 'BS in CSE', 'none', 'WARREN', 'SENIOR');
insert into Undergrad values('A3', 'BS in CSE', 'none', 'MARSHALL', 'SENIOR');
insert into Undergrad values('A4', 'BS in CSE', 'none', 'WARREN', 'SENIOR');
insert into Undergrad values('A5', 'BS in CSE', 'none', 'WARREN', 'SENIOR');
insert into Undergrad values('A6', 'BS in MAE', 'none', 'ERC', 'SENIOR');
insert into Undergrad values('A7', 'BS in MAE', 'none', 'ERC', 'SENIOR');
insert into Undergrad values('A8', 'BS in MAE', 'none', 'WARREN', 'SENIOR');
insert into Undergrad values('A9', 'BS in MAE', 'none', 'REVELLE', 'SENIOR');
insert into Undergrad values('A10', 'BS in MAE', 'none', 'MUIR', 'SENIOR');
insert into Undergrad values('A11', 'BA in PHIL', 'none', 'MUIR', 'SENIOR');
insert into Undergrad values('A12', 'BA in PHIL', 'none', 'WARREN', 'SENIOR');
insert into Undergrad values('A13', 'BA in PHIL', 'none', 'SIXTH', 'SENIOR');
insert into Undergrad values('A14', 'BA in PHIL', 'none', 'MUIR', 'SENIOR');
insert into Undergrad values('A15', 'BA in PHIL', 'none', 'WARREN', 'SENIOR');

  -- id, units, department, "major"
insert into GraduateMS values('A16', 20, 'CSE', 'MS in CSE');
insert into GraduateMS values('A17', 60, 'CSE', 'MS in CSE');
insert into GraduateMS values('A18', 80, 'CSE', 'MS in CSE');
insert into GraduateMS values('A19', 100, 'CSE', 'MS in CSE');
insert into GraduateMS values('A20', 20, 'CSE', 'MS in CSE');
insert into GraduateMS values('A21', 20, 'CSE', 'MS in CSE');
insert into GraduateMS values('A22', 20, 'CSE', 'MS in CSE');

-- courses: id, department, unitmin, unitmax, gradetype, prereq, lab, consent, category
insert into Course values('CSE8A', 'CSE', 2, 4, 'BOTH', 'NO', 'NO', 'NO', 'LD');
insert into Course values('CSE105', 'CSE', 2, 4, 'BOTH', 'NO', 'NO', 'NO', 'UD');
insert into Course values('CSE123', 'CSE', 2, 4, 'BOTH', 'NO', 'NO', 'NO', 'UD');
insert into Course values('CSE250A', 'CSE', 2, 4, 'BOTH', 'NO', 'NO', 'NO', 'UD');
insert into Course values('CSE250B', 'CSE', 2, 4, 'BOTH', 'NO', 'NO', 'NO', 'UD');
insert into Course values('CSE255', 'CSE', 2, 4, 'BOTH', 'NO', 'NO', 'NO', 'UD');
insert into Course values('CSE232A', 'CSE', 2, 4, 'BOTH', 'NO', 'NO', 'NO', 'UD');
insert into Course values('CSE221', 'CSE', 2, 4, 'BOTH', 'NO', 'NO', 'NO', 'UD');
insert into Course values('MAE3', 'MAE', 2, 4, 'BOTH', 'NO', 'NO', 'NO', 'LD');
insert into Course values('MAE107', 'MAE', 2, 4, 'BOTH', 'NO', 'NO', 'NO', 'UD');
insert into Course values('MAE108', 'MAE', 2, 4, 'BOTH', 'NO', 'NO', 'NO', 'UD');
insert into Course values('PHIL10', 'PHIL', 2, 4, 'BOTH', 'NO', 'NO', 'NO', 'LD');
insert into Course values('PHIL12', 'PHIL', 2, 4, 'BOTH', 'NO', 'NO', 'NO', 'LD');
insert into Course values('PHIL165', 'PHIL', 2, 4, 'BOTH', 'NO', 'NO', 'NO', 'UD');
insert into Course values('PHIL167', 'PHIL', 2, 4, 'BOTH', 'NO', 'NO', 'NO', 'UD');

-- classes: classid, name, quarter, year
insert into Class values('CSE8A', 'Intro to Computer Science: Java', 'fall', 2014);
insert into Class values('CSE8A', 'Intro to Computer Science: Java', 'spring', 2015);
insert into Class values('CSE8A', 'Intro to Computer Science: Java', 'fall', 2015);
insert into Class values('CSE8A', 'Intro to Computer Science: Java', 'winter', 2016);
insert into Class values('CSE105', 'Intro to Theory', 'winter', 2015);
insert into Class values('CSE105', 'Intro to Theory', 'winter', 2016);
insert into Class values('CSE250A', 'Probabilistic Reasoning', 'fall', 2014);
insert into Class values('CSE250A', 'Probabilistic Reasoning', 'fall', 2015);
insert into Class values('CSE250B', 'Machine Learning', 'winter', 2015);
insert into Class values('CSE255', 'Data Mining / Predictive Analytics', 'fall', 2015);
insert into Class values('CSE255', 'Data Mining / Predictive Analytics', 'winter', 2016);
insert into Class values('CSE232A', 'Databases', 'fall', 2015);
insert into Class values('CSE221', 'Operating Systems', 'spring', 2015);
insert into Class values('CSE221', 'Operating Systems', 'winter', 2016);
insert into Class values('MAE107', 'Computational Methods', 'spring', 2015);
insert into Class values('MAE108', 'Probability and Statistics', 'fall', 2014);
insert into Class values('MAE108', 'Probability and Statistics', 'winter', 2015);
insert into Class values('MAE108', 'Probability and Statistics', 'winter', 2016);
insert into Class values('PHIL10', 'Intro to Logic', 'fall', 2015);
insert into Class values('PHIL12', 'Scientific Reasoning', 'winter', 2016);
insert into Class values('PHIL165', 'Freedom, Equality, and the Law', 'spring', 2015);
insert into Class values('PHIL165', 'Freedom, Equality, and the Law', 'fall', 2015);
insert into Class values('PHIL165', 'Freedom, Equality, and the Law', 'winter', 2016);

--future: courseid, quarter, year, fname?
insert into FutureClasses values('CSE8A', 'Intro to Computer Science: Java', 'spring', 2016);
insert into FutureClasses values('CSE105', 'Intro to Theory', 'fall', 2016);
insert into FutureClasses values('CSE250A', 'Probabilistic Reasoning', 'spring', 2016);
insert into FutureClasses values('CSE250B', 'Machine Learning', 'fall', 2016);
insert into FutureClasses values('CSE255', 'Data Mining / Predictive Analytics', 'winter', 2017);
insert into FutureClasses values('CSE232A', 'Databases', 'spring', 2016);
insert into FutureClasses values('CSE221', 'Operating Systems', 'fall', 2016);
insert into FutureClasses values('MAE107', 'Computational Methods', 'spring', 2016);
insert into FutureClasses values('MAE108', 'Probability and Statistics', 'fall', 2016);
insert into FutureClasses values('PHIL10', 'Intro to Logic', 'winter', 2017);
insert into FutureClasses values('PHIL12', 'Scientific Reasoning', 'spring', 2016);
insert into FutureClasses values('PHIL165', 'Freedom, Equality, and the Law', 'fall', 2016);

--past classes: studentid, courseid, sectionid, quarter, year, grade, units

--faculty: id, name, title, department
insert into Faculty values('1', 'Justin Bieber', 'Associate Professor', NULL);
insert into Faculty values('2', 'Flo Rida', 'Professor', NULL);
insert into Faculty values('3', 'Selena Gomez', 'Professor', NULL);
insert into Faculty values('4', 'Adele', 'Professor', NULL);
insert into Faculty values('5', 'Taylor Swift', 'Professor', NULL);
insert into Faculty values('6', 'Kelly Clarkson', 'Professor', NULL);
insert into Faculty values('7', 'Adam Levine', 'Professor', NULL);
insert into Faculty values('8', 'Bjork', 'Professor', NULL);

--degree: id, department, level, type, totalunits, avggrade(null), concentration, name
insert into Degree values('1', 'CSE', 'Undergrad', 'BS', 40, NULL, 'no', 'BS in CSE');
insert into Degree values('2', 'PHIL', 'Undergrad', 'BA', 35, NULL, 'no', 'BA in PHIL');
insert into Degree values('3', 'MAE', 'Undergrad', 'BS', 50, NULL, 'no', 'BS in MAE');
insert into Degree values('4', 'CSE', 'Grad', 'MS', 45, NULL, 'no', 'MS in CSE');

--tie courses to a degree
insert into CourseDegreeReq values('CSE8A', '1');
insert into CourseDegreeReq values('CSE105', '1');
insert into CourseDegreeReq values('CSE123', '1');
insert into CourseDegreeReq values('CSE250A', '1');
insert into CourseDegreeReq values('CSE250B', '1');
insert into CourseDegreeReq values('CSE255', '1');
insert into CourseDegreeReq values('CSE232A', '1');
insert into CourseDegreeReq values('CSE221', '1');
insert into CourseDegreeReq values('PHIL10', '2');
insert into CourseDegreeReq values('PHIL12', '2');
insert into CourseDegreeReq values('PHIL165', '2');
insert into CourseDegreeReq values('PHIL167', '2');
insert into CourseDegreeReq values('MAE3', '3');
insert into CourseDegreeReq values('MAE107', '3');
insert into CourseDegreeReq values('MAE108', '3');
insert into CourseDegreeReq values('CSE8A', '4');
insert into CourseDegreeReq values('CSE105', '4');
insert into CourseDegreeReq values('CSE123', '4');
insert into CourseDegreeReq values('CSE250A', '4');
insert into CourseDegreeReq values('CSE250B', '4');
insert into CourseDegreeReq values('CSE255', '4');
insert into CourseDegreeReq values('CSE232A', '4');
insert into CourseDegreeReq values('CSE221', '4');


--add categories for a degree
insert into Category values('LowerDiv', '1', 10);
insert into Category values('UpperDiv', '1', 15);
insert into Category values('TechElec', '1', 15);
insert into Category values('LowerDiv', '2', 15);
insert into Category values('UpperDiv', '2', 20);
insert into Category values('LowerDiv', '3', 20);
insert into Category values('UpperDiv', '3', 20);
insert into Category values('TechElec', '3', 10);
insert into Category values('Grad', '4', 45);

--tie courses to a category
insert into CategoryCourseReq values('LowerDiv', 'CSE8A');
insert into CategoryCourseReq values('UpperDiv', 'CSE105');
insert into CategoryCourseReq values('UpperDiv', 'CSE123');
insert into CategoryCourseReq values('Grad', 'CSE250A');
insert into CategoryCourseReq values('Grad', 'CSE250B');
insert into CategoryCourseReq values('Grad', 'CSE255');
insert into CategoryCourseReq values('Grad', 'CSE232A');
insert into CategoryCourseReq values('Grad', 'CSE221');
insert into CategoryCourseReq values('LowerDiv', 'MAE3');
insert into CategoryCourseReq values('UpperDiv', 'MAE107');
insert into CategoryCourseReq values('UpperDiv', 'MAE108');
insert into CategoryCourseReq values('LowerDiv', 'PHIL10');
insert into CategoryCourseReq values('LowerDiv', 'PHIL12');
insert into CategoryCourseReq values('UpperDiv', 'PHIL165');
insert into CategoryCourseReq values('UpperDiv', 'PHIL167');
insert into CategoryCourseReq values('TechElec', 'CSE250A');
insert into CategoryCourseReq values('TechElec', 'CSE221');
insert into CategoryCourseReq values('TechElec', 'CSE105');
insert into CategoryCourseReq values('TechElec', 'MAE107');
insert into CategoryCourseReq values('TechElec', 'MAE3');

--concentrations: name, degreeid, mingpa, minunits
insert into Concentrations values('Databases', '4', 3.0, 4);
insert into Concentrations values('AI', '4', 3.1, 8);
insert into Concentrations values('Systems', '4', 3.3, 4);  

--add courses to a concentration
insert into ConcCourseReq values('Databases', 'CSE232A');
insert into ConcCourseReq values('AI', 'CSE250A');
insert into ConcCourseReq values('AI', 'CSE255');
insert into ConcCourseReq values('Systems', 'CSE221');


--sections: classid, sectionid, instructor, enrolllimit
--current sections (winter 2016)
insert into Section values('MAE108', '1', 'Selena Gomez', 2);
insert into Section values('CSE221', '2', 'Kelly Clarkson', 5);
insert into Section values('CSE255', '3', 'Justin Bieber', 5);
insert into Section values('PHIL12', '4', 'Adam Levine', 2);
insert into Section values('CSE221', '5', 'Kelly Clarkson', 3);
insert into Section values('CSE105', '6', 'Taylor Swift', 3);
insert into Section values('PHIL165', '7', 'Taylor Swift', 3);
insert into Section values('MAE108', '8', 'Selena Gomez', 1);
insert into Section values('CSE221', '9', 'Kelly Clarkson', 2);
insert into Section values('CSE8A', '10', 'Adele', 5);
-- add sections for past classes
insert into Section values('CSE8A', '11', 'Justin Bieber', 100); -- fall 2014
insert into Section values('CSE8A', '12', 'Kelly Clarkson', 100); -- spring 2015
insert into Section values('CSE8A', '13', 'Selena Gomez', 100); -- fall 2015
insert into Section values('CSE105', '14', 'Taylor Swift', 100); -- winter 2015
insert into Section values('CSE250A', '15', 'Bjork', 100); -- fall 2014
insert into Section values('CSE250A', '16', 'Bjork', 100); -- fall 2015
insert into Section values('CSE250B', '17', 'Justin Bieber', 100); -- winter 2015
insert into Section values('CSE255', '18', 'Flo Rida', 100); -- fall 2015
insert into Section values('CSE232A', '19', 'Kelly Clarkson', 100); -- fall 2015
insert into Section values('CSE221', '20', 'Kelly Clarkson', 100); -- spring 2015
insert into Section values('MAE107', '21', 'Bjork', 100); -- spring 2015
insert into Section values('MAE108', '22', 'Adele', 100); -- fall 2014
insert into Section values('MAE108', '23', 'Selena Gomez', 100); -- winter 2015
insert into Section values('PHIL10', '24', 'Bjork', 100); -- fall 2015
insert into Section values('PHIL165', '25', 'Flo Rida', 100); -- spring 2015
insert into Section values('PHIL165', '26', 'Adam Levine', 100); -- fall 2015


--weeklymeeting: sectionid, type, day, time, building, roomno
insert into WeeklyMeeting values('1', 'LECTURE', 'M', '10:00 AM', 'place', 1);
insert into WeeklyMeeting values('1', 'LECTURE', 'W', '10:00 AM', 'place', 1);
insert into WeeklyMeeting values('1', 'LECTURE', 'F', '10:00 AM', 'place', 1);
insert into WeeklyMeeting values('2', 'LECTURE', 'M', '10:00 AM', 'place', 2);
insert into WeeklyMeeting values('2', 'LECTURE', 'W', '10:00 AM', 'place', 2);
insert into WeeklyMeeting values('2', 'LECTURE', 'F', '10:00 AM', 'place', 2);
insert into WeeklyMeeting values('3', 'LECTURE', 'M', '12:00 PM', 'place', 3);
insert into WeeklyMeeting values('3', 'LECTURE', 'W', '12:00 PM', 'place', 3);
insert into WeeklyMeeting values('3', 'LECTURE', 'F', '12:00 PM', 'place', 3);
insert into WeeklyMeeting values('4', 'LECTURE', 'M', '12:00 PM', 'place', 4);
insert into WeeklyMeeting values('4', 'LECTURE', 'W', '12:00 PM', 'place', 4);
insert into WeeklyMeeting values('4', 'LECTURE', 'F', '12:00 PM', 'place', 4);
insert into WeeklyMeeting values('5', 'LECTURE', 'M', '12:00 PM', 'place', 5);
insert into WeeklyMeeting values('5', 'LECTURE', 'W', '12:00 PM', 'place', 5);
insert into WeeklyMeeting values('5', 'LECTURE', 'F', '12:00 PM', 'place', 5);
insert into WeeklyMeeting values('6', 'LECTURE', 'TU', '2:00 PM', 'place', 6);
insert into WeeklyMeeting values('6', 'LECTURE', 'TH', '2:00 PM', 'place', 6);
insert into WeeklyMeeting values('7', 'LECTURE', 'TU', '3:00 PM', 'place', 7);
insert into WeeklyMeeting values('7', 'LECTURE', 'TH', '3:00 PM', 'place', 7);
insert into WeeklyMeeting values('8', 'LECTURE', 'TU', '3:00 PM', 'place', 8);
insert into WeeklyMeeting values('8', 'LECTURE', 'TH', '3:00 PM', 'place', 8);
insert into WeeklyMeeting values('9', 'LECTURE', 'TU', '5:00 PM', 'place', 9);
insert into WeeklyMeeting values('9', 'LECTURE', 'TH', '5:00 PM', 'place', 9);
insert into WeeklyMeeting values('10', 'LECTURE', 'TU', '5:00 PM', 'place', 10);
insert into WeeklyMeeting values('10', 'LECTURE', 'TH', '5:00 PM', 'place', 10);

-- new data from milestone 4/5
insert into WeeklyMeeting values('1', 'DIS', 'TU', '10:00 AM', 'place', 1);
insert into WeeklyMeeting values('1', 'DIS', 'TH', '10:00 AM', 'place', 1);
insert into WeeklyMeeting values('2', 'DIS', 'TU', '11:00 AM', 'place', 2);
insert into WeeklyMeeting values('2', 'DIS', 'TH', '11:00 AM', 'place', 2);
insert into WeeklyMeeting values('4', 'DIS', 'W', '1:00 PM', 'place', 4);
insert into WeeklyMeeting values('4', 'DIS', 'F', '1:00 PM', 'place', 4);
insert into WeeklyMeeting values('5', 'DIS', 'TU', '12:00 PM', 'place', 5);
insert into WeeklyMeeting values('5', 'DIS', 'TH', '12:00 PM', 'place', 5);
insert into WeeklyMeeting values('6', 'DIS', 'F', '6:00 PM', 'place', 6);
insert into WeeklyMeeting values('7', 'DIS', 'TH', '1:00 PM', 'place', 7);
insert into WeeklyMeeting values('8', 'DIS', 'M', '3:00 PM', 'place', 8);
insert into WeeklyMeeting values('9', 'DIS', 'M', '9:00 AM', 'place', 9);
insert into WeeklyMeeting values('9', 'DIS', 'F', '9:00 AM', 'place', 9);
insert into WeeklyMeeting values('10', 'DIS', 'W', '7:00 PM', 'place', 10);

insert into WeeklyMeeting values('1', 'LAB', 'F', '6:00 PM', 'place', 1);
insert into WeeklyMeeting values('8', 'LAB', 'F', '5:00 PM', 'place', 8);
insert into WeeklyMeeting values('10', 'LAB', 'TU', '3:00 PM', 'place', 10);
insert into WeeklyMeeting values('10', 'LAB', 'TH', '3:00 PM', 'place', 10);

--extra credit data for milestone 4/5
insert into ReviewSession values('2', '3/7/2016', '8:00 AM', 'place', 1);
insert into ReviewSession values('4', '3/7/2016', '9:00 AM', 'place', 1);
insert into ReviewSession values('5', '3/8/2016', '8:00 AM', 'place', 1);
insert into ReviewSession values('6', '3/15/2016', '1:00 PM', 'place', 1);
insert into ReviewSession values('7', '1/29/2016', '8:00 AM', 'place', 1);
insert into ReviewSession values('9', '3/9/2016', '8:00 AM', 'place', 1);
insert into ReviewSession values('10', '2/15/2016', '11:00 AM', 'place', 1);
insert into ReviewSession values('10', '3/14/2016', '11:00 AM', 'place', 1);

-- would need to create final table also


-- past classes: studentid, courseid, sectionid, quarter, year, grade, units
insert into PastClasses values('A1', 'CSE8A', '11', 'fall', 2014, 'A-', 4, 'LETTER');
insert into PastClasses values('A3', 'CSE8A', '11', 'fall', 2014, 'B+', 4, 'LETTER');
insert into PastClasses values('A2', 'CSE8A', '12', 'spring', 2015, 'C-', 4, 'LETTER');
insert into PastClasses values('A4', 'CSE8A', '13', 'fall', 2015, 'A-', 4, 'LETTER');
insert into PastClasses values('A5', 'CSE8A', '13', 'fall', 2015, 'B', 4, 'LETTER');
insert into PastClasses values('A1', 'CSE105', '14', 'winter', 2015, 'A-', 4, 'LETTER');
insert into PastClasses values('A5', 'CSE105', '14', 'winter', 2015, 'B+', 4, 'LETTER');
insert into PastClasses values('A4', 'CSE105', '14', 'winter', 2015, 'C', 4, 'LETTER');
insert into PastClasses values('A16', 'CSE250A', '15', 'fall', 2014, 'C', 4, 'LETTER');
insert into PastClasses values('A22', 'CSE250A', '16', 'fall', 2015, 'B+', 4, 'LETTER');
insert into PastClasses values('A18', 'CSE250A', '16', 'fall', 2015, 'D', 4, 'LETTER');
insert into PastClasses values('A19', 'CSE250A', '16', 'fall', 2015, 'F', 4, 'LETTER');
insert into PastClasses values('A17', 'CSE250B', '17', 'winter', 2015, 'A', 4, 'LETTER');
insert into PastClasses values('A19', 'CSE250B', '17', 'winter', 2015, 'A', 4, 'LETTER');
insert into PastClasses values('A20', 'CSE255', '18', 'fall', 2015, 'B-', 4, 'LETTER');
insert into PastClasses values('A18', 'CSE255', '18', 'fall', 2015, 'B', 4, 'LETTER');
insert into PastClasses values('A21', 'CSE255', '18', 'fall', 2015, 'F', 4, 'LETTER');
insert into PastClasses values('A17', 'CSE232A', '19', 'fall', 2015, 'A-', 4, 'LETTER');
insert into PastClasses values('A22', 'CSE221', '20', 'spring', 2015, 'A', 4, 'LETTER');
insert into PastClasses values('A20', 'CSE221', '20', 'spring', 2015, 'A', 4, 'LETTER');
insert into PastClasses values('A10', 'MAE107', '21', 'spring', 2015, 'B+', 4, 'LETTER');
insert into PastClasses values('A8', 'MAE108', '22', 'fall', 2014, 'B-', 2, 'LETTER');
insert into PastClasses values('A7', 'MAE108', '22', 'fall', 2014, 'A-', 2, 'LETTER');
insert into PastClasses values('A6', 'MAE108', '23', 'winter', 2015, 'B', 2, 'LETTER');
insert into PastClasses values('A10', 'MAE108', '23', 'winter', 2015, 'B+', 2, 'LETTER');
insert into PastClasses values('A11', 'PHIL10', '24', 'fall', 2015, 'A', 4, 'LETTER');
insert into PastClasses values('A12', 'PHIL10', '24', 'fall', 2015, 'A', 4, 'LETTER');
insert into PastClasses values('A13', 'PHIL10', '24', 'fall', 2015, 'C-', 4, 'LETTER');
insert into PastClasses values('A14', 'PHIL10', '24', 'fall', 2015, 'C+', 4, 'LETTER');
insert into PastClasses values('A15', 'PHIL165', '25', 'spring', 2015, 'F', 2, 'LETTER');
insert into PastClasses values('A12', 'PHIL165', '25', 'spring', 2015, 'D', 2, 'LETTER');
insert into PastClasses values('A11', 'PHIL165', '26', 'fall', 2015, 'A-', 2, 'LETTER'); 

-- currently enrolled: studentid, courseid, sectionid, units, grade type, quarter, year
insert into Enrolled values('A16', 'CSE221', '2', 4, 'Letter', 'winter', 2016);
insert into Enrolled values('A17', 'CSE221', '9', 4, 'PNP', 'winter', 2016);
insert into Enrolled values('A18', 'CSE221', '5', 4, 'Letter', 'winter', 2016);
insert into Enrolled values('A19', 'CSE221', '2', 4, 'Letter', 'winter', 2016);
insert into Enrolled values('A20', 'CSE221', '9', 4, 'Letter', 'winter', 2016);
insert into Enrolled values('A21', 'CSE221', '5', 4, 'PNP', 'winter', 2016);
insert into Enrolled values('A22', 'CSE255', '3', 4, 'Letter', 'winter', 2016);
insert into Enrolled values('A16', 'CSE255', '3', 4, 'Letter', 'winter', 2016);
insert into Enrolled values('A17', 'CSE255', '3', 4, 'Letter', 'winter', 2016);
insert into Enrolled values('A1', 'CSE8A', '10', 4, 'PNP', 'winter', 2016);
insert into Enrolled values('A5', 'CSE8A', '10', 4, 'Letter', 'winter', 2016);
insert into Enrolled values('A3', 'CSE8A', '10', 4, 'Letter', 'winter', 2016);
insert into Enrolled values('A7', 'MAE108', '1', 4, 'Letter', 'winter', 2016);
insert into Enrolled values('A8', 'MAE108', '1', 4, 'Letter', 'winter', 2016);
insert into Enrolled values('A9', 'MAE108', '8', 4, 'Letter', 'winter', 2016);
insert into Enrolled values('A4', 'CSE105', '6', 4, 'Letter', 'winter', 2016);
insert into Enrolled values('A12', 'PHIL12', '4', 4, 'Letter', 'winter', 2016);
insert into Enrolled values('A13', 'PHIL165', '7', 4, 'PNP', 'winter', 2016);
insert into Enrolled values('A14', 'PHIL12', '4', 4, 'Letter', 'winter', 2016);
insert into Enrolled values('A15', 'PHIL165', '7', 4, 'Letter', 'winter', 2016);
      


            

