variable "region" {
  description = "region"
  type        = string
  default     = "East US"
}

variable "env" {
  description = "environment dev/staging/prod"
  type        = string
  default     = "dev"
}

variable "vn_addr" {
  description = "virtual network address"
  type        = string
  default     = "10.0.0.0/16"
}

variable "subnet_addr" {
  description = "network subnet address"
  type        = string
  default     = "10.0.1.0/24"
}

variable "source_address" {
  description = "source address"
  type        = string
  default     = ""
}