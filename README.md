# **SparkApp**

SparkApp is a habit-tracking application built collaboratively by **SparkApp-team**.
The goal of the project is to learn real-world team workflows while building a clean, modern MVP consisting of:

* a **Java Spring Boot backend** (REST API)
* a **SwiftUI iOS client**
* shared documentation and API contracts

The project is structured as a monorepo so both sides evolve together.

---

## **Repository Structure**

```
sparkapp/
  backend/    # Java + Spring Boot backend (REST API)
  ios/        # SwiftUI iOS application
  docs/       # API contract, diagrams, shared notes
  README.md   # You're here
```

Each folder includes its own README with setup instructions.

---

## **Technology Stack**

### Backend

* Java 17+
* Spring Boot
* Spring Web, Spring Data JPA
* PostgreSQL (later), H2 (initially)
* Gradle or Maven (developer choice)

### iOS App

* Swift
* SwiftUI
* URLSession for networking
* MVVM-style state management

---

## **Project Goals**

* Practice team collaboration (issues → branches → pull requests → reviews).
* Build a real full-stack product with shared API responsibilities.
* Apply proper version control + GitHub workflow.
* Keep tasks small and trackable with a Kanban board.
* Produce a portfolio-ready project for both members.

---

## **Workflow Overview**

We use:

* **GitHub Issues** for tasks
* **GitHub Projects Kanban** for workflow
* **Pull requests** for all code changes
* **Branch protection** on `main`
* **Labels** for filtering
* **Milestones** for grouping features

Full collaboration rules are in [`CONTRIBUTING.md`](./CONTRIBUTING.md).

---

## **Getting Started**

### Backend

Navigate into `backend/sparkapi/` and follow the instructions in its README.
Once initialized, you can run the backend locally:

```
mvn spring-boot:run
```

### Docker

Docker support is for the Spring Boot backend. The iOS app is not Dockerized because it requires Xcode/macOS tooling.

The Docker setup also starts an ngrok tunnel so the backend can be reached from the Swift app through a stable HTTPS URL.

Before starting Docker, create a local `.env` file from the example:

```
cp .env.example .env
```

Fill in your own ngrok values:

```
NGROK_AUTHTOKEN=your-ngrok-authtoken
NGROK_DOMAIN=your-stable-domain.ngrok-free.app
```

Do not commit `.env`. Each developer should use their own ngrok token and reserved domain.

From the repository root, build and start the backend and tunnel containers:

```
docker compose up -d --build
```

The API will be available locally at:

```
http://localhost:8081
```

The same API will be available remotely at:

```
https://your-stable-domain.ngrok-free.app
```

Check the running service:

```
docker compose ps
```

Follow backend and tunnel logs:

```
docker compose logs -f
```

The ngrok local inspector is available at:

```
http://localhost:4040
```

Stop the containers:

```
docker compose down
```

To run with the debug port exposed:

```
docker compose -f compose.yaml -f compose.debug.yaml up -d --build
```

This exposes:

```
8081  # backend API
4040  # ngrok inspector
5005  # JVM debug port
```

### iOS

Navigate into `ios/` and open the Xcode project.
Run directly from Xcode. For testing against Docker from a device or simulator, the debug API base URL should use the stable ngrok HTTPS URL from your `.env`:

```
https://your-stable-domain.ngrok-free.app
```

---

## **Documentation**

All API endpoints and design notes live in:

```
/docs/api.md
```

This file evolves as the backend and iOS app grow.

---

## **Contributing**

See the full guidelines in:

```
CONTRIBUTING.md
```

This includes branching rules, PR expectations, coding style notes, and review workflow.

---

## **License**

This project is licensed under the **MIT License**.
See `LICENSE` for details.

