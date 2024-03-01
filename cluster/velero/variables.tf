variable "namespace" {
  description = "The namespace in which Velero will be installed."
  type        = string
  default     = "velero"
}

variable "create_namespace" {
  type = bool
  description = "Create the namespace if it does not exist."
  default = false
}

variable "service_account_name" {
  description = "The name of the service account to create for Velero."
  type        = string
  default     = "velero"
}

variable "create_service_account" {
  description = "Create the service account if it does not exist."
  type        = bool
  default = true
}

variable "oidc_provider_uri" {
  description = "The OIDC provider URL."
  type        = string
}