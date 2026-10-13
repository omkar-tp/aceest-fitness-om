# ---- Build a lightweight, production-ready image for ACEest Fitness & Gym ----
FROM python:3.12-slim

# Prevents Python from writing .pyc files and buffers, keeping logs responsive.
ENV PYTHONDONTWRITEBYTECODE=1 \
    PYTHONUNBUFFERED=1

WORKDIR /app

# Install dependencies first to leverage Docker layer caching.
COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt

# Copy application source.
COPY . .

# Run as a non-root user for better security.
RUN useradd --create-home appuser
USER appuser

EXPOSE 5000

# Serve the app with gunicorn in production.
CMD ["gunicorn", "--bind", "0.0.0.0:5000", "app:app"]
