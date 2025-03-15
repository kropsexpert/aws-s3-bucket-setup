variable "bucket_config" {
  description = "Map of bucket names to their configurations"
  type = map(object({
    enable_public_access  = bool
    enable_static_hosting = bool
    versioning_enabled    = bool  
  }))
}



variable "enable_public_access" {
  description = "Enable public access for buckets (true/false)."
  type        = bool
  default     = false
}

variable "enable_static_hosting" {
  description = "Enable static hosting for buckets (true/false)."
  type        = bool
  default     = false
}

variable "tags" {
  description = "Common tags for all resources."
  type        = map(string)
  default = {
    Project     = "YourProject"
    Environment = "Production"
    Owner       = "YourTeam"
  }
}
variable "account_number" {
  description = "The AWS account number"
  type        = string
}

variable "aws_region" {
  description = "The AWS region to deploy resources."
  type        = string
  default     = "us-east-1" # Optional default value
}

variable "logging_bucket" {
  description = "The S3 bucket to use for access logs"
  type        = string
  default     = "" # Optional: Leave it empty if logging is not required
}