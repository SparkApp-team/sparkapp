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
Creates a mocked user response from the provided email. This endpoint does not persist users yet.

Request:

- Content-Type: `application/json`

Example request:

```json
{
  "email": "your@email.com"
}
```
Request fields:
- `email` (`string`): Email address for the mocked user.

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

- `id` (`string`): Mocked user ID.
- `email` (`string`): User email.

## Notes

```md
- This API is in an early stage and currently exposes health checks and mocked user creation.