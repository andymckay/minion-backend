FROM ubuntu
RUN sudo apt-get update
RUN sudo apt-get install -y \
    build-essential \
    curl \
    git \
    libcurl4-openssl-dev \
    libffi-dev \
    mongodb-server \
    postfix \
    python \
    python-dev \
    python-setuptools \
    rabbitmq-server \
    stunnel4 \
    nmap \
    supervisor

RUN easy_install --upgrade setuptools

RUN install -m 700 -o mongodb -g mongodb -d /data/db
RUN useradd -m minion-backend
RUN install -m 700 -o minion-backend -g minion-backend -d /run/minion -d /var/lib/minion -d /var/log/minion

# Somewhere to store the eggs since there's no need to use virtual envs.
ENV PYTHON_EGG_CACHE /tmp

COPY . /srv/minion
WORKDIR /srv/minion
# Normally we'd only copy over requirements and use that, but without
# an explicit requirements.txt file, we have to copy over the whole thing.
RUN python setup.py develop
