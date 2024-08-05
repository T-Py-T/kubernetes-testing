# Exit immediately if a command exits with a non-zero status
set -e

# Define variables
RELEASE_NAME="ignition-app"
NAMESPACE="ignition-namespace"

# Source the .bashrc file to load aliases and environment variables
source ~/.bashrc

# Uninstall the Helm release
echo "Uninstalling Helm release: $RELEASE_NAME in namespace: $NAMESPACE..."
helm uninstall $RELEASE_NAME --namespace $NAMESPACE || echo "Release not found or already deleted."

# Verify that the release is no longer listed
echo "Checking if release is removed..."
if helm list --namespace $NAMESPACE | grep -q $RELEASE_NAME; then
  echo "Error: Release $RELEASE_NAME still exists in namespace $NAMESPACE."
  exit 1
else
  echo "Release $RELEASE_NAME successfully uninstalled from namespace $NAMESPACE."
fi

# Function to delete all resources by kind
delete_resources() {
  local resource_type=$1
  echo "Checking for remaining $resource_type in namespace: $NAMESPACE..."
  for resource in $(microk8s kubectl get $resource_type -n $NAMESPACE -o name); do
    if echo $resource | grep -q $RELEASE_NAME; then
      microk8s kubectl delete $resource -n $NAMESPACE || true
    fi
  done
}

# Delete remaining resources
delete_resources pods
delete_resources services
delete_resources deployments
delete_resources statefulsets
delete_resources daemonsets
delete_resources jobs
delete_resources cronjobs

echo "Cleanup completed."