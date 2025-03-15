aws_region = "us-east-1"
account_number = "111111111"
logging_bucket = "" #replace with existing buckt if present for logging
bucket_config = {
  kuretech-files-bucket = {
    enable_public_access  = false
    enable_static_hosting = false
    versioning_enabled    = true
  }
  kuretech-app-ui-bucket = {
    enable_public_access  = false
    enable_static_hosting = true
    versioning_enabled    = false
  }
  
}

tags = {
  Project     = "KuReTech"
  Environment = "Production"
  Owner       = "KuReTech Admin"
}
