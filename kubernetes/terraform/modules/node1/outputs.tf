output "external_ip_address_node1" {
value = yandex_compute_instance.node1.network_interface.0.nat_ip_address
}