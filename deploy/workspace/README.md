# Workspace tf state area

This area is for things that are by and large the same
between different environments, but could have variable
names, counts, values.

For example:

Dev and prod have the same things:

- EC2 bastion in a vpc
- EC2 server
- Networking
- Autoscaling (multi az)

The difference could come as:

- Keys of EC2 bastion
- Size of EC2 server
- Networking VPC CIDR (to avoid overlapping blocks)
- Autoscaling rules, metrics, target/desired count
