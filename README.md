# retail_store

Retail Store App: https://github.com/aws-containers/retail-store-sample-app

Notes:

- Each Infra element (such as S3 backend, underlying VPC, EKS cluster) has its own sub-directory.  
- Each sub-directory has its own terraform config (providers.tf) for the infra element it builds.
- It is recommended to initialize Terraform in each sub-directory (whatever is the working directory) to ensure that the .tfstate file is more manageable. Alternatively, you can create a providers.tf file in the root directory with the necessary components and use a single .tfstate file for all infra elements.
- For this project, a single S3 bucket (with versioning enabled) is used. Different keys for .tfstate files is used (for example, key = "dev/vpc/terraform.tfstate") for every infra element. 