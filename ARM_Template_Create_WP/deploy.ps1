##
##Deploy Bicep template using PowerShell
##

#Login to Azure
#Login-AzAccount
    
#Vars
$resourceGroupName="sample-wordpress-app-rg"
$location="Australia Central"

#Create Resource Group
New-AzResourceGroup -Name $resourceGroupName -Location $location -Force

###########################

##Deploy resource group and provision resources
New-AzResourceGroupDeployment `
  -Name "wpappsvcdeploy" `
  -ResourceGroupName $resourceGroupName `
  -TemplateFile "azuredeploy.json" `
  -TemplateParameterFile "azuredeploy.parameters.json" #-WhatIf

#Remove Resource Group
##Remove-AzResourceGroup -Name $resourceGroupName -Force -AsJob