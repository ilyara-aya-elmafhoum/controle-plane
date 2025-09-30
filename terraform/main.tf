terraform {
  required_providers {
    openstack = {
      source  = "terraform-provider-openstack/openstack"
      version = "~> 1.54.0"
    }
  }
  required_version = ">= 1.6.0"
}

provider "openstack" {
  cloud        = var.openstack_cloud
  user_name    = var.OS_USERNAME
  password     = var.OS_PASSWORD
  tenant_name  = var.OS_PROJECT_NAME
  auth_url     = var.OS_auth_url
}

# SECURITY GROUP
resource "openstack_networking_secgroup_v2" "controle_plane_sg" {
  name        = "controle-plane-secgroup"
  description = "Règles pour la machine Manager (SSH + Web + outils)"
}

# Ingress rules
resource "openstack_networking_secgroup_rule_v2" "ssh" {
  direction         = "ingress"
  ethertype         = "IPv4"
  protocol          = "tcp"
  port_range_min    = 22
  port_range_max    = 22
  remote_ip_prefix  = var.admin_cidr
  security_group_id = openstack_networking_secgroup_v2.controle_plane_sg.id
}

resource "openstack_networking_secgroup_rule_v2" "http" {
  direction         = "ingress"
  ethertype         = "IPv4"
  protocol          = "tcp"
  port_range_min    = 80
  port_range_max    = 80
  remote_ip_prefix  = "0.0.0.0/0"
  security_group_id = openstack_networking_secgroup_v2.controle_plane_sg.id
}

resource "openstack_networking_secgroup_rule_v2" "https" {
  direction         = "ingress"
  ethertype         = "IPv4"
  protocol          = "tcp"
  port_range_min    = 443
  port_range_max    = 443
  remote_ip_prefix  = "0.0.0.0/0"
  security_group_id = openstack_networking_secgroup_v2.controle_plane_sg.id
}

resource "openstack_networking_secgroup_rule_v2" "semaphore" {
  direction         = "ingress"
  ethertype         = "IPv4"
  protocol          = "tcp"
  port_range_min    = 3000
  port_range_max    = 3000
  remote_ip_prefix  = var.admin_cidr
  security_group_id = openstack_networking_secgroup_v2.controle_plane_sg.id
}

# VM controle-plane
resource "openstack_compute_instance_v2" "controle_plane" {
  name        = "controle-plane"
  flavor_name = var.vm_flavor
  image_name  = var.vm_image
  key_pair    = var.ssh_key_name

  network {
    name = "ext-net1"
  }

  security_groups = [
    openstack_networking_secgroup_v2.controle_plane_sg.id
  ]

  user_data = templatefile("${path.module}/cloudinit.tpl", local.cloudinit_vars)
}

locals {
  cloudinit_vars = {
    admin_cidr               = var.admin_cidr
    sysadmin_public_key      = var.sysadmin_pub_key
    devops_aya_public_key    = var.devops_aya_pub_key
    terraform_bot_public_key = var.terraform_bot_pub_key
  }
}


# Floating IP
resource "openstack_networking_floatingip_v2" "controle_plane_fip" {
  pool = var.floating_ip_pool
}

resource "openstack_networking_floatingip_associate_v2" "controle_plane_assoc" {
  floating_ip = openstack_networking_floatingip_v2.controle_plane_fip.address
  port_id     = openstack_compute_instance_v2.controle_plane.network.0.port
}

# OUTPUT
output "controle_plane_ip" {
  value = openstack_networking_floatingip_v2.controle_plane_fip.address
}

