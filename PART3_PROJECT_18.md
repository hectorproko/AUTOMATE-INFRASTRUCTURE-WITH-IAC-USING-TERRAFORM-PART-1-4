# AUTOMATE-INFRASTRUCTURE-WITH-IAC-USING-TERRAFORM-PART-3/4
Project 18 Terraform
[Link](https://github.com/hectorproko/AUTOMATE-INFRASTRUCTURE-WITH-IAC-USING-TERRAFORM-PART-1-to-4/blob/main/PART3_PROJECT_18.md#update-terraform-block-to-introduce-backend-and-locking)  

So far we have developed AWS Infrastructure code using Terraform and tried to run it from our local workstation.  
Now we will explore alternative Terraform [backends](https://www.terraform.io/language/settings/backends/configuration).  

**Introducing Backend on [S3](https://docs.aws.amazon.com/AmazonS3/latest/userguide/Welcome.html)**   
Each Terraform configuration can specify a backend, which defines where and how operations are performed *(where state snapshots are stored, etc)*  

States file is basically where terraform stores all the state of the infrastructure in `json` format.  

So far, we have been using the default backend, which is the `local backend` – it requires no configuration, and the states file is stored locally. This mode it is not a robust solution, so it is better to store it in some more reliable and durable storage.  

The second problem with storing this file locally is that other engineers will not have access to a state file stored locally on your computer.  

To solve this, we will need to configure a backend where the state file can be accessed remotely by other DevOps team members. There are plenty of different standard backends supported by Terraform that we can choose from. Since we are already using AWS – we can choose an [S3 bucket as a backend](https://www.terraform.io/docs/language/settings/backends/s3.html).  

Another useful option that is supported by **S3** backend is [**State Locking**](https://www.terraform.io/docs/language/state/locking.html) *(used to lock your state for all operations that could write state)*. This prevents others from acquiring the lock and potentially corrupting your state. State Locking feature for S3 backend is optional and requires another AWS service – [DynamoDB](https://aws.amazon.com/dynamodb/).  


Here is our plan to Re-initialize Terraform to use S3 backend: (init terraform step)
* Add S3 and DynamoDB resource blocks before deleting the local state file
* ###### Update terraform block to introduce backend and locking
* Re-initialize terraform
* Delete the local tfstate file and check the one in S3 bucket
* Add outputs
* terraform apply  






### AUTOMATE INFRASTRUCTURE WITH IAC USING TERRAFORM. PART 3 – REFACTORING

### WHEN TO USE WORKSPACES OR DIRECTORY?

### REFACTOR YOUR PROJECT USING MODULES

### COMPLETE THE TERRAFORM CONFIGURATION
