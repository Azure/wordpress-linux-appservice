# How to use WP-CLI with WordPress on App Service

WP-CLI (WordPress Command Line Interface) is a command-line tool designed for managing and interacting with WordPress websites. It allows users to perform various administrative tasks, such as installing and updating plugins, managing themes, creating and managing posts, users, and databases, all through a command line interface rather than the traditional web-based dashboard.



## Usage Example
WordPress on App Service comes with the wp-cli tool installed and enabled by default. It can be accessed and used from the SSH console of your App Service. To use it, please follow the below steps.

1. Go to the scm site of your App Service using the following url: _https//\<appname\>.scm.azurewebsites.net/_
2. Select **SSH** option shown on the scm site.
3. You can now run wp-cli commands as shown in the examples below. A detailed usage of wp-cli can be found here: [WP-CLI Commands](https://developer.wordpress.org/cli/commands/)

    ```
    # Display the list of plugins
    wp plugin list --path=/home/site/wwwroot --allow-root

    # Check for minor version upgrades
    wp core check-update --minor --path=/home/site/wwwroot --allow-root
    ```

**Note:** You need to add **_--allow-root_** at the end of your command as shown in the above examples.


