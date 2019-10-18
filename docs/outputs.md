# Outputs

| Name | Description |
|------|-------------|
| application\_endpoint | The URI for accessing the application. |
| application\_health\_check | The URI for the application health checks. |
| install\_id | The string prefix for resources. |
| installer\_dashboard\_endpoint | The URI for accessing the backend console. |
| installer\_dashboard\_password | Generated password to unlock the installer dashboard. |
| primary\_public\_ip | The public IP address of the first primary node created. |
| ssh\_config\_file | Path to ssh\_config file for command: `ssh -F $\(terraform state show <terraform\_parent\_modules>.module.<module\_name>.module.primaries.local\_file.ssh\_config \| grep filename \| awk '\{print $3\}'\) default` |
| ssh\_private\_key | Path to the private key used for ssh authorization. |

