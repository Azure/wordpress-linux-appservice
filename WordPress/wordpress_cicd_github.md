# Configure CI/CD for WordPress on Azure AppService with GitHub Actions

[WordPress on App Service](https://ms.portal.azure.com/#create/WordPress.WordPress) installs with an Application setting WEBSITES_ENABLE_APP_SERVICE_STORAGE set to true. This enables persistent storage for your site in an Azure Storage mount having the path /home. The WordPress deployment on AppService also includes three plugins.

The WordPress source code is deployed to "/home/site/wwwroot" folder and plugins are installed to this directory "/home/site/wwwroot/wp-content/plugins". When you install any new plugin from wp-admin UI, the plugin code is deployed to the same above path. WordPress themes also follow the same pattern.

This document describes the steps that you can follow to deploy the custom code to your WordPress site running on Azure AppService. The custom code referenced here is about WordPress plugins and themes. You will use GitHub Actions for Continuous Integration / Continuous Deployment (CI/CD) to deploy code updates to your WordPress site.

**Prerequisites:**

1. An Azure account with an active subscription. [Create an account for free](https://azure.microsoft.com/free/?WT.mc_id=A261C142F).
2. A GitHub account. If you don't have one, sign up for [free](https://github.com/join).
3. A working WordPress on Azure App Service
4. GitHub Secret is configured

Some Background


CI/CD For Custom Plugin and Theme Code
Needless to say, for custom code you'll want to have source code version control and an efficient deployment workflow. This is accomplished with GitHub repositories and GitHub Actions.

For the sake of example, my custom code is a fork of the public repository tommcfarlin/wp-hello-world.

To our custom code we'll add a directory for our GitHub Action, .github\workflows.

For our GitHub Action we'll use the FTP Deploy action available in the GitHub Marketplace.

In our .github\workflows directory we'll add a main.yml file into which we'll insert the following code:
on: push
name: 🚀 Deploy website on push
jobs:
  web-deploy:
    name: 🎉 Deploy
    runs-on: ubuntu-latest
    steps:
    - name: 🚚 Get latest code
      uses: actions/checkout@v2

    - name: 📂 Sync files
      uses: SamKirkland/FTP-Deploy-Action@4.3.0
      with:
        server: <mysite>.ftp.azurewebsites.windows.net
        username: ${{ secrets.WP_USER }}
        password: ${{ secrets.WP_PASSWORD }}
        protocol: ftps        
        server-dir: /site/wwwroot/wp-content/plugins/wp-hello-world/
        # dry-run: true
For this to work for your site, you need to:

Add Actions secrets for the FTPS credentials. In our example the secret names are WP_USER and WP_PASSWORD.
For the server: value replace the <mysite> placeholder with the unique FTPS endpoint prefix of your site.
Tips
Note the # dry-run: true attribute at the end of the action code. I recommend this for your initial testing of the GitHub Action.
Refer to the FTP Deploy documentation for other settings you can employ for your GitHub Action.
Going Deeper
CI/CD really shines when you have staged deployments. With Azure Web Apps you can have deployment slots for pre-production environments such as Dev, Stage, and QA. Each has its own FTPS Endpoint allowing you to leverage GitHub Actions for each stage of your code life-cycle.
