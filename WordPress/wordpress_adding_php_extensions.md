# Adding PHP extensions for WordPress Linux App Services

Customers who need to install PHP extensions that are not available on the WordPress Linux App Services image can do so by following the below steps. Here we will take an example and show how to add **soap** extension for PHP version 8, and please note that the process would be similar for other extensions.

## Installing PHP Extensions

1. Open an SSH session using **WebSSH** from the Azure portal.
![Web SSH](./media/post_startup_script_1.png)

1. Find out the PHP version of your WordPress image using the below command.

    ```bash
    php -v
    ```

1. Install **soap** extension for PHP.
   >**Note:** Depending on the version of the PHP, the name of the package needs to be updated accordingly. Additionally, you can use the [Alpine Linux Packages](https://pkgs.alpinelinux.org/packages) dashboard to search for your required PHP extensions. You can make use of wildcards (* and ?) in the search.

   ```bash
    apt-get update
    apt-get install php8-soap
   ```

1. For PHP 8, the extensions will be installed under **/usr/lib/php8/modules/**. If you are not able to find it, you can make use of **find** command to locate the extension file.

    ```bash
    cd /
    find . -name 'soap.so'
    ```

1. Now that the extension is installed, you need to create an **ext** directory under **/home/site/** and copy the extension file to it. This is because changes made outside /home path are non-persistent in nature and will be reset to the default state when the container is restarted.

   ```bash
    mkdir -p /home/site/ext
    cp /usr/lib/php8/modules/soap.so /home/site/ext/soap.so
    ```

1. Then we need to create a **extensions.ini** file under **/home/site/ini** directory and add the extension configuration to it.

   ```bash
    mkdir -p /home/site/ini
    echo 'extension=/home/site/ext/soap.so' >> /home/site/ini/extensions.ini
   ```

1. Go to your App Service in Azure Portal and add the following **Application Settings**. You will find Application Settings under **Settings -> Configurations** blade. Once the below settings are added, click on save. This will restart your Web App and new changes should be reflected.

    |Application Settings Name  | Value                                      |
    |---------------------------|---------------------------------------------
    |PHP_INI_SCAN_DIR           |/usr/local/etc/php/conf.d:/home/site/ini    |

## Testing

1. To test whether the extension is enabled or not, you can create a `phpinfo.php` file under `/home/site/wwwroot/` directory and add the code ```<?php phpinfo();``` to it. You can make use of the below command to do so.

    ```bash
    echo "<?php phpinfo();" > /home/site/wwwroot/phpinfo.php
    ```

   You should now see the extension is enabled by going to `https:\\<sitename>.azurewebsites.net/phpinfo.php`

1. Do not forget to remove the phpinfo.php page once you’re done using it.

    ``` bash
    rm /home/site/wwwroot/phpinfo.php
    ```

## Additional References:
- [Enabling PHP Intl Extension](./wordpress_intl_extension.md)