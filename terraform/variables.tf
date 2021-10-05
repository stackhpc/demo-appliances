variable "cluster_name" {
  type        = string
  description = "The name of the cluster"
}

variable "cluster_network" {
  type        = string
  description = "The name of the network to connect cluster nodes to"
}

variable "cluster_floating_ip" {
  type        = string
  description = "The floating IP to associate with the server"
}

variable "cluster_ssh_public_keys" {
  type = list(string)
  description = "List of SSH public keys to grant access to the server"
}

variable "server_image" {
  type = string
  description = "The ID of the CentOS 8 image to use for the server"
}

variable "server_flavor" {
  type = string
  description = "The ID of the flavor to use for the server"
}
