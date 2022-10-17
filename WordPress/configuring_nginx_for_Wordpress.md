# Configure nginx for Various WordPress Scenarios

WordPress relies on plugins to provide functionality that is not present in the core system. Most of these plugins work immediately after being installed, but some require modification of the environment in which WordPress is running.

WordPress running on App Service for Linux uses nginx as the web server. Configuring nginx is done through a a custom startup script (by default, **/home/dev/startup.sh**) that replaces one or more nginx .conf files as covered in [Setup Startup scripts for WordPress running on Linux AppService](./running_post_startup_scripts.md).

The remainder of this document provides specific nginx configuration file edits for various WordPress scnearios and/or plugins.

## Accepting Payments using WooCommerce "Payment Gateways"

Many WordPress sites run the WooCommerce plugin to provide a storefront, and additional add-on plugins that provide functionality that does not exist in the core WooCommerce plugin. One example of these add-on plugins are "payment gateways" that allow WooCommerce to integrate with providers such as PayPal and Amazon Pay in order to accept payment for goods and services.

These payment providers use a series of GET and POST requests to the underlying web site which require a configuration change to nginx in order to work successfully. Without this change, users will see a '502 Bad Gateway' error near the end of the payment flow. In many cases, the sale will not complete, and in all cases, the user will not be presented with a "success" message.

The underlying issue is that default nginx buffers for POST requests are not large enough to handle these transactions. To increase their size, add the following lines to the appropriate nginx configuration file, inside the `http { }` block.

```
# increase buffer size for POST operations used by WooCommerce Payment Gateways 
# such as PayPal and AmazonPay. Without this, they will fail with 502 Bad Gateway errors
proxy_buffers       8 16k;  # Buffer pool = 8 buffers of 16k
proxy_buffer_size     16k;  # 16k of buffers from pool used for headers
fastcgi_buffers     8 16k;
fastcgi_buffer_size   32k;
```
