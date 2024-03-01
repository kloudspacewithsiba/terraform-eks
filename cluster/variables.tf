variable "eks_name" {
  type = string
}

variable "eks_version" {
  type = string
}

variable "subnet_ids" {
  type = list(string)
}

variable "ami_type" {
  type = string
}

variable "capacity_type" {
  type = string
}

variable "instance_types" {
  type = list(string)
}

variable "scaling_config" {
  type = object({
    desired_size = number
    min_size     = number
    max_size     = number
  })
}

variable "configmap_roles" {
  
}

variable "configmap_users" {
  
}

variable "vpc_id" {
  
}