# SparkApp API

This document describes the current backend API exposed by `backend/sparkapi`.

## Base URL

Local development:

```text
http://localhost:8081
```

The port is currently configured in `backend/sparkapi/src/main/resources/application.properties`.

## Error response format

Handled API errors use this JSON envelope:

```json
{
  "timestamp": "2026-07-12T10:15:30.123Z",
  "status": 400,
  "error": "Bad Request",
  "message": "Validation failed",
  "path": "/auth/register",
  "fieldErrors": {
    "email": "Email must be valid"
  }
}
```

Error response fields:

- `timestamp` (`string`): UTC time at which the error response was created, in ISO-8601 format.
- `status` (`number`): HTTP status code.
- `error` (`string`): HTTP status reason phrase.
- `message` (`string`): Summary of the error.
- `path` (`string`): Request path that produced the error.
- `fieldErrors` (`object`): Field name to validation-message mapping. This is empty when the error is not tied to a request field.

For request-validation errors, `message` is `"Validation failed"` and `fieldErrors` contains the first error for each invalid field. For example, mismatched registration passwords return `400 Bad Request` with `fieldErrors.passwordConfirmation` set to `"Passwords do not match"`.

## Endpoints

### `GET /health`

Purpose:
Returns a simple backend health response so clients can verify that the API is running and reachable.

Response:

- Status: `200 OK`
- Content-Type: `application/json`

Example response:

```json
{
  "status": "ok"
}
```

Response fields:

- `status` (`string`): Current health indicator for the API.


### `POST /auth/register`

Purpose:
Registers a user when the supplied password and password confirmation match. The backend hashes the password through the current fake hash service and persists only the resulting hash.

Request:

- Content-Type: `application/json`

Example request:

```json
{
  "email": "your@email.com",
  "password": "password",
  "passwordConfirmation": "password"
}
```
Request fields:

- `email` (`string`, required): Nonblank, valid email address.
- `password` (`string`, required): Nonblank password containing at least 8 characters. Only its generated hash is stored.
- `passwordConfirmation` (`string`, required): Nonblank repetition of `password`; it must match exactly and is not persisted.

Response:

- Status: `200 OK`
- Content-Type: `application/json`

Example response:

```json
{
  "id": 1,
  "email": "your@email.com"
}
```

Response fields:

- `id` (`string`): Generated user ID. Store this value on the client and send it as `X-USER-ID` for fake-auth endpoints.
- `email` (`string`): User email.

Error responses:

- `400 Bad Request`: A required field is blank, the email is invalid, the password is shorter than 8 characters, or the passwords do not match.
- `409 Conflict`: The email address is already registered.

For a password mismatch, the error is associated with the `passwordConfirmation` field. For a duplicate email, it is associated with the `email` field.


### `POST /auth/login`

Purpose:
Authenticates an existing user and returns the temporary fake-auth user token.

Request:

- Content-Type: `application/json`

Example request:

```json
{
  "email": "your@email.com",
  "password": "password"
}
```

Request fields:

- `email` (`string`, required): Nonblank registered email address.
- `password` (`string`, required): Nonblank plain-text password.

Response:

- Status: `200 OK`
- Content-Type: `application/json`

Example response:

```json
{
  "id": 1,
  "email": "your@email.com"
}
```

Error responses:

- `400 Bad Request`: Email or password is blank.
- `401 Unauthorized`: The email is unknown or the password is incorrect.

For invalid credentials, `message` is `"Invalid email or password"` and `fieldErrors` is empty.


### `GET /users/me`

Purpose:
Returns the current user identified by the temporary fake-auth `X-USER-ID` header.

Request:

- Required header: `X-USER-ID`

Example request header:

```text
X-USER-ID: 1
```

Response:

- Status: `200 OK`
- Content-Type: `application/json`

Example response:

```json
{
  "id" : 1,
  "email": "your@email.com"
}
```

Response fields:

- `id` (`number`): Current user ID from the fake-auth header.
- `email` (`string`): Current user email.

Error responses:

- `404 Not Found`: No user exists for the current fake-auth user ID. The response message is `"User not found"` and `fieldErrors` is empty.


### `POST /habits`

Purpose:
Creates a habit for the current fake-auth user identified by the `X-USER-ID` header.

Request:

- Content-Type: `application/json`
- Required header: `X-USER-ID`

Example request header:

```text
X-USER-ID: 1
```

Example request:

```json
{
  "name": "Drink water",
  "frequency": "daily"
}
```

Request fields:

- `name` (`string`): Habit name.
- `frequency` (`string`): Habit frequency.

Error responses:

- `400 Bad Request`: `name` or `frequency` is blank.

Response:

- Status: `201 Created`
- Content-Type: `application/json`

Example response:

```json
{
  "id": 1,
  "userId": 1,
  "name": "Drink water",
  "frequency": "daily"
}
```

Response fields:

- `id` (`number`): Generated habit ID.
- `userId` (`number`): User ID that owns the habit.
- `name` (`string`): Habit name.
- `frequency` (`string`): Habit frequency.


### `GET /habits/{habitId}`

Purpose:
Returns one habit owned by the current fake-auth user. A habit owned by another user is treated as not found.

Request:

- Required header: `X-USER-ID`
- Path parameter: `habitId` (`number`, positive)

Example request:

```text
GET /habits/1
X-USER-ID: 1
```

Response:

- Status: `200 OK`
- Content-Type: `application/json`

Example response:

```json
{
  "id": 1,
  "userId": 1,
  "name": "Drink water",
  "frequency": "daily"
}
```

Error responses:

- `400 Bad Request`: `habitId` is not a positive number.
- `404 Not Found`: The habit does not exist or is not owned by the current user. The response message is `"Habit not found"`.


### `PUT /habits/{habitId}`

Purpose:
Replaces the editable fields of a habit owned by the current fake-auth user.

Request:

- Content-Type: `application/json`
- Required header: `X-USER-ID`
- Path parameter: `habitId` (`number`, positive)

Example request:

```json
{
  "name": "Exercise",
  "frequency": "weekly"
}
```

Request fields:

- `name` (`string`, required): Nonblank replacement habit name.
- `frequency` (`string`, required): Nonblank replacement habit frequency.

Response:

- Status: `200 OK`
- Content-Type: `application/json`

Example response:

```json
{
  "id": 1,
  "userId": 1,
  "name": "Exercise",
  "frequency": "weekly"
}
```

Error responses:

- `400 Bad Request`: `habitId` is not positive, or `name` or `frequency` is blank.
- `404 Not Found`: The habit does not exist or is not owned by the current user. The response message is `"Habit not found"`.


### `DELETE /habits/{habitId}`

Purpose:
Deletes a habit owned by the current fake-auth user.

Request:

- Required header: `X-USER-ID`
- Path parameter: `habitId` (`number`, positive)

Example request:

```text
DELETE /habits/1
X-USER-ID: 1
```

Response:

- Status: `204 No Content`
- Body: none

Error responses:

- `400 Bad Request`: `habitId` is not a positive number.
- `404 Not Found`: The habit does not exist or is not owned by the current user. The response message is `"Habit not found"`.


### `GET /habits`

Purpose:
Returns all habits owned by the current fake-auth user identified by the `X-USER-ID` header.

Request:

- Required header: `X-USER-ID`

Example request header:

```text
X-USER-ID: 1
```

Response:

- Status: `200 OK`
- Content-Type: `application/json`

Example response:

```json
[
  {
    "id": 1,
    "userId": 1,
    "name": "Drink water",
    "frequency": "daily"
  }
]
```

Response fields:

- `id` (`number`): Habit ID.
- `userId` (`number`): User ID that owns the habit.
- `name` (`string`): Habit name.
- `frequency` (`string`): Habit frequency.

## Notes

- This API is in an early stage and currently exposes health checks, registration, login, current-user lookup, and habit CRUD operations.
- User and habit records are persisted through JPA.
- Authentication is currently fake: `X-USER-ID` is parsed as the current numeric user ID.
- Password hashing is currently fake: the fake hash service reverses the submitted password string.
