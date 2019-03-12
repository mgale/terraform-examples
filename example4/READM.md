# Simple Example 

    Builds a VPC along with subnets and NAT Gateways.

Initial Plan
```
Plan: 20 to add, 0 to change, 0 to destroy.

------------------------------------------------------------------------

Note: You didn't specify an "-out" parameter to save this plan, so Terraform
can't guarantee that exactly these actions will be performed if
"terraform apply" is subsequently run.
```

First Apply
```
Apply complete! Resources: 20 added, 0 changed, 0 destroyed.

real	2m12.436s
user	0m1.926s
sys	0m0.807s
```

Second Plan
```
No changes. Infrastructure is up-to-date.

This means that Terraform did not detect any differences between your
configuration and real physical resources that exist. As a result, no
actions need to be performed.

real	0m10.053s
user	0m1.380s
sys	0m0.464s
```