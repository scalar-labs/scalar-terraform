# Setting Cloud Permissions for scalar-terraform

This guide explains the privileges for users to run scalar-terraform to deploy resources to the cloud.

In general, users who have policies or roles with higher enough privileges, such as the `*FullAccess` actions on AWS or the `Contributor` role on Azure, can deploy resources with scalar-terraform without problems. But for more secure use, you can create a dedicated user and give it limited privileges.

## AWS

### General Policy for Deployment with scalar-terraform

The following JSON is a general policy that allows users to manage resources for Scalar DLT with scalar-terraform.

To create a policy in the AWS console, open IAM > Policies and choose Create policy, then paste the JSON in the JSON tab. Usually it should be attached to the group to which the users running Terraform belong.

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

If you use S3 as a Terraform backend, the action `s3:PutObject` is needed additionally.

## Azure

### General Role for Deployment with scalar-terraform

The following shows a JSON that represents a custom role for users who manage resources for Scalar DLT with scalar-terraform.

In Azure Portal, you can create the role in the Subscriptions section. Choose your subscription and select Access control (IAM) from the menu, then click "+Add" and select "Add custom role". Once the role is created, you can assign it to a user or a group from "Add role assignment" in the "+Add" menu.

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

If you use Azure Storage as a Terraform backend, the built-in role `Storage Account Contributor` will work.
