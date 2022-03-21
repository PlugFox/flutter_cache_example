# ------------------------------------------------------
#                       Dockerfile
# ------------------------------------------------------
# image:    gitlab-registry.ozon.ru/lpp/tms/mobile/magistral/flutter
# requires: debian:buster-slim
# authors:  mmatyunin@ozon.ru
# license:  MIT
# ------------------------------------------------------

ARG VERSION="stable"

FROM plugfox/flutter:${VERSION}-android-warmed as build

ARG VERSION

USER root
WORKDIR /

#TODO: Copy adb keys if needed
#COPY ./adbkey /root/.android/adbkey
#COPY ./adbkey.pub /root/.android/adbkey.pub

COPY ./pubspec.* /root/dependencies/

# TODO: Download if needed
# Get some usefull packages
#RUN dart pub global activate stagehand \
#    && dart pub global activate grinder \
#    && dart pub global activate cider \
#    && dart pub global activate pana \
#    && dart pub global activate flutter_gen \
#    && dart pub global activate dart_code_metrics

# Install linux dependency and utils
#RUN set -eux; apk --no-cache add sqlite sqlite-dev

#RUN mkdir -p /tmp && find / -xdev | sort > /tmp/before.txt

RUN cd /root/dependencies \
    && flutter pub get --suppress-analytics

#RUN find / -xdev | sort > /tmp/after.txt

SHELL [ "/bin/bash", "-c" ]
CMD [ "flutter", "doctor" ]
#ENTRYPOINT [  ]