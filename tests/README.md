# Terraform Test

The directories in here are considered Terraform Test Modules (TTM). These TTM
directories are used in our continuous integration processes. The README of each
TTM will document for which CI process the TTM is used.

These commands will be run on Pull Requests automatically:

- `terraform fmt`
- `tflint`

## TFE Module CI Testing with GitHub Actions

[GitHub Actions](../.github/workflows/handler-test.yml) is used to create a build
that will ensure that the module creates the desired Terraform Enterprise (TFE)
environment. These tests also leverage Terraform Cloud workspaces to allow
maintainers to run and audit contributions to this repository.

### Commands

These commands will be run by Maintainers manually after initial review:

- `terraform init`
- `terraform validate`
- `terraform plan`
- `terraform apply`
- `k6`
- `terraform destroy`

## TFE Integration Testing with CircleCI

TFE integration testing is perfomed via CircleCI inside the [`ptfe-replicated`](https://github.com/hashicorp/ptfe-replicated/blob/master/.circleci/config.yml)
repository. Various environment scenarios are created via this module's TTMs as well as that
of [AWS's](https://github.com/hashicorp/terraform-aws-terraform-enterprise/tree/main/tests) and [GCP's](https://github.com/hashicorp/terraform-aws-terraform-enterprise/tree/main/tests). The TFE
release under test is used to install TFE onto said environment, and integration tests are performed.

## Local Testing with k6 and tfe-load-test

Github Actions and CircleCI test the modules present in the test directory using k6 and configuration located in the 
[tfe-load-test](https://github.com/hashicorp/tfe-load-test) repository. Each module has a run-tests.sh script present
that automates the same actions taken by the aforementioned CI systems when validating a running TFE instance. These
scripts assume:

1. You have k6 installed on your system on a known path
1. The tfe-load-test repository is cloned on your local filesystem
1. For instances requiring a ssh proxy you must have a local copy of the bastion
   ssh private key.

Usage:

```
./run-tests.sh -h
This script bootstraps the k6 / tfe-load-test environment and executes a smoke-test against an active TFE instance deployed with the terraform-azure-terraform-enterprise module.

Syntax: run-tests.sh [-h|k|t|b|s|l]
options:
h     Print this Help.
k     (required) The path to the k6 binary.
t     (required) The path to the tfe-load-test repository.
b     (required) The path to the bastion server ssh private key.
s     (optional) Skip the admin user initialization and tfe token retrieval (This is useful for secondary / repeated test runs).
l     (optional) Bind the test proxy to localhost instead of the detected ip address (This is useful when testing from within a docker container).
```
