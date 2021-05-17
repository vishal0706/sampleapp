#! /bin/bash

## Create cluster with 2 worker node
eksctl create cluster -f eksctl.yaml

## Create ingress controller
kubectl apply -f ingresscontroller.yaml 

# Sleep is for load balancer to come up to active state
sleep 180

## helm chart will create deployment, service and ingress
helm install --generate-name ./helm/mychart
