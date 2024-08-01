##### Environmental Variables #####

locals {
  ##### Subnet #####
  subnet = {
    sub1 = {
      name          = "sub-01"
      ip_cidr_range = "10.0.0.0/24"
      region        = "asia-northeast1"
      stack_type    = "IPV4_ONLY"
      purpose       = "PRIVATE"
    }
    sub2 = {
      #
    }
  }

  ##### VM Count #####
  count = 1

  ##### ssh-key #####
  ssh_key = file("/root/.ssh/test-key.pub")

  #############
  #
  # ssh-keygen -t rsa -f ~/.ssh/test-key -C ubuntu -b 2048
  #
  #############


  ##### Firewall #####
  icmp = {
    name          = "allow-icmp"
    direction     = "INGRESS"
    priority      = 1000
    protocol      = "icmp"
    source_ranges = ["0.0.0.0/0"]
  }

  rules = {
    allow = {
      rule1 = {
        name          = "allow-web"
        direction     = "INGRESS"
        priority      = 1001
        protocol      = "tcp"
        ports         = ["80", "443", "8080", "22"]
        source_ranges = ["0.0.0.0/0"]
      }
      rule2 = {
        name          = "allow-ssh"
        direction     = "INGRESS"
        priority      = 1002
        protocol      = "tcp"
        ports         = ["22"]
        source_ranges = ["0.0.0.0/0"]
      }
    }
    deny = {
      rule3 = {
        name          = "deny-all"
        direction     = "INGRESS"
        priority      = 4096
        protocol      = "all"
        source_ranges = ["0.0.0.0/0"]
      }
    }
  }
}

variable "iips" {
  type    = list(string)
  default = ["10.0.0.30", "10.0.0.31", "10.0.0.32"]
}

