##
##Deploy Bicep template using PowerShell
##

#Login to Azure
#Login-AzAccount
    
#Vars
$resourceGroupName="wordpress-appsvc-rg"
$location="West US"

#Create Resource Group
New-AzResourceGroup -Name $resourceGroupName -Location $location -Force

###########################

##Deploy resource group and provision resources
New-AzResourceGroupDeployment `
  -Name "wpappsvcdeploy" `
  -ResourceGroupName $resourceGroupName `
  -TemplateFile "main.bicep" `
  -TemplateParameterFile "wp.dev.parameters.json"

#Remove Resource Group
##Remove-AzResourceGroup -Name $resourceGroupName -Force -AsJob