variable "prefix" {
  description = "The prefix which should be used for all resources in this example"
  type = string
  default = "lab1"
}

variable "location" {
  description = "The Azure Region in which all resources in this example should be created."
  type = string
  default = "southcentralus"
}
variable "username" {
  description = "User for the VM"
}
variable "password" {
  description = "The password for the user of the VM."
  default = "Udacitylab1demo"
}