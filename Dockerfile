FROM biocorecrg/debian-perlbrew-pyenv3:stretch

# File Author / Maintainer
MAINTAINER Toni Hermoso Pulido <toni.hermoso@crg.eu>

ARG SUPPA_VERSION=2.3

RUN mkdir -p /usr/local/suppa
WORKDIR /tmp

RUN curl --fail --silent --show-error --location --remote-name https://github.com/comprna/SUPPA/archive/v${SUPPA_VERSION}.tar.gz
RUN tar zxf v${SUPPA_VERSION}.tar.gz
RUN cp -prf SUPPA-${SUPPA_VERSION}/* /usr/local/suppa
RUN echo "#!/usr/bin/env python"|cat - /usr/local/suppa/suppa.py > /tmp/out && mv /tmp/out /usr/local/suppa/suppa.py
RUN ln -s /usr/local/suppa/suppa.py /usr/local/bin/suppa.py
RUN ln -s /usr/local/suppa/suppa.py /usr/local/bin/suppa
RUN chmod +x /usr/local/bin/suppa.py
RUN chmod +x /usr/local/bin/suppa
RUN rm -rf v${SUPPA_VERSION}.tar.gz SUPPA-${SUPPA_VERSION}

# Install SUPPA
RUN pip install -I SUPPA==${SUPPA_VERSION}

# Back workdir
WORKDIR /project

# Clean cache
RUN apt-get clean
RUN set -x; rm -rf /var/lib/apt/lists/*

# Shared mounting
VOLUME /share


