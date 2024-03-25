This Readme contains the steps to install Terraform and run the commands for Infinite projects

Installing Terraform

Steps to install Terraform on Windows, Linux, MacOS
https://learn.hashicorp.com/tutorials/terraform/install-cli

Steps on Windows:

1.	Click on https://www.terraform.io/downloads
2.	Click on Terraform download for your machine ex: c:\terraform\downloads
3.	For setting path on Windows:
a.	Go to Control Panel -> System -> System settings -> Environment Variables.
b.	Scroll down in system variables until you find PATH.
c.	Click edit and change accordingly.
d.	Include a semicolon at the end of the previous as that is the delimiter, i.e. c:\path;c:\terraform\downloads
e.	Launch a new console for the settings to take effect
4.	Open command prompt 
5.	Run command terraform –version 
a.	Verify terraform version command display the version
6.	Run command terraform –help 
a.	Verify terraform help command list the options

Steps on Linux:

1.	Click on https://www.terraform.io/downloads
2.	Navigate to the the Linux OS type
3.	Run the commands and install Terraform on your machine
4.	Navigate to the location you installed Terraform
5.	Run command terraform –version 
a.	Verify terraform version command display the version
6.	Run command terraform –help 
a.	Verify terraform help command list the options

Steps on MacOS:

1.	Click on https://www.terraform.io/downloads
2.	Navigate to the the Mac OS type
3.	Run the commands and install Terraform on your machine
4.	Navigate to the location you installed Terraform
5.	Run command terraform –version 
b.	Verify terraform version command display the version
6.	Run command terraform –help 
c.	Verify terraform help command list the options

Run Infinite Terraform Scripts 

1)	Download the script files on the folder on your machine where you installed the terraform
2)	Open location to run scripts from terraform command line
3)	Navigate to the location where script files are located
4)	Run commands terraform init
a)	Verify terraform init command initialize the scripts
5)	Run command terraform plan
a)	Verify terraform plan command display the changes
6)	Run command terraform apply
a)	Verify terraform apply command applies the scripts to Azure
7)	Open Browser Chrome/Firefox/Edge 
8)	Login to https://portal.zure.com
9)	Verify resources are created/updated successfully as per the document “Manual Testing for Infinite Projects”