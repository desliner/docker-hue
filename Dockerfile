FROM isuper/java-oracle:jdk_8

MAINTAINER Max Myslyvtsev <desliner@github>

RUN apt-get update -y \
  && apt-get install --fix-missing -y \
    wget \
    supervisor \
    ant \
    gcc \
    g++ \
    libkrb5-dev \
    libmysqlclient-dev \
    libssl-dev \
    libsasl2-dev \
    libsasl2-modules-gssapi-mit \
    libsqlite3-dev \
    libtidy-0.99-0 \
    libxml2-dev \
    libxslt-dev \
    libffi-dev \
    make \
    maven \
    libldap2-dev \
    python-dev \
    python-setuptools \
    libgmp3-dev \
    libz-dev \
    rsync \
  && rm -rf /var/lib/apt/lists/* \
  && apt-get clean

ENV HUE_VERSION 3.10.0

RUN wget --no-check-certificate https://github.com/cloudera/hue/tarball/release-$HUE_VERSION -O /source.tgz \
  && mkdir -p /source \
  && tar xpvf /source.tgz -C /source --strip=1 \
  && rm /source.tgz \
  && cd /source \
  && make install \
  && cd / \
  && rm -rf /source \
  && rm -rf /root/.m2

RUN echo "[program:hue]" >> /etc/supervisor/conf.d/hue.conf \
  && echo "command=/usr/local/hue/build/env/bin/hue runserver 0.0.0.0:8888" >> /etc/supervisor/conf.d/hue.conf \
  && echo "autostart=true" >> /etc/supervisor/conf.d/hue.conf \
  && echo "autorestart=true" >> /etc/supervisor/conf.d/hue.conf


EXPOSE 8888

CMD ["supervisord", "-n"]
