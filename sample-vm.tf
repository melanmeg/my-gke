resource "google_compute_address" "internal_ip" {
  count = local.count

  name         = format("iip-%02d", count.index + 1)
  subnetwork   = google_compute_subnetwork.default.id
  address_type = "INTERNAL"
  address      = var.iips[count.index]
  region       = "asia-northeast1"
}

resource "google_compute_address" "external-ip" {
  count = local.count

  name         = format("eip-%02d", count.index + 1)
  address_type = "EXTERNAL"
  region       = "asia-northeast1"
}

data "google_compute_image" "image" {
  family  = "ubuntu-2204-lts"
  project = "ubuntu-os-cloud"
}

##############################################

resource "google_compute_disk" "default" {
  count = local.count

  name                      = format("disk-%02d", count.index + 1)
  type                      = "pd-standard"
  zone                      = "asia-northeast1-b"
  size                      = 50
  physical_block_size_bytes = 4096
}

resource "google_compute_attached_disk" "default" {
  count = local.count

  disk     = google_compute_disk.default[count.index].id
  instance = google_compute_instance.default[count.index].id
}

##### VM #####
resource "google_compute_instance" "default" {
  count = local.count

  name         = format("vm-%02d", count.index + 1)
  machine_type = "e2-medium"
  zone         = "asia-northeast1-b"

  boot_disk {
    initialize_params {
      image = data.google_compute_image.image.self_link
      size  = 32
      type  = "pd-ssd"
    }
  }

  network_interface {
    subnetwork = google_compute_subnetwork.default.id
    stack_type = "IPV4_ONLY"
    network_ip = google_compute_address.internal_ip[count.index].address
    access_config {
      nat_ip = google_compute_address.external-ip[count.index].address
    }
  }

  lifecycle {
    ignore_changes = [attached_disk]
  }

  metadata = {
    #block-project-ssh-keys = "true"
    ssh-keys = local.ssh_key
  }
}