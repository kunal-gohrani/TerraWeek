# Terraweek Day 2 - HashiCorp Configuration Language (HCL)
Hello everyone, In this blog, we are going to cover HashiCorp Configuration Language (HCL) which is used by terraform to write infrastructure as code

## Topics We Are Gonna Cover
1. Block, Parameters, and Arguments in HCL
2. Variables in HCL
3. Terraform Commands
4. Create a local file using resources and variables

## Block, Parameters, and Arguments
In HCL (HashiCorp Configuration Language), a block is a fundamental structure used to define and configure **resources**, **data sources**, **providers**, and other elements within a configuration file. A block is identified by its type and is defined using **curly braces {}**. Let’s take a simple example of a block that defines an AWS EC2 instance:
```
resource "aws_instance" "terraform-demo-instance" {
    ami = "ami-02bb7d8191b50f4bb"
    instance_type = "t2.micro"
    count = 1
    tags = {
        Name = "terraform-instance"
    }
}
```

### Parameters
Parameters are like placeholders that define the attributes or settings of a particular resource or data source. They are **predefined properties** that a block can have.

For instance, consider this example of an AWS EC2 instance resource:
```
resource "aws_instance" "terraform-demo-instance" {
    ami = "ami-02bb7d8191b50f4bb"
    instance_type = "t2.micro"
}
```
In this example, **ami** and **instance_type** are parameters of the aws_instance block. These parameters are specific to an AWS EC2 instance and determine things like the Amazon Machine Image (AMI) used and the type of instance.

### Arguments
Arguments are the actual values that you assign to the parameters. They provide the specific settings or values that configure the behaviour of a resource or data source.

In the previous example, **ami-02bb7d8191b50f4bb** and **t2.micro** are the actual values passed to the parameters that determine the configuration of the EC2 instance. 

## Variables in HCL
In HCL (HashiCorp Configuration Language), you can use a variable block to declare variables that can be used throughout your configuration files. This is especially useful for making your configurations more dynamic and reusable.

Here's an example of a variable block:
```
variable "instance_type" {
    default = "t2.micro"
    type = string
    description = "Instance type of a AWS Ec2 instance"
}
```
Let's break down the components of this variable block:

- variable - This is the block type. It indicates that you are defining a variable.
- "instance_type" - This is the variable name. It's a user-defined identifier for this specific variable. You'll use this name to refer to the variable elsewhere in your configuration.
- {} - This is the body of the variable block. It contains the configuration settings for this variable.
  - **description** - This is an optional parameter. It provides a description of what the variable is used for. It's helpful for providing context to other users (including yourself) who might work with this configuration in the future.
  - **type** - This parameter specifies the type of the variable. In this case, it's a string, meaning that this variable is expected to hold a string value.
  - **default** - This is an optional parameter. It provides a default value for the variable. If no value is provided when running Terraform, it will use this default.
 
After defining a variable, you can use it in this way:
```
resource "aws_instance" "terraform-demo-instance" {
    ami = "ami-02bb7d8191b50f4bb"
    instance_type = var.instance_type
}
```
var.instance_type will refer to the value in the instance_type variable when applying these files.

## Terraform Commands
Before diving in to hands-on, it is important for us to learn about terraform commands and their uses:
1. `terraform init`:
    - This command is used to initialize your terraform folder with a new or existing terraform configuration and download necessary plugins and providers, as defined in the project
2. `terraform plan`:
    -  Creates an execution plan based on the configuration.
    -  Shows the changes that will be made to the infrastructure.
    -  Consider this as a dry run of the modifications that will be done to your infrastructure upon applying the Terraform files
4. `terraform apply`:
    - Applies the changes specified in the plan.
    - Modifies or creates infrastructure resources as needed.
5. `terraform destroy`:
    - Destroys the resources defined in the configuration.
    - Safely removes infrastructure components.
6. `terraform validate`:
    - Validates the configuration files for syntax and semantics.
    - Checks for errors or issues before applying changes.

## Create a local file using resources and variables
With the knowledge of resources and variables, let's try to write a terraform resource that will create a local file in your computer, let's get started!

### Step 1: Create a new folder `terraform-localfile` to store our terraform files
This folder will be used to store our terraform configuration files needed to create a file in our local machine.

### Step 2: Create a `main.tf` file
In this `main.tf` file, paste the below code:
```
resource "local_file" "diary" {
    filename = "./diary.txt"
    content = "This is my first day of maintaining a diary"
}
```
This code will create a new file called `diary.txt` inside `terraform-localfile` folder with the contents as written in the content parameter

### Step 3: Run terraform init
Before running any terraform command in a new folder, it is always required to run `terraform init`, which will setup the folder and download necessary plugins.
After running the command, you may notice that some new files/folders have been created like `.terraform` and `.terraform.lock.hcl`, inside `.terraform` folder, you will see that the `local` provider was downloaded.
![image](https://github.com/kunal-gohrani/TerraWeek/assets/47574597/992f1fbd-dfd0-4ec9-9b8a-953cddc6b5a2)

### Step 4: Run terraform plan
`terraform plan` command will let you see what are the changes that will be made when you run `terraform apply`. Consider this command as a dry run of your Terraform files.
![image](https://github.com/kunal-gohrani/TerraWeek/assets/47574597/34d25a7d-a5d8-42ae-9311-52638deb2c0f)


### Step 5: Run terraform apply
`terraform apply` will create the new file `diary.txt` with the contents as mentioned in the local_file resource block. It may prompt you for a confirmation, type "yes", and the file would be created like this:
![image](https://github.com/kunal-gohrani/TerraWeek/assets/47574597/6ba26d87-dc4a-49c7-b4ce-c30c92d893e6)


Congratulations on making it this far! I hope you've enjoyed delving into the fundamentals of Terraform and HashiCorp Configuration Language (HCL). In this blog, we've covered the essentials, from understanding HCL syntax to understanding crucial Terraform commands for managing infrastructure.

To put theory into practice, we embarked on a hands-on journey. By creating a text file using the Terraform local_file resource, you gained firsthand experience in applying Terraform to real-world scenarios.

With this foundational knowledge, you're well on your way to orchestrating infrastructure like a pro. Stay tuned for more exciting adventures in the world of Terraform and beyond!

Keep following for more exciting blogs! Till then, happy learning!
