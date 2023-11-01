#!/bin/sh

kubectl create namespace kong-cp
kubectl create secret generic kong-enterprise-license -n kong-cp --from-file=license=../../license.json
kubectl create secret generic kong-enterprise-superuser-password -n kong-cp --from-literal=password=password
helm install control kong/kong -n kong-cp -f hybrid-cp.yml 

echo "Sleeping (2mins) while Control Plane comes up. You can check status using kubectl"
sleep 120

kubectl create namespace kong-dp
kubectl create secret generic kong-enterprise-license -n kong-dp --from-file=license=../../license.json
kubectl create secret generic kong-enterprise-superuser-password -n kong-dp --from-literal=password=password
helm install data kong/kong -n kong-dp -f hybrid-dp.yml
