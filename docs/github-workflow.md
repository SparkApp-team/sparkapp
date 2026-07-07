# GitHub Workflow

SparkApp uses a lightweight workflow for a small Spring Boot backend and SwiftUI iOS app:

```text
issue -> branch -> commits -> PR -> squash merge -> closed issue
```

The goal is to keep work visible and reviewable without adding unnecessary process.

## Issues

Use an issue for normal feature work, bugs, API contract changes, refactors, spikes, CI work, and dependency updates.

Tiny maintenance PRs may skip an issue when the change is obvious and low risk, for example:

```text
docs/repo/fix-readme-typo
chore/repo/update-gitignore
```

Default rule:

```text
one issue -> one branch -> one PR
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

## Branch Names

Use:

```text
<type>/<area>/<optional-issue-number>-<short-kebab-description>
```

Allowed branch types:

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

Allowed branch areas:

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

Use `ios` for the SwiftUI app. Do not use `frontend` for iOS work. Keep descriptions short, lowercase, and kebab-case.

Valid examples:

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

Invalid examples:

```text
feature/frontend/habits
backend-fix
feature/backend/AddHabitEndpoint
my-random-branch
```

Local hook regex:

```regex
^(main|dependabot/.+|release/v[0-9]+(\.[0-9]+){1,2}|(feature|fix|chore|docs|test|refactor|spike|ci|deps)/(backend|ios|api|db|auth|repo|infra|docs)/([0-9]+-)?[a-z0-9]+(-[a-z0-9]+)*)$
```

GitHub ruleset-compatible regex:

```regex
^(main|dependabot\/.+|release\/v[0-9]+(\.[0-9]+){1,2}|(feature|fix|chore|docs|test|refactor|spike|ci|deps)\/(backend|ios|api|db|auth|repo|infra|docs)\/([0-9]+-)?[a-z0-9]+(-[a-z0-9]+)*)\n?$
```

## Commit Messages

Use Conventional Commits:

```text
type(scope): short summary
```

Allowed commit types:

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

Other valid lowercase kebab-case scopes are allowed as the app grows.

Valid examples:

```text
feat(habits): add create habit endpoint
fix(streaks): handle timezone boundary
test(backend): add habit service tests
chore(repo): add issue templates
ci(backend): add Maven build workflow
docs(api): document habit contract
feat(onboarding): add first-run setup
fix(profile): handle missing display name
refactor(settings): split notification preferences
```

Invalid examples:

```text
added stuff
fix bug
feat: add habits
feature(habits): add endpoint
feat(Habits): add endpoint
```

Merge, revert, fixup, and squash commit messages are allowed by the local hook.

## Local Hooks

Enable the repo hooks once per clone:

```bash
git config core.hooksPath .githooks
```

The hooks validate branch names before push and commit message format when committing.

Test the branch hook manually:

```bash
.githooks/pre-push
```

Test the commit message hook manually:

```bash
printf "feat(habits): add create habit endpoint\n" > /tmp/commit-msg-ok
.githooks/commit-msg /tmp/commit-msg-ok
printf "feat: add habits\n" > /tmp/commit-msg-bad
.githooks/commit-msg /tmp/commit-msg-bad
```

On Windows, run the hooks from Git Bash or another POSIX-compatible shell.

## Pull Requests

Open PRs into `main`. Keep PRs focused and link the issue with `Closes #123` unless it is a tiny maintenance PR.

Before requesting review:

```text
Branch name follows the convention.
Branch area matches the issue area/template where possible.
Builds/tests were run locally, or the reason is explained.
API changes are reflected in docs/api.md.
No secrets, .env files, generated files, or IDE junk are committed.
```

## Manual GitHub Settings

Configure these in GitHub:

```text
Protect main
Require pull request before merge
Require at least 1 approval
Require status checks before merge, once CI exists
Block force pushes
Block deletions
Require linear history
Enable squash merge
Optionally disable merge commits
Auto-delete merged branches
Add branch-name ruleset using the documented GitHub-compatible regex
Start the branch-name ruleset in Evaluate mode first, then switch to Active after confirming it works
```

No GitHub Actions workflows exist yet. Status checks should be required after CI is added.
