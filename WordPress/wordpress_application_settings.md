# WordPress Application Settings

This document described the set of application settings that are configured and used in running your wordpress site created from Azure Marketplace offering.

## Fixed Application Settings

Configuration that can be changed and have an affect  on your WordPress site through the lifetime of your app. Any changes to these settings will update the same in your WordPress application.

| Application Setting  | Scope | Default Value | Max Value  | Description                      |
|----------------------|-------------|---------------|-------------|---------------------------|
|WEBSITES_CONTAINER_START_TIME_LIMIT| Web App| 900| -| The amount of time the platform will wait (for the site to come up) before it restarts your container. WP installation takes around 5-10 mins after the AppService is deployed. By default, timeout limit for Linux AppService is 240 seconds. So, overriding this value to 900 seconds for WordPress deployments to avoid container restarts during the setup process. This is a required setting, and it is recommended to not change this value.|
|WORDPRESS_LOCAL_STORAGE_CACHE_ENABLED| Web App| -| -| Enables high performance for WordPress by serving the content from local storage rather than from remote storage. This only works with single instance of App Service and scaling out is not possible when it is enabled. We highly recommended to set this to TRUE and in case if you need more compute power, you can always try scaling up. |
|WEBSITES_ENABLE_APP_SERVICE_STORAGE| Web App| TRUE| -| When set to TRUE, file contents are preserved during restarts.|
|WP_MEMORY_LIMIT| WordPress| 128M| 512M| Frontend or general wordpress PHP memory limit (per script). Can't be more than PHP_MEMORY_LIMIT|
|WP_MAX_MEMORY_LIMIT| WordPress| 256M| 512M| Admin dashboard PHP memory limit (per script). Generally Admin dashboard/ backend scripts takes lot of memory compared to frontend scripts. Can't be more than PHP_MEMORY_LIMIT.|
|PHP_MEMORY_LIMIT| PHP| 512M| 512M| Memory limits for general PHP script. It can only be decreased.|
|FILE_UPLOADS| PHP| On| -| Can be either On or Off. Note that values are case sensitive. Enables or disables file uploads.|
|UPLOAD_MAX_FILESIZE| PHP| 50M| 256M| Max file upload size limit. Can be increased up to 256M. This value is limited on the upper side by the value of POST_MAX_SIZE variable.|
|POST_MAX_SIZE| PHP| 128M| 256M| Can be increased up to 256M. Generally should be more than UPLOAD_MAX_FILESIZE.|
|MAX_EXECUTION_TIME| PHP| 120| 120| Can only be decreased. Please break down the scripts if it is taking more than 120 seconds. Added to avoid bad scripts from slowing the system.|
|MAX_INPUT_TIME| PHP| 120| 120| Max time limit for parsing the input requests. Can only be decreased.|
|MAX_INPUT_VARS| PHP| 10000| 10000| -|
|DATABASE_HOST| Database| -| -| Database host used to connect to WordPress.|
|DATABASE_NAME| Database| -| -| Database name used to connect to WordPress.|
|DATABASE_USERNAME| Database| -| -| Database username used to connect to WordPress.|
|DATABASE_PASSWORD| Database| -| -| Database password used to connect to WordPress.|
|CUSTOM_DOMAIN| Web App | -| -| This is a multi-purpose app setting. It is used when Azure Frontdoor is configured with a custom domain, and the new domain needs to be configured in WordPress App too. AFD_ENABLED flag has to be set to true in this case. Additionally, it is also used for configuring custom domain to be used for multi-site WordPress installation. |
|ENTRA_CLIENT_ID| Web App| -| -| Client Id of user assigned managed identity. You can find it in the overview section of the user assigned managed identity resource. This is used for password-less authentication to services such as Azure MYSQL, ACS Email and Azure Blob Storage. |
|ENABLE_MYSQL_MANAGED_IDENTITY| Web App| -| -| Set to `true` if you want WordPress to use Managed Identity to access Azure MySQL Flexible Server. (If the setup is not yet done, refer to this [doc](./wordpress_enable_managed_identity_with_mysql.md)) |
|ENABLE_EMAIL_MANAGED_IDENTITY| Web App| -| -| Set to `true` if you want App Service Email Plugin to use Managed Identity to access Azure Communication Service Email (If the setup is not yet done, refer to this [doc](./wordpress_enable_managed_identity_with_acs_email.md)) |


## One-time Application Settings

Configurations that are used as a 'one-time' change and are applied just once. Any additional changes to these App Settings after the app has been deployed or configured won't re-configure or update your WordPress site. Although some of them needs to be preserved for proper functioning of your App.

| Application Setting  | Scope        | Default Value | Max Value  | Description                      |
|----------------------|-------------------|---------------|-------------|----------------------------------|
|SETUP_PHPMYADMIN| PhpMyAdmin| TRUE| -| Setups PhpMyAdmin dashboard and can be accessed from /phpmyadmin on your site. Only used once during the installation process. It is recommended to not change this once the WordPress installation is complete as it will change the Nginx routing rules. **Needs to be preserved for proper functioning of PhpMyAdmin.**|
|CDN_ENABLED| Azure CDN| -| -| Enables and configures CDN during installation time if the flag is set to true. |
|CDN_ENDPOINT| Azure CDN| -| -| The CDN endpoint is configured in the WordPress during installation time. CDN takes around 15 minutes to come up and get configured. CDN_ENABLED flag has to be set to true for this to be configured.|
|AFD_ENABLED| Azure Frontdoor| -| -| Enables and configures AFD during installation time if the flag is set to true. **Needs to be preserved for proper functioning of App.** |
|AFD_ENDPOINT| Azure Frontdoor| -| -| The AFD endpoint is configured in the WordPress during installation time. AFD_ENABLED flag has to be set to true for this to be configured. **Needs to be preserved for proper functioning of the App.** |
|BLOB_STORAGE_ENABLED| Azure Blob Storage| -| -| Enables and configures blob during installation time if the flag is set to true.|
|STORAGE_ACCOUNT_NAME| Azure Blob Storage| -| -|
|BLOB_CONTAINER_NAME| Azure Blob Storage| -| -|
|BLOB_STORAGE_URL| Azure Blob Storage| -| -|
|STORAGE_ACCOUNT_KEY| Azure Blob Storage| -| -|
|WORDPRESS_MULTISITE_CONVERT | Multisite WordPress Setup| -| -| Set this to true to convert the single site to multi-site |
|WORDPRESS_MULTISITE_TYPE | Multisite WordPress Setup| -| -| The types can be either 'subdirectory' or 'subdomain'. For subdomain-based multi-site, CUSTOM_DOMAIN application setting is mandatory. However, it is optional for subdirectory-based multi-site. |
|WORDPRESS_ADMIN_EMAIL| WordPress Setup| -| -|
|WORDPRESS_ADMIN_USER| WordPress Setup| -| -|
|WORDPRESS_ADMIN_PASSWORD| WordPress Setup| -| -|
|WORDPRESS_TITLE| WordPress Setup| -| -|
|WORDPRESS_LOCALE_CODE| WordPress Setup| en_US| -| WordPress localization code for site language.|

## Configuring Application Settings

Go to the Azure Portal and navigate to your **App Service -> Configuration**. Update the required **Application Settings** and save it. This will restart your app and the new changes will get reflected.

![Application Settings](./media/wordpress_database_application_settings.png)
