# Configure custom startup scripts on WordPress Linux App Services

A startup script is a file that performs tasks during the startup process of your app. Azure App Services on Linux runs on Docker. You can create a custom startup script if any additional steps/configurations to be applied and persisted after site restarts. Start-up commands or script can be added to a pre-defined bash shell file **(/home/dev/startup.sh)** which is executed after the webapp container starts.

Note: As of September 2022, the startup script MUST exist at **(/home/dev/startup.sh)**. Further, the value of the Startup Command field in the Azure Portal found under [**App Service for Linux**] >  **Configuration** > **General Settings** > **Startup Command** is ignored. The Azure team is aware of this and working to make this flow more natural.

In this article, you will learn about running a startup file, if needed, for a WordPress site hosted on Linux App Service. For running locally, you don't need a startup file. However, when you deploy a web app to Azure App Service, your code is run in Docker container that can use any startup commands if they are present.

You can navigate to your app's WEBSSH portal as described in 'configure startup script' section to run commands within the container. There are two ways you can run scripts:

1. You can create and run a script from WEBSSH directly. Write operations to non-persistent storage by such scripts are temporary and are reverted upon restart.

2. You can edit /home/dev/startup.sh file to add the required commands. The changes made by this script persist across app restarts. You can look at 'How startup script works section' for more details.

Linux App Service architecture inherently has non-persistent storage i.e. file changes do not sustain after app restart. It uses App Service Storage which is a remote and persistent storage mounted onto /home directory where WordPress code is hosted. A majority of system config files are stored in /etc directory which is non-persistent storage. Changing system configuration by updating config files in non-persistent storage may not work always as the changes would revert back when the app restarts. Startup script enables you to add startup commands that are executed after an app container starts to make file changes that sustain through app restarts.  

## How Startup script works?

It is a bash script (in /home/dev/startup.sh) that is executed each time an app container starts and the changes made by startup commands remain constant even upon restart or scaling out to multiple app instances. The reason is that when an app container starts, it's file system in non-persistent storage has a default initial state defined by the underlying docker image. When startup script is executed, it may update files in non-persistent storage and upon restarting the app, these files revert back to the original state and startup script is executed which provides the same final state of files in non-persistent storage.

A custom startup script has many use cases. The following are some scenarios for which you need a startup script. Please note that your app service must be restarted for any changes in startup script to take affect.

## Update Nginx configuration

Configurations for nginx are defined in **/etc/nginx/conf.d/default.conf** and **/etc/nginx/conf.d/spec-settings.conf** files. You can update any of these files using a startup script. For instance, the following commands in startup script changes the nginx configuration for max simultaneous connections to 20000.

``` 
sed -i "s/keepalive_requests .*/keepalive_requests 20000;/g" /etc/nginx/conf.d/spec-settings.conf
/usr/sbin/nginx -s reload
``` 
Alternatively, you can follow these steps for the same result
* Copy the required config file to /home directory
```
cp /etc/nginx/conf.d/spec-settings.conf /home/custom-spec-settings.conf
```
* Edit /home/custom-spec-settings.conf using vi/vim editors to add custom settings.
 
NOTE: you can also upload a custom config file to /home directory using file manager. Navigate to file manager through this URL : _\<Wordpress_App_Name\>.scm.azurewebsites.net/newui/fileManager_. Upload the custom configuration file in /home directory (ex: /home/custom-spec-settings.conf)
 
* Copy the following code snippet to /home/dev/startup.sh.
 
```
cp /home/custom-spec-settings.conf /etc/nginx/conf.d/spec-settings.conf
/usr/sbin/nginx -s reload
```

## Run WP-CLI commands

WP-CLI is installed by default. You can add any wp-cli command to be executed in startup script. This example code runs cron events that are due.


``` 
wp cron event run --due-now
``` 

## Install system packages

WordPress on Linux App Service offering is based on alpine linux distro. You can use the default **apk add _\<packagename\>_** command to install required packages or package manager. The following command uses pecl to install imagick library for PHP

``` 
pecl install imagick
``` 

## App Service Storage

WordPress App Services (Linux) use a central App Service Storage which is a remote storage volume mounted onto the '/home' directory in the app container. App Service Storage is persistent storage and used to host the WordPress code (in /home/site/wwwroot). It is shared across containers when the app service is scaled out to multiple instances.

## Configure Startup script

The startup script is an empty file by default. Navigate to WEBSSH in scm portal of your WordPress app to update the startup script using the defaults vim/vi editors as shown below.

Navigate to **WebSSH/Bash** shell in SCMportal of your WordPress App. You can access the SCM site either from Azure Portal or using the following URL **https://\<sitename\>.scm.azurewebsites.net/newui**

<kbd><img src="./media/post_startup_script_1.png" width="700" /></kbd>
<kbd><img src="./media/post_startup_script_2.png" width="700" /></kbd>
<kbd><img src="./media/post_startup_script_3.png" width="700" /></kbd>

Add your start-up commands to **/home/dev/startup.sh** file. And restart your app for the changes to get reflected.
<kbd><img src="./media/post_startup_script_4.png" width="700" /></kbd>
