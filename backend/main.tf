module "s3_backend" {
  source = "../modules/s3"
  project = "terraform-backend"
  owner   = "ayush"
  force_destroy = true
}


module "dynamodb_backend"{
    source = "../modules/dynamodb"
    project = "terraform-backend"
    owner = "ayush"
}