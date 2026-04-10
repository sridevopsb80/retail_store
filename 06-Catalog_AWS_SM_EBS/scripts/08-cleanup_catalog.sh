#!/bin/bash
set -e

echo "==============================="
echo "Delete Catalog Resources"
echo "==============================="

kubectl delete -f ../catalog_k8s_manifests/


echo "==============================="
echo "Delete Secret Provider class"
echo "==============================="

kubectl delete -f ../secretproviderclass/01_catalog_secretproviderclass.yaml