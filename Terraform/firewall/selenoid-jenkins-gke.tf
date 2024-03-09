resource "google_compute_firewall" "selenoid-hub-gke" {
  name        = "selenoid-hub-gke-${basename(module.vpc.vpc_network)}"
  network     = basename(module.vpc.vpc_network)
  description = "Selenoid Hub access from GKE VMs"

  allow {
    protocol = "tcp"
    ports    = ["4444"]
  }

  #source_tags = ["goog-gke-node"]  # Jenkins runs in GKE, but you cannot edit network labels for a node pool, so this would have to have been set at creation time. The goog-gke-node default cluster label cannot be used as a network tag
  source_ranges = [local.Cloud_Nat_IP]    # IP address of the Cloud NAT that GKE uses to go externally
  target_tags   = ["selenoid-deployment"] # label I've applied to Marketplace VM
}

resource "google_compute_firewall" "selenoid-ui-vpn" {
  name        = "selenoid-ui-vpn"
  network     = "default"
  description = "Selenoid Hub access from VPN IPs"

  allow {
    protocol = "tcp"
    ports    = ["8080"]
  }

  source_ranges = local.VPN_IPs
  target_tags   = ["selenoid-deployment"]
}
