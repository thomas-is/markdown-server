FROM alpine:latest

# python user id is set at build time
ARG PYTHON_UID=1000


RUN apk add --no-cache \
  curl \
  nginx \
  py3-pip

COPY ./etc/profile                    /etc/profile
COPY ./etc/nginx/nginx.conf           /etc/nginx/nginx.conf
COPY ./etc/nginx/http.d/default.conf  /etc/nginx/http.d/default.conf
COPY ./src                            /src
COPY ./bin/genstyles.sh               /usr/local/bin/
COPY ./bin/docker-entrypoint.sh       /usr/local/bin/

RUN chmod -R 755 /usr/local/bin

RUN  adduser -D -u $PYTHON_UID python \
  && mkdir -p /.cache/pip  \
  && chown python:python /.cache/pip \
  && mkdir -p /venv \
  && chown python:python /venv \
  && mkdir -p /src \
  && chown -R python:python /src

USER python

WORKDIR /src
RUN  python3 -m venv /venv \
  && . /venv/bin/activate \
  && pip install -U \
      pip \
      setuptools \
      wheel \
  && pip install -r /src/requirements.txt
RUN /usr/local/bin/genstyles.sh

USER root
ENTRYPOINT [ "/usr/local/bin/docker-entrypoint.sh" ]

# flask config
ENV FLASK_APP="main"
ENV FLASK_ENV="development"

#CMD [ "/bin/sh", "-l" ]
CMD [ "/venv/bin/flask", "run", "--debug", "--host=0.0.0.0" ]
