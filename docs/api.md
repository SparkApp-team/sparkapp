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

## Notes

- This API is in an early stage and currently exposes only the health endpoint.
- Future endpoint changes should update this document in the same branch as the code change.
