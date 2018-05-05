FROM debian:jessie

LABEL maintainer "Koo Kin Wai <kin.wai.koo@dynatrace.com>"

ARG TIMEZONE
ARG EASYTRAVEL_VERSION
ARG EASYTRAVEL_BUILD
ARG DTXTENANT
ARG DTXSERVERHOST

ARG EASYTRAVEL_INSTALLER_FILE_NAME=dynatrace-easytravel-linux-x86_64-${EASYTRAVEL_VERSION}.${EASYTRAVEL_BUILD}.jar
ARG EASYTRAVEL_DOWNLOAD_URL=https://s3.amazonaws.com/easytravel/dT71/${EASYTRAVEL_INSTALLER_FILE_NAME}

ARG DT_INSTALL_DEPS=openjdk-8-jre-headless
ARG DT_RUNTIME_DEPS=netcat\ curl\ procps\ libstdc++6:i386\ libaprutil1:i386

RUN set -x && \
	rm -f /etc/localtime && \
	ln -s /usr/share/zoneinfo/${TIMEZONE} /etc/localtime && \
	echo "${TIMEZONE}" > /etc/timezone && \
	date && \
	dpkg --add-architecture i386 && \
	echo "deb http://http.debian.net/debian jessie-backports main" >> /etc/apt/sources.list && \
	apt-get update && \
	apt-get install -y ${DT_RUNTIME_DEPS} && \
	apt-get install -y -t jessie-backports ${DT_INSTALL_DEPS} && \
	cd /lib/i386-linux-gnu && \
	ln -s libexpat.so.1 libexpat.so.0 && \
	curl --insecure -L -o /tmp/${EASYTRAVEL_INSTALLER_FILE_NAME} ${EASYTRAVEL_DOWNLOAD_URL} && \
	java -jar /tmp/${EASYTRAVEL_INSTALLER_FILE_NAME} -t /opt/easytravel-${EASYTRAVEL_VERSION}-x64 && \
	sed -i "s/^config\.apmServerDefault=.*/config.apmServerDefault=APM/;s/^config\.apmServerHost=.*/config.apmServerHost=${DTXSERVERHOST}/;s/^config\.apmServerWebPort=.*/config.apmServerWebPort=443/;s/^config\.apmServerPort=.*/config.apmServerPort=443/;s/^config\.apmServerWebURL=.*/config.apmServerWebURL=https:\/\/${DTXSERVERHOST}:443/;s/^config\.apmTenant=.*/config.apmTenant=${DTXTENANT}/;s/^config\.autostart=.*/config.autostart=Standard/;s/^config\.autostartGroup=.*/config.autostartGroup=UEM/" /opt/easytravel-${EASYTRAVEL_VERSION}-x64/resources/easyTravelConfig.properties && \
	echo "" >> /opt/easytravel-${EASYTRAVEL_VERSION}-x64/resources/easyTravelConfig.properties && \
	apt-get remove -y ${DT_INSTALL_DEPS} && \
	apt-get autoremove -y && \
	rm -f /tmp/${EASYTRAVEL_INSTALLER_FILE_NAME}

EXPOSE 8094/tcp
EXPOSE 8079/tcp
WORKDIR /opt/easytravel-${EASYTRAVEL_VERSION}-x64/weblauncher
CMD ["./weblauncher.sh"]
