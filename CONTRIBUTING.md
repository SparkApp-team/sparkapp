# Contributing to SparkApp

Welcome to **SparkApp-team** 👋  
This document explains how we work on this project together.

SparkApp is a small habit tracker built with:

- **Backend:** Java + Spring Boot (in `backend/`)
- **iOS app:** Swift + SwiftUI (in `ios/`)

The goal is to practice real-world collaboration: issues, branches, pull requests, reviews.

---

## 1. How we work

- All work happens through **issues** and **pull requests**.
- We do **not** push directly to `main`.
- Each task should be **small** (1–3 hours).
- We try to keep code **simple and readable**, not “clever”.

If something is unclear, we ask in chat instead of guessing for days.

---

## 2. Repository structure

```text
sparkapp/
  backend/   # Spring Boot backend
  ios/       # SwiftUI iOS app
  docs/      # API contract, notes, diagrams
````

Each folder has its own `README.md` with setup instructions.

---

## 3. Issues and the board

We use GitHub **Issues** + **Project board**.

* Every piece of work starts as an **issue**.
* Issues are added to the board and move through:

  * `Backlog` → `In Progress` → `Done`
* Issues should have:

  * Short title
  * Clear description
  * Acceptance criteria (what “done” means)

Example issue:

> **Title:** Add /health endpoint
> **Description:**
>
> * Create `GET /health` in backend
> * Return `{ "status": "ok" }`
> * Add basic test or manual check steps

---

## 4. Branches

We use feature branches:

* Start from `main`
* Branch names:

  * `feature/...` for new features
  * `bugfix/...` for fixes
  * `chore/...` for maintenance

Examples:

* `feature/backend-health-endpoint`
* `feature/ios-habit-list-screen`
* `bugfix/ios-api-decoding-error`

**Never** work directly on `main`.

---

## 5. Commits

Keep commits small and messages clear.

Format (not strict, just a guide):

* `backend: add health endpoint`
* `ios: connect health check to API`
* `docs: update api.md with habits`

A good commit:

* Does one logical thing
* Compiles / builds
* Doesn’t mix unrelated changes

---

## 6. Pull requests

For every branch, open a **pull request** into `main`.

PR checklist:

* Small scope (ideally 50–200 lines changed)
* Linked issue (`Fixes #123` or `Closes #123`)
* Short description of what changed
* How to test it (steps or screenshots if UI)

Example description:

> **Summary**
>
> * Added `GET /health` endpoint in backend
> * Returns `{ "status": "ok" }`
>
> **Testing**
>
> * Run backend
> * Open `http://localhost:8080/health`
> * See JSON with `"status": "ok"`

At least **one review** from the other person is required before merging.

---

## 7. Code review

When reviewing a PR:

* Be kind and specific.
* Focus on:

  * Correctness
  * Clarity
  * Simplicity
  * Naming
* It’s okay to ask: “Can you explain why you chose this approach?”

Good review comments:

* “Could we rename this method to `findByUserId` so it’s clearer?”
* “Can we handle the case where the response is empty?”
* “Maybe move this constant to a separate file?”

The goal is to learn, not to “win” reviews.

---

## 8. Backend guidelines (Java / Spring Boot)

* Keep controllers thin: they should mainly handle HTTP and delegate to services.
* Use meaningful package structure, for example:

  * `controller`, `service`, `repository`, `model`, `dto`
* Avoid magic strings; prefer constants or enums where it makes sense.
* Keep endpoints documented in `docs/api.md`.
* When you change or add an endpoint:

  * Update `docs/api.md`
  * Mention it in the PR description

---

## 9. iOS guidelines (Swift / SwiftUI)

* Use clear file names: `LoginView`, `HabitListView`, `HabitDetailView`.
* Group code by feature when possible (e.g. `/Features/Login`, `/Features/Habits`).
* Keep networking logic separate from views (e.g. `ApiClient`, `HabitService`).
* Handle loading and error states, even in a simple way (e.g. text labels).

---

## 10. Docs

We keep shared docs in `docs/`:

* `api.md` – REST API contract (endpoints, payloads, examples)
* `architecture.md` (optional) – simple diagrams or notes
* Any planning notes we want to keep

Try to keep docs **short and up to date**.
If code and docs differ, we fix docs as soon as possible.

---

## 11. Communication

Questions, blockers, or confusion:

* Ping the other person in chat (Telegram / Discord / etc.)
* Or leave a comment on the issue / PR

It’s better to ask early than to rework things later.

---

## 12. New ideas

If you have a new feature idea:

1. Create an issue in the Backlog.
2. Describe the idea and why it’s useful.
3. Discuss it briefly together.
4. If you both agree, move it up the priority list.

---

