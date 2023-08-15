# How to enable WebP Support in WordPress on Azure App Service

WordPress on Azure App Service is deployed as custom container and the Container image used for creating WordPress image is based on Alpine Linux. Docker Alpine is the “Dockerize” version of Alpine Linux, a Linux distribution known for being exceptionally lightweight and secure. For these reasons, Alpine Linux was chosen as a base image on which WordPress is built as containerized app.

This Alpine image has access to Alpine package manager and can load all required libraries with "apk" as and when needed.  Below is the guidance for enabling webP support on WordPress on Azure App Service.

**Steps to enable webP support**

1. Launch Azure portal and navigate to your site definition page.
2. Via advanced tools of App Service blade, connect to webssh of your SCM site
3. Navigate to webssh of your app service through this link https://<app service name>.scm.azurewebsites.net/webssh/host
4. Install the gd extension with webp support using the below command:
        apk add --no-cache --virtual .build-deps autoconf pkgconfig gcc g++ gawk make zlib-dev libpng-dev libwebp-dev \
        && docker-php-ext-configure gd --with-webp \
        && docker-php-ext-install gd \
        && apk del .build-deps

5. Copy the newly installed gd.so file to a persistent file storage:
    mkdir -p /home/dev/extensions
    cp /usr/local/lib/php/extensions/no-debug-non-zts-20200930/gd.so /home/dev/extensions/gd.so

6. Now modify the WP post startup script as per the instructions shown below to restore the updated copy of gd.so every time wordpress app gets restarted.

Edit the startup script file located at /home/dev directory using the below command:  

vi /home/dev/startup.sh
cp /home/dev/extensions/gd.so /usr/local/lib/php/extensions/no-debug-non-zts-20200930/gd.so

 Save the startup.sh file (:wq to save)

6. Restart your app from Azure Portal. Now you can start uploading the .webp images and your Wordpress site will render those images.
