# Troubleshooting Guide for Existing WordPress Site Detected Warning

## Overview
If you see the following warning message on your WordPress site homepage:

<img src="../media/existing-site-detected.png" width="800">

This guide will explain the purpose of this warning and provide steps to resolve it yourself, with important notes on potential caveats.

## Why Am I Seeing This Warning?
This warning serves as a safeguard against potential data loss, especially in cases where the same MySQL database server is mistakenly linked to multiple WordPress sites or when an incorrect backup restore could erase existing data. This warning allows you to diagnose the situation if you believe it’s a false alarm or if you’re prepared to proceed with the assumption of a fresh installation.

## Detailed Explanation
The WordPress LAMP stack was originally designed for single-machine hosting, but with cloud-native, containerized hosting, WordPress must support independent scaling and fault tolerance. To achieve this, WordPress directories are hosted on a remote file system. Occasionally, delays in retrieving the current state from the remote file system can cause WordPress to interpret it as a fresh installation, potentially leading to data loss if this warning mechanism is not in place. Typically, a site restart resolves this issue if it’s due to a temporary synchronization delay.

In other cases, the warning may persist due to:
- Existing MySQL tables from a different WordPress setup
- Partial WordPress installation that was not completed due to transient issues

This is a warning, not an error, and you can proceed with resolving it if you’re familiar with your site setup.

## Troubleshooting Steps

1. **Restart the Site**  
   Try restarting your site and wait a few minutes to see if the issue is transient. If the warning persists after 2-3 restarts, proceed with the steps below.

2. **Access the SCM Site**  
   Open the Kudu dashboard for your App Service by navigating to `https://<appname>.scm.azurewebsites.net/`. If you’re new to the Kudu dashboard, [this blog post](https://techcommunity.microsoft.com/blog/appsonazureblog/kudu-dashboard-explained---wordpress-on-app-service/4030035) provides a helpful overview.

3. **Open the BASH Console**  
   Select the "BASH" option on the Kudu dashboard.

4. **Check Deployment Status**  
   Run the following command to view the WordPress deployment status:

   ```bash
   cat /home/wp-locks/wp_deployment_status.txt 
   ```

   Expected **SAMPLE** output:

   ```text
   PHPMYADMIN_INSTALLED
   WORDPRESS_PULL_COMPLETED
   WP_INSTALLATION_COMPLETED
   WP_CONFIG_UPDATED
   SMUSH_PLUGIN_INSTALLED
   EMAIL_PLUGIN_INSTALLED
   SMUSH_PLUGIN_CONFIG_UPDATED
   W3TC_PLUGIN_INSTALLED
   W3TC_PLUGIN_CONFIG_UPDATED
   BLOB_STORAGE_CONFIGURATION_COMPLETE
   WP_LANGUAGE_SETUP_COMPLETED
   WP_TRANSLATE_WELCOME_DATA_COMPLETED
   FIRST_TIME_SETUP_COMPLETED
   BLOB_CDN_CONFIGURATION_COMPLETE
   BLOWFISH_SECRET_UPDATED
   ```

5. **Confirm File Existence**  
   If `/home/wp-locks/wp_deployment_status.txt` is missing, it may indicate a completed setup but a transient issue. You may also want to check the MySQL database for existing WordPress data. A site restart often resolves transient issues.

6. **Verify Installation Status**  
   If the file exists but lacks `WORDPRESS_PULL_COMPLETED` or `WP_INSTALLATION_COMPLETED`, the installation may be incomplete. Verify the WordPress installation by running the following WP CLI command:

   ```bash
   wp core is-installed --path=/home/site/wwwroot --allow-root
   ```

   For detailed instructions, refer to [this guide](../how_to_use_wpcli_tool.md). Run this command in the "SSH" tab on the Kudu dashboard, as it needs to execute within the container context.

7. **Manual File Update (if necessary)**  
   If you confirm that the WordPress installation is correct and you want to proceed with a fresh installation, you can manually create or update the status file as follows:

   ```bash
   touch /home/wp-locks/wp_deployment_status.txt
   echo "WORDPRESS_PULL_COMPLETED" >> /home/wp-locks/wp_deployment_status.txt
   echo "WP_INSTALLATION_COMPLETED" >> /home/wp-locks/wp_deployment_status.txt
   ```

8. **Restart the Site Again**  
   Restart the WordPress App Service. The warning should now be resolved.

By following these steps, you should be able to resolve the warning effectively. 

If the issue persists, please reach out to us through our [official support channels](../../README.md#-community-and-support) and include relevant details, such as your Azure App Service ARM Resource ID.
