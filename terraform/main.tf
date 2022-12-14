resource "proxmox_vm_qemu" "proxmox_vm_master" {
  count       = var.num_masters
  name        = "${var.master_name}-${count.index}"
  target_node = var.pm_node_name
  clone       = var.template_vm_name
  os_type     = "cloud-init"
  agent       = 1
  memory      = var.num_masters_mem
  cores       = var.num_masters_core
  onboot      = true
  
  disk {
    slot = 0
    size = var.master_disk_size
    type = var.master_disk_type
    storage = var.master_disk_location
    iothread = 1
  }
  ipconfig0 = "ip=${var.master_ips[count.index]}/${var.networkrange},gw=${var.gateway}"
  # ipconfig0 = "ip=dhcp,gw=${var.gateway}"

  lifecycle {
    ignore_changes = [
      ciuser,
      sshkeys,
      network
    ]
  }

}

resource "proxmox_vm_qemu" "proxmox_vm_workers" {
  count       = var.num_nodes
  name        = "${var.node_name}-${count.index}"
  target_node = var.pm_node_name
  clone       = var.template_vm_name
  os_type     = "cloud-init"
  agent       = 1
  memory      = var.num_nodes_mem
  cores       = var.num_nodes_core
  disk {
    slot = 0
    size = var.node_disk_size
    type = var.node_disk_type
    storage = var.node_disk_location
    iothread = 1
  }
  ipconfig0 = "ip=${var.worker_ips[count.index]}/${var.networkrange},gw=${var.gateway}"
  # ipconfig0 = "ip=dhcp,gw=${var.gateway}"

  lifecycle {
    ignore_changes = [
      ciuser,
      sshkeys,
      network
    ]
  }

}