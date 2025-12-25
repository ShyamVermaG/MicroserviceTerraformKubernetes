output "service1_lb_ip" {
  value = kubernetes_service.service1.status[0].load_balancer[0].ingress[0].ip
}
