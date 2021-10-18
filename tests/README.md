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
release under test is used to install TFE onto said environment, and integration tests are perfomed.
