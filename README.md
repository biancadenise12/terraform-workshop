# Terraform Basics
This repository aims to create a manual for beginners in Terraform (AWS).

This is a simplified version of [Hashicorp's tutorial](https://learn.hashicorp.com/tutorials/terraform/infrastructure-as-code?in=terraform/aws-get-started).

## Install Terraform Manually (Windows 64-bit)
1. Download the latest version in [terraform.io](https://www.terraform.io/downloads.html).
2. Extract the zip file in `~/terraform_0.14.5`
3. Add the `~\terraform_0.14.5` to `Path` in the environment variables
4. Verify the installation: 
```
C:\Users\b.delpuerto>terraform -version
Terraform v0.14.5
```
Reference: https://learn.hashicorp.com/tutorials/terraform/install-cli?in=terraform/aws-get-started

## Prerequisites
1. AWS Account
2. AWS credentials configured locally
   - Create the credentials file `~/.aws/credentials`
   - Modify the the and input your AWS access key id and secret access key 
   ```
   [default]
   aws_access_key_id     = 
   aws_secret_access_key = 
   ```
## Create the configurations
provider.tf
```
provider "aws" {
    profile = "default"
    region  = "ap-southeast-1"
}
```
`provider` block configures the named provider. It is basically a plugin that Terraform uses to translate the API interactions with the service.

`profile` is the attribute in your provider block that refers to your AWS credentials stored in `~/.aws/credentials`

`region` is another attribute in your provider block that tells Terraform where to create the resources defined in the configurations (.tf files)

resources.tf
```
resource "aws_instance" "example" {
  ami           = "ami-0adfdaea54d40922b"
  instance_type = "t2.micro"
}
```
The resource block has two strings before the block: the resource type and the resource name. In the example, the resource type is `aws_instance` and the name is `example`

In this example, terraform will create an EC2 instance with [Centos 7 (x86_64)](https://wiki.centos.org/Cloud/AWS) AMI and with an instance type of t2.micro.

You can more attributes in the block depending on your requirements or EC2 specifications. Refer to terraform documentation of the aws_instance resource: https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/instance.
## Initialize the directory
```
terraform init
```
This will initialize the backend (if we defined a backend, by default this is our local)

This will also download the plugin for provider which is "aws".
## Format and validate the configuration
```
terraform fmt
```
This automatically updates configurations in the current directory for easy readability and consistency. You can add the `-recursive` to format the configurations in sub-directories.
```
terraform validate

Success! The configuration is valid.
```
To make sure your configuration is syntactically valid and internally consistent, the built in terraform validate command will check and report errors within modules, attribute names, and value types.
## Create the infrastructure
It is a best practice to run `terraform plan` before `terraform apply`

This will output the resources to be created, changed, and destroyed. Execute `terraform apply` after you confirmed the plan and type `yes` at the confirmation prompt.
```
aws_instance.example: Creating...
aws_instance.example: Still creating... [10s elapsed]
aws_instance.example: Still creating... [20s elapsed]
aws_instance.example: Creation complete after 23s [id=i-0602868c09c78a302]

Apply complete! Resources: 1 added, 0 changed, 0 destroyed.
```
Verify the resources created in your AWS console. You should see an aws ec2 instance in Singapore region.

## Terraform state
After we run `terraform apply`, terraform wrote data into a file called `terraform.tfstate`. This is a file in JSON format that contains the IDs and properties of the resources Terraform created so that it can manage or destroy those resources going forward.

## Change the infrastructure
Refer to the `aws_instance` resource documentation. Add more attributes to the ec2 instance that we created previously. In this example, I will try to add a Tag to name the instance. 
```
resource "aws_instance" "example" {
  ami           = "ami-0adfdaea54d40922b"
  instance_type = "t2.micro"

  tags = {
    Name = "HelloWorld"
  }
}
```
Now, run `terraform plan` again to show the execution plan. 

Resource actions are indicated with the following symbols:
- `+` create
- `~` change (update in-place)
- `-` destroy
- `-/+` replace (destroy and then create replacement)

Run `terraform apply` and type `yes` to apply and confirm the changes.
```
aws_instance.example: Modifying... [id=i-0602868c09c78a302]
aws_instance.example: Modifications complete after 2s [id=i-0602868c09c78a302]

Apply complete! Resources: 0 added, 1 changed, 0 destroyed.
```
Verify your changes in AWS console.
## Destroy the infrastructure
The `terraform destroy` command terminates all resources defined in your Terraform configuration. It does not destroy the resources that are not managed by terraform. Terraform uses the tfstate to track the resources it manage.

Like the `terraform apply` command, `terraform destroy` also creates an execution plan before it proceed to termination. You need to type `yes` after you confirmed the resources that will be destroyed by terraform.
```
aws_instance.example: Destroying... [id=i-0602868c09c78a302]
aws_instance.example: Still destroying... [id=i-0602868c09c78a302, 10s elapsed]
aws_instance.example: Still destroying... [id=i-0602868c09c78a302, 20s elapsed]
aws_instance.example: Still destroying... [id=i-0602868c09c78a302, 30s elapsed]
aws_instance.example: Destruction complete after 30s

Destroy complete! Resources: 1 destroyed.
```

## Next steps
1. Create more resources
2. Using remote backend to store remote state
3. Defining and using variables in a configuration
4. Using output data from other terraform state as variables
5. Using a module