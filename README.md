# ACEest Fitness & Gym — DevOps Assignment

A containerized **Flask** web application for logging and tracking gym workouts,
delivered with a complete CI/CD pipeline (GitHub Actions + Jenkins) as part of
the *Introduction to DevOps* assignment.

---

## Features

- Web UI to add workouts and view total time logged.
- JSON REST API for programmatic access.
- Health-check endpoint for container orchestration.
- Automated unit tests with Pytest.
- Dockerized for "write once, run anywhere" consistency.
- Automated CI/CD via GitHub Actions and a Jenkins BUILD quality gate.

## API Endpoints

| Method | Endpoint        | Description                                   |
| ------ | --------------- | --------------------------------------------- |
| GET    | `/`             | Home page (HTML UI).                          |
| GET    | `/health`       | Health check — returns `{"status":"healthy"}`.|
| POST   | `/add_workout`  | Add a workout (JSON or form data).            |
| GET    | `/workouts`     | List all workouts and total duration (JSON).  |

Example:

```bash
curl -X POST http://localhost:5000/add_workout \
     -H "Content-Type: application/json" \
     -d '{"workout": "Deadlift", "duration": 45}'
```

---

## Project Structure

```
.
├── app.py                     # Flask application
├── requirements.txt           # Python dependencies
├── templates/
│   └── index.html             # Web UI
├── tests/
│   └── test_app.py            # Pytest suite
├── Dockerfile                 # Container image definition
├── .dockerignore
├── Jenkinsfile                # Jenkins BUILD pipeline
├── .github/workflows/main.yml # GitHub Actions CI/CD pipeline
└── README.md
```

---

## Local Setup & Execution

### Prerequisites
- Python 3.12+
- (Optional) Docker

### 1. Clone and create a virtual environment

```bash
git clone <your-repo-url>
cd <repo>
python -m venv venv
# Windows
venv\Scripts\activate
# macOS / Linux
source venv/bin/activate
```

### 2. Install dependencies

```bash
pip install -r requirements.txt
```

### 3. Run the app

```bash
python app.py
```

Open http://localhost:5000 in your browser.

---

## Running Tests Manually

```bash
pytest -v
```

---

## Running with Docker

```bash
# Build the image
docker build -t aceest-fitness .

# Run the container
docker run -p 5000:5000 aceest-fitness

# Run the test suite inside the container
docker run --rm aceest-fitness sh -c "pip install pytest && pytest -v"
```

---

## CI/CD Integration Overview

### GitHub Actions (`.github/workflows/main.yml`)
Triggered on **every push and pull request**. The pipeline runs two jobs:

1. **build-and-test**
   - Sets up Python 3.12 and installs dependencies.
   - **Build & Lint:** runs `flake8` to catch syntax errors (fails the build on `E9/F` errors).
   - **Automated Testing:** runs the Pytest suite.
2. **docker** (runs after tests pass)
   - **Docker Image Assembly:** builds the Docker image.
   - **Automated Testing:** executes Pytest inside the containerized environment to confirm stability.

### Jenkins (`Jenkinsfile`)
A declarative pipeline acting as the **primary BUILD phase / quality gate**:

1. **Checkout** — pulls the latest code from GitHub.
2. **Install Dependencies** — provisions a clean virtual environment.
3. **Run Unit Tests** — validates application logic with Pytest.
4. **Docker Build** — performs a clean build of the container image.
5. **Test Inside Container** — confirms the image works end-to-end.

Together, Jenkins provides a controlled BUILD environment as a secondary
validation layer, while GitHub Actions guarantees that the Build and Test
stages pass automatically on every push.

---

## Version Control Strategy

- `main` — stable, production-ready code.
- Feature branches (`feature/*`), bug-fix branches (`fix/*`), and infrastructure
  branches (`infra/*`) are merged via pull requests.
- Commits use descriptive, conventional messages (e.g. `feat: add workout API`,
  `test: cover invalid duration`, `ci: add GitHub Actions workflow`).
