terraform {
  required_providers {
    yandex = {
      source  = "yandex-cloud/yandex"
      version = "0.139.0"
    }
  }
  required_version = ">= 0.13"
}

provider "yandex" {
  zone = "ru-central1-a"
  cloud_id = "b1g5b020anchqspg6qul"
  folder_id = "b1g303pbs3v02ediqp2m"
  service_account_key_file = file("~/playsdev/key.json")
}

variable "servers" {
  type = map(object({
    name = string
    image_id = string
  }))
  default = {
    "ubuntu" = {
      name = "ubuntu_ansible"
      image_id = "fd8ou6hurlbfqmi57ofd"
    }
    "fedora" = {
      name = "fedora_ansible"
      image_id = "fd8u4lo7mqb9ikhuskqp"
    }
  }
}

resource "yandex_vpc_subnet" "ansible_subnet" {
  v4_cidr_blocks = ["10.2.0.0/16"]
  zone           = "ru-central1-a"
  network_id     = yandex_vpc_network.ansible_net.id
}

resource "yandex_vpc_address" "ansible_addr" {
  for_each = var.servers
  name = each.value.name

  external_ipv4_address {
    zone_id = "ru-central1-a"
  }
}

resource "yandex_vpc_network" "ansible_net" {
  name = "ansible"
}

resource "yandex_compute_disk" "ansible_disk" {
  for_each = var.servers
  name     = "disk-${each.key}"
  type     = "network-hdd"
  zone     = "ru-central1-a"
  image_id = each.value.image_id
  size = 10
  # fd8u4lo7mqb9ikhuskqp - fedora fd8ou6hurlbfqmi57ofd - ubuntu
}

resource "yandex_compute_instance" "ansible" {
  for_each = var.servers
  name        = "ansible_${each.key}"
  platform_id = "standard-v3"
  zone        = "ru-central1-a"

  scheduling_policy {
    preemptible = true
  }

  resources {
    cores  = 2
    memory = 1
    core_fraction = 20
  }

  boot_disk {
    disk_id = yandex_compute_disk.ansible_disk[each.key].id
    auto_delete = true
  }

  network_interface {
    subnet_id = yandex_vpc_subnet.ansible_subnet.id
    nat = true
    nat_ip_address = yandex_vpc_address.ansible_addr[each.key].external_ipv4_address[0].address
  }

  metadata = {
    user-data = "${file("./metadata.txt")}"
  }
}

#output "name_ansible" {
#  value = [for k,v in var.servers : "${yandex_compute_instance.ansible[k].name}"]
#}

#output "addr_ansible" {
#  value = [for k,v in var.servers : "${yandex_vpc_address.ansible_addr[k].external_ipv4_address[0].address}"]
  #value = yandex_compute_instance.ansible.name
#}
