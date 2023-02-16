variable "region" {
  default = ""
}

variable "region_zone" {
  default = ""
}

variable "project_id" {
  description = "gcp project ID"
  default = ""
}

variable "service_account" {
  description = "gcp service account"
  default = ""
}
variable "project_name" {
  description = "gcp project Name"
  default = ""
}

variable "short_project" {
  description = "instance short name"
  default = ""
}

variable "credentials_file_path" {
  description = "Path to the JSON file used to describe your account credentials"
  default     = ""
}

variable "public_key_path" {
  description = "Path to file containing public key"
  default     = ""
}

variable "private_key_path" {
  description = "Path to file containing private key"
  default     = ""
}

variable "env_src_path" {
  description = "Path to install script within this repository"
  default     = ""
}

variable "env_dest_path" {
  description = "Path to put the install script on each destination resource"
  default     = ""
}

variable "docker_compose_src_path" {
  description = "Path to copy docker-compose within this repository"
  default     = ""
}

variable "docker_compose_dest_path" {
  description = "Path to put the copy docker-compose on each destination resource"
  default     = ""
}

variable "machine_type" {
  description = "machine_type"
  default     = ""
}

variable "ssh_user" {
  description = "ssh user"
  default     = ""
}
