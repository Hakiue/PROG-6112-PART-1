/* =====================================================================
   RaceDay Database Script
   Module: PROG6212 - Programming 2B
   Part 1, Section C
   ===================================================================== */

USE master;
GO

IF DB_ID('RaceDayDB') IS NOT NULL
BEGIN
    ALTER DATABASE RaceDayDB SET SINGLE_USER WITH ROLLBACK IMMEDIATE;
    DROP DATABASE RaceDayDB;
END
GO

CREATE DATABASE RaceDayDB;
GO

USE RaceDayDB;
GO

/* =====================================================================
   TABLES
   ===================================================================== */

CREATE TABLE Users (
    UserId          INT IDENTITY(1,1) PRIMARY KEY,
    FirstName       VARCHAR(50)     NOT NULL,
    LastName        VARCHAR(50)     NOT NULL,
    Email           VARCHAR(100)    NOT NULL UNIQUE,
    PasswordHash    VARCHAR(255)    NOT NULL,
    Role            VARCHAR(20)     NOT NULL CHECK (Role IN ('Organiser', 'Participant')),
    PhoneNumber     VARCHAR(20)     NULL,
    ProfilePictureUrl VARCHAR(255) NULL,
    CreatedAt       DATETIME        NOT NULL DEFAULT GETDATE()
);
GO

CREATE TABLE EventTypes (
    EventTypeId     INT IDENTITY(1,1) PRIMARY KEY,
    TypeName        VARCHAR(20)     NOT NULL UNIQUE CHECK (TypeName IN ('Run', 'Walk', 'Cycle'))
);
GO

CREATE TABLE Events (
    EventId         INT IDENTITY(1,1) PRIMARY KEY,
    OrganiserId     INT             NOT NULL,
    EventTypeId     INT             NOT NULL,
    Name            VARCHAR(100)    NOT NULL,
    Description     VARCHAR(MAX)    NULL,
    EventDate       DATETIME        NOT NULL,
    Location        VARCHAR(150)    NOT NULL,
    DistanceKm      DECIMAL(6,2)    NOT NULL,
    BannerImageUrl  VARCHAR(255)    NULL,
    CreatedAt       DATETIME        NOT NULL DEFAULT GETDATE(),
    CONSTRAINT FK_Events_Organiser FOREIGN KEY (OrganiserId) REFERENCES Users(UserId),
    CONSTRAINT FK_Events_EventType FOREIGN KEY (EventTypeId) REFERENCES EventTypes(EventTypeId)
);
GO

CREATE TABLE Categories (
    CategoryId      INT IDENTITY(1,1) PRIMARY KEY,
    EventId         INT             NOT NULL,
    Name            VARCHAR(50)     NOT NULL,
    MinAge          INT             NULL,
    MaxAge          INT             NULL,
    DistanceKm      DECIMAL(6,2)    NULL,
    CONSTRAINT FK_Categories_Event FOREIGN KEY (EventId) REFERENCES Events(EventId) ON DELETE CASCADE
);
GO

CREATE TABLE Enrolments (
    EnrolmentId     INT IDENTITY(1,1) PRIMARY KEY,
    ParticipantId   INT             NOT NULL,
    EventId         INT             NOT NULL,
    CategoryId      INT             NOT NULL,
    EnrolmentDate   DATETIME        NOT NULL DEFAULT GETDATE(),
    Status          VARCHAR(20)     NOT NULL DEFAULT 'Pending' CHECK (Status IN ('Pending', 'Confirmed', 'Cancelled')),
    CONSTRAINT FK_Enrolments_Participant FOREIGN KEY (ParticipantId) REFERENCES Users(UserId),
    CONSTRAINT FK_Enrolments_Event FOREIGN KEY (EventId) REFERENCES Events(EventId),
    CONSTRAINT FK_Enrolments_Category FOREIGN KEY (CategoryId) REFERENCES Categories(CategoryId),
    CONSTRAINT UQ_Enrolments_Participant_Event UNIQUE (ParticipantId, EventId)
);
GO

CREATE TABLE Results (
    ResultId               INT IDENTITY(1,1) PRIMARY KEY,
    EnrolmentId            INT             NOT NULL UNIQUE,
    RecordedByOrganiserId  INT             NOT NULL,
    FinishTime             TIME            NOT NULL,
    FinishPosition          INT             NOT NULL,
    RecordedAt             DATETIME        NOT NULL DEFAULT GETDATE(),
    CONSTRAINT FK_Results_Enrolment FOREIGN KEY (EnrolmentId) REFERENCES Enrolments(EnrolmentId) ON DELETE CASCADE,
    CONSTRAINT FK_Results_Organiser FOREIGN KEY (RecordedByOrganiserId) REFERENCES Users(UserId)
);
GO

/* =====================================================================
   SEED DATA
   ===================================================================== */

-- Event Types
INSERT INTO EventTypes (TypeName) VALUES ('Run'), ('Walk'), ('Cycle');
GO

-- Users: 2 Organisers, 2 Participants
-- NOTE: PasswordHash values below are placeholders. In Part 2, replace
-- these with real hashes produced by your API's hashing library.
INSERT INTO Users (FirstName, LastName, Email, PasswordHash, Role, PhoneNumber)
VALUES
    ('Thandi', 'Nkosi', 'thandi.nkosi@raceday.co.za', 'HASHED_PASSWORD_1', 'Organiser', '0821234567'),
    ('Johan', 'van der Merwe', 'johan.vdm@raceday.co.za', 'HASHED_PASSWORD_2', 'Organiser', '0827654321'),
    ('Lerato', 'Dube', 'lerato.dube@example.com', 'HASHED_PASSWORD_3', 'Participant', '0731122334'),
    ('Ryan', 'Adams', 'ryan.adams@example.com', 'HASHED_PASSWORD_4', 'Participant', '0739988776');
GO

-- Events: 3 events, one per Organiser/type
INSERT INTO Events (OrganiserId, EventTypeId, Name, Description, EventDate, Location, DistanceKm)
VALUES
    (1, 1, 'Cape Town City Run', 'A scenic road run through the city bowl.', '2026-11-15 07:00:00', 'Cape Town, Western Cape', 21.1),
    (1, 3, 'Table Bay Cycle Challenge', 'A coastal cycling event for all skill levels.', '2026-10-04 06:30:00', 'Cape Town, Western Cape', 60.0),
    (2, 2, 'Pretoria Community Walk', 'A family-friendly charity walk.', '2026-09-20 08:00:00', 'Pretoria, Gauteng', 5.0);
GO

-- Categories: at least one per event
INSERT INTO Categories (EventId, Name, MinAge, MaxAge, DistanceKm)
VALUES
    (1, 'Senior 21km', 20, 59, 21.1),
    (1, 'Junior 10km', 12, 19, 10.0),
    (2, 'Open 60km', 16, NULL, 60.0),
    (3, 'Open 5km', NULL, NULL, 5.0),
    (3, 'Under 12', NULL, 11, 5.0);
GO

-- Enrolments: sample Participant sign-ups
INSERT INTO Enrolments (ParticipantId, EventId, CategoryId, Status)
VALUES
    (3, 1, 1, 'Confirmed'),  -- Lerato enrolled in Cape Town City Run, Senior 21km
    (4, 1, 1, 'Pending'),    -- Ryan enrolled in Cape Town City Run, Senior 21km
    (3, 3, 4, 'Confirmed');  -- Lerato enrolled in Pretoria Community Walk, Open 5km
GO

-- Results: sample captured result for a completed enrolment
INSERT INTO Results (EnrolmentId, RecordedByOrganiserId, FinishTime, FinishPosition)
VALUES
    (1, 1, '01:48:32', 47);
GO