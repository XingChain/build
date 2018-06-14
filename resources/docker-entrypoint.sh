#!/bin/sh
set -eo pipefail

NRS_PLATFORM="Chain Platform"

echo "cid.apiServerHost=0.0.0.0" > conf/cid.properties
echo "cid.uiServerHost=0.0.0.0" >> conf/cid.properties
PLATFORM_OS=`uname -o` PLATFORM_ARCH=`uname -m` echo "cid.myPlatform=${PLATFORM_OS} ${PLATFORM_ARCH}" >> conf/cid.properties

echo "cid.myAddress=${NRS_ADDRESS}" >> conf/cid.properties
echo "cid.myHallmark=${NRS_HALLMARK}" >> conf/cid.properties
echo "cid.adminPassword=${NRS_ADMIN_PASSWORD}" >> conf/cid.properties
echo "cid.allowedBotHosts=${NRS_ALLOWED_BOT_HOSTS}" >> conf/cid.properties
echo "cid.allowedUserHosts=${NRS_ALLOWED_USER_HOSTS}" >> conf/cid.properties
echo "cid.maxNumberOfInboundConnections=${NRS_MAX_INBOUND}" >> conf/cid.properties
echo "cid.maxNumberOfOutboundConnections=${NRS_MAX_OUTBOUND}" >> conf/cid.properties
echo "cid.maxNumberOfConnectedPublicPeers=${NRS_MAX_PUBLIC_PEERS}" >> conf/cid.properties

if [ ! -z "$NRS_KEYSTORE_PASSWORD" ]; then
	echo "cid.apiSSL=true" >> conf/cid.properties
	echo "cid.keyStorePath=keystores/keystore" >> conf/cid.properties
	echo "cid.keyStorePassword=${NRS_KEYSTORE_PASSWORD}" >> conf/cid.properties
fi  

exec "$@"