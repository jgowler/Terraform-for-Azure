variable "subscription_id" {
    type = string
    default = ""
    sensitive = true
}
variable "tenant_id" {
    type = string
    default = ""
    sensitive = true
}
variable "service_account_id" {
    type = string
    default = ""
    sensitive = true
}
variable "service_account_secret" {
    type = string
    default = ""
    sensitive = true
}
variable "resource_group" {
    type = string
    description = "The resource group for Terraform projects"  
}