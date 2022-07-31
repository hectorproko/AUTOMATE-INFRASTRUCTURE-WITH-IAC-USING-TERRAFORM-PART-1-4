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
Create an Internet Gateway in a separate Terraform file internet_gateway.tf  
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


Did you notice how we have used format() function to dynamically generate a unique name for this resource? The first part of the %s takes the interpolated value of aws_vpc.main.id while the second %s appends a literal string IG and finally an exclamation mark is added in the end.
If any of the resources being created is either using the count function, or creating multiple resources using a loop, then a key-value pair that needs to be unique must be handled differently.

For example, each of our subnets should have a unique name in the tag section. Without the format() function, we would not be able to see uniqueness. With the format function, each private subnet’s tag will look like this.
Name = PrvateSubnet-0
Name = PrvateSubnet-1
Name = PrvateSubnet-2

Lets try and see that in action.
  tags = merge(
    var.tags,
    {
      Name = format("PrivateSubnet-%s", count.index)
    } 
  )




### AUTOMATE INFRASTRUCTURE WITH IAC USING TERRAFORM. PART 2

### AWS ROUTES

### CREATE SECURITY GROUPS

### CREATE CERTIFICATE FROM AMAZON CERIFICATE MANAGER

### CREATING AUSTOALING GROUPS

### STORAGE AND DATABASE
