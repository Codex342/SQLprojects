
-- Create the Careers Database

CREATE DATABASE Careers;
GO


-- Verifying The Database 
SELECT name,
       database_id,
       create_date
FROM sys.databases
WHERE name = 'Careers';
GO

-- Changing Context To Database 
USE Careers;
Go 


-- Creating and Verifying the Reference, Recruiter, and Candidate Schemas
CREATE SCHEMA Reference;
GO 

SELECT name FROM sys.schemas 
WHERE name = 'Reference';
GO 

CREATE SCHEMA Recruiter;
GO 

SELECT name FROM sys.schemas 
WHERE name = 'Recruiter';
GO 

CREATE SCHEMA Candidate;
GO 

SELECT name FROM sys.schemas 
WHERE name = 'Candidate';
GO 

-- Creating and Verifying The JobType Table 
CREATE TABLE Reference.JobType
(
    JobTypeId          INT IDENTITY (1,1) NOT NULL,
    JobTypeCode        NVARCHAR(64)       NOT NULL,
    JobTypeName        NVARCHAR(256)      NOT NULL,
    JobTypeDescription NVARCHAR(512)      NOT NULL,

    IsActive           BIT                NOT NULL DEFAULT 1,
    CreatedOn          DATETIME2          NOT NULL DEFAULT SYSUTCDATETIME(),
    UpdatedOn          DATETIME2          NULL,

    CONSTRAINT PK_JobType PRIMARY KEY (JobTypeId),
    CONSTRAINT UQ_JobType_Code UNIQUE (JobTypeCode)
);
GO

SELECT * FROM Reference.JobType;
GO 

-- Creating and Verifying The JobSector Table 
CREATE TABLE Reference.JobSector
(
    JobSectorId          INT IDENTITY (1,1) NOT NULL,
    JobSectorCode        NVARCHAR(64)       NOT NULL,
    JobSectorName        NVARCHAR(256)      NOT NULL,
    JobSectorDescription NVARCHAR(512)      NOT NULL,

    IsActive             BIT                NOT NULL DEFAULT 1,
    CreatedOn            DATETIME2          NOT NULL DEFAULT SYSUTCDATETIME(),
    UpdatedOn            DATETIME2          NULL,

    CONSTRAINT PK_JobSector PRIMARY KEY (JobSectorId),
    CONSTRAINT UQ_JobSector_Code UNIQUE (JobSectorCode)
);
GO

SELECT * FROM Reference.JobSector;
GO 

-- Creating and Verifying The Account Table 
CREATE TABLE Recruiter.Account
(
    RecruiterAccountId INT IDENTITY (1,1) NOT NULL,

    CompanyName        NVARCHAR(256)      NOT NULL,
    CompanyAddress     NVARCHAR(1024)     NOT NULL,

    EmailAddress       NVARCHAR(256)      NOT NULL,
    Password           NVARCHAR(256)      NOT NULL,

    IsLocked           BIT                NOT NULL DEFAULT 0,
    IsActive           BIT                NOT NULL DEFAULT 1,

    CreatedOn          DATETIME2          NOT NULL DEFAULT SYSUTCDATETIME(),
    UpdatedOn          DATETIME2          NULL,

    CONSTRAINT PK_RecruiterAccount PRIMARY KEY (RecruiterAccountId),
    CONSTRAINT UQ_RecruiterAccount_Email UNIQUE (EmailAddress)
);
GO

SELECT * FROM Recruiter.Account;
GO 

-- Creating and Verifying the Profile Table 
CREATE TABLE Recruiter.Profile
(
    RecruiterProfileId INT IDENTITY (1,1) NOT NULL,
    RecruiterAccountId INT                NOT NULL,

    RecruiterFirstName NVARCHAR(128)      NOT NULL,
    RecruiterLastName  NVARCHAR(128)      NOT NULL,

    JobTitle           NVARCHAR(200)      NOT NULL,
    TelephoneNumber    NVARCHAR(50)       NOT NULL,

    IsAccountHolder    BIT                NOT NULL DEFAULT 0,

    IsActive           BIT                NOT NULL DEFAULT 1,
    CreatedOn          DATETIME2          NOT NULL DEFAULT SYSUTCDATETIME(),
    UpdatedOn          DATETIME2          NULL,

    CONSTRAINT PK_RecruiterProfile PRIMARY KEY (RecruiterProfileId),
    CONSTRAINT FK_RecruiterProfile_RecruiterAccount FOREIGN KEY (RecruiterAccountId)
        REFERENCES Recruiter.Account (RecruiterAccountId)
);
GO

SELECT * Recruiter.Profile;
GO  

-- Creating and Verifying the Account Table 
CREATE TABLE Candidate.Account
(
    CandidateAccountId INT IDENTITY (1,1) NOT NULL,

    EmailAddress       NVARCHAR(256)      NOT NULL,
    Password           NVARCHAR(256)      NOT NULL,

    IsLocked           BIT                NOT NULL DEFAULT 0,
    IsActive           BIT                NOT NULL DEFAULT 1,

    CreatedOn          DATETIME2          NOT NULL DEFAULT SYSUTCDATETIME(),
    UpdatedOn          DATETIME2          NULL,

    CONSTRAINT PK_CandidateAccount PRIMARY KEY (CandidateAccountId),
    CONSTRAINT UQ_CandidateAccount_Email UNIQUE (EmailAddress)
);
GO

SELECT * FROM Candidate.Account;
GO 

-- Creating and Verifying Profile Table --
CREATE TABLE Candidate.Profile
(
  
    CandidateProfileId   INT IDENTITY (1,1) NOT NULL,
    CandidateAccountId   INT                NOT NULL,

    FirstName            NVARCHAR(128)      NOT NULL,
    LastName             NVARCHAR(128)      NOT NULL,

    TelephoneNumber      NVARCHAR(50)       NULL,

    Location             NVARCHAR(512)      NOT NULL,

    CvSymbolicLink       NVARCHAR(4000)     NULL,

    AvailableImmediately BIT                NOT NULL DEFAULT 0,
    CandidateType        NVARCHAR(64)       NOT NULL,

    IsActive             BIT                NOT NULL DEFAULT 1,
    CreatedOn            DATETIME2          NOT NULL DEFAULT SYSUTCDATETIME(),
    UpdatedOn            DATETIME2          NULL,

    CONSTRAINT PK_CandidateProfile PRIMARY KEY (CandidateProfileId),
    CONSTRAINT UQ_CandidateProfile_Account UNIQUE (CandidateAccountId),
    CONSTRAINT FK_CandidateProfile_CandidateAccount FOREIGN KEY (CandidateAccountId)
        REFERENCES Candidate.Account (CandidateAccountId)
);
GO

SELECT * FROM Candidate.Profile;
GO  

-- Populating The Reference Tables 
INSERT INTO Reference.JobType
    (JobTypeCode, JobTypeName, JobTypeDescription)
VALUES (N'PERMANENT', N'Permanent', N'Ongoing employed role.'),
       (N'CONTRACT', N'Contract', N'Fixed-term or day-rate contract role.'),
       (N'TEMPORARY', N'Temporary', N'Short-term temporary role.'),
       (N'INTERNSHIP', N'Internship', N'Entry-level training opportunity.');
GO

INSERT INTO Reference.JobSector
    (JobSectorCode, JobSectorName, JobSectorDescription)
VALUES (N'TECHNOLOGY', N'Technology', N'Software, data and IT roles.'),
       (N'FINANCE', N'Finance', N'Banking, accounting and financial services.'),
       (N'HEALTHCARE', N'Healthcare', N'Health, care and medical services.'),
       (N'EDUCATION', N'Education', N'Schools, colleges and training providers.'),
       (N'RETAIL', N'Retail', N'Shops, ecommerce and customer-facing retail roles.');
GO

-- Populating The Recruiter Tables 
INSERT INTO Recruiter.Account
    (CompanyName, CompanyAddress, EmailAddress, Password)
VALUES (N'Dales Digital Recruitment', N'12 Market Street, The Dales', N'admin@dalesdigital.example', N'TrainingPassword01'),
       (N'Northbridge Talent Partners', N'44 Station Road, Northbridge', N'admin@northbridgetalent.example', N'TrainingPassword02'),
       (N'Careers Hub Healthcare', N'8 Riverside Court, Westford', N'admin@careershubhealth.example', N'TrainingPassword03');
GO

INSERT INTO Recruiter.Profile
    (RecruiterAccountId, RecruiterFirstName, RecruiterLastName, JobTitle, TelephoneNumber, IsAccountHolder)
VALUES (1, N'Amelia', N'Brooks', N'Senior Technology Recruiter', N'01908 100001', 1),
       (1, N'Noah', N'Price', N'Data Recruitment Consultant', N'01908 100002', 0),
       (2, N'Grace', N'Evans', N'Finance Recruitment Manager', N'01908 100003', 1),
       (2, N'Oliver', N'Green', N'Graduate Recruitment Consultant', N'01908 100004', 0),
       (3, N'Sophia', N'Turner', N'Healthcare Recruitment Lead', N'01908 100005', 1);
GO

-- Populating The Candidate Tables 
INSERT INTO Candidate.Account
    (EmailAddress, Password)
VALUES (N'jacob.miles@example.com', N'TrainingPassword01'),
       (N'emily.carter@example.com', N'TrainingPassword02'),
       (N'harry.wilson@example.com', N'TrainingPassword03'),
       (N'ava.patel@example.com', N'TrainingPassword04'),
       (N'leo.morgan@example.com', N'TrainingPassword05'),
       (N'mia.clarke@example.com', N'TrainingPassword06');
GO

INSERT INTO Candidate.Account
    (EmailAddress, Password, IsActive)
VALUES (N'ethan.reed@example.com', N'TrainingPassword07', 0);
GO

INSERT INTO Candidate.Profile
(CandidateAccountId, FirstName, LastName, TelephoneNumber, Location, CvSymbolicLink, AvailableImmediately, CandidateType)
VALUES (1, N'Jacob', N'Miles', N'07700 900001', N'Milton Keynes', N'/cv/jacob-miles.pdf', 1, N'Contractor'),
       (2, N'Emily', N'Carter', N'07700 900002', N'Bedford', N'/cv/emily-carter.pdf', 0, N'Permanent'),
       (3, N'Harry', N'Wilson', N'07700 900003', N'Northampton', N'/cv/harry-wilson.pdf', 1, N'Permanent'),
       (4, N'Ava', N'Patel', N'07700 900004', N'Luton', N'/cv/ava-patel.pdf', 1, N'Contractor'),
       (5, N'Leo', N'Morgan', N'07700 900005', N'Cambridge', N'/cv/leo-morgan.pdf', 0, N'Permanent'),
       (6, N'Mia', N'Clarke', N'07700 900006', N'Oxford', N'/cv/mia-clarke.pdf', 1, N'Contractor');
GO

INSERT INTO Candidate.Profile
(CandidateAccountId, FirstName, LastName, TelephoneNumber, Location, CvSymbolicLink, AvailableImmediately, CandidateType, IsActive)
VALUES (7, N'Ethan', N'Reed', N'07700 900007', N'Milton Keynes', N'/cv/ethan-reed.pdf', 0, N'Permanent', 0);
GO

-- Populating The Job Tables 
INSERT INTO Recruiter.JobAdvert
(RecruiterProfileId, JobTypeId, JobSectorId, JobAdvertReference, JobTitle, JobSummary, JobDescription,
 WorkingLocation, WorkingType, SalaryFrom, SalaryTo, IsNotAcceptingApplications, IsActive)
VALUES (1, 1, 1, N'JOB-2026-0001', N'Junior SQL Developer',
        N'Entry-level SQL role.',
        N'Work with databases, reports and internal business systems.',
        N'Milton Keynes', N'Hybrid', 28000, 34000, 0, 1),

       (2, 2, 1, N'JOB-2026-0002', N'Contract Data Analyst',
        N'Contract reporting role.',
        N'Analyse operational data and produce weekly management reports.',
        N'Remote', N'Remote', 350, 450, 0, 1),

       (3, 1, 2, N'JOB-2026-0003', N'Finance Systems Analyst',
        N'Finance systems support role.',
        N'Support finance reporting, reconciliations and SQL-based analysis.',
        N'London', N'Hybrid', 42000, 52000, 0, 1),

       (4, 4, 2, N'JOB-2026-0004', N'Graduate Data Assistant',
        N'Graduate role for data-focused candidates.',
        N'Assist with spreadsheet, reporting and database tasks.',
        N'Northbridge', N'Office', 24000, 28000, 0, 1),

       (5, 1, 3, N'JOB-2026-0005', N'Healthcare Data Coordinator',
        N'Healthcare data coordination role.',
        N'Coordinate patient, staffing and service reporting data.',
        N'Westford', N'Office', 30000, 36000, 0, 1),

       (5, 3, 3, N'JOB-2026-0006', N'Temporary Clinic Administrator',
        N'Temporary healthcare admin role.',
        N'Support appointment scheduling and clinic administration.',
        N'Westford', N'Office', 13, 16, 1, 1),

       (1, 1, 1, N'JOB-2026-0007', N'Junior Reporting Assistant',
        N'Entry-level reporting role with training provided.',
        N'Assist with reports, spreadsheets, dashboards and basic SQL queries.',
        N'Milton Keynes', N'Hybrid', NULL, NULL, 0, 0);
GO

INSERT INTO Recruiter.JobApplication
    (JobAdvertId, CandidateProfileId, ApplicationReference, ApplicationCoverLetter, WorkVisaRequired, ViewedCount)
VALUES (1, 1, N'APP-2026-0001', N'I have completed beginner SQL training and want to work with databases.', 0, 2),
       (1, 2, N'APP-2026-0002', N'I am interested in junior SQL development and reporting.', 0, 1),
       (2, 1, N'APP-2026-0003', N'I am available immediately for contract data analysis work.', 0, 4),
       (2, 4, N'APP-2026-0004', N'I have reporting experience and can start immediately.', 1, 0),
       (3, 3, N'APP-2026-0005', N'I have finance and systems experience.', 0, 3),
       (4, 5, N'APP-2026-0006', N'I am seeking my first graduate data role.', 0, 1),
       (5, 6, N'APP-2026-0007', N'I have healthcare administration experience and strong Excel skills.', 0, 2),
       (5, 2, N'APP-2026-0008', N'I am interested in healthcare reporting and data coordination.', 0, 0),
       (6, 3, N'APP-2026-0009', N'I am available for temporary healthcare administration work.', 0, 1),
       (6, 6, N'APP-2026-0010', N'I can support temporary clinic administration immediately.', 0, 0);
GO 






