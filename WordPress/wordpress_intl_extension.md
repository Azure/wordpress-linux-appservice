# How to enable PHP Intl extension with WordPress App Service

## Steps

1. Run the below code only once from the SSH console of your App Service.
    ```
    apt-get update && \
    apt-get install -y libicu-dev && \
    docker-php-ext-configure intl && \
    docker-php-ext-install intl && \
    docker-php-ext-enable intl
    ```
 

2. Now copy the intl.so & docker-php-ext-intl.ini file to persistent storage (/home). Run this code from the SSH console
    ```
    mkdir /home/intl-ext
    cp /usr/local/etc/php/conf.d/docker-php-ext-intl.ini /home/intl-ext/docker-php-ext-intl.ini
    cp /usr/local/lib/php/extensions/no-debug-non-zts-20220829/intl.so /home/intl-ext/intl.so
    ```
 

3. Add below code in /home/dev/startup.sh file.
    ```
    apk add icu-dev
    cp /home/intl-ext/docker-php-ext-intl.ini /usr/local/etc/php/conf.d/docker-php-ext-intl.ini
    cp /home/intl-ext/intl.so /usr/local/lib/php/extensions/no-debug-non-zts-20220829/intl.so
    supervisorctl restart php-fpm
    ```

4. Now try to execute the startup.sh script from SSH console and see if there are any errors.
    ```
    cd /home/dev
    ./startup.sh
    ```
 

5. If you see any errors related to supervisord process, then replace the code in /home/dev/startup.sh file with below one. Otherwise, ignore this step
    ```
    apk add icu-dev
    cp /home/intl-ext/docker-php-ext-intl.ini /usr/local/etc/php/conf.d/docker-php-ext-intl.ini
    cp /home/intl-ext/intl.so /usr/local/lib/php/extensions/no-debug-non-zts-20220829/intl.so
    kill $(ps aux | grep 'php-fpm' | awk '{print $1}') 2> /dev/null
    ```
 

6. Now Restart your App Service and check if the extension is enabled using phpinfo file. To create phpinfo file run the below commands from SSH console.
    ```
    cd /home/site/wwwroot/
    echo "<?php phpinfo();" > phpinfo.php
    ```
 
7. Don't forget to delete the phpinfo.php file immediately after validating the extension.
    ```
    rm /home/site/wwwroot/phpinfo.php
    ```


## References:
- [Adding PHP extensions for WordPress Linux App Services](./wordpress_adding_php_extensions.md)
