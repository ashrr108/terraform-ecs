
resource "tls_private_key" "key_pair" {
  count = var.generate_key_pair ? 1 : 0
  algorithm = "RSA"
  rsa_bits  = 4096
}

resource "aws_key_pair" "ssh" {
  key_name   = var.key_pair
  public_key = local.ssh_key_pair_pub
}

resource "local_file" "ssh" {
  content         = sensitive(local.ssh_key_pair_priv)
  filename        = "${path.root}/data/${var.key_pair}"
  file_permission = "0600"
}