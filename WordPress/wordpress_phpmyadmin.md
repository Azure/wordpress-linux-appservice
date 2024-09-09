# PhpMyAdmin with WordPress on Linux App Service

PhpMyAdmin can be accessed from your site at `https://<your-app>.azurewebsites.net/phpmyadmin/`. <br>

The path to PhpMyAdmin code inside the container is **/home/phpmyadmin/**

The following Application Settings are passed on to the Web App during the deployment in order to install and enable it on the web server. Installation of PhpMyAdmin happens only once along with the WordPress setup process. It is recommended to not change this value once the WordPress installation is complete, as it might change the routing rules. [Learn more about: Application Settings](./wordpress_application_settings.md)

|Application Settings| Value     |
|--------------------|-----------|
|SETUP_PHPMYADMIN    | true/false|



## Accessing MySQL with Managed Identity

Managed Identity is enabled by default for all new sites created starting **September 2024**. It is used to securely access the database from the App Service, eliminating the need to manage and store credentials. Please follow the below instructions to retrieve the database username and access token for the MySQL server.

- The script to fetch MySQL access token is available at **/usr/local/bin/fetch-mysql-access-token.sh** inside the container and can be accessed from SSH console of your App Service. Run the following command from SSH console of your App Service:
    ```
    bash /usr/local/bin/fetch-mysql-access-token.sh
    ```
- Database username should be available as **DATABASE_USERNAME** environment variable / application setting in your App Service. You can also run the following command from SSH console to view it.
    ```
    echo $DATABASE_USERNAME
    ```
- Once you get the username and access token, you can login to the MySQL server from PhpMyAdmin dashboard of your site: `https://<your-app>.azurewebsites.net/phpmyadmin/`. 
