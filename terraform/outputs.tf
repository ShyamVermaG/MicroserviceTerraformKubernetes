output "vm_public_ip" {
  value = google_compute_instance.java_vm.network_interface[0].access_config[0].nat_ip
}
