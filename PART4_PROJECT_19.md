# AUTOMATE-INFRASTRUCTURE-WITH-IAC-USING-TERRAFORM-PART-1-4
Project 16-19 Terraform

### AUTOMATE INFRASTRUCTURE WITH IAC USING TERRAFORM. PART 4 - TERRAFORM CLOUD  

Created an account  

Start from scratch  

![Markdown Logo](https://raw.githubusercontent.com/hectorproko/AUTOMATE-INFRASTRUCTURE-WITH-IAC-USING-TERRAFORM-PART-1-to-4/main/images/welcome.png)  

![Markdown Logo](https://raw.githubusercontent.com/hectorproko/AUTOMATE-INFRASTRUCTURE-WITH-IAC-USING-TERRAFORM-PART-1-to-4/main/images/organization.png)  

![Markdown Logo](https://raw.githubusercontent.com/hectorproko/AUTOMATE-INFRASTRUCTURE-WITH-IAC-USING-TERRAFORM-PART-1-to-4/main/images/workspace.png)  


![Markdown Logo](https://raw.githubusercontent.com/hectorproko/AUTOMATE-INFRASTRUCTURE-WITH-IAC-USING-TERRAFORM-PART-1-to-4/main/images/workspace2.png)  


![Markdown Logo](https://raw.githubusercontent.com/hectorproko/AUTOMATE-INFRASTRUCTURE-WITH-IAC-USING-TERRAFORM-PART-1-to-4/main/images/permission.png)  

Lets created the repo to choose  

![Markdown Logo](https://raw.githubusercontent.com/hectorproko/AUTOMATE-INFRASTRUCTURE-WITH-IAC-USING-TERRAFORM-PART-1-to-4/main/images/install.png)  

![Markdown Logo](https://raw.githubusercontent.com/hectorproko/AUTOMATE-INFRASTRUCTURE-WITH-IAC-USING-TERRAFORM-PART-1-to-4/main/images/cloud.png)  

![Markdown Logo](https://raw.githubusercontent.com/hectorproko/AUTOMATE-INFRASTRUCTURE-WITH-IAC-USING-TERRAFORM-PART-1-to-4/main/images/variables.png)  

Make sure you select Environment variable  

Worspace name is terraform-cloud like the repo name is automatic  



This is how it looks if you navigate back  
![Markdown Logo](https://raw.githubusercontent.com/hectorproko/AUTOMATE-INFRASTRUCTURE-WITH-IAC-USING-TERRAFORM-PART-1-to-4/main/images/workspaces.png)  


![Markdown Logo](https://raw.githubusercontent.com/hectorproko/AUTOMATE-INFRASTRUCTURE-WITH-IAC-USING-TERRAFORM-PART-1-to-4/main/images/terraform_cloud_apply.gif)  


![Markdown Logo](https://raw.githubusercontent.com/hectorproko/AUTOMATE-INFRASTRUCTURE-WITH-IAC-USING-TERRAFORM-PART-1-to-4/main/images/created.png)  


![Markdown Logo](https://raw.githubusercontent.com/hectorproko/AUTOMATE-INFRASTRUCTURE-WITH-IAC-USING-TERRAFORM-PART-1-to-4/main/images/terraform_cloud_destroyed.gif)  


![Markdown Logo](https://raw.githubusercontent.com/hectorproko/AUTOMATE-INFRASTRUCTURE-WITH-IAC-USING-TERRAFORM-PART-1-to-4/main/images/triggered.png)  


![Markdown Logo](https://raw.githubusercontent.com/hectorproko/AUTOMATE-INFRASTRUCTURE-WITH-IAC-USING-TERRAFORM-PART-1-to-4/main/images/terraform_cloud_autoPlanning.gif)  


Configure 3 branches in your `terraform-cloud` repository for `dev`, `test`, `prod` environments  

Make necessary configuration to trigger runs automatically only for `dev` environment  

Create an Email and Slack notifications for certain events (e.g. started `plan` or errored run) and test it  

Settings > Notifications > Create a Notification  


Create a new Workspace  
	Workspace Name: terraform-cloud-dev  
	Step 4: Configure settings  
	Apply Method: Auto apply  
	VCS branch: dev  
	
Need to create a new run  

