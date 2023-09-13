# Terraweek Day 2 - HashiCorp Configuration Language (HCL)
Hello everyone, In this blog, we are going to cover HashiCorp Configuration Language (HCL) which is used by terraform to write infrastructure as code

## Topics We Are Gonna Cover
1. Block, Parameters, and Arguments in HCL
2. Variables in HCL
3. Terraform Commands
4. Create a local file using resources and variables
5. Using AWS provider to create an EC2 instance

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
- "region" - This is the variable name. It's a user-defined identifier for this specific variable. You'll use this name to refer to the variable elsewhere in your configuration.
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

## Create a local file using resources and variables
With the knowledge of resources and variables, let's try to write a terraform resource that will create a local file in your computer, let's get started!

### Step 1: Create a new folder
