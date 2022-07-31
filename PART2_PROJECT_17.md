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






### AUTOMATE INFRASTRUCTURE WITH IAC USING TERRAFORM. PART 2

### AWS ROUTES

### CREATE SECURITY GROUPS

### CREATE CERTIFICATE FROM AMAZON CERIFICATE MANAGER

### CREATING AUSTOALING GROUPS

### STORAGE AND DATABASE
