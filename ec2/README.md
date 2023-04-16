# Roost Setup from Terraform

This terraform script allows to setup Roost for enterprise customers. User has to provide valid Route 53 hosted zone where provided subdomain would be configured to access Roost.

Okta, Google, Github, Linked and Azure can be configured as Third-party auth provider to login into Roost.

By default, mysql container would be launched in controlplane instance to store Roost data. If willing to use RDS or other database, set var.is_own_mysql = true and update all `var.mysql_` with necessary details.

## Prerequisites

- Copy [terraform.tfvars.original](./terraform.tfvars.original) as terraform.tfvars and update necessary values.

- Update terraform state backend in provider.tf

```bash
    terraform plan
    terraform apply --auto-approve
```

## Important input parameters to set -

- region
- route53_hosted_zone_id
- ec2_ami
- enterprise_dns
- ip_block_vpc (VPC CIDR where Roost would be setup)
- okta_client_id or appropriate auth provider
- company (Provided by Roost team)

In case willing to use RDS, configure all `mysql_` related terraform variables.

## How to ssh into instance

Terraform generates new keypair and stores in [data](./data) if var.generate_key_pair = true.
If wish to use pre-existing key (say keypair1), follow below two steps.

1. set var.key_pair = keypair1 && var.generate_key_pair = false.

1. Place keypair in [data](./data) without extention name. e.g. (instead of keypair1.pem, it should be keypair1)

1. `terraform import aws_key_pair.ssh data/keypair1`
