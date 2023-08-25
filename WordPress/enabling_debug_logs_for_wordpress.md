# How to Enable Debug Logs for WordPress on App Service

To enable debug logs in WordPress, add the following code to the **wp-config.php** file in the /home/site/wwwroot directory.. Note that you must insert this code before **/\* That's all, stop editing! Happy blogging. \*/** line in the wp-config.php file.

```
define( 'WP_DEBUG', true );
define( 'WP_DEBUG_LOG', true );
define( 'WP_DEBUG_DISPLAY', false );
@ini_set( 'display_errors', 0 );
```

All the debug logs are now written to ```/var/log/php-fpm/php-fpm.www.log``` file and you can monitor them using the command below. 
```
tail -f /var/log/php-fpm/php-fpm.www.log
```
