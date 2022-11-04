# WordPress on Linux App Service Bicep Deployment

This is the Bicep template that deploys the resources for running a WordPress site on a Linux App service.
It deploys the following resources:
* App Service Hosting Plan - Provisoned to use a WordPress container image based on the alpine latest build.
* App Service - Configured to use a WordPress container image based on the alpine latest build.
* MySQL Server running on the Flexible server SKU with a database deployed and configured for use with WordPress.
* Virtual Network - with a 10.0.0.0/16 CIDR block.
* Private DNS Zone for the MySQL database.
* CDN Profile (Azure Frontdoor) with a CDN profile endpoint with compression enabled.


## Overview
The main Bicep template (main.bicep) is broken up into easy to read and modify sections and is very configurable via custom parameters that are well documented. You can deploy this template without changing any parameters but will be promped for database server admin name, database server password, wordpress email, wordpress initial administrator and wordpress password.
There is also a bicep template file (wp.dev.parameters.json) included in the repository which you can change the values to suit your deployment. Please remember to **NOT** store usernames or passwords in this file. The parameters file should be self expanatory as the parameters are names in accordance with their purpose.

## How to deploy
Firstly, modify the bicep template file (wp.dev.parameters.json) with the parameter input values for your environment, its accepted practice to have a parameters file per environment/deployment as needed.
Modify the deployment scripts (deploy.azcli and deploy.ps1) and change the input parameters such as resource group name and location to suit your deployment needs.
You can then run the deployment scripts as follows:
* ./deploy.azcli for Bash script
* ./deploy.ps1 for Powershell script