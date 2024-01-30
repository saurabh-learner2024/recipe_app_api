FROM python:3.9-alpine3.13
LABEL maintainer="Saurabh Jaiswal"

#  It tells python that you don't want to buffer the output.The output from python will be printed
#  directly to the console, which prevents any delays of messages getting from our python running
#  application to the screen so we can see the logs immediately in the screen
ENV PYTHONUNBUFFERED 1

COPY ./requirements.txt /tmp/requirements.txt
COPY ./requirements.dev.txt /tmp/requirements.dev.txt
COPY ./app /app
WORKDIR /app
EXPOSE 8000

ARG DEV=false
RUN python -m venv /py && \
    /py/bin/pip install --upgrade pip && \
    /py/bin/pip install -r /tmp/requirements.txt && \
    if [ $DEV = "true" ]; \
        then /py/bin/pip install -r /tmp/requirements.dev.txt; \
    fi && \
    rm -rf /tmp && \
    adduser \
        --disabled-password \
        --no-create-home \
        django-user


# This adds the /py/bin directory to the system's PATH environment variable. This ensures that the commands
# inside the virtual environment can be executed without specifying full path.
ENV PATH="/py/bin:$PATH"

# This sets the user context to django-user. Any subsequent commands will be executed as
# this user rather than the default root user.
USER django-user
