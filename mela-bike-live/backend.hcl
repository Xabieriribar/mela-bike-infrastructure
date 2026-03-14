bucket = "odoo-infra-production-state"
region = "eu-central"

endpoints = {
  s3 = "https://fsn1.your-objectstorage.com"
}

skip_requesting_account_id  = true
skip_credentials_validation = true
skip_metadata_api_check     = true
skip_region_validation      = true
use_path_style              = true
use_lockfile                = true