variable "lb_dns_name" {}

resource "aws_cloudfront_distribution" "" {
  origin {
    domain_name = var.lb_dns_name
    origin_id   = var

    s3_origin_config {
      origin_access_identity = aws_cloudfront_origin_access_identity.default.cloudfront_access_identity_path
    }
  }

  origin {
    domain_name = aws_s3_bucket.failover.bucket_regional_domain_name
    origin_id   = "failoverS3"

    s3_origin_config {
      origin_access_identity = aws_cloudfront_origin_access_identity.default.cloudfront_access_identity_path
    }
  }

  default_cache_behavior {
    # ... other configuration ...
    target_origin_id = "groupS3"
  }

  # ... other configuration ...
}