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
Creates a user from the provided email and persists it through the JPA `UserRepository`.

Request:

- Content-Type: `application/json`

Example request:

```json
{
  "email": "your@email.com"
}
```
Request fields:

- `email` (`string`): Email address for the user.

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

## Notes

- This API is in an early stage and currently exposes health checks and basic user creation.
- User records are persisted through JPA.
- No real authentication or password handling exists yet. The backend currently stores a placeholder `passwordHash` value internally.
