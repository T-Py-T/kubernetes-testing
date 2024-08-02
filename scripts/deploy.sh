#!/bin/bash

# Exit immediately if a command exits with a non-zero status
set -e
# set -x # Gives a verbose output to the cli

# Define variables
RELEASE_NAME="ignition-app"
CHART_NAME="ignition-app"
NAMESPACE="ignition-namespace"
VALUES_FILE="charts/$CHART_NAME/values.yaml"
CHART_VERSION=$(grep '^version:' charts/$CHART_NAME/Chart.yaml | awk '{print $2}')
CHART_FILE="docs/$CHART_NAME-$CHART_VERSION.tgz"


# Check if the release already exists
if helm status $RELEASE_NAME -n $NAMESPACE > /dev/null 2>&1; then
  # Upgrade the existing release
  echo "Upgrading existing release $RELEASE_NAME in namespace $NAMESPACE..."
  helm upgrade $RELEASE_NAME $CHART_FILE --namespace $NAMESPACE --values $VALUES_FILE
else
  # Install a new release
  echo "Installing new release $RELEASE_NAME in namespace $NAMESPACE..."
  helm install $RELEASE_NAME $CHART_FILE --namespace $NAMESPACE --values $VALUES_FILE
fi

echo "Deployment completed successfully."
