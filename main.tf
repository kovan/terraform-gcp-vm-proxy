terraform {
  required_providers {
    google = {
      source  = "hashicorp/google"
      version = "3.89.0"
    }
  }
}

provider "google" {
  project = "steel-wharf-330805"
  region  = "us-central1"
  zone    = "us-central1-c"
}

resource "google_compute_instance" "vm_proxy" {
  name                      = "vm-proxy"
  machine_type              = "f1-micro"
  allow_stopping_for_update = false
  boot_disk {
    initialize_params {
      image = "centos-cloud/centos-8"
    }
  }

   metadata = {
    ssh-keys = "bufetarcelmic_2:${file("~/.ssh/gcp-vm-proxy.pub")}"
  }

  network_interface {
    network = google_compute_network.vpc_proxy_vm.self_link
    access_config {
    }
  }
  metadata_startup_script = "${file("./script.sh")}"

  tags = ["proxy"]
}

resource "google_compute_network" "vpc_proxy_vm" {
  name                    = "vpc-proxy-vm"
  auto_create_subnetworks = "true"
}

resource "google_compute_firewall" "ssh-tunnel" {
  name    = "ssh-tunnel"
  network = google_compute_network.vpc_proxy_vm.self_link
  allow {
    protocol = "tcp"
    ports    = ["22"]
  }
  #target_tags = ["terraform-instance"]
  source_ranges = ["0.0.0.0/0"]
}
