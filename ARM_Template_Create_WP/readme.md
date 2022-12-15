# WordPress on Linux App Service ARM Template Deployment

This is the ARM template that deploys the resources for running a WordPress site on a Linux App service.
It deploys the following resources:
* App Service Hosting Plan - Provisoned to use a WordPress container image based on the alpine latest build.
* App Service - Configured to use a WordPress container image based on the alpine latest build.
* MySQL Server running on the Flexible server SKU with a database deployed and configured for use with WordPress.
* Virtual Network - with a 10.0.0.0/16 CIDR block.
* Private DNS Zone for the MySQL database.
* CDN Profile (Azure Frontdoor) with a CDN profile endpoint with compression enabled.


## Overview
The main ARM template (azuredeploy.json) is a standard ARM template and is very configurable via custom parameters that are well documented. You can deploy this template without changing any parameters but will be prompted for database server admin name, database server password, wordpress email, wordpress initial administrator and wordpress password.
There is also a parameters file (azuredeploy.parameters.json) included in the repository which you can change the values to suit your deployment. Please remember to **NOT** store usernames or passwords in this file. The parameters file should be self explanatory as the parameters are names in accordance with their purpose.

## How to deploy
Firstly, modify the parameters file (azuredeploy.parameters.json) with the parameter input values for your environment, its accepted practice to have a parameters file per environment/deployment as needed. Also replace the null values with the settings for your configuration.
Modify the deployment scripts (deploy.azcli and deploy.ps1) and change the input parameters such as resource group name and location to suit your deployment needs.
You can then run the deployment scripts as follows:
* ./deploy.azcli for Bash script
* ./deploy.ps1 for Powershell script