#!/bin/bash

# Exit immediately if a command exits with a non-zero status
set -e

# Define variables
RELEASE_NAME="my-ignition-app"
CHART_NAME="ignition-app"
NAMESPACE="ignition-namespace"
VALUES_FILE="charts/$CHART_NAME/values.yaml"

# Check if the namespace exists, and create it if it doesn't
if ! kubectl get namespace $NAMESPACE > /dev/null 2>&1; then
  echo "Namespace $NAMESPACE does not exist. Creating namespace..."
  kubectl create namespace $NAMESPACE
fi

# Check if the release already exists
if helm status $RELEASE_NAME -n $NAMESPACE > /dev/null 2>&1; then
  # Upgrade the existing release
  echo "Upgrading existing release $RELEASE_NAME in namespace $NAMESPACE..."
  helm upgrade $RELEASE_NAME $CHART_NAME --namespace $NAMESPACE --values $VALUES_FILE
else
  # Install a new release
  echo "Installing new release $RELEASE_NAME in namespace $NAMESPACE..."
  helm install $RELEASE_NAME $CHART_NAME --namespace $NAMESPACE --values $VALUES_FILE
fi

echo "Deployment completed successfully."
