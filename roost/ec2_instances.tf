locals {
  roost_eaas_config_json = jsonencode({
    "enterprise_name" : var.company
    "enterprise_logo" : var.company_logo,
    "enterprise_email_domain" : var.enterprise_email_domain,
    "enterprise_dns" : var.enterprise_dns,
    "admin_email" : var.admin_email,
    "email_sender" : var.senders_email,
    "email_sender_pass" : var.senders_email_pass,
    "email_smtp_host" : var.email_smtp_host,
    "email_smtp_port" : var.email_smtp_port,
    "eaas_server_ip" : aws_instance.roost_eaas_server.private_ip,
    "eaas_server_pem_key" : "/var/tmp/Roost/.ssh/${var.key_pair}",
    "eaas_server_username" : "ubuntu",
    "enterprise_ssl_certificate_path" : var.enterprise_ssl_certificate_path,
    "enterprise_ssl_certificate_key_path" : var.enterprise_ssl_certificate_key_path,
    "ENV_SERVER" : {
      "DEFAULT_PORT" : 3000,
      "JWT_SECRET" : var.roost_jwt_token,
      "GOOGLE_CLIENT_ID" : var.google_client_id,
      "GOOGLE_CLIENT_SECRET" : var.google_client_secret,
      "AZURE_CLIENT_ID" : var.azure_client_id,
      "AZURE_CLIENT_SECRET" : var.azure_client_secret,
      "GITHUB_CLIENT_ID" : var.github_client_id,
      "GITHUB_CLIENT_SECRET" : var.github_client_secret,
      "LINKEDIN_CLIENT_ID" : var.linkedin_client_id,
      "LINKEDIN_CLIENT_SECRET" : var.linkedin_client_secret,
      "OKTA_CLIENT_ISSUER" : var.okta_issuer,
      "OKTA_CLIENT_ID" : var.okta_client_id,
      "OKTA_CLIENT_SECRET" : var.okta_client_secret,
    },
    "is_own_sql" : var.is_own_mysql,
    "ENV_DATABASE" : {
      "MYSQL_HOST" : var.mysql_host,
      "MYSQL_PORT" : var.mysql_port,
      "MYSQL_USERNAME" : var.mysql_username,
      "MYSQL_PASSWORD" : var.mysql_password,
      "MYSQL_ROOT_PASSWORD" : var.mysql_root_password,
      "MYSQL_DB_NAME" : var.mysql_db_name,
    }
  })

  first_az  = data.aws_availability_zones.available.names[0]
  second_az = data.aws_availability_zones.available.names[1]

  az1 = (var.region != "" && var.az1_suffix != "") ? format("%s%s", var.region, var.az1_suffix) : local.first_az
  az2 = (var.region != "" && var.az2_suffix != "") ? format("%s%s", var.region, var.az2_suffix) : local.second_az

  ec2_ami = var.ec2_ami != "" ? var.ec2_ami : data.aws_ami.ubuntu.image_id

  cidr_block = join("/",[var.ip_block_vpc,"26"])
  name = var.prefix
  project = format("%s-%s", var.prefix, var.company)

  ssh_key_pair_pub = length(tls_private_key.key_pair) > 0 ? tls_private_key.key_pair[0].public_key_openssh : ""
  ssh_key_pair_priv = length(tls_private_key.key_pair) > 0 ? tls_private_key.key_pair[0].private_key_pem : ""


}

data "aws_availability_zones" "available" {
  state = "available"
}

data "aws_ami" "ubuntu" {
  most_recent = true

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-jammy-22.04-amd64-server-*"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

  owners = ["099720109477"] # Canonical
}


resource "aws_instance" "roost_controlplane" {  
  ami                    = var.ec2_ami
  instance_type          = var.instance_type_controlplane
  key_name               = var.key_pair
  subnet_id              = aws_subnet.eaas_private_subnet2.id
  vpc_security_group_ids = [aws_security_group.controlplane.id]
  monitoring             = true
  associate_public_ip_address = false
  
  # private_dns_name_options {
  #   enable_resource_name_dns_a_record = true
  #   enable_resource_name_dns_aaaa_record = true
  #   hostname_type = "resource-name"
  # }

  root_block_device {
    volume_type = "gp3"
    volume_size = 50
  }

  ebs_block_device {
    delete_on_termination = false
    device_name = join("/",["","dev",var.device_name])
    volume_type = "gp3"
    volume_size = var.controlplane_disk
  }
  tags = {
    Project = local.project
    Name = join("-",[var.prefix, var.company, "enterprise-controlplane"])
  }
}
resource "aws_instance" "roost_eaas_server" {  
  ami                    = var.ec2_ami
  instance_type          = var.instance_type_controlplane
  key_name               = var.key_pair
  subnet_id              = aws_subnet.eaas_private_subnet1.id
  vpc_security_group_ids = [aws_security_group.eaas_server.id ]
  monitoring             = true
  associate_public_ip_address = false
  
  #  private_dns_name_options {
  #   enable_resource_name_dns_a_record = true
  #   enable_resource_name_dns_aaaa_record = true
  #   hostname_type = "resource-name"
  # }

  root_block_device {
    volume_type = "gp3"
    volume_size = 50
  }

  ebs_block_device {
    delete_on_termination = false
    device_name = join("/",["","dev",var.device_name])
    volume_type = "gp3"
    volume_size = var.eaas_disk
  }

  tags = {
    Project = local.project
    Name = join("-",[var.prefix, var.company, "eaas-server"])
  }
}
resource "aws_instance" "roost_jumphost" {
  ami                    = var.ec2_ami
  instance_type          = var.instance_type_controlplane
  key_name               = var.key_pair
  subnet_id              = aws_subnet.eaas_private_subnet2.id
  vpc_security_group_ids = [aws_security_group.jumphost.id]
  monitoring             = true
  associate_public_ip_address = false
  
  # private_dns_name_options {
  #   enable_resource_name_dns_a_record = true
  #   enable_resource_name_dns_aaaa_record = true
  #   hostname_type = "resource-name"
  # }

  root_block_device {
    volume_type = "gp3"
    volume_size = 50
  }

  ebs_block_device {
    delete_on_termination = false
    device_name = join("/",["","dev",var.device_name])
    volume_type = "gp3"
    volume_size = var.jumphost_disk
  }
  tags = {
    Project = local.project
    Name = join("-",[var.prefix, var.company, "jumphost-server"])
  }
}

resource "aws_instance" "roost_ssh" {
  ami                    = var.ec2_ami
  instance_type          = var.instance_type_jumphost
  key_name               = var.key_pair
  subnet_id              = aws_subnet.eaas_public_subnet1.id
  vpc_security_group_ids = [aws_security_group.bastion.id ]
  monitoring             = true
  associate_public_ip_address = true
  
  # private_dns_name_options {
  #   enable_resource_name_dns_a_record = true
  #   enable_resource_name_dns_aaaa_record = true
  #   hostname_type = "resource-name"
  # }

  # ebs_block_device {
  #  delete_on_termination = false
  #  device_name = join("/",["","dev",var.device_name])
  #  volume_type = "gp3"
  #  volume_size = 100
  # }

  tags = {
    Project = local.project
    Name = join("-",[var.prefix, var.company, "bastion-ssh"])
  }
}

resource "null_resource" "deploy-ssh-keypair-roost-ssh" {
  # Changes to roost_ssh id requires re-provisioning
  triggers = {
    roost_ssh_instance_id = aws_instance.roost_ssh.id
  }

  # Bootstrap script can run on any instance of the cluster
  # So we just choose the first in this case
  connection {
      type = "ssh"
      host = aws_instance.roost_ssh.public_ip
      user = "ubuntu"
      private_key = sensitive(file("${path.root}/data/${var.key_pair}"))
      timeout = "1m"
  }
  provisioner "file" {
    content = sensitive(file("${path.root}/data/${var.key_pair}"))
    destination = "/home/ubuntu/.ssh/${var.key_pair}"
  }

  provisioner "file" {
    content = templatefile("${path.root}/data/ssh_config.tftpl",{
      controlplane_ip = "${aws_instance.roost_controlplane.private_ip}",
      eaas_server_ip = "${aws_instance.roost_eaas_server.private_ip}",
      jumphost_ip = "${aws_instance.roost_jumphost.private_ip}",
      key_pair_name = "${var.key_pair}"
    })
    destination = "/home/ubuntu/.ssh/config"
  }

  provisioner "remote-exec" {
    # Bootstrap script called with private_ip of each node in the cluster
    inline = [
      "echo roost_ssh IP '${ aws_instance.roost_ssh.public_ip}' >> /tmp/test",
      "echo Controlplane IP '${aws_instance.roost_controlplane.private_dns}' >> /tmp/test",
      "chmod 0600 /home/ubuntu/.ssh/${var.key_pair}",
      "echo alias roostcp=\"ssh -i /home/ubuntu/.ssh/${var.key_pair} ubuntu@${aws_instance.roost_controlplane.private_ip}\" >> /home/ubuntu/.aliases",
      "echo alias roosteaas=\"ssh -i /home/ubuntu/.ssh/${var.key_pair} ubuntu@${aws_instance.roost_eaas_server.private_ip}\" >> /home/ubuntu/.aliases",
      "echo alias roostjump=\"ssh -i /home/ubuntu/.ssh/${var.key_pair} ubuntu@${aws_instance.roost_jumphost.private_ip}\" >> /home/ubuntu/.aliases",
    ]
  }
}

resource "null_resource" "provision-controlplane" {
  # Changes to controlplane id requires re-provisioning
  triggers = {
    controlplane_id = aws_instance.roost_controlplane.id
  }

  connection {
    type = "ssh"
    agent = false
    host = aws_instance.roost_controlplane.private_ip
    user = "ubuntu"
    private_key = sensitive(file("${path.root}/data/${var.key_pair}"))
    timeout = "1m"
    bastion_host = aws_instance.roost_ssh.public_ip
    bastion_private_key = sensitive(file("${path.root}/data/${var.key_pair}"))
  }

  provisioner "remote-exec" {
    inline = [
      "mkdir -p /var/tmp/Roost",
    ]
     on_failure = fail
  }

  provisioner "remote-exec" {
    inline = [
      "echo Running 'curl -s https://roost-stable.s3.us-west-2.amazonaws.com/enterprise/roost.sh | SETUP=1 CUSTOMER=${var.company}'",
      "curl -s https://roost-stable.s3.us-west-2.amazonaws.com/enterprise/roost.sh | SETUP=1 CUSTOMER=${var.company} bash -",
    ]
    on_failure = fail
  }

  provisioner "remote-exec" {
    inline = [
      "mkdir -p /var/tmp/Roost/.ssh",
    ]
     on_failure = fail
  }

  provisioner "file" {
    content = local.roost_eaas_config_json
    destination = "/var/tmp/Roost/config.json"
    on_failure = fail
  }

  provisioner "file" {
    content = sensitive(file("${path.root}/data/${var.key_pair}"))
    destination = "/var/tmp/Roost/.ssh/${var.key_pair}"
  }

  provisioner "remote-exec" {
    inline = [
      "echo 'Running: USE_ROOST_DEV_ENABLED=${var.dev} ROOST_VER=${var.roost_version} REACTUI_VER=${var.reactui_version} PROXY_VER=${var.proxy_version} /var/tmp/Roost/bin/roost-enterprise.sh -c /var/tmp/Roost/config.json -i roost' ",
      "USE_ROOST_DEV_ENABLED=${var.dev} ROOST_VER=${var.roost_version} REACTUI_VER=${var.reactui_version} PROXY_VER=${var.proxy_version} /var/tmp/Roost/bin/roost-enterprise.sh -c /var/tmp/Roost/config.json -i roost"
    ]
    on_failure = fail
  }
}
