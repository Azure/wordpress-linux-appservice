# Upgrading from Other WordPress Images

This document describes the approach to upgrade WordPress instances running on Linux App Service (using other images) to the new WordPress image (mcr.microsoft.com/appsvc/wordpress-alpine-php).

**Note-1:** Please note that the following process to upgrade the image will only refresh the underlying tools such as Nginx, PHP, Redis etc., And it doesn't upgrade/refresh the existing WordPress version or source code. As a result, sometimes there can be compatibility issue between PHP version and existing WordPress code. It is recommended to test the changes thoroughly in a staging environment before making any changes to the production. And it is responsbility of the users to upgarde their WordPress source code to make it compatible with the PHP version.

**Note-2:** Another approach for migration would be to create a new instance of WordPress on Linux App Service from Azure Marketplace and then migrate the old WordPress by following the steps mentioned [here](./wordpress_migration_linux_appservices.md). 


## Steps for Upgrading
1. Make sure your WordPress code is in **/home/site/wwroot** path.
2. Create the following folder **/home/wp-locks** using SCM site (**https://_\<appname\>_.scm.azurewebsites.net/newui**).
3. Upload [wp_deployment_status.txt](./files/wp_deployment_status.txt) file to /home/wp-locks folder. This will prevent re-installation of WordPress and deletion of any old data when you switch to the new image.
4. Make sure the following Application Settings are present and configured correctly.

    |    Application Setting Name            |  Value   |
    |----------------------------------------|----------|
    |    WEBSITES_ENABLE_APP_SERVICE_STORAGE |  true    |
	|    DATABASE_HOST                       | *\<actual value\>* |
	|    DATABASE_NAME                       | *\<actual value\>* |
	|    DATABASE_PASSWORD                   | *\<actual value\>* |
	|    DATABASE_USERNAME                   | *\<actual value\>* |

5. Replace the wp-config.php file in **/home/site/wwwroot** with [this](https://github.com/Azure-App-Service/ImageBuilder/blob/master/GenerateDockerFiles/wordpress/wordpress/wordpress_src/wordpress-azure/wp-config.php). And you can edit this file to add any customized changes (if you had any earlier).
4. Update the new image details in the deployment centre with appropriate **tag** value and restart your App Service. 
<kbd><img src="./media/wordpress_deployment_center_update.png" width="750" /></kbd>
