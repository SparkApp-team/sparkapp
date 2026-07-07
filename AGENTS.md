# AGENTS.md

## Repo Purpose

SparkApp is a habit-tracking monorepo with a Java Spring Boot backend, a SwiftUI iOS client, and shared API documentation.

## Detected Repository Structure

```text
backend/sparkapi/                  Spring Boot REST API using Maven
ios/SparkApp/                      SwiftUI iOS app with an Xcode project
docs/api.md                        Shared API contract
docs/requests.http                 HTTP request examples
.github/CODEOWNERS                 Current code ownership rules
compose.yaml                       Backend/ngrok Docker Compose setup
compose.debug.yaml                 Debug Compose override
```

No web frontend, GitHub Actions workflow, or database migration directory is currently present.

## Build And Test Commands

Backend:

```bash
cd backend/sparkapi
./mvnw test
./mvnw spring-boot:run
```

Windows backend equivalents:

```powershell
cd backend\sparkapi
.\mvnw.cmd test
.\mvnw.cmd spring-boot:run
```

Docker backend/ngrok environment:

```bash
docker compose up -d --build
docker compose ps
docker compose logs -f
docker compose down
docker compose -f compose.yaml -f compose.debug.yaml up -d --build
```

iOS:

```text
Open ios/SparkApp/SparkApp.xcodeproj in Xcode and run a shared SparkApp scheme.
```

Reliable command-line iOS build/test command: Not yet defined.

CI:

```text
Not yet defined.
```

## Branch Naming

Use:

```text
<type>/<area>/<optional-issue-number>-<short-kebab-description>
```

Allowed types:

```text
feature
fix
chore
docs
test
refactor
spike
ci
deps
```

Allowed areas:

```text
backend
ios
api
db
auth
repo
infra
docs
```

Examples:

```text
feature/backend/12-create-habit-endpoint
feature/ios/13-habit-list-screen
docs/api/14-habit-contract
fix/backend/18-streak-timezone-bug
refactor/backend/habit-service
chore/repo/github-templates
ci/backend/maven-build
deps/backend/spring-boot-upgrade
spike/auth/session-strategy
test/backend/habit-service-tests
```

## Issue Template To Branch Mapping

```text
Backend task       -> feature/backend/..., fix/backend/..., test/backend/..., refactor/backend/...
iOS task           -> feature/ios/..., fix/ios/..., test/ios/..., refactor/ios/...
API contract       -> docs/api/..., feature/api/..., chore/api/...
Bug report         -> fix/<area>/...
Tech debt/refactor -> refactor/<area>/... or chore/repo/...
Spike/research     -> spike/<area>/...
CI work            -> ci/<area>/...
Dependency updates -> deps/<area>/...
Repo maintenance   -> chore/repo/...
Documentation      -> docs/<area>/...
```

Prefer one issue = one branch = one PR. Tiny maintenance PRs may skip an issue.

## Commit Convention

Use Conventional Commits:

```text
type(scope): short summary
```

Allowed types:

```text
feat
fix
docs
style
refactor
test
chore
ci
build
perf
deps
```

Preferred scopes:

```text
backend
ios
api
db
auth
users
habits
streaks
notifications
ci
infra
docs
tests
repo
deps
```

Other valid lowercase kebab-case scopes are allowed.

## PR Expectations

PRs should be small and focused, target `main`, use the PR template, and link an issue with `Closes #` unless the change is tiny repo maintenance. Include what was tested and call out any API contract changes.

## Verification Checklist

Before finishing a Codex run:

```text
Review git diff.
Run relevant safe tests when available.
For backend changes, prefer backend/sparkapi Maven tests.
For API changes, update docs/api.md or explain why not needed.
For iOS changes, state whether Xcode/manual verification was possible.
Confirm no secrets, .env files, generated files, or IDE junk were added.
```

## Constraints For Future Codex Runs

```text
Do not commit secrets.
Do not modify unrelated files.
Prefer small focused PRs.
Prefer one issue = one branch = one PR.
Tiny maintenance PRs may skip an issue.
Branch area should match the issue area/template where possible.
Ask before adding new production dependencies unless explicitly requested.
Do not invent project paths or commands.
Do not document web/frontend as active unless it exists.
Do not rename existing project structure unless explicitly requested.
```
