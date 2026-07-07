# SparkApp API

This document describes the current backend API exposed by `backend/sparkapi`.

## Base URL

Local development:

```text
http://localhost:8081
```

The port is currently configured in `backend/sparkapi/src/main/resources/application.properties`.

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


### `POST /users`

Purpose:
Creates a user from the provided email and password, hashes the password through the current fake hash service, and persists the user through the JPA `UserRepository`.

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

- `email` (`string`): Email address for the user.
- `password` (`string`): Plain-text password submitted by the client. The current backend stores only the generated password hash internally.

Response:

- Status: `200 OK`
- Content-Type: `application/json`

Example response:

```json
{
  "userId": "1",
  "email": "your@email.com"
}
```

Response fields:

- `userId` (`string`): Generated user ID. Store this value on the client and send it as `X-USER-ID` for fake-auth endpoints.
- `email` (`string`): User email.


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
  "userId": "1",
  "email": "your@email.com"
}
```

Response fields:

- `userId` (`string`): Current user ID from the fake-auth header.
- `email` (`string`): Current user email.


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

Response fields:

- `id` (`number`): Generated habit ID.
- `userId` (`number`): User ID that owns the habit.
- `name` (`string`): Habit name.
- `frequency` (`string`): Habit frequency.


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

- This API is in an early stage and currently exposes health checks, basic user creation, current-user lookup, habit creation, and habit listing.
- User and habit records are persisted through JPA.
- Authentication is currently fake: `X-USER-ID` is parsed as the current numeric user ID.
- Password hashing is currently fake: the fake hash service reverses the submitted password string.
