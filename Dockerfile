FROM debian:bookworm
LABEL maintainer="Deriv Services Ltd <DERIV@cpan.org>"

ENV TZ=UTC
ENV DEBIAN_FRONTEND=noninteractive

# Use an apt-cacher-ng or similar proxy when available during builds
ARG http_proxy
ARG apt_proxy
ENV DEBIAN_FRONTEND=noninteractive

WORKDIR /app

RUN bash -c 'if [ -n "${apt_proxy:-${http_proxy}}" ]; then echo "Acquire::http::Proxy \"${apt_proxy:-${http_proxy}}\";" > /etc/apt/apt.conf.d/30proxy; fi' \
 ;  apt-get update \
 && apt-get dist-upgrade -y -q --no-install-recommends build-essential automake libpoppler-glib-dev libpoppler-dev poppler-utils libwxgtk3.0-gtk3-dev libwxbase3.0-dev wx3.0-headers

COPY ./ ./

RUN ./bootstrap \
 && ./configure \
 && make \
 && make install

