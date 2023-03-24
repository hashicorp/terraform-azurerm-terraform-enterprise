# Example: Standalone Mounted Disk Mode Terraform Enterprise as a DEMO

## About this test

This test for Terraform Enterprise creates a TFE
installation with the following traits.

- Standalone
- Mounted Disk mode
- a small VM machine type (Standard_D4_v3)
- Ubuntu 20.04 as the VM image
- a publicly accessible HTTP load balancer with TLS termination

## Pre-requisites

This test assumes the following resources exist.

- TFE license on a filepath accessible by tests
