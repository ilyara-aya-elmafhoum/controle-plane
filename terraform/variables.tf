# variables.tf
variable "openstack_cloud" {
  description = "Nom du cloud OpenStack"
  type        = string
}

variable "OS_USERNAME" {
  description = "Nom d'utilisateur OpenStack"
  type        = string
}

variable "OS_PASSWORD" {
  description = "Mot de passe OpenStack"
  type        = string
  sensitive   = true
}

variable "OS_PROJECT_NAME" {
  description = "Nom du projet OpenStack"
  type        = string
}

variable "OS_auth_url" {
  description = "URL d'authentification OpenStack"
  type        = string
}

variable "ssh_key_name" {
  description = "Nom de la clé SSH dans OpenStack"
  type        = string
  default     = "my-ssh-key"  # Ajoutez une valeur par défaut
}

variable "sysadmin_pub_key" {
  description = "Clé publique SSH sysadmin"
  type        = string
}

variable "devops_aya_pub_key" {
  description = "Clé publique SSH devops-aya"
  type        = string
}

variable "terraform_bot_pub_key" {
  description = "Clé publique SSH terraform-bot"
  type        = string
}

variable "vm_flavor" {
  description = "Type d'instance VM"
  type        = string
  default     = "nva2_a4_ram8_disk50_perf2"  # Valeur par défaut
}

variable "vm_image" {
  description = "Image de la VM"
  type        = string
  default     = "Ubuntu 22.04"  # Valeur par défaut
}

variable "floating_ip_pool" {
  description = "Pool d'IP flottantes"
  type        = string
  default     = "public"  # Valeur par défaut
}

variable "admin_cidr" {
  description = "CIDR admin pour les règles de sécurité"
  type        = string
  default     = "0.0.0.0/0"  # Valeur par défaut
}

variable "sysadmin_pub_key_path" {
  description = "Path to the sysadmin SSH public key"
  type        = string
}

variable "devops_aya_pub_key_path" {
  description = "Path to the devops Aya SSH public key"
  type        = string
}

variable "terraform_bot_pub_key_path" {
  description = "Path to the terraform bot SSH public key"
  type        = string
}
