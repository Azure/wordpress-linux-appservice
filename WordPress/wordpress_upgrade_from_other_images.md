# Migrate the WordPress Images running on a different docker container to Microsoft supported containers

This document describes the approach to migrate WordPress instances running on Linux App Service (using different container) to the latest new WordPress image **(mcr.microsoft.com/appsvc/wordpress-alpine-php)**.

**Note-1:** The following steps detailed will upgrade the underlying stack such as Nginx, PHP, Redis etc., and it will not upgrade/refresh the WordPress version or source code.  As a result, sometimes there can be compatibility issue between the upgraded PHP version and underlying WordPress code. So Upgrading the WordPres to latest comptabile version with the PHP version as per the [PHP Compatibility and WordPress Versions](https://make.wordpress.org/core/handbook/references/php-compatibility-and-wordpress-versions/) is the responsibility of the user.

It is recommended to migrate the image first in staging environment, test it thoroughly and then plan for your migration in production environments. 

**Note-2:** Another approach for migration would be to create a new instance of WordPress on Linux App Service from Azure Marketplace and then migrate the content from your existing WordPress site by following the [WordPress Migration Guide](./wordpress_migration_linux_appservices.md). 


## Steps for upgrading
1. Make sure your WordPress code is in **/home/site/wwwroot** path.
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

5. Take a back-up of your wp-config.php
6. Replace the wp-config.php file in **/home/site/wwwroot** with [this](https://github.com/Azure-App-Service/ImageBuilder/blob/master/GenerateDockerFiles/wordpress/wordpress/wordpress_src/wordpress-azure/wp-config.php). 
7. Reapply any additional configurations from your backup wp-config.php file, add any other additional customizations you may want
8. Now Lanunch the Azure Portal and navigate to your App Service definition page.  
9. Navigate to Deployment Center blade and update the new image details  with appropriate **tag** value as shown in the below screen shot.  
<kbd><img src="./media/wordpress_deployment_center_update.png" width="750" /></kbd>
10. Restart your App Service to take the changes in affect. 
11. To cross verify, Launch (**https://_\<appname\>_.scm.azurewebsites.net/newui/webssh**)
12. 
