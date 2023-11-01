#!/bin/sh

# openssl req -new -x509 -nodes -newkey ec:<(openssl ecparam -name secp384r1) \
#     -keyout ./kong-cluster.key -out ./kong-cluster.crt \
#     -days 1095 -subj "/CN=kong_clustering"

kubectl create namespace kong-cp
#kubectl create secret generic kong-enterprise-license -n kong-cp --from-file=license=../../license.json
#kubectl create secret generic kong-enterprise-superuser-password -n kong-cp --from-literal=password=password
kubectl create secret tls kong-cluster-cert -n kong-cp --cert=kong-cluster.crt --key=kong-cluster.key
helm install control kong/kong -n kong-cp -f hybrid-cp.yml 

echo "Sleeping (2mins) while Control Plane comes up. You can check status using kubectl"
sleep 120

kubectl create namespace kong-dp
#kubectl create secret generic kong-enterprise-license -n kong-dp --from-file=license=../../license.json
#kubectl create secret generic kong-enterprise-superuser-password -n kong-dp --from-literal=password=password
kubectl create secret tls kong-cluster-cert -n kong-dp --cert=kong-cluster.crt --key=kong-cluster.key
helm install data kong/kong -n kong-dp -f hybrid-dp.yml
