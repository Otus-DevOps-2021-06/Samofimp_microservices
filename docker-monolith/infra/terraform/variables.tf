variable "cloud_id" {
  description = "Yandex.Cloud"
}
variable "folder_id" {
  description = "Directory"
}
variable "zone" {
  description = "Zone"
  # Значение по умолчанию
  default = "ru-central1-a"
}
variable "public_key_path" {
  description = "Path to the public key used for ssh access"
}
variable "subnet_id" {
  description = "Subnet"
}
variable "service_account_key_file" {
  description = "key .json"
}
variable "private_key_file" {
  description = "Path to private key on VM under user ubuntu"
}
variable "instance_count" {
  description = "Count of instances created"
}
variable "image_id" {
  description = "An image id"
}
