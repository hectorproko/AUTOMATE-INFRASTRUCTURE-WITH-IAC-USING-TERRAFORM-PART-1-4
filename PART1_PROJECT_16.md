# AUTOMATE-INFRASTRUCTURE-WITH-IAC-USING-TERRAFORM-PART-1/4
Project 16 Terraform

After you have built AWS infrastructure for 2 websites manually, it is time to automate the process using Terraform.
Let us start building the same set up with the power of Infrastructure as Code (IaC)

![Markdown Logo](https://raw.githubusercontent.com/hectorproko/AWS-CLOUD-SOLUTION-FOR-2-COMPANY-WEBSITES-USING-A-REVERSE-PROXY-TECHNOLOGY/main/images/tooling_project_15.png)  

### AUTOMATE INFRASTRUCTURE WITH IAC USING TERRAFORM PART 1
You must have completed Terraform course from the Learning dashboard

Create an IAM user, name it terraform (ensure that the user has only programatic access to your AWS account) and grant this user AdministratorAccess permissions.

IAM > Users > Add users  
* **Step1**:  
  * User name: **terraform**  
  * Select AWS credential type: **Access key - Programmatic access**  
* **Step2**:  
  * Create group  
    * Group name: **terraform**  
    * Policy name:  `AdministratorAccess`  
* **Step3**:  
  * Add tags  
    * Name **terraform**  
* **Step4**:  
    * Review  
* **Step5**:  
    * Store Access key ID and Secret access key  


![Markdown Logo](https://raw.githubusercontent.com/hectorproko/AUTOMATE-INFRASTRUCTURE-WITH-IAC-USING-TERRAFORM-PART-1-to-4/main/images/users.png)  

So I have pip installed

pip install boto3

``` bash
hector@hector-Laptop:~$ pip list | grep boto3
boto3                        1.17.112
hector@hector-Laptop:~$
```

I will use AWS CLI to authenticate so I make sure I have installed
``` bash
hector@hector-Laptop:~$ aws --version
aws-cli/1.22.71 Python/3.8.10 Linux/5.4.0-109-generic botocore/1.24.16
hector@hector-Laptop:~$
```

Going to set authentication configuration on AWS CLI for user terraform  
[Guide](https://boto3.amazonaws.com/v1/documentation/api/latest/guide/quickstart.html) to configure the Python SDK properly. 

``` bash
hector@hector-Laptop:~$ aws configure
AWS Access Key ID [****************HQXB]: xxxxxxxxxxxxxxxxxxxx
AWS Secret Access Key [****************equ5]: xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx
Default region name [us-east-1]:
Default output format [None]:
hector@hector-Laptop:~$
```

Create an [S3 bucket](https://docs.aws.amazon.com/AmazonS3/latest/userguide/Welcome.html) to store Terraform state file.   
Amazon S3 > Buckets > Create Bucket  
* General Configuration  
  * Bucket name: `hector-dev-terraform-bucket`  
  * AWS Region: `us-east-1 ` 
* Tags
  * Name `hector-dev-terraform-bucket`  


![Markdown Logo](https://raw.githubusercontent.com/hectorproko/AUTOMATE-INFRASTRUCTURE-WITH-IAC-USING-TERRAFORM-PART-1-to-4/main/images/buckets.png)  

When you have configured authentication and installed `boto3`, make sure you can programmatically access your
``` bash
hector@hector-Laptop:~$ python3
Python 3.8.10 (default, Mar 15 2022, 12:22:08)
[GCC 9.4.0] on linux
Type "help", "copyright", "credits" or "license" for more information.
>>> import boto3
>>> s3 = boto3.resource('s3')
>>> for bucket in s3.buckets.all():
...     print(bucket.name)
...
hector-dev-terraform-bucket #Returns the name of our bucket`
>>>
```
### VPC | SUBNETS | SECURITY GROUPS

Update the system packages
udo apt update
Install the wget and unzip package to download and extract terraform setup

sudo apt-get install wget unzip -y

Installing **terraform**   
``` bash
hector@hector-Laptop:~/Project16-17$ sudo wget https://releases.hashicorp.com/terraform/0.14.7/terraform_0.14.7_linux_amd64.zip #download terraform setup
hector@hector-Laptop:~/Project16-17$ ls #zip file downloaded
PBL  README.md  terraform_1.1.9_linux_amd64.zip
hector@hector-Laptop:~/Project16-17$ sudo unzip terraform_1.1.9_linux_amd64.zip #Extract the downloaded setup using unzip
Archive:  terraform_1.1.9_linux_amd64.zip
inflating: terraform
hector@hector-Laptop:~/Project16-17$ ls #terraform extracted
PBL  README.md  terraform  terraform_1.1.9_linux_amd64.zip
hector@hector-Laptop:~/Project16-17$ sudo mv terraform /usr/local/bin/ #moving extracted setup to /bin directory
hector@hector-Laptop:~/Project16-17$ terraform -v #checking `version (not latest)
Terraform v1.1.9
on linux_amd64
hector@hector-Laptop:~/Project16-17$
```

Our current directory structure consists of a folder called `PBL` with a file inside `main.tf`   

`main.tf` **AWS** as a provider, and a resource to create a VPC  

``` bash
#Provider block informs Terraform that we intend to build infrastructure within AWS.
provider "aws" { 
  region = "us-east-1"
}

#Resource block will create a VPC.
resource "aws_vpc" "main" {
  cidr_block                     = "10.0.0.0/16"
  enable_dns_support             = "true"
  enable_dns_hostnames           = "true"
  enable_classiclink             = "false"
  enable_classiclink_dns_support = "false"
}
```
For Terraform to work we need to download the necessary **plugin**. **Plugins** are used by [providers](https://www.terraform.io/language/providers) and [provisioners](https://www.terraform.io/language/resources/provisioners/syntax). So far we only have a **provider** in our `main.tf` file. So, Terraform will just download **plugin** for **AWS** provider.  

We accomplish this with `terraform init`  

We will use this command to initialize the `PBL` directory  

``` bash
hector@hector-Laptop:~/Project16-17$ cd PBL/
hector@hector-Laptop:~/Project16-17/PBL$ ls
main.tf
hector@hector-Laptop:~/Project16-17/PBL$ terraform init
```
<details close>
<summary>Output</summary>

``` bash
Initializing the backend...

Initializing provider plugins...
- Finding latest version of hashicorp/aws...
- Installing hashicorp/aws v4.13.0...
- Installed hashicorp/aws v4.13.0 (signed by HashiCorp)

Terraform has created a lock file .terraform.lock.hcl to record the provider
selections it made above. Include this file in your version control repository
so that Terraform can guarantee to make the same selections by default when
you run "terraform init" in the future.

Terraform has been successfully initialized!

You may now begin working with Terraform. Try running "terraform plan" to see
any changes that are required for your infrastructure. All Terraform commands
should now work.

If you ever set or change modules or backend configuration for Terraform,
rerun this command to reinitialize your working directory. If you forget, other
commands will detect it and remind you to do so if necessary.
``` 
</details>




Notice that a new directory has been created: `.terraform` This is where **Terraform** keeps **plugins**. Generally, it is safe to delete this folder. You just have to execute `terraform init` again, to download them.  

``` bash
hector@hector-Laptop:~/Project16-17/PBL$ ls -a
.  ..  main.tf  .terraform  .terraform.lock.hcl
```
*In addition, [.terraform.lock.hcl](https://www.terraform.io/language/files/dependency-lock) Dependency Lock File*


Now we create the only resource we just defined `aws_vpc`. Before creating anything we should check to see what **terraform** intends to provision with `terraform plan` 
If we are happy with changes planned we execute `terraform apply`  


Files generated after running **plan** and **apply**  
``` bash
hector@hector-Laptop:~/Project16-17/PBL$ ls
main.tf  terraform.tfstate  terraform.tfstate.backup
hector@hector-Laptop:~/Project16-17/PBL$
```

`terraform.tfstate`  is how **Terraform** keeps itself up to date with the exact **state** of the infrastructure. It reads this file to know what already exists, what should be added, or destroyed based on the entire terraform code that is being developed.  

`terraform.tfstate.lock.info` *(gets deleted immediately)* This is what **Terraform** uses to track, who is running its code against the infrastructure at any point in time. This is very important for teams working on the same Terraform repository at the same time. The lock prevents a user from executing **Terraform** configuration against the same infrastructure when another user is doing the same – it allows to avoid duplicates and conflicts.  


Lets create the first 2 **public subnets** by adding below configuration to the `main.tf` file:
``` bash
# Declaring 2 resource blocks – one for each of the subnets

# Create public subnets1
    resource "aws_subnet" "public1" {
    vpc_id                     = aws_vpc.main.id #<< interpolate the value of the VPC id
    cidr_block                 = "10.0.1.0/24"
    map_public_ip_on_launch    = true
    availability_zone          = "us-east-1"
}
# Create public subnet2
    resource "aws_subnet" "public2" {
    vpc_id                     = aws_vpc.main.id #<<
    cidr_block                 = "10.0.3.0/24"
    map_public_ip_on_launch    = true
    availability_zone          = "us-east-1"
}
```

Once again we run `terraform plan` and `terraform apply`  

**Observations:**  *(Best Practices)*     
*Hard coded values:*  
`availability_zone` and `cidr_block` arguments are **hard coded** and our goal should always be to make our work **dynamic**  
*Multiple Resource Blocks:*  
We have declared multiple **resource blocks** for each subnet in the code. We need to create a single resource block that can **dynamically** create resources without specifying **multiple blocks**.  

### FIXING THE PROBLEMS BY CODE REFACTORING

**Fixing Hard Coded Values:** We will introduce variables, and remove hard coding.  
Starting with the *provider block*, we declare a **variable** named `region`, give it a default value, and update the provider section by referring to the declared variable.
``` bash
variable "region" {
  default = "us-east-1"
}

provider "aws" {
  region = var.region
}
```

Doing the same to `cidr` value in the vpc block, and all the other arguments.  
``` bash
variable "vpc_cidr" {
  default = "10.0.0.0/16"
}

variable "enable_dns_support" {
  default = "true"
}

variable "enable_dns_hostnames" {
 default ="true" 
}

variable "enable_classiclink" {
  default = "false"
}

variable "enable_classiclink_dns_support" {
  default = "false"
}

provider "aws" {
  region = var.region
}

# Create VPC
resource "aws_vpc" "main" {
  cidr_block                     = var.vpc_cidr
  enable_dns_support             = var.enable_dns_support 
  enable_dns_hostnames           = var.enable_dns_support
  enable_classiclink             = var.enable_classiclink
  enable_classiclink_dns_support = var.enable_classiclink
}
```
	
**Fixing multiple resource blocks:** We are going to introduce **Loops** & **Data sources**  
	
We will explore the use of Terraform’s **Data Sources** to fetch information outside of Terraform *(in this case, from AWS)*  

Let us fetch Availability zones from AWS, and replace the hard coded value in the subnet’s availability_zone section.

**Get list of availability zones**
``` bash
data "aws_availability_zones" "available" {
state = "available"
}
```

To make use of this new data resource, we introduce a `count` argument in the subnet block as follow:   
``` bash
# Create public subnet1
resource "aws_subnet" "public" { 
count                   = 2 #invokes a loop twice
vpc_id                  = aws_vpc.main.id
cidr_block              = "10.0.1.0/24" # << Will make second loop fail
map_public_ip_on_launch = true
availability_zone       = data.aws_availability_zones.available.names[count.index]
}
```

The data resource `data.aws_availability_zones.available.names[count.index]` will return a list object that contains a list of AZs. In this case the `counter` is set to 2 so it will return something like this `["us-east-1a", "us-east-1b"]`  

Another way to look at it:  
`us-east-1a` = `data.aws_availability_zones.available.names[0]`  
`us-east-1b` = `data.aws_availability_zones.available.names[1]`  


If we run Terraform with this configuration, it may succeed for the first time, but by the time it goes into the second loop, it will fail because we still have `cidr_block` hard coded. The same `cidr_block` cannot be created twice within the same VPC. So...

**Let’s make `cidr_block` dynamic.** 
We will introduce a function `cidrsubnet()` that works like an algorithm to dynamically create a subnet CIDR per AZ. Regardless of the number of subnets created, it takes care of the cidr value per subnet.  

Its parameters are **cidrsubnet(`prefix`, `newbits`, `netnum`)**  
* The `prefix` parameter must be given in CIDR notation, same as for VPC.
* The `newbits` parameter is the number of additional bits with which to extend the prefix. For example, if given a prefix ending with /16 and a newbits value of 4, the resulting subnet address will have length /20
* The `netnum` parameter is a whole number that can be represented as a binary integer with no more than newbits binary digits, which will be used to populate the additional bits added to the prefix   

Testing **terraform console**  
``` bash
hector@hector-Laptop:~$ terraform console
> cidrsubnet("172.16.0.0/16", 4, 0)
"172.16.0.0/20"
>
```
We update the configuration  
``` bash
# Create public subnet1
resource "aws_subnet" "public" { 
    count                   = 2
    vpc_id                  = aws_vpc.main.id
    cidr_block              = cidrsubnet(var.vpc_cidr, 4 , count.index)
    map_public_ip_on_launch = true
    availability_zone       = data.aws_availability_zones.available.names[count.index]
}
```

**The final problem to solve is removing hard coded `count` value.**  
*We'll introduce `length()` function, which basically determines the length of a given list, map, or string.*

Declare a variable to store the desired number of public subnets, and set the default value
``` bash	
variable "preferred_number_of_public_subnets" {
  default = 2
}
```
Next, update the count argument with a condition. Terraform needs to check first if there is a desired number of subnets. Otherwise, use the data returned by the length function. See how that is presented below.

``` bash	
# Create public subnets
resource "aws_subnet" "public" {
  count  = var.preferred_number_of_public_subnets == null ? length(data.aws_availability_zones.available.names) : var.preferred_number_of_public_subnets   
  vpc_id = aws_vpc.main.id
  cidr_block              = cidrsubnet(var.vpc_cidr, 4 , count.index)
  map_public_ip_on_launch = true
  availability_zone       = data.aws_availability_zones.available.names[count.index]
}
```

Now lets break it down: `count  = var.preferred_number_of_public_subnets == null ? length(data.aws_availability_zones.available.names) : var.preferred_number_of_public_subnets`  

* The first part `var.preferred_number_of_public_subnets == null` checks if the value of the variable is set to `null` or has some value defined.
* The second part `?` and `length(data.aws_availability_zones.available.names)` means, if the first part is true, then use this. In other words, if preferred number of public subnets is `null` (Or not known) then set the value to the data returned by `length` function *(number of subnets created will equal amount of AZ)*
* The third part `:` and `var.preferred_number_of_public_subnets` means, if the first condition is false, i.e preferred number of public subnets is `not null` then set the value to whatever is defined in `var.preferred_number_of_public_subnets`  


  
<details close>
<summary>Now the entire configuration looks like this</summary>

``` bash
# Get list of availability zones
data "aws_availability_zones" "available" {
  state = "available"
}
variable "region" {
  default = "us-east-1"
}
variable "vpc_cidr" {
  default = "10.0.0.0/16"
}
variable "enable_dns_support" {
  default = "true"
}
variable "enable_dns_hostnames" {
  default ="true" 
}
variable "enable_classiclink" {
  default = "false"
}
variable "enable_classiclink_dns_support" {
  default = "false"
}
variable "preferred_number_of_public_subnets" {
  default = 2
}
provider "aws" {
  region = var.region
}
# Create VPC
resource "aws_vpc" "main" {
  cidr_block                     = var.vpc_cidr
  enable_dns_support             = var.enable_dns_support 
  enable_dns_hostnames           = var.enable_dns_support
  enable_classiclink             = var.enable_classiclink
  enable_classiclink_dns_support = var.enable_classiclink
}
# Create public subnets
resource "aws_subnet" "public" {
  count  = var.preferred_number_of_public_subnets == null ? length(data.aws_availability_zones.available.names) : var.preferred_number_of_public_subnets   
  vpc_id = aws_vpc.main.id
  cidr_block              = cidrsubnet(var.vpc_cidr, 4 , count.index)
  map_public_ip_on_launch = true
  availability_zone       = data.aws_availability_zones.available.names[count.index]
}
```  
</details>



### INTRODUCING VARIABLES.TF &AMP; TERRAFORM.TFVARS

To make our code a lot more readable and better structured instead of having a long list of variables in `main.tf` file I'll move out some parts of the configuration content to other files.


We will put all **variable declarations** in a separate file and provide non **default values** to each of them  
* Created a new file `variables.tf` where I moved all the **variable declarations**  
* Created another file `terraform.tfvars` where I **set values** for each of the variables  

<details close>
<summary>Maint.tf</summary>

``` bash
# Get list of availability zones
data "aws_availability_zones" "available" {
state = "available"
}
provider "aws" {
  region = var.region
}
# Create VPC
resource "aws_vpc" "main" {
  cidr_block                     = var.vpc_cidr
  enable_dns_support             = var.enable_dns_support 
  enable_dns_hostnames           = var.enable_dns_support
  enable_classiclink             = var.enable_classiclink
  enable_classiclink_dns_support = var.enable_classiclink
}
# Create public subnets
resource "aws_subnet" "public" {
  count  = var.preferred_number_of_public_subnets == null ? length(data.aws_availability_zones.available.names) : var.preferred_number_of_public_subnets   
  vpc_id = aws_vpc.main.id
  cidr_block              = cidrsubnet(var.vpc_cidr, 4 , count.index)
  map_public_ip_on_launch = true
  availability_zone       = data.aws_availability_zones.available.names[count.index]
}
```  
</details>

<details close>
<summary>variables.tf</summary>

``` bash
variable "region" {
  default = "us-east-1"
}
variable "vpc_cidr" {
  default = "10.0.0.0/16"
}
variable "enable_dns_support" {
  default = "true"
}
variable "enable_dns_hostnames" {
  default ="true" 
}
variable "enable_classiclink" {
  default = "false"
}
variable "enable_classiclink_dns_support" {
  default = "false"
}
variable "preferred_number_of_public_subnets" {
  default = null
}

```  
</details>

<details close>
<summary>terraform.tfvars</summary>

``` bash
region = "us-east-1"
vpc_cidr = "10.0.0.0/16" 
enable_dns_support = "true" 
enable_dns_hostnames = "true"  
enable_classiclink = "false" 
enable_classiclink_dns_support = "false" 
preferred_number_of_public_subnets = 2
```  
</details>


Now the file structure in the **PBL** folder look like this  
``` bash
hector@hector-Laptop:~/Project16-17/PBL$ tree
.
├── main.tf
├── terraform.tfstate
├── terraform.tfstate.backup
├── terraform.tfvars
└── variables.tf

0 directories, 5 files
hector@hector-Laptop:~/Project16-17/PBL$
```
We run `terraform plan` to ensure everything works  