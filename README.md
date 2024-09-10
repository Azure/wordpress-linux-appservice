# 🚀 WordPress on Azure App Service

[![Deploy to Azure](https://aka.ms/deploytoazurebutton)](https://portal.azure.com/#create/WordPress.WordPress)

---

## 🔍 Overview

Whether you're handling a few thousand visitors daily on your eCommerce platform or drawing in large crowds to your content, it's essential that your site is fast and always available to keep your audience engaged. Our cloud solutions ensure **high availability**, **speed**, **scalability**, and **security** — so you can confidently deliver a seamless digital experience.

WordPress on Azure App Service is a fully managed PaaS offering that takes care of infrastructure maintenance, security patching, and scaling for you as described [here](https://github.com/Azure/wordpress-linux-appservice/blob/main/WordPress/wordpress_auto_updates.md). It also supports virtual networks and can run in an isolated, dedicated App Service Environment. Features like automatic WordPress updates, threat detection, and free SSL encryption are included to enhance security for all our customers.

While there are multiple WordPress options on Azure, we recommend starting with [WordPress on Azure App Service](https://aka.ms/linux-wordpress) from the Azure Marketplace. This Marketplace offering is optimized for Linux App Service, making it easy to install. This comes with the latest software packages, tailored SKU sizes for both Azure App Service and Azure Database for MySQL Flexible Server, and include dedicated support from the App Service team.

---

## 🧠 Concepts

### Key Features:
Here’s the updated **Concepts** section with both the previous and new key features, each with an emoji:

---

## 🧠 Concepts

### Key Features:
- 🛡️ **Automatic security patches**: Updates are applied within 45 days, following the support policy, to keep your WordPress site secure.
- 🚀 **Pre-configured Azure CDN and Blob Storage**: Optimized for content delivery, ensuring high availability and performance across the globe.
- 🏗️ **Best practices from Azure Well-Architected Framework**: The default setup follows Azure's best practices for security, scalability, and performance.
- 📈 **Flexible hosting plans**: Ranges from small hobby projects to large enterprise needs, offering scalability and customization.
- 🔄 **Built-in infrastructure maintenance**: Automatic updates and security patches without manual intervention.
- 📊 **Automatic scaling**: Resources dynamically adjust based on traffic, ensuring seamless user experiences.
- 🔒 **SSL Certificates**: Free SSL certificates for traffic encryption to secure your website.
- 🔗 **Virtual Networks**: Support for secure, isolated environments to enhance your site's security and performance.
- 🌍 **Multi-cloud Availability**: Available in public cloud, US Government Cloud (Fairfax), and China Cloud (Mooncake).


    High-level architecture
    ![WordPress on Linux App Service](https://user-images.githubusercontent.com/15884692/204471285-0350cf5e-4bd3-45c7-a5e0-9234fac9a785.png)

---

## 🚀 Quickstart

### 1. **Deploy WordPress**  
   You can deploy the recommended version of [WordPress on Azure App Service](https://aka.ms/linux-wordpress) directly from the Azure Marketplace. It’s optimized for Linux App Service and pre-configured with recommended software packages, including support for [Azure Database for MySQL Flexible Server](https://learn.microsoft.com/en-us/azure/mysql/flexible-server/overview).

   [![Deploy to Azure](https://aka.ms/deploytoazurebutton)](https://portal.azure.com/#create/WordPress.WordPress)

or follow the steps outlined in the ARM template deployment guide found [here](.ARM_Template_Create_WP/README.md) .
   

### 2. **Choose an Docker Image**  
   Select from the following WordPress container images:

   | Image Name | Image Tag | OS | PHP Version | Nginx version | Comments |
   |------------|------------|----|-------------|---------------|----------|
   | mcr.microsoft.com/appsvc/wordpress-alpine-php | 8.3 | Alpine Linux 3.20 | 8.3.8 | 1.26.1 | ✅ Supported and recommended |
   | mcr.microsoft.com/appsvc/wordpress-alpine-php | 8.2 | Alpine Linux 3.20 | 8.2.20 | 1.26.1 | ✅ Supported |
   | mcr.microsoft.com/appsvc/wordpress-alpine-php | 8.0 | Alpine Linux 3.16 | 8.0.30 | 1.24.0 | ⚠️ End of Life |
   | mcr.microsoft.com/appsvc/wordpress-alpine-php | latest | Alpine Linux 3.16 | 8.0.30 | 1.24.0 | ❌ Deprecated (Use a specific numerical tag instead) |

> **Note**: The `latest` tag points to PHP 8.0, which is no longer maintained. Always use a specific version number to avoid issues.

- Image Server URL: https://mcr.microsoft.com
- URL to view all the list of WordPress tags [here](https://mcr.microsoft.com/v2/appsvc/wordpress-alpine-php/tags/list)

---

## 📚 Tutorials

### 🔐 **Security & Identity Management**
- [Change MySQL Database Password for WordPress on Linux App Service](./WordPress/changing_mysql_database_password.md)
- [Change WordPress Admin Credentials for WordPress hosted on Linux App Service](./WordPress/changing_wordpress_admin_credentials.md)
- [Enabling Managed Identity with Azure Communication Service Email](./WordPress/wordpress_enable_managed_identity_with_acs_email.md)
- [Enabling Managed Identity with Azure MySQL for WordPress App Service](./WordPress/wordpress_enable_managed_identity_with_mysql.md)
- [Enable Microphone and Camera with WordPress App Service](./WordPress/wordpress_enable_microphone_camera.md)

---

### ⚙️ **Configuration & Customization**
- [A View of Application Settings for WordPress on Linux App Service](./WordPress/wordpress_application_settings.md)
- [Configuring Nginx for WordPress on Linux App Service](./WordPress/configuring_nginx_for_wordpress.md)
- [Adding PHP Extensions for WordPress on Linux App Service](./WordPress/wordpress_adding_php_extensions.md)
- [How to Enable PHP Intl Extension with WordPress App Service](./WordPress/wordpress_intl_extension.md)
- [Setup Startup Scripts for WordPress on Linux App Service](./WordPress/running_post_startup_scripts.md)
- [Enabling Multi-site WordPress on Azure App Service](./WordPress/wordpress_multisite_installation.md)
- [How to Use WP-CLI with WordPress on App Service](./WordPress/how_to_use_wpcli_tool.md)

---

### 🔄 **Migration & Database Management**
- [Migrate Any WordPress Site to WordPress on Linux App Service](./WordPress/wordpress_migration_linux_appservices.md)
- [Configure WordPress on Linux App Service with Existing MySQL Database](./WordPress/using_an_existing_mysql_database.md)
- [Migrate WordPress Images from Other Containers to Microsoft-Supported Containers](./WordPress/wordpress_upgrade_from_other_images.md)
- [Connect to Database with phpMyAdmin on WordPress App Service](./WordPress/wordpress_phpmyadmin.md)

---

### 🚀 **Performance Optimization & Scaling**
- [Enabling High Performance with Local Storage](./WordPress/enabling_high_performance_with_local_storage.md)
- [Image Optimizations in WordPress](./WordPress/wordpress_image_compression.md)
- [Configuring Local Redis Cache for WordPress](./WordPress/wordpress_local_redis_cache.md)
- [Hosting Plans and Scaling WordPress](./WordPress/wordpress_hosting_plans_and_scaling.md)
- [How to Enable WebP Support in WordPress on Azure App Service](./WordPress/wordpress_WebPimages_support.md)

---

### 🌐 **Integration & Networking**
- [AFD Integration with WordPress on Azure App Service](./WordPress/wordpress_afd_configuration.md)
- [Configuring Azure Blob Storage with WordPress](./WordPress/wordpress_azure_blob_storage.md)
- [Configuring Azure CDN with WordPress](./WordPress/wordpress_azure_cdn.md)
- [Integrating Azure Communication Email Service with WordPress App Service](./WordPress/wordpress_email_integration.md)

---

### 🔧 **Troubleshooting & Debugging**
- [How to Enable Debug Logs for WordPress on App Service](./WordPress/enabling_debug_logs_for_wordpress.md)
- [Troubleshooting CORS Errors with Azure CDN / FrontDoor or Azure Blob Storage](./WordPress/cors_issue_with_azure_cdn_frontdoor_blob.md)

---

### 🎯 **Development & CI/CD**
- [How to Create a Staging Environment for WordPress on Azure App Service](./WordPress/wordpress_azure_StageDeployments.md)
- [Enabling CI/CD for WordPress on App Service](./WordPress/wordpress_azure_ci_cd.md)

---

### 🤖 **AI & Automation**
- [WordPress on Azure App Service – Simplify Site Creation with Azure OpenAI](./WordPress/wordpress_azure_open_ai_integration.md)

---

## 🤝 Contributing

This project welcomes contributions and suggestions.  Most contributions require you to agree to a
Contributor License Agreement (CLA) declaring that you have the right to, and actually do, grant us
the rights to use your contribution. For details, visit <https://cla.opensource.microsoft.com>.

When you submit a pull request, a CLA bot will automatically determine whether you need to provide
a CLA and decorate the PR appropriately (e.g., status check, comment). Simply follow the instructions
provided by the bot. You will only need to do this once across all repos using our CLA.

This project has adopted the [Microsoft Open Source Code of Conduct](https://opensource.microsoft.com/codeofconduct/).
For more information see the [Code of Conduct FAQ](https://opensource.microsoft.com/codeofconduct/faq/) or
contact [opencode@microsoft.com](mailto:opencode@microsoft.com) with any additional questions or comments.

---

## ⚠️ Trademarks

This project may contain trademarks or logos for projects, products, or services. Authorized use of Microsoft trademarks or logos is subject to and must follow [Microsoft's Trademark & Brand Guidelines](https://www.microsoft.com/en-us/legal/intellectualproperty/trademarks/usage/general).
Use of Microsoft trademarks or logos in modified versions of this project must not cause confusion or imply Microsoft sponsorship.
Any use of third-party trademarks or logos are subject to those third-party's policies.