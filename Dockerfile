# based on https://github.com/gfx/docker-android-project/blob/master/Dockerfile with openjdk-8
FROM openjdk:8

MAINTAINER Leandro Santana <leo93santana@gmail.com>

ENV DEBIAN_FRONTEND noninteractive

RUN dpkg --add-architecture i386 && \
    apt-get update && \
    apt-get install -yq libc6:i386 libstdc++6:i386 zlib1g:i386 libncurses5:i386 --no-install-recommends && \
    apt-get clean

ENV ANDROID_SDK_URL http://dl.google.com/android/android-sdk_r24.4.1-linux.tgz
RUN mkdir -p /opt/adt/
RUN curl -L "${ANDROID_SDK_URL}" | tar --no-same-owner -xz -C /opt/adt
RUN cd /opt/adt; mv android-sdk-linux/ sdk/
ENV ANDROID_HOME /opt/adt/sdk
ENV ANDROID_SDK /opt/adt/sdk
ENV PATH ${ANDROID_HOME}/tools:$ANDROID_HOME/platform-tools:$PATH
ENV ANDROID_NDK_HOME /opt/adt/sdk/ndk-bundle
ENV ANDROID_NDK_VERSION r14b
RUN cd /opt/adt/sdk/ && wget -q https://dl.google.com/android/repository/android-ndk-${ANDROID_NDK_VERSION}-linux-x86_64.zip
RUN cd /opt/adt/sdk/ && unzip -q android-ndk-${ANDROID_NDK_VERSION}-linux-x86_64.zip
RUN cd /opt/adt/sdk/ && mv ./android-ndk-${ANDROID_NDK_VERSION} ndk-bundle
ENV PATH ${PATH}:${ANDROID_NDK_HOME}

RUN apt-get clean
ENV BITRISE_DOCKER_REV_NUMBER_ANDROID_NDK v2017_03_29_1
CMD bitrise -version

# License Id: android-sdk-license-ed0d0a5b
ENV ANDROID_COMPONENTS platform-tools,build-tools-23.0.3,build-tools-24.0.0,build-tools-24.0.2,android-23,android-24
# License Id: android-sdk-license-5be876d5
ENV GOOGLE_COMPONENTS extra-android-m2repository,extra-google-m2repository

RUN echo y | android update sdk --no-ui --all --filter "${ANDROID_COMPONENTS}" ; \
    echo y | android update sdk --no-ui --all --filter "${GOOGLE_COMPONENTS}"

# Support Gradle
ENV TERM dumb