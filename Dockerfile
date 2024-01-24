FROM python:3.9-slim-buster

ENV PYTHONFAULTHANDLER=1 \
    PYTHONUNBUFFERED=1

RUN apt-get update -qq \
    && DEBIAN_FRONTEND=noninteractive apt-get install -yq --no-install-recommends \
        apt-transport-https \
        build-essential \
        ca-certificates \
        curl \
        git \
        gnupg \
        jq \
        less \
        libpcre3 \
        libpcre3-dev \
        openssh-client \
        telnet \
        unzip \
        vim \
        wget \
        cron \
        postgresql-client \
    && apt-get clean \
    && rm -rf /var/cache/apt/archives/* \
    && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/* \
    && truncate -s 0 /var/log/*log

RUN pip3 install python-dotenv pyTelegramBotAPI python-telegram-bot

ENV PATH $PATH:/root/.local/bin

RUN mkdir -p /app
WORKDIR /app

ADD . /app

COPY ./config/random /app/config

# Make the script executable
RUN chmod +x /app/restart.sh && \
    chmod +x /app/send.sh

# Create the cron directory
RUN mkdir -p /etc/cron.d

# Add a new cron job that runs the script every minute
RUN echo "* * * * * /app/restart.sh >> /var/log/cron.log 2>&1" > /etc/cron.d/service-restart
RUN echo "0 11 * * * TZ=\"Europe/Moscow\" /app/send.sh >> /var/log/cron.log 2>&1" >> /etc/cron.d/service-restart

# Give execution rights on the cron job
RUN chmod 0644 /etc/cron.d/service-restart

# Apply cron job
RUN crontab /etc/cron.d/service-restart

# Create the log file to be able to run tail
RUN touch /var/log/cron.log

# Create postgres user
RUN groupadd -r postgres && useradd -r -g postgres postgres

EXPOSE 8000

CMD cron && tail -f /var/log/cron.log
