## This module block inherits the default (non-aliased) google provider configuration 
module "implicit-provider-inheritance" {
  source = "./modules/first-module"
  instance_name = "vm-sarah-test"
}

## This module block is explicitly passed the aliased google provider configuration
## Made to be the default provider configuration in the module, so the same module
## works ok
module "explicit-provider-passing-make-alias-the-default-provider" {
  providers = {
    google = google.google-europe-west
  }
  source = "./modules/first-module"
  instance_name = "vm-sarah-test"
}

## This module is written to expect 2 configurations of the Google provider
## block is explicitly passed the aliased google provider configuration
module "explicit-provider-passing-with-2-configurations" {
  providers = {
    google = google
    google.google-europe-west = google.google-europe-west
  }
  source = "./modules/second-module"
  instance_name = "vm-sarah-test"
}