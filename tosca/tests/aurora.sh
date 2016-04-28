#!/bin/bash -e

baseURL="http://localhost:8088/rest/latest"
# Delete the application, update the Mesos-types components, upload aurora template et run the deployment again

# TODO : test if JQ is present if not prompt and exit

# POST authentification and store token in cookie
curl -c cookie -d 'username=admin&password=admin&submit=Login' "http://localhost:8088/login"

echo "Connected to API at : ${baseURL}"
##################### RETRIEVE environment and DELETE application ##########################
# Retrieve applicationId
applicationId=$(curl -s -b cookie -H 'content-type:application/json' -d '{"query":"","filters":{"target":["application"]},"from":0,"size":1}' "http://localhost:8088/rest/v1/applications/search" | jq -r .data.data[0].id)

echo "Retrieved Application ID : ${applicationId}"
if [[ 'null' != $applicationId ]]; then
  # Retrieve environments statuses and assume there is only one environment
  status=$(curl -s -b cookie -H 'content-type:application/json' -d "[\"${applicationId}\"]" "${baseURL}/applications/statuses" | jq ".data.\"${applicationId}\"")
  echo $status
  environmentId=$(echo $status | jq -r 'keys[0]')
  echo "Application status : "$(echo $status | jq ".\"${environmentId}\".environmentStatus")
  if [[ environmentId != 'null' && "UNDEPLOYED" != $(echo $status | jq -r ".\"${environmentId}\".environmentStatus") ]]; then
    # Undeploy the application
    curl -s -b cookie -X DELETE "${baseURL}/applications/${applicationId}/environments/${environmentId}/deployment"
    echo "Undeloying application..."

    depStatus="UNDEPLOYMENT_IN_PROGRESS"
    # Wait until undeployment is completeg
    while [ $depStatus != "UNDEPLOYED" ];
    do
      depStatus=$(curl -s -b cookie "${baseURL}/applications/${applicationId}/environments/${environmentId}/status" | jq -r '.data')
      sleep 5
    done
    echo "Application undeployed"
  fi
  # Delete app
  curl -b cookie -X DELETE "${baseURL}/applications/${applicationId}"
  echo "Application deleted"
fi

##################### RETRIEVE and DELETE templates & CSARS ##########################
# Retrieve templates id
auroraTemplateId=$(curl -s -b cookie -H 'content-type:application/json'\
 -d '{"query":"Aurora","filters":{"target":["topologytemplate"]},"from":0,"size":1}'\
 "${baseURL}/templates/topology/search" | jq -r '.data.data[0].id')

if [[ 'null' != $auroraTemplateId ]]; then
  # Delete template
  echo "Delete Aurora Template"
  curl -s -b cookie -X DELETE "${baseURL}/templates/topology/${auroraTemplateId}"
fi

# Retrieve and delete CSARS
echo "Delete CSARS from alien database"
echo $csars
csars=$(curl -s -b cookie -H "Content-Type: application/json"\
 -d '{"query":"","filters":{"target":["csar"]},"from":0,"size":10}' "${baseURL}/csars/search"\
 | jq '.data.data | map(select(.name | test("mesos-types|Aurora"; "i"))) | map({(.name): .id}) | add')

echo $csars | jq -e '.Aurora' >/dev/null && curl -s -b cookie -X DELETE "${baseURL}/csars/"$(echo ${csars} | jq -r '.Aurora')
echo $csars | jq -e '."mesos-types"' >/dev/null && curl -s -b cookie -X DELETE "${baseURL}/csars/"$(echo ${csars} | jq -r '."mesos-types"')

# Update mesos-types
cd ../mesos-types
rm -f mesos.zip
zip -qr mesos *
# Upload component
echo "Upload mesos-types"
curl -b ../tests/cookie -F "file=@mesos.zip" "${baseURL}/csars"

# Update aurora template
cd ../alien-templates
rm -f aurora.zip
zip -q aurora aurora-template-standalone.yml

echo "Upload Aurora template"
curl -s -b ../tests/cookie -F "file=@aurora.zip" "${baseURL}/csars"

cd ../tests
auroraTemplateId=$(curl -s -b cookie -H 'content-type:application/json'\
 -d '{"query":"Aurora","filters":{"target":["topologytemplate"]},"from":0,"size":1}'\
 "${baseURL}/templates/topology/search" | jq -r '.data.data[0].id')

# Create an application from the Aurora template
## Retrieve latest template version
auroraTemplateVersionId=$(curl -s -b cookie "${baseURL}/templates/${auroraTemplateId}/versions" | jq -r '.data'.id)

echo "Got template id : ${auroraTemplateId} and Template version : ${auroraTemplateVersionId}"
## Create application
applicationId=$(curl -s -b cookie -H "Content-Type: application/json" -d "{
  \"description\": \"Aurora cluster\",
  \"name\": \"AuroraTest\",
  \"topologyTemplateVersionId\": \"${auroraTemplateVersionId}\"}" "${baseURL}/applications" | jq -r '.data')

echo "Got app id : ${applicationId}"
## Retrieve environment and deploy app
environmentId=$(curl -s -b cookie -H "Content-Type: application/json" -d '{"query":"","filters":{},"from":0,"size":1}'\
  "${baseURL}/applications/${applicationId}/environments/search" | jq -r '.data.data[0].id')

echo "Environment id : ${environmentId}"
## Retrieve deployment topology
topologyId=$(curl -s -b cookie "${baseURL}/applications/${applicationId}/environments/${environmentId}/topology" | jq -r '.data')
deploymentTopologyId=$(curl -s -b cookie "${baseURL}/applications/${applicationId}/environments/${environmentId}/deployment-topology" | jq -r '.data.topology.delegateId')
locationPolicies=$(curl -s -b cookie "${baseURL}/topologies/${topologyId}/locations" | jq '.data[0].location')
orchestratorId=$(echo $locationPolicies | jq -r '.orchestratorId')
locationId=$(echo $locationPolicies | jq -r '.id')

## Deploy the goddamn app
curl -s -b cookie -H "Content-Type: application/json" -d "{
  \"groupsToLocations\": {\"_A4C_ALL\":\"${locationId}\"},
  \"orchestratorId\": \"${orchestratorId}\"
}" "${baseURL}/applications/${applicationId}/environments/${environmentId}/deployment-topology/location-policies"

# curl -s -b cookie -H "Content-Type: application/json" -d "{
#   \"applicationEnvironmentId\": \"${environmentId}\",
#   \"applicationId\": \"${applicationId}\"}" "${baseURL}/applications/deployment"

rm -f cookie
