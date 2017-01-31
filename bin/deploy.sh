#!/bin/bash

echo "Deployment to bluemix started"

ansible-playbook playbook.yml
RETURN_CODE=$?

if [[ $RETURN_CODE != 0 ]]; then
  echo "Deployment to bluemix failed"
  exit $RETURN_CODE
else
  echo "Deployment to bluemix successful"
fi
