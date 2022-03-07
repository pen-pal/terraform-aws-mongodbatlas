# Configure the MongoDB Atlas Provider
provider "mongodbatlas" {
  public_key  = var.mongodbatlas_public_key
  private_key = var.mongodbatlas_private_key
}

# Configure the MongoDB Atl
#pass configuration as environment variablesas Provider
#export MONGODB_ATLAS_PUBLIC_KEY="xxxx"
#export MONGODB_ATLAS_PRIVATE_KEY="xxxx"
#provider "mongodbatlas" {}


provider "random" {}
