echo "==============================="
echo "Set environment variables "
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


#########################
# Verification steps - Enable if necessary
#########################

# echo "==============================="
# echo "List Secrets info"
# echo "==============================="

# echo
# echo " List all secrets in your account (filtered by name) "

# # remove for final pipeline
# aws secretsmanager list-secrets \
#   --region $AWS_REGION \
#   --query "SecretList[?contains(Name, 'catalog-db-secret-1')].[Name,ARN]" \
#   --output table

# echo
# echo " Describe the Secret for Details "

# aws secretsmanager describe-secret \
#   --secret-id catalog-db-secret-1 \
#   --region $AWS_REGION

# echo
# echo " Retrieve Secret Value "

# # remove for final pipeline
# aws secretsmanager get-secret-value \
#   --secret-id catalog-db-secret-1 \
#   --region $AWS_REGION \
#   --query SecretString --output text

echo "==============================="
echo "Create the SecretProviderClass"
echo "==============================="

kubectl apply -f ../secretproviderclass/01_catalog_secretproviderclass.yaml


echo "==============================="
echo "Apply Catalog manifests"
echo "==============================="

kubectl apply -f ../catalog_k8s_manifests/

# echo "==============================="
# echo "Verification"
# echo "==============================="

# echo
# echo " Verify if Secrets are mounted in pods "

# # MySQL Pod
# kubectl exec -it <mysql-pod-name> -- ls /mnt/secrets-store
# kubectl exec -it <mysql-pod-name> -- cat /mnt/secrets-store/MYSQL_USER
# kubectl exec -it <mysql-pod-name> -- cat /mnt/secrets-store/MYSQL_PASSWORD


# # Catalog Pod
# kubectl exec -it <catalog-pod-name> -- ls /mnt/secrets-store
# kubectl exec -it <catalog-pod-name> -- cat /mnt/secrets-store/MYSQL_USER
# kubectl exec -it <catalog-pod-name> -- cat /mnt/secrets-store/MYSQL_PASSWORD

# # Verify Catalog Microservice Application

# # List Pods
# kubectl get pods

echo
echo " Connect to MySQL Database and Verify "

# Connect to MySQL Database using MySQL Client Pod
kubectl run mysql-client --rm -it \
  --image=mysql:8.0 \
  --restart=Never \
  -- mysql -h catalog-mysql -u mydbadmin -p mysqldb101

# Run SQL Commands

SHOW DATABASES;
USE catalogdb;
SHOW TABLES;
SELECT * FROM products;
SELECT * FROM tags;
SELECT * FROM product_tags;
EXIT;

