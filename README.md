# kubernetes-testing

# Clone the repository

1. Open a terminal and navigate to the directory where you want to clone the repository.

2. Run the following command to clone the repository:
```sh
git clone https://github.com/T-Py-T/kubernetes-testing.git
```


# Build the Helm chart

1. Navigate to the cloned repository root:

2. Run the following command to build the Helm chart:
```sh
kube@kubecontroller:~/kubernetes-testing$ ./scripts/build.sh
```

# Deploy the Helm chart
```sh
kube@kubecontroller:~/kubernetes-testing$ ./scripts/deploy.sh
```

# Cleanup
```sh
helm uninstall ignition-app

# Nuke if not using anymore
cd ..
rm -rf kubernetes-testing
```