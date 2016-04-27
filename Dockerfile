FROM rawmind/alpine-monit:0.3.3-2
MAINTAINER Raul Sanchez <rawmind@gmail.com>

#Set environment
ENV SERVICE_NAME=traefik \
    SERVICE_HOME=/opt/traefik \
    SERVICE_USER=traefik \
    SERVICE_UID=10001 \
    SERVICE_GROUP=traefik \
    SERVICE_GID=10001 \
    SERVICE_CONF=0 \
    SERVICE_VERSION=v1.0.0-beta.555 \
    SERVICE_URL=https://github.com/containous/traefik/releases/download
ENV SERVICE_RELEASE=${SERVICE_URL}/${SERVICE_VERSION}/traefik_linux-amd64 \
    PATH=${PATH}:${SERVICE_HOME}/bin 

# Download and install traefik
RUN mkdir -p ${SERVICE_HOME}/bin ${SERVICE_HOME}/etc ${SERVICE_HOME}/log \
  && cd ${SERVICE_HOME}/bin \
  && curl -jksSL "${SERVICE_RELEASE}" -O \
  && mv traefik_linux-amd64 traefik \
  && chmod 755 traefik \
  && addgroup -g ${SERVICE_GID} ${SERVICE_GROUP} \
  && adduser -g "${SERVICE_NAME} user" -D -h ${SERVICE_HOME} -G ${SERVICE_GROUP} -s /sbin/nologin -u ${SERVICE_UID} ${SERVICE_USER} \
  && chmod +x ${SERVICE_HOME}/bin/traefik 
ADD root /
RUN chmod +x ${SERVICE_HOME}/bin/*.sh \
  && chown -R ${SERVICE_USER}:${SERVICE_GROUP} ${SERVICE_HOME} /opt/monit

USER $SERVICE_USER
WORKDIR $SERVICE_HOME

EXPOSE 8080 8000 8443
