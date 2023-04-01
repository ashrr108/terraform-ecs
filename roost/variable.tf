variable "prefix" {
  description = "Prefix to be used to uniquely identify EaaS resources."
  type        = string
  default     = "terraform-eaas"
}
variable "region" {
  description = "Region where EaaS would setup. Default: 'us-west-1"
  type = string
  default = "us-west-1"
}

variable "az1_suffix" {
  description = "Availability zone suffix. e.g. a, b, c. Default: ''"
  type = string
  default = ""
}

variable "az2_suffix" {
  description = "Availability zone suffix. e.g. a, b, c. Default: ''"
  type = string
  default = ""
}

variable "ec2_ami" {
  description = "AMI used to launch all instances. Default 'ami-02ea247e531eb3ce6'"
  type = string
  default = "ami-02ea247e531eb3ce6"
}
variable "key_pair"{
  description = "ssh key-pair would be generated with provided name in path.root/data directory."
  type = string
  default = "roost-keypair"
}
variable "generate_key_pair"{
  description = "Default: true. Set false to use existing AWS keypair name provided as var.key_pair. Keypair must exists in path.root/data with name exectly matching keypair name. (file must not include extension)"
  type = string
  default = true
}
variable "route53_hosted_zone_id" {
  description = "Route53 hosted zone ID where subdomain would be configured."
  type = string
  default = ""
}
variable "enterprise_dns" {
  description = "Fully qualified sub domain name."
  type = string
  default = ""
}

variable "ip_block_vpc" {
  description = "IP for CIDR block for VPC"
  type = string
  default = "172.32.255.192"
}

variable "google_client_id" {
  description = "user ID of GCP"
  type = string
  default = ""
}
variable "google_client_secret" {
  description = "user secret of GCP"
  type = string
  sensitive = true
  default = ""
}
variable "github_client_id" {
  description = "user ID of Github"
  type = string
  default = ""
}
variable "github_client_secret" {
  description = "user secret of Github"
  type = string
  sensitive = true
  default = ""
}
variable "azure_client_id" {
  description = "user ID of Azure"
  type = string
  default = ""
}
variable "azure_client_secret" {
  description = "user secret of Azure"
  type = string
  sensitive = true
  default = ""
}
variable "linkedin_client_id" {
  description = "user ID of LinkedIn"
  type = string
  default = ""
}
variable "linkedin_client_secret" {
  description = "user secret of LinkedIn"
  type = string
  sensitive = true
  default = ""
}
variable "okta_client_id" {
  description = "user ID of Okta"
  type = string
  default = ""
}
variable "okta_client_secret" {
  description = "user secret of Okta"
  type = string
  nullable = false
  sensitive = true
}
variable "okta_issuer" {
  description = "user issuer of Okta, if okta id and secret are provided."
  type = string
}

variable "roost_jwt_token" {
  description = "Roost authorization token."
  type = string
  nullable = false
  sensitive = true
}
variable "device_name" {
  description = "Raw block device name which is available in the instance when ebs is attached."
  type = string
  default = "sdh"
}
variable "deletion_protection"{
  description = "Loadbalancer deletion_protection flag. Default false"
  type = bool
  default = false
}
variable "company" {
  description = "Name of the company"
  type = string
  default = "zbio"
}

variable "company_logo" {
  description = "Logo of the Enterprise. Default to roost logo"
  type        = string
  default     = "https://roost.ai/hubfs/logos/LOGO-roost.png"
}

variable "enterprise_email_domain" {
  description = "Enterprise email domain. Default ''"
  type = string
  default = ""
}
variable "admin_email" {
  description = "Admin email."
  type = string
  default = ""
}
variable "admin_email_pass" {
  description = "Admin email."
  type = string
  default = ""
}

variable "senders_email" {
  description = "senders email"
  type = string
  default = ""
}

variable "senders_email_pass" {
  description = "senders email password"
  type = string
  default = ""
}
variable "email_smtp_host" {
  description = "SMTP Host"
  type = string
  default = ""
}
variable "email_smtp_port" {
  description = "SMTP Port. Default '465'"
  type = string
  default = "465"
}

variable "enterprise_ssl_certificate_path" {
  description = "SSL certificates path. Default /var/tmp/Roost/certs/server.cer"
  type        = string
  default     = "/var/tmp/Roost/certs/server.cer"
}

variable "enterprise_ssl_certificate_key_path" {
  description = "SSL certificate key path. Default /var/tmp/Roost/certs/server.key"
  type        = string
  default     = "/var/tmp/Roost/certs/server.key"
}

variable "is_own_mysql"{
  description = "Set true if you want to use roost embedded database."
  type = bool
  default = false
}
variable "mysql_username" {
  description = "mysql username."
  type = string
  default = ""
}
variable "mysql_password" {
  description = "mysql password."
  type = string 
  default = ""
}
variable "mysql_port" {
  description = "mysql host port."  
  type = number
  default = 3306
}
variable "mysql_root_password" {
  description = "mysql root password."
  type = string
  default = ""
}
variable "mysql_host"{
  description = "mysql host url."
  type = string
  default = ""
}
variable "mysql_db_name" {
  description = "mysql database name."
  type = string
}
variable "instance_type_controlplane" {
  description = "Instance type for controlplane and eaas server"
  type = string
  default = "c5.2xlarge"
}
variable "instance_type_jumphost" {
  description = "Instance type for jumphost"
  type = string
  default = "t2.micro"
}

variable "roost_version" {
  description = "Version of Roost EaaS"
  type = string
  default = "v1.1.0"
}

variable "eaas_disk" {
  description = "EaaS Roost Disk size."
  type = number
  default = 150
}

variable "jumphost_disk" {
  description = "Roost Jumphost Disk size."
  type = number
  default = 100
}

variable "controlplane_disk" {
  description = "Roost Controlplane Disk size."
  type = number
  default = 100
}

variable "reactui_version" {
  description = "Version of Roost React UI"
  type = string
  default = "v1.1.0"
}

variable "proxy_version" {
  description = "Version of Roost Console Proxy"
  type = string
  default = "v1.1.0"
}

variable "certificate_arn" {
  description = "ACM certificate arn to use"
  type = string
  default = ""
}
variable "dev"{
  description = "Dev mode flag. Enable Debug. Default false"
  type = bool
  default = false
}
