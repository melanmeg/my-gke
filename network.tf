##### Network #####
resource "google_compute_network" "default" {
  name                    = "net-01"
  routing_mode            = "REGIONAL"
  auto_create_subnetworks = false
}

##### Subnet #####
resource "google_compute_subnetwork" "default" {
  name          = local.subnet.sub1.name
  ip_cidr_range = local.subnet.sub1.ip_cidr_range
  region        = local.subnet.sub1.region
  stack_type    = local.subnet.sub1.stack_type
  purpose       = local.subnet.sub1.purpose
  network       = google_compute_network.default.id
}

##################################################

##### Firewall #####
resource "google_compute_firewall" "allow-icmp" {
  name      = local.icmp.name
  direction = local.icmp.direction
  priority  = local.icmp.priority

  network = google_compute_network.default.name

  allow {
    protocol = local.icmp.protocol
  }

  source_ranges = local.icmp.source_ranges
}

resource "google_compute_firewall" "allow" {
  for_each  = local.rules.allow
  name      = each.value.name
  direction = each.value.direction
  priority  = each.value.priority

  network = google_compute_network.default.name

  allow {
    protocol = each.value.protocol
    ports    = each.value.ports
  }

  source_ranges = each.value.source_ranges
}

resource "google_compute_firewall" "deny" {
  for_each  = local.rules.deny
  name      = each.value.name
  direction = each.value.direction
  priority  = each.value.priority

  network = google_compute_network.default.name

  deny {
    protocol = each.value.protocol
  }

  source_ranges = each.value.source_ranges
}

##############################################

#resource "google_storage_bucket" "static-site" {
#  name          = "test-bucket-hoge-01"
#  location      = "asia-northeast1"
#  force_destroy = true
#  storage_class = "STANDARD"
#
#  uniform_bucket_level_access = true
#
#  website {
#    main_page_suffix = "index.html"
#    not_found_page   = "404.html"
#  }
#  cors {
#    #origin          = ["http://image-store.com"]
#    method          = ["GET", "HEAD", "PUT", "POST", "DELETE"]
#    response_header = ["*"]
#    max_age_seconds = 3600
#  }
#}