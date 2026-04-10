#!/bin/bash

echo "==============================="
echo "Create Pod Identity Association"
echo "==============================="

echo
echo " Verifying Amazon EKS Pod Identity Agent Installation "

aws eks list-addons --cluster-name ${EKS_CLUSTER_NAME}

echo
echo " Creating Pod Identity Association "

aws eks create-pod-identity-association \
  --cluster-name ${EKS_CLUSTER_NAME} \
  --namespace default \
  --service-account catalog-mysql-sa \
  --role-arn arn:aws:iam::${AWS_ACCOUNT_ID}:role/catalog-db-secrets-role

echo
echo " Verifying Pod Identity Association "

aws eks list-pod-identity-associations --cluster-name ${EKS_CLUSTER_NAME}