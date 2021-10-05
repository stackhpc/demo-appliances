#####
##### Security groups
#####

resource "openstack_networking_secgroup_v2" "secgroup_server" {
  name                 = "${var.cluster_name}-secgroup-server"
  description          = "Rules for the server"
  delete_default_rules = true   # Fully manage with terraform
}

## Allow all egress for the server
resource "openstack_networking_secgroup_rule_v2" "secgroup_server_rule_egress_v4" {
  direction         = "egress"
  ethertype         = "IPv4"
  security_group_id = openstack_networking_secgroup_v2.secgroup_server.id
}

## Allow ingress on port 22 (SSH) from anywhere
resource "openstack_networking_secgroup_rule_v2" "secgroup_server_rule_ingress_ssh_v4" {
  direction = "ingress"
  ethertype = "IPv4"
  protocol          = "tcp"
  port_range_min    = 22
  port_range_max    = 22
  security_group_id = openstack_networking_secgroup_v2.secgroup_server.id
}

## Allow ingress on port 80 (HTTP) from anywhere
resource "openstack_networking_secgroup_rule_v2" "secgroup_server_rule_ingress_http_v4" {
  direction = "ingress"
  ethertype = "IPv4"
  protocol          = "tcp"
  port_range_min    = 80
  port_range_max    = 80
  security_group_id = openstack_networking_secgroup_v2.secgroup_server.id
}

## Allow ingress on port 9000/9001 (minio) from anywhere
resource "openstack_networking_secgroup_rule_v2" "secgroup_server_rule_ingress_mino_v4" {
  direction = "ingress"
  ethertype = "IPv4"
  protocol          = "tcp"
  port_range_min    = 9000
  port_range_max    = 9001
  security_group_id = openstack_networking_secgroup_v2.secgroup_server.id
}

#####
##### Server instance
#####

resource "openstack_compute_instance_v2" "server" {
  name      = "${var.cluster_name}-server"
  image_id  = var.server_image
  flavor_id = var.server_flavor
  network {
    name = var.cluster_network
  }
  security_groups = [
    openstack_networking_secgroup_v2.secgroup_server.name
  ]
  # Use cloud-init to inject the SSH keys
  user_data = <<-EOF
    #cloud-config
    ssh_authorized_keys:
      %{ for key in var.cluster_ssh_public_keys }
      - ${key}
      %{ endfor }
  EOF
}

#####
##### Floating IP association
#####

resource "openstack_compute_floatingip_associate_v2" "server_floatingip_assoc" {
  floating_ip = var.cluster_floating_ip
  instance_id = openstack_compute_instance_v2.server.id
}
