# aws-s3-bucket-setup

Explanation of Each Step:

    Trigger the Workflow:
        The workflow is triggered by a push or pull_request to the main branch.

Checkout Repository:
        The actions/checkout@v2 action checks out your repository so that Terraform can read the files.

    Set up Terraform:
        The hashicorp/setup-terraform@v1 action installs Terraform. You can specify the version of Terraform you want to use.

    Configure AWS Credentials:
        The aws-actions/configure-aws-credentials@v1 action configures AWS credentials using GitHub Secrets. You need to store your AWS_ACCESS_KEY_ID, AWS_SECRET_ACCESS_KEY, and AWS_REGION in GitHub Secrets.

    Run Terraform Init:
        The terraform init step initializes Terraform and configures the backend with the appropriate S3 bucket and DynamoDB table (optional).


    Run Terraform Plan:
        The terraform plan step generates an execution plan to review before applying changes. The -out=tfplan flag stores the plan to a file for later use.

    Run Terraform Apply:
        The terraform apply step applies the Terraform plan. The -auto-approve flag automatically approves the changes without needing manual confirmation.
        Caution: This is risky in production environments, so consider removing -auto-approve for manual approval.

    Terraform Output:
        The terraform output command prints the outputs of your Terraform configuration, so you can inspect any values that you have defined as outputs.

GitHub Secrets:

Before you run this workflow, make sure to store the following secrets in your GitHub repository:

    AWS Credentials:
        AWS_ACCESS_KEY_ID
        AWS_SECRET_ACCESS_KEY
        AWS_REGION

    Terraform Backend Configuration (if needed):
        TF_STATE_BUCKET: Your S3 bucket for the Terraform state.
        TF_LOCK_TABLE: Your DynamoDB table for locking (optional).

Optional Modifications:

    If you're using other backends or need to handle environment-specific configurations, you can use multiple workflows or conditionals in the GitHub Actions file.
    You can also add steps for testing, linting, or validation (e.g., using terraform validate before applying).

Triggering the Action:

Once you push this file to your GitHub repository, the workflow will automatically run on each push or pull_request to the main branch. You can see the workflow status in the GitHub Actions tab of your repository.


Running Terraform Locally

To run Terraform locally, use the following commands:

Pre-requisite: create a bucket manually in aws console for state file.

1. Initialize Terraform: ( replace bucket name, region and dynamo db table name)

terraform init \
  -backend-config="bucket=kutech-terraform-state-bucket" \
  -backend-config="region=us-east-1" 

  OR ( if using dynamo DB)
  terraform init \
  -backend-config="bucket=kutech-terraform-state-bucket" \
  -backend-config="region=us-east-1" \
  -backend-config="dynamodb_table=terraform-lock"


  2. Plan and Apply:
   
    terraform plan -var-file="s3-buckets.tfvars"

    terraform apply -var-file="s3-buckets.tfvars"


   Note: For remote state locking, ensure to add the dynamodb_table configuration in the backend.tf file:
   dynamodb_table = var.dynamodb_table

   In the GitHub Actions deploy.yaml file, include the following in the init step:
   -backend-config="dynamodb_table=${{ secrets.TF_LOCK_TABLE }}"