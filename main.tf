variable "node_count"
{
	default = 2
}

variable "master_count"
{
	default = 1 
}

variable "ssh_key"
{
	default = "~/.ssh/id_rsa"
}

provider "digitalocean"
{
	token = "${var.digital_ocean_token}"
}

resource "digitalocean_ssh_key" "sharo-key"
{
	name       = "sharo key"
	public_key = "${file(pathexpand("${var.ssh_key}.pub"))}"
}

resource "digitalocean_droplet" "kube_master"
{
	count = "${var.master_count}"
	image= "ubuntu-18-10-x64"
	name = "kube-master"
	region = "fra1"
	size = "s-2vcpu-2gb"
	ssh_keys = ["${digitalocean_ssh_key.sharo-key.fingerprint}"]
}

resource "digitalocean_droplet" "kube_nodes"
{
	count = "${var.node_count}"
	image= "ubuntu-18-10-x64"
	name = "kube-node${count.index}"
	region = "fra1"
	size = "s-2vcpu-2gb"
	ssh_keys = ["${digitalocean_ssh_key.sharo-key.fingerprint}"]
}

output master_ip
{
	value = ["${digitalocean_droplet.kube_master.*.ipv4_address}"]
}

output node_ips
{
	value = ["${digitalocean_droplet.kube_nodes.*.ipv4_address}"]
}
output all_ips
{
	value = ["${concat(digitalocean_droplet.kube_master.*.ipv4_address, digitalocean_droplet.kube_nodes.*.ipv4_address)}"]
}
