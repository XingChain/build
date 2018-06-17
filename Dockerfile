FROM openjdk:8-jre-alpine

ARG NRS_TYPE=cid
ARG NRS_VERSION=1.11.13
LABEL maintainer="Xing Chain <dev@chainid.io>"

# wget already included is deprecated in regards to TLS latest security minimals
RUN apk add --no-cache \
 wget \
 gpgme

WORKDIR /opt/${NRS_TYPE}
COPY resources/docker-entrypoint.sh resources/import-letsencrypt-java.sh /usr/local/bin/
RUN chmod +x /usr/local/bin/docker-entrypoint.sh
RUN /usr/local/bin/import-letsencrypt-java.sh
RUN wget --no-check-certificate "https://data-01.nyc3.digitaloceanspaces.com/ChainPlatform.zip"
RUN unzip ChainPlatfom.zip -d /opt
RUN rm ChainPlatfom.zip

# install let'sencrypt CA
#keytool -genkey -keyalg RSA -alias selfsigned -keystore keystore -storetype pkcs12 -storepass qwerty -validity 360 -keysize 2048
RUN /usr/local/bin/import-letsencrypt-java.sh

ENV NRS_ADDRESS= \
 NRS_HALLMARK= \
 NRS_ALLOWED_BOT_HOSTS=* \
 NRS_ALLOWED_USER_HOSTS=* \
 NRS_ADMIN_PASSWORD= \
 NRS_MAX_INBOUND=250 \
 NRS_MAX_OUTBOUND=50 \
 NRS_MAX_PUBLIC_PEERS=20

# keytool -genkey -alias my_alias -keyalg RSA -keystore keystore
# ENV NRS_KEYSTORE_PASSWORD=<your_password>

VOLUME /opt/${NRS_TYPE}/certs
VOLUME /opt/${NRS_TYPE}/cid_db
VOLUME /opt/${NRS_TYPE}/cid_test_db
EXPOSE 6868 6969 6789 8888 9999 

ENTRYPOINT ["/usr/local/bin/docker-entrypoint.sh"]
CMD java -cp classes:lib/*:conf:addons/classes:addons/lib/* cid.Cid
