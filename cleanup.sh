#!/bin/sh

helm uninstall control -n kong-cp
helm uninstall data -n kong-dp

kubectl delete pvc data-control-postgresql-0 -n kong-cp
kubectl delete namespace kong-cp
kubectl delete namespace kong-dp
