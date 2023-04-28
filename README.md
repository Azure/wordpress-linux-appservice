# WordPress on Linux App Service

[![Deploy to Azure](https://aka.ms/deploytoazurebutton)](https://portal.azure.com/#create/WordPress.WordPress)

Whether you’re shuffling a couple thousand visitors a day through an eCommerce shopping experience or attracting thousands of visitors to your content per day, your digital experience must be available and load fast to engage and wow your audiences. Our cloud-based solutions give your sites high availability, speed, scalability, and security, so you can press ahead with confidence.

WordPress hosted on Azure App Service is a fully managed Azure PaaS offering with built-in infrastructure maintenance, security patching and scaling. It also supports virtual networks, and the ability to run in an isolated and dedicated App Service Environment. WordPress updates and patches, threat detection and blocking, and traffic encryption with free SSL certificates are part of what we offer to all of our customers.

There are several forms of WordPress running on Azure, but we recommend [WordPress on Azure AppService](https://aka.ms/linux-wordpress) from the Azure Marketplace as your start point. Because these Marketplace offerings are optimized for Linux App Service, they are designed to be easy-to-install and come with up-to-date software packages, fine tuned SKU sizes for both App Service & [Azure Database for MySQL Flexible Server](https://learn.microsoft.com/en-us/azure/mysql/flexible-server/overview) and also with support from App Service team.

WordPress on Azure App Service is supported in Public cloud, US Government clouds(Fairfax) & China Cloud(mooncake).

![WordPress on Linux App Service](https://user-images.githubusercontent.com/15884692/204471285-0350cf5e-4bd3-45c7-a5e0-9234fac9a785.png)

## Image Details
Image Server URL: https://mcr.microsoft.com
URL to view all the list of WordPress tags:  https://mcr.microsoft.com/v2/appsvc/wordpress-alpine-php/tags/list

|Image Name |Image Tag  |OS |PHP Version | Nginx version| 
|-----------|-----------|---|------------|--------------|
|appsvc/wordpress-alpine-php    |latest |Alpine Linux 3.16  |8.0.28  |1.22.1 |
|appsvc/wordpress-alpine-php    |8.0 |Alpine Linux 3.16  |8.0.28  |1.22.1 |

**Note**: *latest* tag corresponds to 8.0 version of PHP, and it does not actually mean that it will always carry the latest version of image. We will soon stop using the *latest* tag and use appropriate 'numerical' tag to avoid confusion.



## How to Configurations

* [Change MySQL Database Password for WordPress on Linux App Service](./WordPress/changing_mysql_database_password.md)
* [Change WordPress Admin Credentials of the WordPress hosted on Linux App Service](./WordPress/changing_wordpress_admin_credentials.md)
* [Setup Startup scripts for WordPress running on Linux App Service](./WordPress/running_post_startup_scripts.md)
* [Configuring Nginx for WordPress running on Linux App Service](./WordPress/configuring_nginx_for_wordpress.md)
* [A view of Application Settings of WordPress on Linux App Service](./WordPress/wordpress_application_settings.md)
* [Connect to database with phpmyadmin of WordPress on Linux AppService](./WordPress/wordpress_phpmyadmin.md)
* [Configure WordPress on Linux AppService with existing MySQL database](./WordPress/using_an_existing_mysql_database.md)
* [Migrate any WordPress site to WordPress on Linux App Service](./WordPress/wordpress_migration_linux_appservices.md)
* [Adding PHP extensions for WordPress on Linux App Service](./WordPress/wordpress_adding_php_extensions.md)
* [AFD Integration with WordPress on Azure App Service](./WordPress/wordpress_afd_configuration.md)
* [Enabling High Performance with Local Storage](./WordPress/enabling_high_performance_with_local_storage.md)

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
