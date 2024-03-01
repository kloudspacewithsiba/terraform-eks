variable "vpc_name" {
  type = string
}

variable "region" {
  type = string
}

variable "tags" {
  type = object({
    ConfigManagement = string
    Owner            = string
    Site             = string
    Billing          = string
    Environment      = string
  })
}

variable "vpc_cidr" {
  type = string
}
