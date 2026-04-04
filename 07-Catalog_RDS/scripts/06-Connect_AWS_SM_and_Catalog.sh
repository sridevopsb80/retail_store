echo "==============================="
echo "Setting Environment Variables "
echo "==============================="

# Set environment variable
export AWS_REGION="us-east-1"


echo "==============================="
echo "Create Secret in AWS Secrets Manager"
echo "==============================="
# Create Secret 
aws secretsmanager create-secret \
  --name catalog-db-secret-1 \
  --region $AWS_REGION \
  --description "MySQL credentials for Catalog microservice" \
  --secret-string '{
      "MYSQL_USER": "mydbadmin",
      "MYSQL_PASSWORD": "mysqldb101"
  }'

echo "==============================="
echo "Create the SecretProviderClass"
echo "==============================="

kubectl apply -f ../secretproviderclass/01_catalog_secretproviderclass.yaml


echo "==============================="
echo "Apply Catalog manifests"
echo "==============================="

kubectl apply -f ../catalog_k8s_manifests/
