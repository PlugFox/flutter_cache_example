ARG VERSION="stable"

FROM plugfox/flutter:${VERSION}-android-warmed as build

ARG VERSION
USER root
WORKDIR /

COPY . /tmp/dependencies/

#RUN mkdir -p /tmp && find / -xdev | sort > /tmp/before.txt

RUN set -eux; cd /tmp/dependencies \
    && shopt -s extglob \
    && find /tmp/dependencies \! \( -name pubspec.yaml -or -name pubspec.lock \) -print -mindepth 1 | xargs rm -rf \
    && cd /tmp/dependencies \
    && flutter config --no-analytics \
    && flutter pub get --suppress-analytics \
    && mkdir -p /cache

#RUN find / -xdev | sort > /tmp/after.txt && diff /tmp/before.txt /tmp/after.txt -u | grep -E "^\+"

# Cache dependencies
RUN set -eux; for f in \
        /tmp/dependencies \
        /var/tmp/.pub_cache \
        /root/.flutter \
        /root/.config \
        /opt/flutter/bin/cache/flutter_version_check.stamp \
        /opt/flutter/.git/FETCH_HEAD \
        /opt/flutter/.git/logs/refs/remotes \
        /opt/flutter/.git/refs/remotes \
    ; do \
        dir="$(dirname "$f")"; \
        mkdir -p "/cache$dir"; \
        cp --archive --link --dereference --no-target-directory "$f" "/cache$f"; \
    done


FROM plugfox/flutter:${VERSION}-android-warmed as production

ARG VERSION
USER root
WORKDIR /

COPY --chown=101:101 --from=build /cache/ /

# Install linux dependency and utils
#RUN set -eux; apk --no-cache add sqlite sqlite-dev

SHELL [ "/bin/bash", "-c" ]
CMD [ "flutter", "doctor" ]
#ENTRYPOINT "put your code here" && /bin/bash

