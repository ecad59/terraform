# See https://cloud.google.com/compute/docs/load-balancing/network/example

provider "google" {
  region      = var.region
  project     = var.project_id
  credentials = file(var.credentials_file_path)
}

resource "google_compute_instance" "instance-template" {
  name         = "tf-${var.short_project}"
  machine_type = var.machine_type
  zone         = var.region_zone
  tags         = ["${var.short_project}-node"]
  project      = var.project_id

  boot_disk {
    auto_delete = true
    device_name = "disk-${var.short_project}-services"
    initialize_params {
      image = "https://www.googleapis.com/compute/beta/projects/ubuntu-os-cloud/global/images/ubuntu-2004-focal-v20221121"
      size  = 80
      type  = "pd-balanced"
    }
  }

  confidential_instance_config {
    enable_confidential_compute = false
  }

  reservation_affinity {
    type = "ANY_RESERVATION"
  }

  network_interface {
    network = "default"
  }

  metadata = {
    ssh-keys = "${var.ssh_user}:${file(var.public_key_path)}"
  }

  #docker-compose
   provisioner "file" {
    source      = var.docker_compose_src_path
    destination = var.docker_compose_dest_path

    connection {
      host        = self.network_interface.0.access_config.0.nat_ip
      type        = "ssh"
      user        = "${var.ssh_user}"
      private_key = file(var.private_key_path)
      agent       = false
    }
  }

    provisioner "file" {
    source      = var.env_src_path
    destination = var.env_dest_path

    connection {
      host        = self.network_interface.0.access_config.0.nat_ip
      type        = "ssh"
      user        = "${var.ssh_user}"
      private_key = file(var.private_key_path)
      agent       = false
    }
  }

   provisioner "remote-exec" {
    connection {
      host        = self.network_interface.0.access_config.0.nat_ip
      type        = "ssh"
      user        = "${var.ssh_user}"
      private_key = file(var.private_key_path)
      agent       = false
    }

    inline = [
      "sudo chmod +x ${var.docker_compose_dest_path}",
      "sudo apt-get -y update",
      "sudo apt-get -y install docker.io",
      "sudo apt-get -y install docker-compose",
      "docker volume create influxdb-volume",
      "docker volume create grafana-volume",
      "docker network create monitoring_network",
      "cd /tmp && docker-compose up -d"
    ]
  }

  service_account {
    email  = var.service_account
    scopes = ["https://www.googleapis.com/auth/devstorage.read_only", "https://www.googleapis.com/auth/logging.write", "https://www.googleapis.com/auth/monitoring.write", "https://www.googleapis.com/auth/service.management.readonly", "https://www.googleapis.com/auth/servicecontrol", "https://www.googleapis.com/auth/trace.append"]
  }
}

resource "google_compute_firewall" "default" {
  name    = "tf-${var.short_project}-firewall"
  network = "default"
  project = var.project_id

  allow {
    protocol = "tcp"
    ports    = ["3000", "8086", "2049", "111"]
  }

  allow {
    protocol = "udp"
    ports    = ["8089", "2049", "111"]
  }

  source_ranges = ["0.0.0.0/0"]
  target_tags   = ["${var.short_project}-node"]
}

resource "google_compute_http_health_check" "default" {
  name                = "tf-${var.short_project}-basic-check"
  request_path        = "/"
  check_interval_sec  = 1
  healthy_threshold   = 1
  unhealthy_threshold = 10
  timeout_sec         = 1
  project             = var.project_id
}

resource "google_compute_target_pool" "default" {
  name          = "tf-${var.short_project}-target-pool"
  instances     = ["europe-west1-b/instance-template"]
  health_checks = [google_compute_http_health_check.default.name]
  project       = var.project_id
}
