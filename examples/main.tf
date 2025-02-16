#
# MAINTAINER Vitaliy Natarov "vitaliy.natarov@yahoo.com"
#
terraform {
  required_version = "~> 1.0"
}

provider "aws" {
  region                  = "us-east-1"
  shared_credentials_file = pathexpand("~/.aws/credentials")
}

# Get the usera and account information
data "aws_caller_identity" "current" {
}

module "sagemaker" {
  source      = "../"
  name        = "TEST"
  environment = "stage"

  # Sagemaker model
  enable_sagemaker_model             = true
  sagemaker_model_name               = ""
  sagemaker_model_execution_role_arn = "arn:aws:iam::${data.aws_caller_identity.current.account_id}:role/admin-role"

  sagemaker_model_primary_container = [{
    image = "${data.aws_caller_identity.current.account_id}.dkr.ecr.us-east-1.amazonaws.com/sagemaker-sparkml-serving"
  }]
  sagemaker_model_container = []

  # Sagemaker endpoint config
  enable_sagemaker_endpoint_configuration = true
  sagemaker_endpoint_configuration_name   = ""
  sagemaker_endpoint_configuration_production_variants = [{
    initial_instance_count = 1
    instance_type          = "ml.t2.medium"
    variant_name           = "sage-endpoint-config-1"
  }]

  # Sagemaker endpoint
  enable_sagemaker_endpoint = true
  sagemaker_endpoint_name   = ""

  # Sagemaker notebook instance lifecycle configuration
  enable_sagemaker_notebook_instance_lifecycle_configuration    = true
  sagemaker_notebook_instance_lifecycle_configuration_name      = ""
  sagemaker_notebook_instance_lifecycle_configuration_on_create = null
  sagemaker_notebook_instance_lifecycle_configuration_on_start  = null

  # Sagemaker notebook instance
  enable_sagemaker_notebook_instance        = true
  sagemaker_notebook_instance_name          = ""
  sagemaker_notebook_instance_role_arn      = "arn:aws:iam::${data.aws_caller_identity.current.account_id}:role/admin-role"
  sagemaker_notebook_instance_instance_type = "ml.t2.medium"

  sagemaker_notebook_instance_subnet_id              = null
  sagemaker_notebook_instance_security_groups        = null
  sagemaker_notebook_instance_kms_key_id             = null
  sagemaker_notebook_instance_direct_internet_access = null

  tags = tomap({
    "Environment"   = "dev",
    "Createdby"     = "Vitaliy Natarov",
    "Orchestration" = "Terraform"
  })
}
