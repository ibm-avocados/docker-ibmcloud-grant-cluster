#!/bin/bash

ibmcloud plugin install -f kubernetes-service
sleep 20
ibmcloud login --apikey $1 -r "us-south"
sleep 20
curl -u "$8:$9" -L -o master.zip https://github.ibm.com/rvennam/grant-cluster/archive/master.zip
$1=${API_KEY}
$2=${EVENT_NAME}
$3=${PASSWORD}
$4=${ADMIN_PAGE_ENABLED}
$5=${USERS_PER_CLUSTER}
$6=${FILTER_TAG}
$7=${ACCESS_GROUP_ID}
unzip master.zip
echo "---" > grant-cluster-master/manifest.yaml
echo "applications:" >> grant-cluster-master/manifest.yaml
echo "- name: ${EVENT_NAME}" >> grant-cluster-master/manifest.yaml
echo "  memory: 256M" >> grant-cluster-master/manifest.yaml
echo "  instances: 1" >> grant-cluster-master/manifest.yaml
cd grant-cluster-master
ibmcloud cf push --no-start -f manifest.yaml
ibmcloud cf set-env $APP_HOSTNAME ACCOUNT $ACCOUNT
ibmcloud cf set-env $APP_HOSTNAME APIKEY $APIKEY
ibmcloud cf set-env $APP_HOSTNAME PASSWORD $PASSWORD
ibmcloud cf set-env $APP_HOSTNAME IDENTIFIER $IDENTIFIER
ibmcloud cf set-env $APP_HOSTNAME ADMIN_PAGE_ENABLED $ADMIN_PAGE_ENABLED
ibmcloud cf set-env $APP_HOSTNAME USERS_PER_CLUSTER $USERS_PER_CLUSTER
ibmcloud cf set-env $APP_HOSTNAME FILTER_TAG $FILTER_TAG
ibmcloud cf set-env $APP_HOSTNAME ACCESS_GROUP_ID $ACCESS_GROUP_ID
ibmcloud cf start $APP_HOSTNAME

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

