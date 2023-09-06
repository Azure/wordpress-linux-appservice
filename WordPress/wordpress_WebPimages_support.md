# How to enable WebP Support in WordPress on Azure App Service

WordPress on Azure App Service is deployed as custom container and the Container image used for creating WordPress image is based on Alpine Linux. Docker Alpine is the “Dockerize” version of Alpine Linux, a Linux distribution known for being exceptionally lightweight and secure. For these reasons, Alpine Linux was chosen as a base image on which WordPress is built as containerized app.

This Alpine image has access to Alpine package manager and can load all required libraries with "apk" as and when needed.  Below is the guidance for enabling webP support on WordPress on Azure App Service.

**Steps to enable webP support**

1. Launch Azure portal and navigate to your site definition page.
2. Via advanced tools of App Service blade, connect to webssh of your SCM site
3. Navigate to webssh of your app service through this link https://<app service name>.scm.azurewebsites.net/webssh/host
4. Install the gd extension with webp support using the below command (Run in WebSSH/SSH):
     ```bash
     apk add --no-cache --virtual .build-deps autoconf pkgconfig gcc g++ gawk make zlib-dev libpng-dev libwebp-dev \
     && docker-php-ext-configure gd --with-webp \
     && docker-php-ext-install gd \
     && apk del .build-deps
     ```
5. Copy the newly installed gd.so file to a persistent file storage:
    ```bash
    mkdir -p /home/site/ext
    cp /usr/local/lib/php/extensions/no-debug-non-zts-20200930/gd.so /home/site/ext/gd.so
     ```
6. Then we need to create a **extensions.ini** file under **/home/site/ini** directory and add the extension configuration to it.
   ```bash
   mkdir -p /home/site/ini
   echo 'extension=/home/site/ext/gd.so' >> /home/site/ini/extensions.ini
   ```

7. Go to your App Service in Azure Portal and add the following **Application Settings**. You will find Application Settings under **Settings -> Configurations** blade. Once the below settings are added, click on save. Now restart your Web App and new changes should be reflected after the restart. 

    |Application Settings Name  | Value                                      |
    |---------------------------|---------------------------------------------
    |PHP_INI_SCAN_DIR           |/usr/local/etc/php/conf.d:/home/site/ini    |
  

## Testing

1. To test whether the extension is enabled or not, you can create a `phpinfo.php` file under `/home/site/wwwroot/` directory and add the code ```<?php phpinfo();``` to it. You can make use of the below command to do so.

    ```bash
    echo "<?php phpinfo();" > /home/site/wwwroot/phpinfo.php
    ```

   You should now see the extension is enabled by going to `https:\\<sitename>.azurewebsites.net/phpinfo.php`

2. Do not forget to remove the phpinfo.php page once you’re done using it.

    ``` bash
    rm /home/site/wwwroot/phpinfo.php
    ```
