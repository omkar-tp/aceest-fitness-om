# Custom Jenkins controller image with Python and the Docker CLI pre-installed,
# so the pipeline can create a venv, run Pytest, and build Docker images.
FROM jenkins/jenkins:lts

USER root

# Install Python (for venv + pytest) and the Docker CLI (for docker build/run).
RUN apt-get update \
    && apt-get install -y --no-install-recommends \
        python3 \
        python3-venv \
        python3-pip \
        docker.io \
    && rm -rf /var/lib/apt/lists/*

USER jenkins
