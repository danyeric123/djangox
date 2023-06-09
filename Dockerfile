# Pull base image
FROM python:3.11-slim-buster as base

# Set environment variables
ENV PYTHONDONTWRITEBYTECODE 1
ENV PYTHONUNBUFFERED 1

# Create and set work directory called `app`
RUN mkdir -p /code
WORKDIR /code

# Install dependencies
COPY Pipfile /code/Pipfile
COPY Pipfile.lock /code/Pipfile.lock

RUN pip install --no-cache-dir --upgrade pip pipenv
RUN pipenv sync --system

# Copy local project
COPY . /code/

RUN python /code/manage.py collectstatic 

RUN python /code/manage.py makemigrations && \
    python /code/manage.py migrate

FROM base as test

# Run tests
RUN pipenv sync --dev --system

FROM base as production

# Expose port 8000
EXPOSE 8000

# Use gunicorn on port 8000
CMD ["gunicorn", "--bind", ":8000", "--workers", "2", "django_project.asgi:application"]