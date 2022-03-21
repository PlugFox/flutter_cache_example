ARG VERSION="stable"

FROM plugfox/flutter:${VERSION}-android-warmed as build

ARG VERSION
USER root
WORKDIR /

COPY . /tmp/dependencies/

# Install linux dependency and utils
#RUN set -eux; apk --no-cache add sqlite sqlite-dev

#RUN mkdir -p /tmp && find / -xdev | sort > /tmp/before.txt

#RUN find packages \! -name "package.json" -mindepth 2 -maxdepth 2 -print | xargs rm -rf
RUN set -eux; cd /tmp/dependencies \
    && shopt -s extglob \
    && find /space ! -iregex '(pubspec.yaml|pubspec.lock)' | xargs rm -rf \
    && flutter pub get --suppress-analytics

#RUN find / -xdev | sort > /tmp/after.txt


FROM plugfox/flutter:${VERSION}-android-warmed as production

ARG VERSION
USER root
WORKDIR /

COPY --chown=101:101 --from=build /tmp/dependencies .

SHELL [ "/bin/bash", "-c" ]
CMD [ "flutter", "doctor" ]
#ENTRYPOINT "put your code here" && /bin/bash

