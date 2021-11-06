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

resource "google_compute_instance" "vm-proxy" {
  name                      = "vm-proxy"
  machine_type              = "g1-small"
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
      // nat_ip = google_compute_address.static.address
      nat_ip = "34.68.21.183"
    }
  }
  metadata_startup_script = file("./script.sh")

  #tags = ["http-server", "https-server", "ssh"]

}


resource "google_compute_network" "vpc_proxy_vm" {
  name                    = "vpc-proxy-vm"
  auto_create_subnetworks = "true"
}



resource "google_compute_firewall" "ssh-tunnel-fw" {
  name    = "ssh-tunnel-fw"
  network = google_compute_network.vpc_proxy_vm.self_link

  allow {
    protocol = "tcp"
    ports    = ["22","3000", "80", "8080", "3128"]
  }

  // source_ranges = ["0.0.0.0/0"]
  // target_tags   = ["vm-proxy", "ssh-tunnel"]

}

resource "google_compute_firewall" "http-server-fw" {
  name      = "http-server-fw"
  network   = google_compute_network.vpc_proxy_vm.self_link

  allow {
    protocol = "tcp"
    ports    = ["3000", "80", "8080", "3128"]
  }

 // source_ranges = ["0.0.0.0/0"]
 // target_tags   = [ "http-server"]
}

