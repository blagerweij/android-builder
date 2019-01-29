FROM openjdk:8-alpine

LABEL maintainer="Barry Lagerweij" \
  maintainer.email="b.lagerweij@carepay.co.ke" \
  description="Android Builder"

RUN apk add --no-cache wget unzip ca-certificates \
  && wget -q -O /etc/apk/keys/sgerrand.rsa.pub https://alpine-pkgs.sgerrand.com/sgerrand.rsa.pub  \
  && wget -q https://github.com/sgerrand/alpine-pkg-glibc/releases/download/2.28-r0/glibc-2.28-r0.apk \
  && wget -q https://github.com/sgerrand/alpine-pkg-glibc/releases/download/2.28-r0/glibc-bin-2.28-r0.apk \
  && apk add --no-cache glibc-2.28-r0.apk glibc-bin-2.28-r0.apk \
  && wget -q https://dl.google.com/android/repository/sdk-tools-linux-4333796.zip \
  && unzip sdk-tools-linux-4333796.zip -d /tmp/android-sdk \
  && rm sdk-tools-linux-4333796.zip \
  && mkdir -p ~/.android \
  && echo "count=0" >> ~/.android/repositories.cfg \
  && echo yes | /tmp/android-sdk/tools/bin/sdkmanager \
        "platform-tools" \
        "build-tools;28.0.3" \
        "extras;android;m2repository" \
        "extras;google;m2repository" \
        "extras;m2repository;com;android;support;constraint;constraint-layout-solver;1.0.2" \
        "extras;m2repository;com;android;support;constraint;constraint-layout;1.0.2" \
        "extras;google;google_play_services" \
        "platforms;android-28" \
        "platforms;android-27" \
        "platforms;android-26" \
        "platforms;android-25" \
  && apk del wget unzip ca-certificates \
  && rm -rf /tmp/android-sdk/extras /tmp/android-sdk/tools/lib/x86 /tmp/android-sdk/tools/lib/monitor-* glibc-2.28-r0.apk glibc-bin-2.28-r0.apk /etc/apk/keys/sgerrand.rsa.pub \
  && mkdir /tmp/project \
  && echo "sdk.dir=/tmp/android-sdk" > /tmp/project/local.properties
ENV ANDROID_HOME /tmp/android-sdk
WORKDIR /tmp/project
