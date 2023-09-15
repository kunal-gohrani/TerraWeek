# TerraWeek Day 3: Managing Resources via Terraform
Hello everyone, today we are going to cover how to define and manage resources created via Terraform. We'll be starting by creating an AWS EC2 instance using a key pair and allowing port 22 in the security group. Along with this, we will also touch upon provisioners and lifecycle management in Terraform. So let's get started

## Step 1: Create a folder named `terraweek-day3`
This folder will be used to store our terraform files. The following steps should be performed in this folder unless asked otherwise.

## Step 2: Create a file called `terraform.tf`
This file will contain a declaration of providers we will be using, in this case, it should be aws provider.
```terraform
terraform {
  required_providers {
    aws = {
      source = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

provider "aws" {
    region = "ap-south-1"
}
```

## Step 3: Run `terraform init`
Run `terraform init` to initialize the terraform repository and download AWS provider and plugins

## Step 4: Create an AWS Key Pair 
1. Login to your AWS Account
2. Navigate to EC2 section using the search bar at top of page.
3. On the left of the page, select `Key Pairs`
![Screenshot 2023-09-15 at 11 05 55 AM](https://github.com/kunal-gohrani/TerraWeek/assets/47574597/dd4f8e49-57db-48b2-9eb5-73fd80a861ae)

4. Click on Create key pair button
5. Add a name for the key pair
![image](https://github.com/kunal-gohrani/TerraWeek/assets/47574597/e5810a00-639e-4720-b6b7-e1bbaf41cfd2)
6. Click on create key pair
7. A `.pem` file will be downloaded and the key pair will be listed in the key pairs section of your AWS Account, Note down the name of the key pair you created and the folder you downloaded the `.pem` file in.

## Step 5: Create a file called `variable.tf`
Create a variable named "keypair" in this file and set its value to the name of the keypair we created earlier.
```terraform
variable "keypair" {
    default = "terraform"
    type = string
}
```

## Step 6: Create a file called `ec2.tf`
This file will contain our ec2 resources and security group.
1. First, let's create a security group that allows traffic in port 22 from any IP, and allows all outgoing traffic.
```terraform
resource "aws_security_group" "allow_ssh" {
  name        = "allow_ssh"
  description = "Allow SSH Access"

  ingress {
    description      = "SSH Access From Anywhere"
    from_port        = 22
    to_port          = 22
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  tags = {
    Name = "allow_ssh"
  }
}
```
**NOTE:** Allowing SSH Access from anywhere is a potential security risk, please destroy the resources that have been created in this project using `terraform destroy` after you have finished the hands on.

2. Create an `aws_instance` resource which creates the EC2 in AWS, this resource will be tied to the security group and the key pair we created earlier. We will also use an `output` block to print the public IP address of the instance after it's been deployed using `terraform apply`
```terraform
resource "aws_instance" "terraform-instance" {
    ami = "ami-0f5ee92e2d63afc18"
    instance_type = "t2.micro"
    associate_public_ip_address = true
    key_name = var.keypair
    vpc_security_group_ids = [aws_security_group.allow_ssh.id]

    tags = {
        Name = "terraform-instance"
    }
}

output "terraform-instance-ip" {
    value = aws_instance.terraform-instance.public_ip   
}
```

## Step 7: Run `terraform validate` to validate the configuration files.
![image](https://github.com/kunal-gohrani/TerraWeek/assets/47574597/b2382924-c713-43f3-a85d-9f2455bf35cd)

## Step 8: Run `terraform fmt` to format your configuration files.
`terraform fmt` fixed the format of your configuration files 

## Step 9: Run `terraform plan`
Run `terraform plan` to check out the resources that will be applied in your AWS Account, Consider `terraform plan` as a dry run to know what resources will be deployed and validate the configuration

## Step 10: Run `terraform apply`
This will deploy the resources to your AWS Account and output the public IP of the created instance. After a while, your instance would be created and the public IP will be shown in your terminal as below:
![image](https://github.com/kunal-gohrani/TerraWeek/assets/47574597/aa809d2b-e350-4cb1-b765-a7cf45d17bf8)

Congratulations! We have successfully created an EC2 instance with SSH Access!

## Step 11: Validate SSH Access
Remember the .pem file that we downloaded from AWS earlier? Go to the folder it was downloaded in and run these commands
`chmod 400 <.PEM FILE>` and `ssh -i <.PEM FILE> ubuntu@<PUBLIC-IP>`. Make sure to replace <.PEM FILE> with the name of the pem file downloaded, and <PUBLIC-IP> with the public IP of the instance that we deployed.
![image](https://github.com/kunal-gohrani/TerraWeek/assets/47574597/0e96132e-175a-4510-a170-f06cb631cbb1)

Congratulations on successfully deploying the EC2 instance with SSH Access allowed!

# Terraform State File
Every terraform project you create and apply will create a file by the name of `teraform.tfstate`, This file is known as **terraform state file**.

Think of Terraform state files like a detailed blueprint of your infrastructure. They keep track of every little detail - from what resources are there to how they're connected. This is super important because Terraform uses this info to make sure everything is in the right place.

Now, imagine a scenario where the state files are inadvertently deleted. This action can have serious consequences. Without the state files, Terraform loses track of the existing resources and their configurations. It's similar to erasing the blueprint of a building while construction is still underway. Any further operations on the infrastructure become highly risky, as Terraform won't have a reliable reference point to understand the current state. This underscores the critical importance of safeguarding and managing your Terraform state files diligently.

You can view the contents of `terraform.tfstate` file anytime but make sure to never change the contents of it manually.

# Provisioners in Terraform
Provisioners in Terraform serve as the finishing touch to your infrastructure. They help customize instances after they've been created. This can involve tasks like installing software, configuring settings, or running scripts during creation or destruction phase. While provisioners can be handy, it's worth noting that they should be used sparingly, as they can make your configurations less predictable and harder to maintain.

## Types of Provisioners in Terraform
There are two types of provisioners:
1. Generic Provisioners: These are generally vendor-independent and can be used with any cloud vendor. E.g.: **file, local-exec, and remote-exec**
2. Vendor Provisioners: It can only be used only with its vendor. Eg: the chef provisioner can only be used with the chef for automating and provisioning the server configuration.
For the purpose of this blog, we will be seeing how to use a `local-exec` provisioner to run commands on our local machine upon creation and destruction of the AWS instance.

### local-exec provisioner
A `local-exec` provisioner is used to run commands on the machine that deploys terraform resources using `terraform apply`. Let's now use this provisioner in our aws_instance resource to print the instance's public IP after it has been created. Replace the aws_instance resource with the code below to add `local-exec` provisioner
```terraform
resource "aws_instance" "terraform-instance" {
    ami = "ami-0f5ee92e2d63afc18"
    instance_type = "t2.micro"
    associate_public_ip_address = true
    key_name = var.keypair
    vpc_security_group_ids = [aws_security_group.allow_ssh.id]

    tags = {
        Name = "terraform-instance"
    }

    provisioner "local-exec" {
        command = "echo \"The Server's IP Address is ${self.public_ip}\""
    }
    
    provisioner "local-exec" {
        when = destroy
        command = "echo \"Server ${self.public_ip} has been destroyed\""
      
    }
}
```
Make sure to run `terraform destroy` to destroy the previously created resources. Then run `terraform apply` to create a new resource which includes the provisioners. 

**Output of Terraform Apply:**
![image](https://github.com/kunal-gohrani/TerraWeek/assets/47574597/46f3066a-6248-4d9d-93c3-07219b298a27)

**Output of Terraform Destroy:**
Now run `terraform destroy` to see the destroy local-exec provisioner running.
![image](https://github.com/kunal-gohrani/TerraWeek/assets/47574597/1ef8717a-9b10-4f1b-9332-feb844e6c4ba)

# Lifecycle Management in Terraform
Terraform allows you to manage the lifecycle of resources using the lifecycle block. This block can be used to configure how Terraform should handle resource creation, updates, and destruction.

1. **create_before_destroy:** This setting controls whether to create a new resource before destroying the old one during an update. By default, Terraform destroys the old resource first and then creates the new one. Enabling this setting allows for zero-downtime replacements.

2. **prevent_destroy:** Setting prevent_destroy to true prevents a resource from being destroyed. This can be useful to protect critical resources from accidental deletion.

3. **ignore_changes:** ignore_changes allows you to specify resource attributes that Terraform should ignore when determining if a resource needs to be replaced. This can be helpful when certain attributes are managed outside of Terraform.

Here’s an example of using the lifecycle block to prevent the accidental destruction of an AWS EC2 instance:
```terraform
resource "aws instance" "my-instance" {
  ami = "ami-0c94855ba95b798c7"
  instance_type = "+2.micro"
  lifecycle {
    prevent_destroy = true
  }
}
```
**NOTE:** Adding `prevent_destroy` in a terraform resource will not allow terraform to destroy the resource when `terraform destroy` is used. Be careful when setting lifecycle configuration in Terraform.

# Conclusion
Congratulations on completing this step-by-step guide to creating an EC2 instance with SSH access and keypair using Terraform! You've not only gained hands-on experience in provisioning cloud resources but also delved into crucial Terraform concepts like provisioners and lifecycle management.
Stay tuned for more exciting adventures in the realm of Terraform and cloud provisioning. Happy coding!

Contact me on LinkedIn: [Kunal Gohrani](www.linkedin.com/in/kunal-gohrani)
