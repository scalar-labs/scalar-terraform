# Restricting Cloud Privileges for scalar-terraform

This guide explains how to restrict privileges for running scalar-terraform.

In general from security perspective, it is better to assign restricted privileges to users not to make them able to do operations that they are not supposed to do.

## AWS

### A Policy for Deployment with scalar-terraform

The following JSON is a policy that allows users to manage resources for Scalar DLT with scalar-terraform. Please note that it is sufficient but not necessary since, for example, it doesn't limit the target resource with `"Resource": "*"` so it can/should be further restricted.

To create a policy in the AWS console, open IAM > Policies and choose Create policy, then paste the JSON in the JSON tab. Usually it should be attached to a group of users who run scalar-terraform.

```json
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Effect": "Allow",
            "Action": [
                "ec2:*Address",
                "ec2:*InternetGateway",
                "ec2:*Ipv6Addresses",
                "ec2:*KeyPair",
                "ec2:*NatGateway",
                "ec2:*PrivateIpAddresses",
                "ec2:*RouteTable",
                "ec2:*SecurityGroup*",
                "ec2:*Subnet*",
                "ec2:*SubnetCidrBlock",
                "ec2:*Tags",
                "ec2:*Volume",
                "ec2:*VpcCidrBlock",
                "ec2:CreateRoute",
                "ec2:CreateVpc",
                "ec2:DeleteRoute",
                "ec2:DeleteVpc",
                "ec2:Describe*",
                "ec2:Get*",
                "ec2:ModifyVpcAttribute",
                "ec2:ReplaceRouteTableAssociation",
                "ec2:RunInstances",
                "ec2:StartInstances",
                "ec2:StopInstances",
                "ec2:TerminateInstances",
                "elasticloadbalancing:*",
                "iam:AddRoleToInstanceProfile",
                "iam:AttachRolePolicy",
                "iam:CreateInstanceProfile",
                "iam:CreatePolicy",
                "iam:CreateRole",
                "iam:DeleteInstanceProfile",
                "iam:DeletePolicy",
                "iam:DeleteRole",
                "iam:DetachRolePolicy",
                "iam:GetInstanceProfile",
                "iam:GetPolicy",
                "iam:GetPolicyVersion",
                "iam:GetRole",
                "iam:ListAttachedRolePolicies",
                "iam:ListInstanceProfilesForRole",
                "iam:ListPolicyVersions",
                "iam:PassRole",
                "iam:RemoveRoleFromInstanceProfile",
                "iam:TagRole",
                "route53:*HostedZone*",
                "route53:ChangeResourceRecordSets",
                "route53:ChangeTagsForResource",
                "route53:Get*",
                "route53:List*",
                "s3:GetBucketLocation",
                "s3:GetObject",
                "s3:ListBucket"
            ],
            "Resource": "*"
        }
    ]
}
```

### Using S3 as a Terraform Backend

If you use S3 as a Terraform backend, the action `s3:PutObject` needs to be added to the above list.

## Azure

### A Role for Deployment with scalar-terraform

The following JSON is a custom role that allow users to manage resources for Scalar DLT with scalar-terraform. This it also sufficient but not necessary as described in AWS section.

In Azure Portal, you can create the role in Subscriptions section. Choose your subscription and select Access control (IAM) from the menu, then click "+Add" and select "Add custom role". Once the role is created, you can assign it to a user or a group from "Add role assignment" in the "+Add" menu.

Please keep your subscription ID in the `assignableScopes` array.

```json
{
    "properties": {
        "roleName": "Scalar Terraform Runner",
        "description": "",
        "assignableScopes": [
            "/subscriptions/xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx"
        ],
        "permissions": [
            {
                "actions": [
                    "Microsoft.Authorization/roleAssignments/*",
                    "Microsoft.Compute/availabilitySets/*",
                    "Microsoft.Compute/disks/*",
                    "Microsoft.Compute/virtualMachines/*",
                    "Microsoft.Network/loadBalancers/*",
                    "Microsoft.Network/networkInterfaces/*",
                    "Microsoft.Network/networkSecurityGroups/*",
                    "Microsoft.Network/privateDnsZones/*",
                    "Microsoft.Network/publicIPAddresses/*",
                    "Microsoft.Network/virtualNetworks/*",
                    "Microsoft.Resources/subscriptions/resourceGroups/*"
                ],
                "notActions": [],
                "dataActions": [],
                "notDataActions": []
            }
        ]
    }
}
```

### Using Azure Storage as a Terraform Backend

If you use Azure Storage as a Terraform backend, the built-in role `Storage Account Contributor` needs to be assigned additionally.
