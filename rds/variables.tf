variable "project_name" {
  description = "Project identifier."
  type        = string
  default     = "jpmc"
}

variable "region" {
  description = "region where resources would be created."
  type        = string
  default     = "ap-south-1"
}

variable "vpc_security_group_ids" {
  description = "List of security Group IDs to be added into database for intervpc access permission as well as custom sg"
  type        = list(string)
  default     = [""]
}

variable "subnets" {
  description = "Atleast two subnets where database would be created."
  type        = list(string)
  default     = ["", ""]
  validation {
    condition     = length(var.subnets) > 1 && var.subnets[0] != "" && var.subnets[1] != ""
    error_message = "Atleast two subnets are required for database"
  }
}
variable "password" {
  description = "master password for RDS"
  type        = string
  default     = ""
  validation {
    condition     = var.password != ""
    error_message = "password can not be empty"
  }
}
variable "user" {
  description = "RDS user"
  type        = string
  default     = "roost"
}
variable "port" {
  description = "RDS port"
  type        = string
  default     = "3306"
}
