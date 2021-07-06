provider "yandex" {
  service_account_key_file = var.service_account_key_file
  cloud_id                 = var.cloud_id
  folder_id                = var.folder_id
  zone                     = var.zone
}

module "node1" {
  source          = "./modules/node1"
  public_key_path = var.public_key_path
  image_id        = var.image_id
  subnet_id       = var.subnet_id
}

module "node2" {
  source          = "./modules/node2"
  public_key_path = var.public_key_path
  image_id        = var.image_id
  subnet_id       = var.subnet_id
}
