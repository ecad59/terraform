variable  "pm_api_url_main" {
    default =  ""
}

variable  "pm_api_token_id" {
    default =  ""
}

variable  "pm_api_token_secret" {
    default =  ""
}

variable  "target_node_main" {
    default =  ""
}

variable "clone" {
    description = "cloud init clone name"
    default =  ""
}

variable "public_key_path" {
  description = "Path to file containing public key"
  default     = ""
}

variable "private_key_path" {
  description = "Path to file containing private key"
  default     = ""
}