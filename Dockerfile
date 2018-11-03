FROM resin/rpi-raspbian

RUN echo 'deb http://ftp.debian.org/debian jessie-backports main' >> /etc/apt/sources.list

RUN apt-get update && \
    apt-get install nano binutils xz-utils libjna-java mediainfo wget -y && \
    apt-get install -t jessie-backports openjdk-8-jre-headless ca-certificates-java -y

RUN wget "https://get.filebot.net/filebot/FileBot_4.8.2/FileBot_4.8.2-portable.tar.xz"  -O /tmp/FileBot_4.8.2-portable.tar.xz && \
    cd /tmp && \
    xz -d FileBot_4.8.2-portable.tar.xz && \
    tar xvf FileBot_4.8.2-portable.tar && \
    mkdir /opt/filebot && \
    mv * /opt/filebot

RUN mkdir /tmp/jna-4.0.0 && cd /tmp/jna-4.0.0 && \
    wget --no-check-certificate https://maven.java.net/content/repositories/releases/net/java/dev/jna/jna/4.0.0/jna-4.0.0.jar https://maven.java.net/content/repositories/releases/net/java/dev/jna/jna-platform/4.0.0/jna-platform-4.0.0.jar && \
    jar xf jna-4.0.0.jar && \
    cp -p com/sun/jna/linux-arm/libjnidispatch.so /usr/lib/arm-linux-gnueabihf/jni/libjnidispatch_4.0.0.so && \
    cd /usr/lib/arm-linux-gnueabihf/jni/ && \
    mv libjnidispatch.so libjnidispatch_3.2.7.so && \
    ln -s libjnidispatch_4.0.0.so libjnidispatch.so && \
    cd /usr/share/java && \
    rm jna.jar && \
    cp /tmp/jna-4.0.0/*.jar . && \
    ln -s jna-4.0.0.jar jna.jar && \
    ln -s jna-platform-4.0.0.jar jna-platform.jar && \
    java -jar jna.jar

RUN cd /opt/filebot && \
    ln -s /usr/lib/arm-linux-gnueabihf/libmediainfo.so.0 libmediainfo.so && \
    ln -s /usr/lib/arm-linux-gnueabihf/libzen.so.0 libzen.so

ENTRYPOINT [ "/opt/filebot/filebot.sh" ]