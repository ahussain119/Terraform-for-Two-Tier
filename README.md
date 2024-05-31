# Terraform Project

This project contains the Terraform scripts to provision a Tier-2 infrastructure in AWS.

## Prerequisites

Before running the Terraform scripts, make sure you have the following prerequisites installed:

- Terraform (version X.X.X)
- AWS CLI (version X.X.X)
- AWS account credentials configured

## Getting Started

1. Clone the repository to your local machine:

    ```bash
    git clone https://github.com/ahussain119/Tier-2.git
    ```

2. Navigate to the project directory:

    ```bash
    cd terraform-project
    ```

3. Update the variables in the `terraform.tfvars` file with your desired values.

4. Initialize the Terraform project:

    ```bash
    terraform init
    ```

5. Review the execution plan:

    ```bash
    terraform plan
    ```

6. Apply the changes:

    ```bash
    terraform apply
    ```

7. Confirm the changes by typing `yes` when prompted.

## Project Structure

The project is structured as follows:

- `main.tf`: The entry point for the Terraform script. It calls the modules and passes the required variables to them.
- `variables.tf`: Defines the input variables used in the Terraform modules.
- `terraform.tfvars`: Contains the values for the input variables.
- `modules/`: Contains the reusable Terraform modules used in the project.
- `script/`: Contains the shell script used as user data for the EC2 instances.

## Modules

The project uses the following modules:

- `networking`: Creates the VPC, subnets, and routing tables.
- `security-groups`: Sets up the security groups for the EC2 instances and load balancer.
- `auto_scaling`: Configures the auto scaling group and launch configuration.
- `loadbalancer`: Creates the load balancer and target group.
- `jumper`: Sets up a jump host for accessing the private instances.

## Contributing

Contributions to this project are welcome. If you find any issues or have suggestions for improvements, please open an issue or submit a pull request.
