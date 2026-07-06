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
- Required header: `X-USER-ID`

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

Request headers:

- `X-USER-ID` (`string`): Temporary fake-auth user ID header. The current fake auth service returns this value as the current user ID.

Response:

- Status: `200 OK`
- Content-Type: `application/json`

Example response:

```json
{
  "id": "1",
  "email": "your@email.com"
}
```

Response fields:

- `id` (`string`): Generated user ID.
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
  "id": "1",
  "email": "your@email.com"
}
```

Response fields:

- `id` (`string`): Current user ID.
- `email` (`string`): Current user email.

## Notes

- This API is in an early stage and currently exposes health checks, basic user creation, and a current-user lookup.
- User records are persisted through JPA.
- Authentication is currently fake: `X-USER-ID` is treated as the current user ID.
- Password hashing is currently fake: the fake hash service reverses the submitted password string.
