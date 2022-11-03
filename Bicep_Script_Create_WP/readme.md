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

## Contributing

This project welcomes contributions and suggestions.  Most contributions require you to agree to a
Contributor License Agreement (CLA) declaring that you have the right to, and actually do, grant us
the rights to use your contribution. For details, visit <https://cla.opensource.microsoft.com>.

When you submit a pull request, a CLA bot will automatically determine whether you need to provide
a CLA and decorate the PR appropriately (e.g., status check, comment). Simply follow the instructions
provided by the bot. You will only need to do this once across all repos using our CLA.

This project has adopted the [Microsoft Open Source Code of Conduct](https://opensource.microsoft.com/codeofconduct/).
For more information see the [Code of Conduct FAQ](https://opensource.microsoft.com/codeofconduct/faq/) or
contact [opencode@microsoft.com](mailto:opencode@microsoft.com) with any additional questions or comments.

## Trademarks

This project may contain trademarks or logos for projects, products, or services. Authorized use of Microsoft trademarks or logos is subject to and must follow [Microsoft's Trademark & Brand Guidelines](https://www.microsoft.com/en-us/legal/intellectualproperty/trademarks/usage/general).
Use of Microsoft trademarks or logos in modified versions of this project must not cause confusion or imply Microsoft sponsorship.
Any use of third-party trademarks or logos are subject to those third-party's policies.
