# PhpMyAdmin with WordPress on Linux App Service

PhpMyAdmin is setup in the container at `https://<your-app>/home/phpmyadmin/` path.

The following Application Settings are passed on to the Web App during the deployment in order to install and enable it on the web server. Installation of PhpMyAdmin happens only once along with the WordPress setup process. It is recommended to not change this value once the WordPress installation is complete, as it might change the routing rules. [Learn more about: Application Settings](./wordpress_application_settings.md)

|Application Settings| Value     |
|--------------------|-----------|
|SETUP_PHPMYADMIN    | true/false|
