variable "compartment_id" {
  description = "OCID of the compartment where networking resources should be created."
  type        = string
}

variable "name_prefix" {
  description = "Prefix applied to the display names of networking resources."
  type        = string
}

variable "vcn_cidr" {
  description = "CIDR block assigned to the VCN."
  type        = string
}

variable "subnet_cidr" {
  description = "CIDR block assigned to the public subnet."
  type        = string
}

variable "tags" {
  description = "Freeform tags to attach to networking resources."
  type        = map(string)
  default     = {}
}

variable "vcn_dns_label" {
  description = "DNS label for the VCN."
  type        = string
}

variable "subnet_dns_label" {
  description = "DNS label for the subnet."
  type        = string
}