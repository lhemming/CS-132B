---------------------------------------------- sql server versions
-- part 1: insert on weekly meeting table

IF EXISTS (
    SELECT *
    FROM sys.objects
    WHERE [type] = 'TR' AND [name] = 'weeklyMeetingInsert'
    )
    DROP TRIGGER weeklyMeetingInsert;
GO

-- for extra credit: check against review sessions (insert for review check weeklymeeting / weeklymeeting insert check with review)
CREATE TRIGGER weeklyMeetingInsert ON WeeklyMeeting
INSTEAD OF INSERT
AS
DECLARE @sec varchar(15)
DECLARE @time time
DECLARE @day varchar(10)
SET @sec = (SELECT SECTIONID FROM INSERTED)
SET @time = (SELECT TIME FROM INSERTED)
SET @day = (SELECT DAY FROM INSERTED)
IF (EXISTS (
            SELECT *
            FROM WeeklyMeeting wk
            WHERE wk.SECTIONID = @sec 
            AND wk.TIME = @time AND wk.DAY = @day -- since all meetings are an hour, just check start time
            ) )
BEGIN
     THROW 51000, 'Entry conflicts with preexisting meeting for same section.', 1
END
ELSE IF (EXISTS (
            SELECT * 
            FROM ReviewSession r, Calendar c
            WHERE r.SECTIONID = @sec
            AND r.TIME = @time AND r.DATE = c.DATE AND c.WEEKDAYNAME = @day
    ))
BEGIN
     THROW 55000, 'Entry conflicts with review session for same section.', 1
END
ELSE
     INSERT INTO WeeklyMeeting SELECT * FROM INSERTED;


IF EXISTS (
    SELECT *
    FROM sys.objects
    WHERE [type] = 'TR' AND [name] = 'reviewSessionInsert'
    )
    DROP TRIGGER reviewSessionInsert;
GO

CREATE TRIGGER reviewSessionInsert ON ReviewSession
INSTEAD OF INSERT
AS
DECLARE @sec varchar(15)
DECLARE @time time
DECLARE @dat date
SET @sec = (SELECT SECTIONID FROM INSERTED)
SET @time = (SELECT TIME FROM INSERTED)
SET @dat = (SELECT DATE FROM INSERTED)
IF (EXISTS (
            SELECT *
            FROM WeeklyMeeting wk, Calendar c
            WHERE wk.SECTIONID = @sec 
            AND wk.TIME = @time AND c.DATE = @dat AND c.WEEKDAYNAME = wk.DAY
            ) )
BEGIN
     THROW 56000, 'Entry conflicts with weekly meeting for same section.', 1
END
ELSE IF (EXISTS (
            SELECT * 
            FROM ReviewSession r
            WHERE r.SECTIONID = @sec
            AND r.TIME = @time AND r.DATE = @dat
    ))
BEGIN
     THROW 57000, 'Entry conflicts with revious review session for same section.', 1
END
ELSE
     INSERT INTO ReviewSession SELECT * FROM INSERTED;

-- part 1: update to weekly meeting table
IF EXISTS (
    SELECT *
    FROM sys.objects
    WHERE [type] = 'TR' AND [name] = 'weeklyMeetingUpdate'
    )
    DROP TRIGGER weeklyMeetingUpdate;
GO

CREATE TRIGGER weeklyMeetingUpdate ON WeeklyMeeting
FOR UPDATE
AS
DECLARE @sec varchar(15)
DECLARE @time time
DECLARE @day varchar(10)
DECLARE @type varchar(15)
DECLARE @build varchar(15)
DECLARE @rno int
SET @sec = (SELECT SECTIONID FROM INSERTED)
SET @time = (SELECT TIME FROM INSERTED)
SET @day = (SELECT DAY FROM INSERTED)
SET @type = (SELECT TYPE FROM INSERTED)
SET @build = (SELECT BUILDING FROM INSERTED)
SET @rno = (SELECT ROOMNO FROM INSERTED)
IF ( (UPDATE(TIME) OR UPDATE(DAY) ) AND EXISTS ( -- like 70% sure this works but needs more thorough tests
            SELECT *
            FROM WeeklyMeeting wk
            WHERE wk.SECTIONID = @sec 
            AND wk.TIME = @time AND wk.DAY = @day AND wk.TYPE <> @type
			-- since all meetings are an hour, just check start time
            ) )
BEGIN
     THROW 51000, 'Update conflicts with preexisting meeting for same section.', 1
END;

-- part 2: insert to enrollment list for section
IF EXISTS (
    SELECT *
    FROM sys.objects
    WHERE [type] = 'TR' AND [name] = 'enrollmentInsert'
    )
    DROP TRIGGER enrollmentInsert;
GO

CREATE TRIGGER enrollmentInsert ON Enrolled
INSTEAD OF INSERT
AS
DECLARE @sec varchar(15)
SET @sec = (SELECT SECTIONID FROM INSERTED)
IF ( (SELECT ENROLL_LIMIT FROM SECTION WHERE SECTIONID = @sec) 
	<= (
        SELECT COUNT(SECTIONID)
        FROM Enrolled e
        WHERE e.SECTIONID = @sec
      ) )
BEGIN
     THROW 52000, 'Enrollment for selected section is full.', 1
END
ELSE
     INSERT INTO Enrolled SELECT * FROM INSERTED;

-- part 3: overlapping professor meetings (lectures only; others extra credit). Prof is tied to review session, lecture, lab, dis, final, etc
IF EXISTS (
    SELECT *
    FROM sys.objects
    WHERE [type] = 'TR' AND [name] = 'professorSectionInsert'
    )
    DROP TRIGGER professorSectionInsert;
GO

CREATE TRIGGER professorSectionInsert ON CurrentlyTeaching -- needs more testing! but should be close
INSTEAD OF INSERT
AS
DECLARE @fac varchar(50)
DECLARE @sec varchar(15)
SET @fac = (SELECT FACULTYNAME FROM INSERTED) -- assume we're inserting into a CurrentlyTeaching thing
SET @sec = (SELECT SECTIONID FROM INSERTED)
IF ( 
	EXISTS (SELECT SECTIONID FROM CurrentlyTeaching WHERE FACULTYNAME = @fac) -- if section taught by same fac has a same meeting time, 
	 AND EXISTS
	 (
     	SELECT *
        FROM Section s, CurrentlyTeaching ct, Section s2, WeeklyMeeting wk, WeeklyMeeting wk2
        WHERE s.SECTIONID <> @sec AND ct.SECTIONID = s.SECTIONID AND ct.FACULTYNAME = @fac AND s2.SECTIONID = @sec 
        AND s.SECTIONID = wk.SECTIONID AND wk2.SECTIONID = @sec AND wk.DAY = wk2.DAY AND wk.TIME = wk2.TIME
     ) )
BEGIN
     THROW 53000, 'Professor is already teaching another section that conflicts with entered section.', 1
END
ELSE
     INSERT INTO CurrentlyTeaching SELECT * FROM INSERTED;
     UPDATE Section SET INSTRUCTOR = @fac WHERE @sec = sectionid;

