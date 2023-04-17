variable "project_name" {
  description = "Name of ecs cluster"
  type        = string
  default     = "jpmc"
}

variable "ecs_task_execution_role_name" {
  description = "name of task execution role to be created."
  type        = string
  default     = "ecsTaskExecutionRole"
  validation {
    condition     = var.ecs_task_execution_role_name != ""
    error_message = "ecs_task_execution_role_name is required which must have permission to run ecs tasks"
  }
}
variable "UI_IMG" {
  description = "Roost UI image name"
  type        = string
  default     = "zbio/roost-web"
}

variable "UI_VER" {
  description = "Roost configuration UI tag"
  type        = string
  default     = "ecs"
}


variable "SERVER_IMG" {
  description = "Roost Server image name"
  type        = string
  default     = "zbio/roost-app"
}
variable "SERVER_VER" {
  description = "Roost configuration Server tag"
  type        = string
  default     = "ecs"
}

variable "RELEASE_IMG" {
  description = "Roost Release server image name"
  type        = string
  default     = "zbio/roost-eaas"
}
variable "RELEASE_VER" {
  description = "Roost configuration Release server tag"
  type        = string
  default     = "ecs"
}

variable "JUMPHOST_IMG" {
  description = "Roost Jumphost image name"
  type        = string
  default     = "zbio/roost-jump"
}

variable "JUMPHOST_VER" {
  description = "Roost configuration Release jumphost tag"
  type        = string
  default     = "ecs"
}

variable "PROXY_VER" {
  description = "Roost configuration for proxy tag"
  type        = string
  default     = "ecs"
}

variable "NGINX_IMG" {
  description = "Roost Nginx image name"
  type        = string
  default     = "zbio/roost-nginx"
}

variable "NGINX_VER" {
  description = "Roost configuration nginx tag"
  type        = string
  default     = "ecs"
}

variable "create_cluster" {
  description = "Roost create ecs cluster"
  type        = bool
  default     = false
}

variable "private_subnet" {
  description = "One private subnet with the nat gateway attached is required to not use public ip in ecs services. "
  type        = string
  default     = ""
}

variable "cluster_name" {
  description = "Roost create ecs cluster"
  type        = string
  default     = ""
}

variable "region" {
  description = "region where Roost setup would occur"
  type        = string
  default     = ""
  validation {
    condition     = var.region != ""
    error_message = "region is required where roost resources can be created"
  }
}

variable "vpc_id" {
  description = "VPC ID where roost resources are created"
  type        = string
  default     = ""
  validation {
    condition     = var.vpc_id != ""
    error_message = "vpc_id is required where roost resources can be created"
  }
}

variable "subnets" {
  description = "Atleast two subnets where ecs loadbalancer would be created."
  type        = list(string)
  default     = [""]
  validation {
    condition     = length(var.subnets) > 1
    error_message = "Atleast two public subnets are required for loadbalancer"
  }
}


variable "certificate_arn" {
  description = "certificate_arn of the HTTPs certificate to be used in loadbalancer"
  type        = string
  default     = ""
  validation {
    condition     = var.certificate_arn != ""
    error_message = "Atleast two public subnets are required for loadbalancer"
  }
}

variable "enterprise_dns" {
  description = "Roost Enterprise DNS"
  type        = string
  default     = ""
  validation {
    condition     = var.enterprise_dns != ""
    error_message = "Roost Enterprise DNS cannot be empty"
  }
}

variable "okta_client_issuer" {
  description = "OKTA CLIENT ISSUER"
  type        = string
  default     = ""
}

variable "okta_client_id" {
  description = "OKTA_CLIENT_ID"
  type        = string
  default     = ""
}

variable "okta_client_secret" {
  description = "OKTA_CLIENT_SECRET"
  type        = string
  default     = ""
}

variable "roost_version" {
  description = "ROOST VERSION"
  type        = string
  default     = "ecs"
  validation {
    condition     = var.roost_version != ""
    error_message = "ROOST VERSION cannot be empty"
  }
}

variable "azure_client_id" {
  description = "AZURE_CLIENT_ID"
  type        = string
  default     = ""
}

variable "azure_client_secret" {
  description = "AZURE_CLIENT_SECRET"
  type        = string
  default     = ""
}

variable "azure_adfs_client_issuer" {
  description = "AZURE_ADFS_CLIENT_ISSUER"
  type        = string
  default     = ""
}

variable "azure_adfs_client_id" {
  description = "AZURE_ADFS_CLIENT_ID"
  type        = string
  default     = ""
}

variable "azure_adfs_client_secret" {
  description = "AZURE_ADFS_CLIENT_secret"
  type        = string
  default     = ""
}

variable "enterprise_logo" {
  description = "ENTERPRISE LOGO"
  type        = string
  default     = "https://roost.ai/hubfs/logos/Roost.ai-logo-gold.svg"
}

variable "admin_email" {
  description = "ADMIN EMAIL"
  type        = string
  default     = ""

  validation {
    condition     = var.admin_email != ""
    error_message = "Roost admin email cannot be empty"
  }
}

variable "company_name" {
  description = "COMPANY NAME"
  type        = string
  default     = ""

  validation {
    condition     = var.company_name != ""
    error_message = "COMPANY NAME cannot be empty"
  }
}

variable "mysql_user" {
  description = "My SQL user name"
  type        = string
  default     = "admin"

  validation {
    condition     = var.mysql_user != ""
    error_message = "My SQL user name cannot be empty"
  }
}

variable "mysql_password" {
  description = "My SQL password"
  type        = string
  default     = ""

  validation {
    condition     = var.mysql_password != ""
    error_message = "My SQL password cannot be empty"
  }
}

variable "mysql_host" {
  description = "My SQL Host"
  type        = string
  default     = ""

  validation {
    condition     = var.mysql_host != ""
    error_message = "My SQL Host cannot be empty"
  }
}

variable "dbname" {
  description = "Roost DBNAME"
  type        = string
  default     = "roostio"

  validation {
    condition     = var.dbname != ""
    error_message = "Roost DBNAME cannot be empty"
  }
}

variable "mysql_port" {
  description = "My SQL Port"
  type        = string
  default     = "3306"

  validation {
    condition     = var.mysql_port != ""
    error_message = "My SQL Port cannot be empty"
  }
}

variable "roost_local_key" {
  description = "ROOST LOCAL KEY"
  type        = string
  default     = "06b5e496f8f53139de7d2cc03b1e71ce"
}

variable "roost_verbose_level" {
  description = "ROOST Verbose level"
  type        = string
  default     = "4"
}
