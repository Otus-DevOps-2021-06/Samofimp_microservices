output "external_ip_address_node2" {
    value = yandex_compute_instance.node2.network_interface.0.nat_ip_address
}
