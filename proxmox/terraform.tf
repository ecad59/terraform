terraform {
    required_providers {
        proxmox =  {
        source = "Telmate/proxmox"
        version = "2.9.11"
        }
    }
}
 
provider "proxmox" {
    pm_api_url = var.pm_api_url_main
    pm_api_token_id= var.pm_api_token_id
    pm_api_token_secret= var.pm_api_token_secret
}

resource "proxmox_vm_qemu" "vmmain" {
    desc = ""
    name = ""
    target_node = var.target_node_main
    clone = var.clone

    os_type = "cloud-init"

    cores = 0
    sockets = 0
    cpu = ""
    memory = 0
    scsihw = ""
    bootdisk = ""

    disk {
        slot = 0
        size = ""
        type = ""
        storage = ""
        iothread = 0
    }

    sshkeys = file(var.public_key_path)
}