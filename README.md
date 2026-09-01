# PROG-6112-PART-1

# RaceDay — Part 1: System Planning and Database

**Module:** PROG6212 — Programming 2B
**Part:** 1 of 3 (System Planning and Database)

## System Description

RaceDay is a full-stack event management platform for South Africa's road running, walking,
and cycling community. It replaces the paper-based registration and spreadsheet tracking
many local events still rely on. Event Organisers can create and manage events, define
categories, and capture participant results. Participants can browse upcoming events, enter
events by selecting a category, track their personal enrolment and results history, and view
event details ahead of race day.

This part of the project covers the planning phase only: no application code is written here.
The `/docs` folder contains the Entity Relationship Diagram, the API endpoint plan, and the
SQL script used to create and seed the database — all three are designed to match each other
exactly, since that consistency is what Part 2's implementation will be built against.

## Roles

- **Organiser** — creates, edits, and deletes events; manages event categories; captures
  participant results after an event; views all enrolments for their own events.
- **Participant** — creates an account; browses events; enters an event by selecting a
  category; views their own enrolment history; views their own results (finish time and
  finishing position) after an Organiser publishes them.

## /docs Contents

| File | Description |
|---|---|
| `RaceDay_ERD.png` | Entity Relationship Diagram — 6 entities, all primary/foreign keys and cardinality shown |
| `RaceDay_API_Endpoint_Plan.md` | Full endpoint plan covering Authentication, User Profile, Events, Categories, Event Enrolments, and Results |
| `RaceDay_Database_Script.sql` | SQL Server script that creates the schema and seeds sample data (2 Organisers, 2 Participants, 3 Events, categories, and enrolments) |

## Running the SQL Script

1. Open the script in SQL Server Management Studio (SSMS).
2. Make sure your query window's active database is `master` before running it — the script
   drops and recreates `RaceDayDB`, which SQL Server won't allow if your session is currently
   inside that database.
3. Press F5 / Execute. The script creates `RaceDayDB`, builds all six tables with constraints,
   and seeds sample data.
4. To inspect the seed data, run `SELECT * FROM <table>` for each table in a new query window
   connected to `RaceDayDB`.

## CI/CD

<img width="1432" height="397" alt="CI-CD" src="https://github.com/user-attachments/assets/170b7fda-be00-496a-8179-6a358e737ef8" />



## Video Walkthrough

<!-- Add your unlisted YouTube link here — walk through the ERD decisions, endpoint plan
     choices, and run the SQL script live in SSMS. -->
[Watch the Part 1 walkthrough](YOUR_YOUTUBE_LINK_HERE)

## AI Disclosure

AI assistance (Claude) was used in drafting the initial ERD, endpoint plan, and SQL script.
All three were reviewed, tested against a live SQL Server instance, and adjusted before
submission.
