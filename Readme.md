Prerequisites:

#### Install EKSCTL
which eksctl && eksctl version
if [ $? == 0 ]; then
  echo "eksctl is already installed"
else
  echo "Install eksctl"
  curl --silent --location "https://github.com/weaveworks/eksctl/releases/latest/download/eksctl_$(uname -s)_amd64.tar.gz" | tar xz -C /tmp
  sudo mv /tmp/eksctl /usr/local/bin
  eksctl version
fi

#### Install kubectl
if [ -x "$(command -v kubectl)" ]; then
    echo "kubectl is already installed"
else
    echo "Install kubectl"
    sudo curl --silent --location -o /usr/local/bin/kubectl \
    https://amazon-eks.s3.us-west-2.amazonaws.com/1.17.11/2020-09-18/bin/linux/amd64/kubectl
    sudo chmod +x /usr/local/bin/kubectl
    #Install yq for yaml processing
    echo 'yq() {
    docker run --rm -i -v "${PWD}":/workdir mikefarah/yq "$@"
    }' | tee -a ~/.bashrc && source ~/.bashrc
    #Verify the binaries are in the path and executable
    for command in kubectl jq envsubst aws
    do
        which $command &>/dev/null && echo "$command in path" || echo "$command NOT FOUND"
    done
    #Enable kubectl bash_completion
    echo "Enable kubectl bash_completion"
    kubectl completion bash >>  ~/.bash_completion
    . /etc/profile.d/bash_completion.sh
    . ~/.bash_completion
    echo "Enable kubectl bash_completion DONE"
    #set the AWS Load Balancer Controller version
    echo "Enable EXPORT LBC"
    echo 'export LBC_VERSION="v2.0.0"' >>  ~/.bash_profile
    . ~/.bash_profile
    echo "Enable EXPORT LBC DONE"
fi

### Install helm
helm version
if [ $? == 0 ]; then
  echo "helm is already installed"
else
  curl -fsSL -o get_helm.sh https://raw.githubusercontent.com/helm/helm/master/scripts/get-helm-3
  chmod 700 get_helm.sh
  ./get_helm.sh
fi

### After prerequisites you have to run the main script which will deploy cluster and create the deployment,service,ingress.
### For running the script use below command.
sh -x main.sh

### After the script is successfully executed you have to hit the load balancer dns in one of your browser.
### You will see that your website is up and running.You can get the load balancer dns from the aws console or you can use the below command and get it
kubectl get ingress