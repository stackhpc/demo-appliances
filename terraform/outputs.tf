output "cluster_gateway_ip" {
  description = "The IP address of the gateway used to contact the cluster nodes"
  value       = var.cluster_floating_ip
}

output "cluster_nodes" {
  description = "A list of the nodes in the cluster from which an Ansible inventory will be populated"
  value       = [
    {
      name          = openstack_compute_instance_v2.server.name
      ip            = openstack_compute_instance_v2.server.network[0].fixed_ip_v4
      primary_group = "${var.cluster_name}_servers"
    }
  ]
}
