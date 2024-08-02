#!/bin/bash

# Exit immediately if a command exits with a non-zero status
set -e

# Define variables
# Define variables
RELEASE_NAME="my-ignition-app"
CHART_NAME="ignition-app"
NAMESPACE="ignition-namespace"
VALUES_FILE="charts/$CHART_NAME/values.yaml"
CHART_DIR="charts/$CHART_NAME/Chart.yaml"
REPO_URL="https://github.com/T-Py-T/kubernetes-testing/"  # Update with your Helm repo URL
REPO_DIR="docs"

# Extract the current chart version from Chart.yaml
CURRENT_VERSION=$(grep '^version:' $CHART_DIR/Chart.yaml | awk '{print $2}')
echo "Current version: $CURRENT_VERSION"

# Parse the version number
IFS='.' read -r -a VERSION_PARTS <<< "$CURRENT_VERSION"
MAJOR=${VERSION_PARTS[0]}
MINOR=${VERSION_PARTS[1]}
PATCH=${VERSION_PARTS[2]}

# Increment the PATCH version
PATCH=$((PATCH + 1))
NEW_VERSION="$MAJOR.$MINOR.$PATCH"
echo "New version: $NEW_VERSION"

# Update Chart.yaml with the new version
sed -i "s/^version: .*/version: $NEW_VERSION/" $CHART_DIR/Chart.yaml

# Package the Helm chart with the new version
echo "Packaging Helm chart..."
helm package $CHART_DIR --version $NEW_VERSION -d $REPO_DIR

# Update the Helm repository index
echo "Updating Helm repo index..."
helm repo index $REPO_DIR --url $REPO_URL

# Optional: Push changes to a GitHub repository
echo "Pushing changes to GitHub..."
git add $CHART_DIR/Chart.yaml $REPO_DIR
git commit -m "Bump version to $NEW_VERSION"
git push origin main

echo "Build completed successfully."
