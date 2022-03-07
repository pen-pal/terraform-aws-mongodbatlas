terraform {
  required_providers {
    mongodbatlas = {
      source  = "mongodb/mongodbatlas"
      version = "~> 1.3.0"
    }
    random = {
      source  = "hashicorp/random"
      version = "3.0.1"
    }
    aws = "~>4.0.0"
  }

  required_version = ">=0.12"
}

