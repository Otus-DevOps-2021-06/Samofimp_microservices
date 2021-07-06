resource "yandex_compute_instance" "node1" {
  name        = "node1"
  platform_id = "standard-v2"

  resources {
    cores  = 4
    memory = 4
  }

  boot_disk {
    initialize_params {
      image_id = var.image_id
      size = 40
      type = "network-ssd"
    }
  }

  network_interface {
    subnet_id = var.subnet_id
    nat       = true
  }
  
  metadata = {
    ssh-keys = "ubuntu:${file(var.public_key_path)}"
  }
}
