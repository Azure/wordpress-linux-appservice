# Performance Optimized WordPress

## Background
When WordPress was originally developed, it was meant to run on a single server node. And for majority of the applications, a single instance is sufficient. In case if you need more resources, you can scale up your instance to add more CPU and memory power. This is also known as vertical scaling (scale up). You can significantly improve the performance of your application by using Azure CDN or Azure Front Door to cache your static data (such as images, videos etc.,) and serve it to the users all across the globe with very high speed. You can also make use of highly scalable Azure Blob Storage to store the uploaded static data (from wp-content/uploads) and serve it to the users from the blob storage endpoint. These techniques help in significantly improving the performance and reducing the load on your Web App.

To scale WordPress application to multiple nodes (also known as horizontal scaling or scale out), we need to decouple the database and file storage from the nodes running the WordPress server. With the wide availability of managed database servers (such as Azure Flexible MySQL server) and remote file storages, we now have the capability to acheive this with significant ease. However, one inconvinience using remote file storage is that the part of the applications that requires heavy file I/O might be slower due to network latency introduced by the remote file storage. 

Azure App Service is designed to offer both vertical and horizontal scaling for your Web Applications. And therefore, by default, it uses a persistent network file storage mounted at /home path to store the site content. A general thumb rule for applications like WordPress is that you always go for vertical scaling (scale up) first, and only when you are out of options, you go ahead with horizontal scaling (scale out). Please note that in case of our offering, the database server and file storage are decoupled from the host machine on which your App is running. Azure Flexible MySQL server can be scaled independently and it also takes regular backups of your data. Additionally, the internal remote file server integrated with Azure App Service also has failover replicas of your data to prevent down time.

## What is the new performance optimized feature?
As I was saying earlier, in most of the cases, a single instance of App Service is sufficient. And therefore, the peformance of the your WordPress site can be significantly improved by moving WordPress source code to local storage of the host VM where where App Service is running. The copying happens during the container startup. Now, that the content is being served from local storage instead of the remote file storage, the performance is going to be superfast. Additionally, we use Unison file sync utility that runs in the background, and it dynamically monitors and syncs any file changes between local storage and remote file server.


## What data is moved to the local storage?


## How to enable this feature?



## Limitations and side effects



