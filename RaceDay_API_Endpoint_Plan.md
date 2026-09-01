# RaceDay API Endpoint Plan

**Module:** PROG6212 — Programming 2B
**Part:** 1, Section B
**Roles referenced:** `Organiser`, `Participant`, `Any` (any authenticated user), `None` (public)

---

## 1. Authentication

| HTTP Method | Route | Description | Role Required | Request Body | Expected Response |
|---|---|---|---|---|---|
| POST | /api/auth/register | Registers a new user as either an Organiser or a Participant and hashes their password before saving. | None | `{ firstName, lastName, email, password, role, phoneNumber }` | 201 Created — new user (no password returned) · 400 Bad Request — validation failed · 409 Conflict — email already registered |
| POST | /api/auth/login | Authenticates a user's credentials and starts a session storing the user's ID and role. | None | `{ email, password }` | 200 OK — session started, user summary returned · 401 Unauthorized — invalid credentials |
| POST | /api/auth/logout | Ends the current user's session. | Any | None | 200 OK — session cleared |

## 2. User Profile

| HTTP Method | Route | Description | Role Required | Request Body | Expected Response |
|---|---|---|---|---|---|
| GET | /api/users/me | Returns the profile of the currently logged-in user. | Any | None | 200 OK — user profile · 401 Unauthorized — no active session |
| PUT | /api/users/me | Updates the logged-in user's own profile details. | Any | `{ firstName, lastName, phoneNumber }` | 200 OK — updated profile · 400 Bad Request — validation failed |
| PUT | /api/users/me/profile-picture | Uploads/replaces the logged-in Participant's profile picture. | Participant | `multipart/form-data: file` | 200 OK — updated profile picture URL · 400 Bad Request — invalid file |

## 3. Events

| HTTP Method | Route | Description | Role Required | Request Body | Expected Response |
|---|---|---|---|---|---|
| GET | /api/events | Lists all events, with optional filtering (date, event type, location). | Any | None | 200 OK — list of events |
| GET | /api/events/{id} | Returns full detail for a single event, including its categories. | Any | None | 200 OK — event detail · 404 Not Found |
| POST | /api/events | Creates a new event owned by the logged-in Organiser. | Organiser | `{ name, description, eventDate, location, distanceKm, eventTypeId }` | 201 Created — new event · 400 Bad Request |
| PUT | /api/events/{id} | Updates an event owned by the logged-in Organiser. | Organiser | `{ name, description, eventDate, location, distanceKm, eventTypeId }` | 200 OK — updated event · 403 Forbidden — not the owning Organiser · 404 Not Found |
| DELETE | /api/events/{id} | Deletes an event owned by the logged-in Organiser. | Organiser | None | 204 No Content · 403 Forbidden · 404 Not Found |
| POST | /api/events/{id}/banner | Uploads/replaces the banner image for an event, stored in Azure Blob Storage. | Organiser | `multipart/form-data: file` | 200 OK — banner image URL · 403 Forbidden · 404 Not Found |
| GET | /api/events/mine | Lists all events created by the logged-in Organiser (for the dashboard). | Organiser | None | 200 OK — list of the Organiser's events |

## 4. Categories

| HTTP Method | Route | Description | Role Required | Request Body | Expected Response |
|---|---|---|---|---|---|
| GET | /api/events/{eventId}/categories | Lists all categories available for a given event. | Any | None | 200 OK — list of categories · 404 Not Found |
| POST | /api/events/{eventId}/categories | Adds a new age/distance category to an event owned by the logged-in Organiser. | Organiser | `{ name, minAge, maxAge, distanceKm }` | 201 Created — new category · 403 Forbidden · 404 Not Found |
| PUT | /api/categories/{id} | Updates a category belonging to an event owned by the logged-in Organiser. | Organiser | `{ name, minAge, maxAge, distanceKm }` | 200 OK — updated category · 403 Forbidden · 404 Not Found |
| DELETE | /api/categories/{id} | Deletes a category from an event owned by the logged-in Organiser. | Organiser | None | 204 No Content · 403 Forbidden · 404 Not Found |

## 5. Event Enrolments

| HTTP Method | Route | Description | Role Required | Request Body | Expected Response |
|---|---|---|---|---|---|
| POST | /api/events/{eventId}/enrolments | Enrols the logged-in Participant into an event under a chosen category. | Participant | `{ categoryId }` | 201 Created — new enrolment · 404 Not Found — event/category does not exist · 409 Conflict — already enrolled in this event |
| GET | /api/users/me/enrolments | Lists all events the logged-in Participant has enrolled in, with status. | Participant | None | 200 OK — list of the Participant's enrolments |
| GET | /api/events/{eventId}/enrolments | Lists all Participants enrolled in a specific event owned by the logged-in Organiser. | Organiser | None | 200 OK — list of enrolments · 403 Forbidden · 404 Not Found |
| PUT | /api/enrolments/{id}/status | Updates an enrolment's status (e.g. Confirmed/Cancelled) for an event owned by the logged-in Organiser. | Organiser | `{ status }` | 200 OK — updated enrolment · 403 Forbidden · 404 Not Found |

## 6. Results

| HTTP Method | Route | Description | Role Required | Request Body | Expected Response |
|---|---|---|---|---|---|
| POST | /api/enrolments/{enrolmentId}/result | Captures the finish time and finishing position for a Participant's enrolment, for an event owned by the logged-in Organiser. | Organiser | `{ finishTime, finishPosition }` | 201 Created — new result · 403 Forbidden · 404 Not Found · 409 Conflict — result already captured |
| PUT | /api/results/{id} | Corrects an already-captured result for an event owned by the logged-in Organiser. | Organiser | `{ finishTime, finishPosition }` | 200 OK — updated result · 403 Forbidden · 404 Not Found |
| GET | /api/users/me/results | Returns the logged-in Participant's personal race history across all events they have completed. | Participant | None | 200 OK — list of results with event name, date, category, finish time, and position |
| GET | /api/events/{eventId}/results | Lists all published results for a specific event owned by the logged-in Organiser. | Organiser | None | 200 OK — list of results · 403 Forbidden · 404 Not Found |
