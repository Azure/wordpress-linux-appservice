# WordPress on Linux App Service Bicep Deployment

**Approximate time to deploy is around 12 minutes depending on the options selected.**

A Bicep template that deploys the resources for running a WordPress site hosted on a Linux App service.
It deploys the following resources:
* App Service Hosting Plan - Provisoned to use a WordPress container image based on the alpine latest build.
* App Service - Configured to use a WordPress container image based on the alpine latest build - will generate a unique url unless specified.
* MySQL Server -  hosted on the Flexible server SKU with a database deployed and configured for use with WordPress.
* Virtual Network - Deploys a virtual network with a default address space of 10.0.0.0/16.
* Private DNS Zone for the MySQL database private link connection.
* Azure storage account - Used by Wordpress for storing assets such as images and BLOBs and Wordpress will automatically make use of this if enabled - User configurable
* CDN Profile - Deploys a CDN profile (Standard Microsoft SKU) endpoint with compression enabled - User configurable and cannot be deployed if Azure Frontdoor is used.
* Azure Front Door Profile - Deploys an Azure Frontdoor (Standard AzureFrontDoor SKU) CDN profile endpoint with compression enabled - User configurable and cannot be deployed if Azure CDN is used.
  

## Overview
The main Bicep template (main.bicep) is broken up into easy to read and modify sections and is very configurable via custom parameters that are well documented. You can deploy this template without changing any parameters but will be prompted for database server admin name, database server password, wordpress email, wordpress initial administrator and wordpress password.
There is also a bicep template file (wp.dev.parameters.json) included in the repository which you can change the values to suit your deployment. Please remember to **NOT** store usernames or passwords in this file. The parameters file should be self explanatory as the parameters are names in accordance with their purpose.

## How to deploy
Firstly, modify the bicep template file (wp.dev.parameters.json) with the parameter input values for your environment, its accepted practice to have a parameters file per environment/deployment as needed.
Modify the deployment scripts (deploy.azcli and deploy.ps1) and change the input parameters such as resource group name and location to suit your deployment needs.
You can then run the deployment scripts as follows:
* ./deploy.azcli for Bash script
* ./deploy.ps1 for Powershell script