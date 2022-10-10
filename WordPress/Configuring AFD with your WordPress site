# How to use Azure Front Door (AFD) with WordPress on Azure App Service? 

Azure Front Door is a modern cloud content delivery network (CDN) service that delivers high performance, scalability, and secure user experiences for your content and applications. Learn More. 

WordPress on Azure App Service now supports AFD. This improves performance of apps by delivering your content using Microsoft's global edge network with hundreds of global and local points of presence. Access to the static and dynamic content of your WordPress application is accelerated by caching static content at the edge server and using split TCP method to reduce connection establishment time among others. 


### How it works? 

For a Linux WordPress deployment with AFD enabled, a new AFD endpoint is created along with an origin group for the app service in the selected Profile. The AFD endpoint hostname is passed to the app services as an app setting which is used configure AFD in WordPress. 
 

The following Application Settings are passed on to the Web App during the deployment in order to configure Azure Front Door in WordPress.  

AFD_ENABLED: <true/false> 
AFD_ENDPOINT: <AFD_Endpoint_Hostname> 
 

When AFD endpoint comes up, the following constants are updated in wp-config file. This updates the domain of all hyperlinks produced by WordPress to AFD endpoint hostname and redirects all admin pages to AFD. 

WP_HOME: <AFD_Endpoint_Hostname> 
WP_SITEURL: <AFD_Endpoint_Hostname> 
 

#NOTE: It may take up to 15 minutes or more in case of app restarts to configure AFD since it leads to a reset of the cron job that configures AFD. 
 

Front Door acts as a reverse proxy for WordPress on Azure App Service and in the entry point to the application. So when user makes a request, it is served by the nearest edge server (following anycast method) which in turn retrieves the response from app service and returns back to the user. 
 

AFD is configured to cache and compress static content at the edge server for 3 days unless 'cache-control: private' header is present in response. You can look at the ruleset created in AFD profile for details. 
 

For a Linux WordPress deployment with AFD and Blob Storage enabled, an additional origin group is created for blob container used to host WordPress uploads. The Ruleset created during deployment is updated to override origin group to blob container for uploads (wp-content/uploads). Learn More about WordPress with Blob Storage. 
