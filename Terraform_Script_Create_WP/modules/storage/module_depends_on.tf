/*
    Add the following line to the resource in this module that depends on the completion of external module components:

    depends_on = ["${var.storage_depends_on}"]

    This will force Terraform to wait until the dependant external resources are created before proceeding with the creation of the
    resource that contains the line above.

    This is a hack until Terraform officially support module depends_on.
*/

variable "storage_depends_on" {
  type    = any
  default = null
}