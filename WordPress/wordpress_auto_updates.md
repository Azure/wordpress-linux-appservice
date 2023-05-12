# WordPress Core Automatic upgrades

WordPress core automatic upgrades is one of the most important features of WordPress because it helps to ensure the security and stability of the platform. WordPress is constantly evolving and improving, and new updates are released regularly to address security vulnerabilities, fix bugs, and improve performance.

By automatically updating the WordPress core software, website owners can ensure that their website is always running on the latest version of the platform. This helps to protect the site from security vulnerabilities and other issues that could impact the performance of the site.

By default, **WordPress on App Service** enabled with  auto upgrade of WordPress core minor version.  Minor version updates are necessary for keeping the site up to date with security fixes and any other maintenance updates.

## WordPress Core Automatic updates behaviour

WordPress checks for updates every two hours and updates to the latest version if available. During the update process, the site enters maintenance mode, which renders it temporarily inaccessible. Once the update is complete, the site returns back to normal state.

## Enable WordPress Core major updates 

To enable WordPress core major updates, go to the Updates section in WordPress admin dashboard of your site and click on "Enable automatic updates for all new versions of WordPress" link as shown below.

![WordPress Major Updates](./media/wp_auto_updates_1.png)

Once you click on this link and enable WordPress core auto updates, you can go back to enabling only WordPress core minor updates by clicking the "Switch to automatic updates for maintenance and security releases only." link on the same page as shown below.

![WordPress Major Updates](./media/wp_auto_updates_2.png)

In case you are unable to see such links in Updates section of WordPress admin, you can add the following to wp-config.php file (see below for steps to update this file):
```
define( 'WP_AUTO_UPDATE_CORE', minor);
```
***NOTE:*** This setting enables only minor version updates for WordPress. You can set it to "true" for enabling Major version updates. See [here](https://wordpress.org/documentation/article/configuring-automatic-background-updates/#:~:text=WP_AUTO_UPDATE_CORE%27%2C%20true%20)%3B-,WP_AUTO_UPDATE_CORE,-can%20be%20defined) for more information.

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

