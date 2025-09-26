variable "tenancy_id" {
  description = "Tenancy OCID used to look up availability domains."
  type        = string
}

variable "compartment_id" {
  description = "Compartment OCID where compute instances will be created."
  type        = string
}

variable "name_prefix" {
  description = "Prefix applied to instance display names."
  type        = string
}

variable "subnet_id" {
  description = "Target subnet OCID for the primary VNIC."
  type        = string
}

variable "nsg_ids" {
  description = "List of Network Security Group OCIDs to attach to the primary VNIC."
  type        = list(string)
  default     = []
}

variable "assign_public_ip" {
  description = "Whether to assign a public IP to the primary VNIC."
  type        = bool
  default     = true
}

variable "instance_count" {
  description = "Number of compute instances to create."
  type        = number
  default     = 1
}

variable "instance_shape" {
  description = "Compute shape for all instances."
  type        = string
}

variable "instance_ocpus" {
  description = "Number of OCPUs for Flex shapes."
  type        = number
  default     = 1
}

variable "instance_memory_gbs" {
  description = "Memory (GB) for Flex shapes."
  type        = number
  default     = 6
}

variable "image_id" {
  description = "OCID of the boot image."
  type        = string
}

variable "ssh_authorized_keys" {
  description = "SSH public keys injected into instances."
  type        = string
}

variable "tags" {
  description = "Freeform tags applied to compute resources."
  type        = map(string)
  default     = {}
}