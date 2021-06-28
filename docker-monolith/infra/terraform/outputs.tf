output "external_ip_address" {
  value = tolist([for single_instance in yandex_compute_instance.docker-host : single_instance.network_interface.0.nat_ip_address])
}