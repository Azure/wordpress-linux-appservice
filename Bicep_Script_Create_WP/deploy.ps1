##Deploy Biceo teplate using powershell

#Login to Azure
#Login-AzAccount
    
#Vars
$subscriptionName="<SUBSCRIPTION_NAME>"
$resourceGroupName="wordpress-appsvc-rg"
$location="West US"
$bicepSrc="main.bicep"
$armOutput="main.json"
$templateParamFile="wp.dev.parameters.json"


#Select Subscription
# $subscriptionId = (Get-AzSubscription -SubscriptionName $subscriptionName).Id
# Select-AzSubscription -SubscriptionId $subscriptionId  


#Create Resource Group
New-AzResourceGroup -Name $resourceGroupName -Location $location -Force

#Convert Bicep to .JSON ARM template - issues with cmdlet - New-AzResourceGroupDeployment
az bicep build --file $bicepSrc

#Deploy the Decompiled ARM template with param file
New-AzResourceGroupDeployment `
  -ResourceGroupName $resourceGroupName `
  -TemplateFile $armOutput `
  -TemplateParameterFile $templateParamFile ##-WhatIf
  
  ##-AsJob

#Remove Resource Group
##Remove-AzResourceGroup -Name $resourceGroupName -Force -AsJob


