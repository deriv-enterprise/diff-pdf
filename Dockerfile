FROM deriv-enterprise/debian
LABEL maintainer="Deriv Services Ltd <DERIV@cpan.org>"

# Use an apt-cacher-ng or similar proxy when available during builds
ARG http_proxy
ARG apt_proxy

WORKDIR /app

RUN bash -c 'if [ -n "${apt_proxy:-${http_proxy}}" ]; then echo "Acquire::http::Proxy \"${apt_proxy:-${http_proxy}}\";" > /etc/apt/apt.conf.d/30proxy; fi' \
 ;  apt-get update \
 && apt-get dist-upgrade -y -q --no-install-recommends build-essential automake libpoppler-glib-dev libpoppler-dev poppler-utils libwxgtk3.2-dev

COPY ./ ./

RUN ./bootstrap \
 && ./configure \
 && make \
 && make install

