// declare the provider and provider version
terraform {
  required_providers {
    google = {
      source  = "hashicorp/google"
      version = "3.89.0"
    }
  }
}

// provide the project ID and the region 
// for the Google Cloud Compute Virtual Machine 
provider "google" {
  project = "steel-wharf-330805"
  region  = "us-central1"
  zone    = "us-central1-c"
}

// create a Google Cloud Compute Instance
// with a public IP address and a custom name
// with a f1-micro machine type (spend little money, for 1 user is enough)
// with a custom image (the latest centos-cloud/centos-8 image)
resource "google_compute_instance" "vm-proxy-2" {
  name                      = "vm-proxy-2"
  machine_type              = "f1-micro"
  allow_stopping_for_update = false
  boot_disk {
    initialize_params {
      image = "centos-cloud/centos-8"
    }
  }

  metadata = {
    ssh-keys = "tutorial_users:${file("~/.ssh/gcp-vm-proxy.pub")}"
  }

  network_interface {
    network = google_compute_network.vpc_proxy_vm2.self_link
    access_config {
      // let google cloud generate an IP address
      nat_ip = google_compute_address.static.address
      // or use an already declared static ip
      # nat_ip = "34.68.21.183" 
    }
  }
  metadata_startup_script = file("./script.sh")
}

// optionally create a static IP address
resource "google_compute_address" "static" {
  name = "ipv4-address-2"
}

// create a Google Cloud Compute Network
resource "google_compute_network" "vpc_proxy_vm2" {
  name                    = "vpc-proxy-vm2"
  auto_create_subnetworks = "true"
}

//  create a Google Cloud Network SSH firewall rule
resource "google_compute_firewall" "ssh-tunnel-fw2" {
  name    = "ssh-tunnel-fw2"
  network = google_compute_network.vpc_proxy_vm2.self_link

  allow {
    protocol = "tcp"
    ports    = ["22"]
  }
}

// create a Google Cloud Network HTTP firewall rule
resource "google_compute_firewall" "http-server-fw2" {
  name      = "http-server-fw2"
  network   = google_compute_network.vpc_proxy_vm2.self_link

  allow {
    protocol = "tcp"
    ports    = ["3128","80","8080", "443"] // port 3128 if from the squid proxy server
  }
}
