# WordPress Core Automatic updates

WordPress core automatic upgrades is one of the most important features of WordPress because it helps to ensure the security and stability of the platform. WordPress is constantly evolving and improving, and new updates are released regularly to address security vulnerabilities, fix bugs, and improve performance.

By automatically updating the WordPress core software, website owners can ensure that their website is always running on the latest version of the platform. This helps to protect the site from security vulnerabilities and other issues that could impact the performance of the site.

WordPress publishes 2 types of releases[WordPress release cadence](https://www.inmotionhosting.com/blog/major-vs-minor-wordpress-releases/#:~:text=Jumping%20from%20something%20like%20WordPress,1.):

1.  Minor version releases - Typically these releases carry bug fixes, security fixes to keep users site safe and secure
2.  Major version releases - These releases will typically include changes to WordPress core modules, new features, plugins or themes

## Automatic updates of Minor Version release
By default, **WordPress on App Service** is enabled with  auto upgrade of WordPress core minor version.  Minor version updates are necessary for keeping the site up to date with security fixes and any other maintenance updates.

There is a back-end cron job runs on your WordPress site every two hours and updates the site to latest minor version as and when it is release. During the update process, the site enters into maintenance mode and it becomes temporarily inaccessible. Once the version update is over, the site returns back to normal state by itself.

## Enable automated updates to WordPres Major version release 

It is recommended to  upgrade your WordPress site to latest major version available on demand. If you still wanted to opt-in for automated upgrade of WordPress core major version when it release, then follow these steps.

1. Launch the WP Admin dashbaord of your site, navigate to the Updates section and click on "Enable automatic updates for all new versions of WordPress" link as shown below.

![WordPress Major Updates](./media/wp_auto_updates_1.png)

2. If your site is not showing up this option "Enable automatic updates for all new versions of WordPress" in Updates section of your WordPress admin, then you can add the following line to wp-config.php file located at /home/site/wwwroot/.
   
```
define( 'WP_AUTO_UPDATE_CORE', true);
```
***NOTE:*** WP_AUTO_UPDATE_CORE can be defined with one of three values, each producing a different behavior. You can set it to "true" for enabling Major, Minor and Developement updates. See [here](https://aka.ms/WordPressautoupdateslink) for more information.

## Disable all WordPress Core Automatic updates

If you want to disable all WordPress Core Automatic updates, update the Constant WP_AUTO_UPDATE_CORE in wp-config file (see below for steps to update this file) by adding the following code snippet

```
define( 'WP_AUTO_UPDATE_CORE', false);
```

## Steps to edit wp-config.pgp file

To edit wp-config.php file, follow these steps:

1. Navigate to webssh of your app service through this link https://\<app service name\>.scm.azurewebsites.net/webssh/host

2. Edit wp-config.php file with vi/vim editors using the following command
```
vi /home/site/wwwroot/wp-config.php
```

3. Save the file

## Learn More

- [WordPress Core Automatic updates](https://wordpress.org/documentation/article/configuring-automatic-background-updates/)

