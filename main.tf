provider "aws"{
    region = "us-east-1"
}

resource "aws_s3_bucket" "s3_bucket" {
    bucket = "ajaykrishna-portfolio-bucket"
    object_lock_enabled = false
  
}
resource "aws_cloudfront_distribution" "cloudfront_distribution" {
  aliases = [
        "ajay-portfolio.com",
        "www.ajay-portfolio.com",
    ]
  enabled = true
  is_ipv6_enabled = true
  default_root_object = "index.html"
  price_class = "PriceClass_100"
  origin {
        connection_attempts      = 3
        connection_timeout       = 10
        domain_name              = "ajaykrishna-portfolio-bucket.s3.us-east-1.amazonaws.com"
        origin_access_control_id = "E19BIDAPXOMO7L"
        origin_id                = "ajaykrishna-portfolio-bucket.s3.us-east-1.amazonaws.com"
        origin_path              = null
    }
    restrictions {
      geo_restriction {
        locations = []
        restriction_type = "none"
      }
    }
        viewer_certificate {
        acm_certificate_arn            = "arn:aws:acm:us-east-1:058264217516:certificate/4a157fb0-d97d-4c6a-b619-6c8bf13e8feb"
        cloudfront_default_certificate = false
        iam_certificate_id             = null
        minimum_protocol_version       = "TLSv1.2_2021"
        ssl_support_method             = "sni-only"
    }
    default_cache_behavior {
        allowed_methods            = [
            "GET",
            "HEAD",
        ]
        cache_policy_id            = "658327ea-f89d-4fab-a63d-7e88639e58f6"
        cached_methods             = [
            "GET",
            "HEAD",
        ]
        compress                   = true
        default_ttl                = 0
        field_level_encryption_id  = null
        max_ttl                    = 0
        min_ttl                    = 0
        origin_request_policy_id   = null
        realtime_log_config_arn    = null
        response_headers_policy_id = null
        smooth_streaming           = false
        target_origin_id           = "ajaykrishna-portfolio-bucket.s3.us-east-1.amazonaws.com"
        trusted_key_groups         = []
        trusted_signers            = []
        viewer_protocol_policy     = "redirect-to-https"
    }
}
resource "aws_route53_zone" "route_53" {
  name = "ajay-portfolio.com"
}
resource "aws_api_gateway_rest_api" "rest_api"{
 name = "visitorcountapi"
}
resource "aws_lambda_function" "lambda_function" {
  function_name = "vistorcount"
  role = "arn:aws:iam::058264217516:role/service-role/vistorcount-role-qd3unmb8"
  filename = "visitorcount.zip"
  runtime = "python3.12"
  handler = "lambda_function.lambda_handler"
  timeout = 70
}
resource "aws_dynamodb_table" "db_table"{
 name = "Visitorcount"
 billing_mode = "PAY_PER_REQUEST"
}
terraform {
  backend "s3" {
    bucket = "cloudresumechallenge-tfstate-bucket"
    key = "terraform.tfstate"
    encrypt = true
    region = "us-east-1"
    
  }
}