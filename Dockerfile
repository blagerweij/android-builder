FROM openjdk:8-alpine

LABEL maintainer="Barry Lagerweij" \
  maintainer.email="b.lagerweij@carepay.co.ke" \
  description="Android Builder"

COPY android-packages /tmp/android-packages
RUN apk add --no-cache wget unzip ca-certificates \
  && wget -q -O /etc/apk/keys/sgerrand.rsa.pub https://raw.githubusercontent.com/sgerrand/alpine-pkg-glibc/master/sgerrand.rsa.pub \
  && wget -q -O /tmp/glibc.apk https://github.com/sgerrand/alpine-pkg-glibc/releases/download/2.26-r0/glibc-2.26-r0.apk \
  && wget -q -O /tmp/glibc-bin.apk https://github.com/sgerrand/alpine-pkg-glibc/releases/download/2.26-r0/glibc-bin-2.26-r0.apk \
  && apk add --no-cache /tmp/glibc.apk /tmp/glibc-bin.apk \
  && wget -q -O /tmp/android-tools.zip https://dl.google.com/android/repository/sdk-tools-linux-3859397.zip \
  && mkdir -p /tmp/android-sdk/licenses \
  && unzip /tmp/android-tools.zip -d /tmp/android-sdk \
  && rm /tmp/android-tools.zip \
  && echo "d56f5187479451eabf01fb78af6dfcb131a6481e" > /tmp/android-sdk/licenses/android-sdk-license \
  && echo "84831b9409646a918e30573bab4c9c91346d8abd" > /tmp/android-sdk/licenses/android-sdk-preview-license \
  && echo "d975f751698a77b662f1254ddbeed3901e976f5a" > /tmp/android-sdk/licenses/intel-android-extra-license \
  && mkdir ~/.android; echo "count=0" >> ~/.android/repositories.cfg \
  && /tmp/android-sdk/tools/bin/sdkmanager --package_file=/tmp/android-packages \
  && apk del wget unzip ca-certificates \
  && rm -rf /tmp/android-sdk/extras /tmp/android-sdk/tools/lib/x86 /tmp/android-sdk/tools/lib/monitor-* /tmp/glibc.apk /tmp/glibc-bin.apk /etc/apk/keys/sgerrand.rsa.pub

RUN mkdir /tmp/project \
  && echo "sdk.dir=/tmp/android-sdk" > /tmp/project/local.properties
ENV ANDROID_HOME /tmp/android-sdk
WORKDIR /tmp/project
