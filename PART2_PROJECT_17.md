# AUTOMATE-INFRASTRUCTURE-WITH-IAC-USING-TERRAFORM-PART-2/4
Project 17 Terraform

Best practices Tagging  

**Tagging** helps you manage your resources much more efficiently:
* Resources are much better organized in ‘virtual’ groups
* They can be easily filtered and searched from console or programmatically
* Billing team can easily generate reports and determine how much each part of infrastructure costs how much (by department, by type, by environment, etc.)
* You can easily determine resources that are not being used and take actions accordingly
* If there are different teams in the organization using the same account, tagging can help differentiate who owns which resources  


Lets add multiple tags as a default set. for example, in out [terraform.tfvars](https://github.com/hectorproko/AUTOMATE-INFRASTRUCTURE-WITH-IAC-USING-TERRAFORM-PART-1-to-4/blob/main/PBL/terraform.tfvars) file we can have default tags defined.
``` bash
tags = {
  Enviroment      = "development" 
  Owner-Email     = "hectore@email.com"
  Managed-By      = "Terraform"
  Billing-Account = "1234567890"
}
```

Now we can tag all resources using the format below
``` bash
tags = merge(
    var.tags,
    {
      Name = "Name of the resource"
    },
  )
```

We need to to declare the variable `tags` in [variables.tf](https://github.com/hectorproko/AUTOMATE-INFRASTRUCTURE-WITH-IAC-USING-TERRAFORM-PART-1-to-4/blob/main/PBL/variables.tf) using the following format
``` bash
variable "tags" {
  description = "A mapping of tags to assign to all resources."
  type        = map(string)
  default     = {}
}
```
Now every time we need to make a change to the **tags**, we can do that in one single place `terraform.tfvars`  


**Internet Gateways & `format()` function**  
Create an **Internet Gateway** in a separate Terraform file [internet_gateway.tf](https://github.com/hectorproko/AUTOMATE-INFRASTRUCTURE-WITH-IAC-USING-TERRAFORM-PART-1-to-4/blob/main/PBL/modules/VPC/internet_gateway.tf)  

We have can use `format()` function to dynamically generate a unique name for a resource  

``` bash
resource "aws_internet_gateway" "ig" {
  vpc_id = aws_vpc.main.id
tags = merge(
    var.tags,
    {
      Name = format("%s-%s!", aws_vpc.main.id,"IG")
    } 
  )
}
```


In the example above the **first** of the `%s` takes the interpolated value of `aws_vpc.main.id` while the **second** `%s` appends a literal string IG and finally an exclamation mark is added in the end.  

This is useful when creating a resource with a `count` function or creating multiple resources using a `loop` which requires the **key-value pair** to be unique  




For example, each of our subnets should have a unique name in the **tag** section. We can accomplish this with `format()` function.

``` bash
tags = merge(
  var.tags,
  {
    Name = format("PrivateSubnet-%s", count.index)
  } 
)
```
The output should look something like this  
`Name = PrvateSubnet-0`  
`Name = PrvateSubnet-1`  
`Name = PrvateSubnet-2`  



NAT Gateways
Create 1 NAT Gateways and 1 Elastic IP (EIP) addresses
Now use similar approach to create the NAT Gateways in a new file called natgateway.tf.

Note: We need to create an Elastic IP for the NAT Gateway, and you can see the use of depends_on to indicate that the Internet Gateway resource must be available before this should be created. Although Terraform does a good job to manage dependencies, but in some cases, it is good to be explicit.
You can read more on dependencies here
resource "aws_eip" "nat_eip" {
  vpc        = true
  depends_on = [aws_internet_gateway.ig]
tags = merge(
    var.tags,
    {
      Name = format("%s-EIP", var.name)
    },
  )
}
resource "aws_nat_gateway" "nat" {
  allocation_id = aws_eip.nat_eip.id
  subnet_id     = element(aws_subnet.public.*.id, 0)
  depends_on    = [aws_internet_gateway.ig]
tags = merge(
    var.tags,
    {
      Name = format("%s-Nat", var.name)
    },
  )
}



**NAT Gateways**  

Creating 1 **NAT Gateway** and 1 **Elastic IP (EIP)** address in a new file called [natgateway.tf](https://github.com/hectorproko/AUTOMATE-INFRASTRUCTURE-WITH-IAC-USING-TERRAFORM-PART-1-to-4/blob/main/PBL/modules/VPC/natgateway.tf)  

We need to create an **Elastic IP** for the **NAT Gateway**, and we introduce the use of `depends_on` to indicate that the **Internet Gateway** resource must be available before this should be created.  

`depends_on` [Documentation](https://www.terraform.io/language/meta-arguments/depends_on)  

``` bash
resource "aws_eip" "nat_eip" {
  vpc        = true
  depends_on = [aws_internet_gateway.ig]
  tags = merge(
    var.tags,
    {
      Name = format("%s-EIP", var.name)
    },
  )
}

resource "aws_nat_gateway" "nat" {
  allocation_id = aws_eip.nat_eip.id
  subnet_id     = element(aws_subnet.public.*.id, 0)
  depends_on    = [aws_internet_gateway.ig]
  tags = merge(
    var.tags,
    {
      Name = format("%s-Nat", var.name)
    },
  )
}
```

### AWS ROUTES
To create **routes** for both **public** and **private** subnets we generate [route_tables.tf](https://github.com/hectorproko/AUTOMATE-INFRASTRUCTURE-WITH-IAC-USING-TERRAFORM-PART-1-to-4/blob/main/PBL/modules/VPC/route_tables.tf) with resources `aws_route_table`, `aws_route`, `aws_route_table_association`  

``` bash	
# create private route table
resource "aws_route_table" "private-rtb" {
  vpc_id = aws_vpc.main.id
  tags = merge(
    var.tags,
    {
      Name = format("%s-private-rtb", var.name)
    },
  )
}

# associate all private subnets to the private route table
resource "aws_route_table_association" "private-subnets-assoc" {
  count          = length(aws_subnet.private[*].id)
  subnet_id      = element(aws_subnet.private[*].id, count.index)
  route_table_id = aws_route_table.private-rtb.id
}

# create route table for the public subnets
resource "aws_route_table" "public-rtb" {
  vpc_id = aws_vpc.main.id
  tags = merge(
    var.tags,
    {
      Name = format("%s-public-rtb", var.name)
    },
  )
}

# create route for the public route table and attach the internet gateway
resource "aws_route" "public-rtb-route" {
  route_table_id         = aws_route_table.public-rtb.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.ig.id
}

# associate all public subnets to the public route table
resource "aws_route_table_association" "public-subnets-assoc" {
  count          = length(aws_subnet.public[*].id)
  subnet_id      = element(aws_subnet.public[*].id, count.index)
  route_table_id = aws_route_table.public-rtb.id
}
```


Now we run `terraform plan` and `terraform apply` it should add the following resources to **AWS** in **multi-az** set up:
* Our main VPC
* 2 Public subnets
* 4 Private subnets
* 1 Internet Gateway
* 1 NAT Gateway
* 1 EIP
* 2 Route tables  
  
This concludes the **Networking** part of **AWS** set up

Moving on to **Compute and Access Control** configuration automation using Terraform!

**AWS Identity and Access Management**  

[**IAM**](https://docs.aws.amazon.com/IAM/latest/UserGuide/introduction.html) and [**Roles**](https://docs.aws.amazon.com/IAM/latest/UserGuide/id_roles.html)  
We want to pass an IAM role our EC2 instances to give them access to some specific resources, so we need to do the following:  
1. Create [AssumeRole](https://docs.aws.amazon.com/STS/latest/APIReference/API_AssumeRole.html)  
   
*Assume Role uses Security Token Service (STS) API that returns a set of temporary security credentials that you can use to access AWS resources that you might not normally have access to. These temporary credentials consist of an access key ID, a secret access key, and a security token. Typically, you use AssumeRole within your account or for cross-account access.*  

Adding the following code to a new file named [roles.tf](https://github.com/hectorproko/AUTOMATE-INFRASTRUCTURE-WITH-IAC-USING-TERRAFORM-PART-1-to-4/blob/main/PBL/modules/VPC/roles.tf)

``` bash
resource "aws_iam_role" "ec2_instance_role" {
  name = "ec2_instance_role"
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Sid    = ""
        Principal = {
          Service = "ec2.amazonaws.com"
        }
      },
    ]
  })
  tags = merge(
    var.tags,
    {
      Name = "aws assume role"
    },
  )
}
```
In this code we are creating **AssumeRole** with **AssumeRole policy**. It grants to an entity, in our case it is an **EC2**, permissions to assume the role.  

2. Create IAM policy for this role  
   
This is where we need to define a required policy (i.e., permissions) according to our requirements. For example, allowing an **IAM role** to perform action **describe** applied to **EC2** instances:  
``` bash
resource "aws_iam_policy" "policy" {
  name        = "ec2_instance_policy"
  description = "A test policy"
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = [
          "ec2:Describe*",
        ]
        Effect   = "Allow"
        Resource = "*"
      },
    ]
})
tags = merge(
    var.tags,
    {
      Name =  "aws assume policy"
    },
  )
}
```

3. Attach the Policy to the IAM Role
This is where, we will be attaching the policy which we created above, to the role we created in the first step.  
``` bash
resource "aws_iam_role_policy_attachment" "test-attach" {
  role       = aws_iam_role.ec2_instance_role.name
  policy_arn = aws_iam_policy.policy.arn
}
```
4. Create an Instance Profile and interpolate the IAM Role  
``` bash
resource "aws_iam_instance_profile" "ip" {
  name = "aws_instance_profile_test"
  role =  aws_iam_role.ec2_instance_role.name
}
```
For now we are done with **Identity and Management**  

### CREATE SECURITY GROUPS

### CREATE CERTIFICATE FROM AMAZON CERIFICATE MANAGER

### CREATING AUSTOALING GROUPS

### STORAGE AND DATABASE
