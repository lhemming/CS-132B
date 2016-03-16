-- PART 1: create cpqg and cpg tables

select sec.CLASSID, sec.INSTRUCTOR, cl.QUARTER, cl.YEAR, l.grade, COUNT(pc.GRADE) AS GRADECOUNT into cpqg 
from Section sec, PastClasses pc, Class cl, Grade_conversion g, lettergrades l
	where sec.classid = cl.classid AND cl.classid = pc.courseid AND pc.grade = g.letter_grade 
		AND pc.sectionid = sec.sectionid AND pc.quarter = cl.quarter 
		AND pc.year = cl.year AND l.signedgrade = pc.grade 
		GROUP BY l.grade, sec.classid, sec.instructor, cl.quarter, cl.year ORDER BY l.grade;

-- ** DECISION: do we want to include zero columns here, or want to not include
-- and check if exists in views during decision support queries, as well as handle case for insert during support?

insert into cpqg -- get zero count data
select sec.CLASSID, sec.INSTRUCTOR, cl.QUARTER, cl.YEAR, l.grade, 0 AS GRADECOUNT 
from Section sec, PastClasses pc, Class cl, Grade_conversion g, lettergrades l
where sec.classid = cl.classid AND cl.classid = pc.courseid  
		AND pc.sectionid = sec.sectionid AND pc.quarter = cl.quarter 
		AND l.grade NOT IN (select l1.grade from PastClasses pc1, lettergrades l1 
		where pc1.courseid = sec.classid and pc1.sectionid = sec.sectionid and 
		pc1.grade = l1.signedgrade)
		AND pc.year = cl.year 
		GROUP BY sec.classid, sec.instructor, cl.quarter, cl.year, l.grade;

-- ** DECISION: do we want to include zero columns here, or want to not include
-- and check if exists in views during decision support queries, as well as handle case for insert during support?
select sec.CLASSID, sec.INSTRUCTOR, l.GRADE, COUNT(pc.GRADE) AS GRADECOUNT into cpg
from Section sec, PastClasses pc, Grade_conversion g, lettergrades l
	where pc.grade = g.letter_grade AND pc.grade = l.signedgrade 
		AND pc.sectionid = sec.sectionid 
		GROUP BY l.grade, sec.classid, sec.instructor ORDER BY l.grade;

insert into cpg
select DISTINCT g.CLASSID, g.INSTRUCTOR, l.grade, 0 AS GRADECOUNT -- ONLY for classes that have been taught in the past. not current or future.
from cpg g, lettergrades l
where l.grade NOT IN (select g1.grade from cpg g1 where g1.classid = g.classid and 
g.instructor = g1.instructor)

-- ********* PART 2: rewrite decision support queries ii and iii to use views! **********

-- PART 3: triggers

-- drop triggers if they exist to ensure for correct entering 
IF EXISTS (
    SELECT *
    FROM sys.objects
    WHERE [type] = 'TR' AND [name] = 'cpqgInsert'
    )
    DROP TRIGGER cpqgInsert;
GO

IF EXISTS (
    SELECT *
    FROM sys.objects
    WHERE [type] = 'TR' AND [name] = 'cpqgDelete'
    )
    DROP TRIGGER cpqgDelete;
GO

IF EXISTS (
    SELECT *
    FROM sys.objects
    WHERE [type] = 'TR' AND [name] = 'cpqgUpdate'
    )
    DROP TRIGGER cpqgUpdate;
GO

IF EXISTS (
    SELECT *
    FROM sys.objects
    WHERE [type] = 'TR' AND [name] = 'cpgInsert'
    )
    DROP TRIGGER cpgInsert;
GO

IF EXISTS (
    SELECT *
    FROM sys.objects
    WHERE [type] = 'TR' AND [name] = 'cpgDelete'
    )
    DROP TRIGGER cpgDelete;
GO

IF EXISTS (
    SELECT *
    FROM sys.objects
    WHERE [type] = 'TR' AND [name] = 'cpgUpdate'
    )
    DROP TRIGGER cpgUpdate;
GO


-- should work!! but test more
CREATE TRIGGER cpqgInsert ON PastClasses -- want to update tables when a new grade gets entered - this happens in PastClases
AFTER INSERT
AS
DECLARE @grade varchar(5)
DECLARE @sec varchar(15)
DECLARE @quarter varchar(10)
DECLARE @year int
DECLARE @course varchar(15)
SET @grade = (SELECT GRADE FROM INSERTED) 
SET @sec = (SELECT SECTIONID FROM INSERTED)
SET @quarter = (SELECT QUARTER FROM INSERTED)
SET @year = (SELECT YEAR FROM INSERTED)
SET @course = (SELECT COURSEID FROM INSERTED)
IF (EXISTS  -- if row exists in table, update it
	(select * from cpqg where @course = classid AND @quarter = quarter AND @year = year 
	AND instructor = (select instructor from Section where sectionid = @sec and classid = @course)
	AND grade = (select grade from lettergrades where signedgrade = @grade)
	))
BEGIN
	UPDATE cpqg
	SET gradecount = gradecount + 1
	WHERE @course = classid AND @quarter = quarter AND @year = year 
		AND instructor = (select instructor from Section where sectionid = @sec and classid = @course)
		AND grade = (select grade from lettergrades where signedgrade = @grade)
END 
ELSE	-- else add row to table; exists for when we want to enter new classes after the quarter ends into pastclasses
	INSERT INTO cpqg values (@course, (select instructor from section where sectionid = @sec), 
							@quarter, @year,
							(select grade from lettergrades where signedgrade = @grade), 1);


--classid IN (select sec.classid from section sec where @course = sec.classid and sec.sectionid = @sec)
--	AND quarter in (select cl.quarter from class cl, section sec where @sec = sec.sectionid 
--		and @course = sec.classid and @course = cl.classid)
--	AND year in (select cl.year from class cl, section sec where @sec = sec.sectionid 
--		and @course = sec.classid and @course = cl.classid and @quarter = cl.quarter)
--	AND instructor in (select sec.instructor from section sec where sec.sectionid = @sec)
--	AND grade = (select grade from lettergrades where signedgrade = @grade);

CREATE TRIGGER cpqgDelete ON PastClasses -- want to update tables when a new grade gets entered - this happens in PastClases
AFTER DELETE
AS
DECLARE @grade varchar(5)
DECLARE @sec varchar(15)
DECLARE @quarter varchar(10)
DECLARE @year int
DECLARE @course varchar(15)
SET @grade = (SELECT GRADE FROM DELETED) 
SET @sec = (SELECT SECTIONID FROM DELETED)
SET @quarter = (SELECT QUARTER FROM DELETED)
SET @year = (SELECT YEAR FROM DELETED)
SET @course = (SELECT COURSEID FROM DELETED)
UPDATE cpqg
SET gradecount = gradecount - 1
WHERE @course = classid AND @quarter = quarter AND @year = year 
	AND instructor = (select instructor from Section where sectionid = @sec and classid = @course)
	AND grade = (select grade from lettergrades where signedgrade = @grade);


CREATE TRIGGER cpqgUpdate ON PastClasses -- recalculate grade counts for grades affected
AFTER UPDATE
AS
DECLARE @grade1 varchar(5)
DECLARE @sec1 varchar(15)
DECLARE @quarter1 varchar(10)
DECLARE @year1 int
DECLARE @course1 varchar(15)
DECLARE @grade2 varchar(5)
DECLARE @sec2 varchar(15)
DECLARE @quarter2 varchar(10)
DECLARE @year2 int
DECLARE @course2 varchar(15)
SET @grade1 = (SELECT GRADE FROM INSERTED) -- assume we're inserting into a CurrentlyTeaching thing
SET @sec1 = (SELECT SECTIONID FROM INSERTED)
SET @quarter1 = (SELECT QUARTER FROM INSERTED)
SET @year1 = (SELECT YEAR FROM INSERTED)
SET @course1 = (SELECT COURSEID FROM INSERTED)
SET @grade2 = (SELECT GRADE FROM DELETED) -- assume we're inserting into a CurrentlyTeaching thing
SET @sec2 = (SELECT SECTIONID FROM DELETED)
SET @quarter2 = (SELECT QUARTER FROM DELETED)
SET @year2 = (SELECT YEAR FROM DELETED)
SET @course2 = (SELECT COURSEID FROM DELETED)
IF (EXISTS  -- if row exists in table, update it
	(select * from cpqg where @course1 = classid AND @quarter1 = quarter AND @year1 = year 
	AND instructor = (select instructor from Section where sectionid = @sec1 and classid = @course1)
	AND grade = (select grade from lettergrades where signedgrade = @grade1)
	))
BEGIN
UPDATE cpqg
SET gradecount = gradecount + 1
WHERE @course1 = classid AND @quarter1 = quarter AND @year1 = year 
	AND instructor = (select instructor from Section where sectionid = @sec1 and classid = @course1)
	AND grade = (select grade from lettergrades where signedgrade = @grade1)
END
ELSE 
BEGIN
	INSERT INTO cpqg values (@course1, (select instructor from section where sectionid = @sec1), 
							@quarter1, @year1,
							(select grade from lettergrades where signedgrade = @grade1), 1)
END
UPDATE cpqg
SET gradecount = gradecount - 1
WHERE @course2 = classid AND @quarter2 = quarter AND @year2 = year 
	AND instructor = (select instructor from Section where sectionid = @sec2 and classid = @course2)
	AND grade = (select grade from lettergrades where signedgrade = @grade2);

-- repeat triggers for CPG table
CREATE TRIGGER cpgInsert ON PastClasses -- want to update tables when a new grade gets entered - this happens in PastClases
AFTER INSERT
AS
DECLARE @grade varchar(5)
DECLARE @sec varchar(15)
DECLARE @course varchar(15)
SET @grade = (SELECT GRADE FROM INSERTED) 
SET @sec = (SELECT SECTIONID FROM INSERTED)
SET @course = (SELECT COURSEID FROM INSERTED)
IF (EXISTS  -- if row exists in table, update it
	(select * from cpg where @course = classid 
	AND instructor = (select instructor from Section where sectionid = @sec and classid = @course)
	AND grade = (select grade from lettergrades where signedgrade = @grade)
	))
BEGIN
	UPDATE cpg
	SET gradecount = gradecount + 1
	WHERE @course = classid 
		AND instructor = (select instructor from Section where sectionid = @sec and classid = @course)
		AND grade = (select grade from lettergrades where signedgrade = @grade)
END 
ELSE	-- else add row to table
	INSERT INTO cpg values (@course, (select instructor from section where sectionid = @sec), 
							(select grade from lettergrades where signedgrade = @grade), 1);


-- delete cpg
CREATE TRIGGER cpgDelete ON PastClasses -- want to update tables when a new grade gets entered - this happens in PastClases
AFTER DELETE
AS
DECLARE @grade varchar(5)
DECLARE @sec varchar(15)
DECLARE @course varchar(15)
SET @grade = (SELECT GRADE FROM DELETED) 
SET @sec = (SELECT SECTIONID FROM DELETED)
SET @course = (SELECT COURSEID FROM DELETED)
UPDATE cpg
SET gradecount = gradecount - 1
WHERE @course = classid 
	AND instructor = (select instructor from Section where sectionid = @sec and classid = @course)
	AND grade = (select grade from lettergrades where signedgrade = @grade);

-- update cpg
CREATE TRIGGER cpgUpdate ON PastClasses -- recalculate grade counts for grades affected
AFTER UPDATE
AS
DECLARE @grade1 varchar(5)
DECLARE @sec1 varchar(15)
DECLARE @course1 varchar(15)
DECLARE @grade2 varchar(5)
DECLARE @sec2 varchar(15)
DECLARE @course2 varchar(15)
SET @grade1 = (SELECT GRADE FROM INSERTED) 
SET @sec1 = (SELECT SECTIONID FROM INSERTED)
SET @course1 = (SELECT COURSEID FROM INSERTED)
SET @grade2 = (SELECT GRADE FROM DELETED) 
SET @sec2 = (SELECT SECTIONID FROM DELETED)
SET @course2 = (SELECT COURSEID FROM DELETED)
IF (EXISTS  -- if row exists in table, update it
	(select * from cpg where @course1 = classid 
	AND instructor = (select instructor from Section where sectionid = @sec1 and classid = @course1)
	AND grade = (select grade from lettergrades where signedgrade = @grade1)
	))
BEGIN
UPDATE cpg
SET gradecount = gradecount + 1
WHERE @course1 = classid 
	AND instructor = (select instructor from Section where sectionid = @sec1 and classid = @course1)
	AND grade = (select grade from lettergrades where signedgrade = @grade1)
END
ELSE 
BEGIN
	INSERT INTO cpg values (@course1, (select instructor from section where sectionid = @sec1), 
							(select grade from lettergrades where signedgrade = @grade1), 1)
END
UPDATE cpg
SET gradecount = gradecount - 1
WHERE @course2 = classid 
	AND instructor = (select instructor from Section where sectionid = @sec2 and classid = @course2)
	AND grade = (select grade from lettergrades where signedgrade = @grade2);


