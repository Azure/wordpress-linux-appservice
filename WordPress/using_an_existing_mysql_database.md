# How to configure WordPress on Linux AppService to an existing MySQL Database

**Prerequisite**:  WordPress database is already preexisted on your database server

1. The App Service plan hosting your app and the  database server are running in the same region to avoid performance issues.
1. Use [Azure MySQL Flexible Server](https://portal.azure.com/#view/HubsExtension/BrowseResource/resourceType/Microsoft.DBforMySQL%2FflexibleServers) as database.
1. Keep the database in the same VNET as your App Service. Follow the steps described [here](https://docs.microsoft.com/azure/mysql/flexible-server/how-to-manage-virtual-network-portal).
1. The MySQL database version should be compatible with the new WordPress version running on Linux App Service.
1. Backup your WordPress site and database.
   - [WordPress backups](https://wordpress.org/support/article/wordpress-backups/)
   - [Backing up your database](https://wordpress.org/support/article/backing-up-your-database/) for more details.
1. Launch the Azure Portal and navigate to your **App Service -> Configuration** blade. Update the database name, database server, user name & password in the **Application Settings** of App Service and save it. This will restart your App and the new changes will get reflected.

<!TODO: Add Screenshot>

    |    Application Setting Name    |
    |--------------------------------|
    |    DATABASE_NAME               |
    |    DATABASE_HOST               |
    |    DATABASE_USERNAME           |
    |    DATABASE_PASSWORD           |
## Note: If you are using Managed Idenity, do not use the application setting DATABASE_PASSWORD, follow this document to configure: [Enabling Managed Identity with Azure MySQL for WordPress App Service](https://github.com/Azure/wordpress-linux-appservice/blob/main/WordPress/wordpress_enable_managed_identity_with_mysql.md)
**Reference**: [WordPress Application Settings](./wordpress_application_settings.md)
