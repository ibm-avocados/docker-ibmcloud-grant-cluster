#!/bin/bash

set -eox

ibmcloud plugin install -f kubernetes-service
ibmcloud cf install -f
ibmcloud login --apikey $1 -r "us-south"
sleep 20
ibmcloud target --cf-api https://api.us-south.cf.cloud.ibm.com
ibmcloud cf target -o 'advowork@us.ibm.com'
ibmcloud cf target -s 'dev'
sleep 20
curl -u "$8:$9" -L -o master.zip https://github.ibm.com/rvennam/grant-cluster/archive/master.zip
API_KEY=$1
EVENT_NAME=$2
PASSWORD=$3
ADMIN_PAGE_ENABLED=$4
USERS_PER_CLUSTER=$5
FILTER_TAG=$6
ACCESS_GROUP_ID=$7
unzip master.zip
echo "---" > grant-cluster-master/manifest.yaml
echo "applications:" >> grant-cluster-master/manifest.yaml
echo "- name: ${EVENT_NAME}" >> grant-cluster-master/manifest.yaml
echo "  memory: 256M" >> grant-cluster-master/manifest.yaml
echo "  instances: 1" >> grant-cluster-master/manifest.yaml
cd grant-cluster-master
ibmcloud cf push --no-start -f manifest.yaml
ibmcloud cf set-env ${EVENT_NAME} ACCOUNT ${ACCOUNT}
ibmcloud cf set-env ${EVENT_NAME} APIKEY ${APIKEY}
ibmcloud cf set-env ${EVENT_NAME} PASSWORD ${PASSWORD}
ibmcloud cf set-env ${EVENT_NAME} IDENTIFIER "iam_id"
ibmcloud cf set-env ${EVENT_NAME} ADMIN_PAGE_ENABLED ${ADMIN_PAGE_ENABLED}
ibmcloud cf set-env ${EVENT_NAME} USERS_PER_CLUSTER ${USERS_PER_CLUSTER}
ibmcloud cf set-env ${EVENT_NAME} FILTER_TAG ${FILTER_TAG}
ibmcloud cf set-env ${EVENT_NAME} ACCESS_GROUP_ID ${ACCESS_GROUP_ID}
ibmcloud cf start ${EVENT_NAME}

echo "#"
echo "#"
echo "#"
echo ""
echo "URL: https://${EVENT_NAME}.mybluemix.net"
echo "Key: \`${PASSWORD}\`"
echo ""
echo "## Note"
echo "- Don't forget you have your https://kubernetes.admin.ibmdeveloper.net/?account=e2b54d0c3bbe4180b1ee63a0e2a7aba4&filter=${EVENT_NAME} to see the status of the clusters too"
echo "- If you need a \`cloudshell\` you can use https://shell.cloud.ibm.com/. It should be attached to the IBMid, that the student will have created for your workshop. If you have issues with it though please ask questions in  #cloudshell-users, we do not control it."
echo ""
echo ""

