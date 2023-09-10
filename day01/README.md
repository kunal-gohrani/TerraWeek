#  Introduction to Terraform and Terraform Basics
Hello Everyone, In this blog we are going to cover terraform and its basics. We will understand what is terraform, and why is it such a popular tool in the industry, and start off with its installation and basic terminologies related to it.

## What is Terraform? 
HashiCorp's Terraform is an open-source infrastructure as code (IAC) tool. You can use declarative configuration files to define and provision your infrastructure. This means you may use a high-level configuration language to define the resources you require (such as virtual machines, networks, or databases), and Terraform will manage the rest. It supports a variety of cloud providers, including AWS, Azure, GCP, and others, making it a versatile option for managing infrastructure across different platforms.

## How does Terraform simplify infrastructure provisioning? 
Traditional infrastructure provisioning requires manual involvement and lots of documentation to note the infrastructure required, which frequently results in human error, lengthy deployment delays, and limited scalability. Terraform simplifies this process by offering a standardized and automated method of managing your infrastructure. Terraform allows you to declare your intended infrastructure **state in code**, which may then be versioned, shared, and reused. This makes it simple to replicate environments, verify consistency, scale resources as needed, and maintain consistency across environments. Furthermore, Terraform tracks resource dependencies and makes changes in a safe and predictable manner, minimizing downtime and potential disruptions.

## How to Install Terraform?
To install Terraform, you can head over to the official Terraform installation website over [here](https://developer.hashicorp.com/terraform/tutorials/aws-get-started/install-cli) and follow the mentioned steps for your Operating System.

If you want to use Terraform to provision resources in cloud environments, you may need to set up your cloud account to allow Terraform to provision and manage resources. 

In AWS, this can be done by creating an IAM user specifically for Terraform with programmatic **Access Key** and **Secret Key**. These keys can then be provided to Terraform via different methods as shown in this blog [here](https://medium.com/@knoldus/add-aws-credentials-in-terraform-b43efa7b934d)


## Terminologies Related to Terraform
1. **Providers:** Providers are Terraform plugins that allow it to communicate with various infrastructure and service providers. Terraform can handle the resources and data sources specific to each provider. For example - You can use aws provider of aws to allow terraform to manage aws resources.
```
terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "5.16.1"
    }
  }
```
The above code snippet informs terraform to install and use AWS terraform provider version 5.16.1

2. **Resources:** Resources represent the infrastructure components you want to manage, such as virtual machines, databases, networks, etc. They are defined using a resource block in your configuration.
Example: To create an AWS EC2 instance using terraform, we can write a resource block like this:
```
resource "aws_instance" "terraform-demo-instance" {
    ami = "ami-0f5ee92e2d63afc18"
    instance_type = "t2.micro"
    count = 1
    tags = {
        Name = "terraform-demo-instance"
    }
}
```
The above code snippet will create an AWS EC2 Instance using the Ubuntu AMI in a t2.micro instance

3. **Variables:** Variables allow you to parameterize your configurations, making them more flexible and reusable. They can be defined in separate variable files or directly in the configuration.
Example: We can create a variable file called `variable.tf` containing variables related to AMI ID, instance type, and then refer them in our `ec2.tf` file containing our ec2 instance resource block.
**variable.tf** file:
```
variable "ami-id" {
    default = "ami-0f5ee92e2d63afc18"
    type = string
    description = "This will contain AMI ID based on modules"
}

variable "instance_type" {
    default = "t2.micro"
    type = string
    description = "This is instance type based one env"
}

variable "instance_name" {
    default = "batch-4-demo-instance"
    type = string
}
```

**ec2.tf** file:
```
resource "aws_instance" "terraform-demo-instance" {
    ami = var.ami-id
    instance_type = var.instance_type
    count = 1
    tags = {
        Name = "${var.instance_name}"
    }
}
```

4. **Output Values:** Outputs allow you to extract and display specific information about your infrastructure after it's been created. This can be useful for obtaining, for example, the public IP of a newly created instance. We will learn more about Output Values later
Example:
```
output "instance_ip" {
  value = aws_instance.terraform-demo-instance.public_ip
}
```
The above code snippet will output the public IP of the terraform-demo-instance EC2 instance after it has been created using the `terraform apply` command.

5. **Modules:** Modules enable you to encapsulate and reuse Terraform configurations. They help in organizing and managing complex infrastructures by breaking them down into smaller, more manageable pieces. Modules can be used to setup a reusable piece of code that can be used to deploy resources in different environments (development, staging, or prod) based on certain variables. For example, in the below code snippet, we have created a module to deploy resources in the `dev` environment, and the variables have been set as needed in that environment. We will be looking into modules in a lot more detail later on in the week.
Example:
```
module "dev-demo-app" {
    source = "./modules/demo-app"
    env_name = "dev"
    instance_type = "t2.micro"
    instance_name = "terraform-instance"
    ami-id = "ami-0f5ee92e2d63afc18"
    bucket_name = "batch-4-demo-bucket-k"
    table_name = "batch-4-demo-table-k"
}
```

In this small blog, you understood what is terraform, its uses in the industry, how to install it and some terminologies related to it. In the next blog, we will be learning lot more about terraform, till then, happy learning! 🧑🏻‍💻
