locals {
  global_tags = {
    Env     = var.global_vars.env
    Project = var.global_vars.project
    Owner   = var.global_vars.owner
  }
}