output "bucket_info" {
  value = {
    for bucket, details in aws_s3_bucket.buckets :
    bucket => {
      name               = details.bucket
      arn                = details.arn
      public_access      = var.bucket_config[bucket].enable_public_access
      static_hosting     = var.bucket_config[bucket].enable_static_hosting
      website_url        = (
        var.bucket_config[bucket].enable_static_hosting && 
        contains(keys(aws_s3_bucket_website_configuration.static_hosting), bucket) ? 
        aws_s3_bucket_website_configuration.static_hosting[bucket].website_endpoint : 
        " "
      )
    }
  }
}


output "account_number" {
  value = var.account_number
}