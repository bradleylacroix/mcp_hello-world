@description('Location for all resources')
param location string = 'canadacentral'

// Requested naming pattern: <abbr>_hello-world
var storageRaw = 'st_hello-world'
var appInsightsRaw = 'ai_hello-world'
var planRaw = 'plan_hello-world'
var funcRaw = 'func_hello-world'

// sanitize names for Azure constraints
var storageName = toLower(replace(replace(storageRaw, '_', ''), '-', ''))
var appInsightsName = replace(appInsightsRaw, '_', '-')
var planName = replace(planRaw, '_', '-')
var functionName = replace(funcRaw, '_', '-')

resource storageAccount 'Microsoft.Storage/storageAccounts@2022-09-01' = {
  name: storageName
  location: location
  sku: {
    name: 'Standard_LRS'
  }
  kind: 'StorageV2'
  properties: {}
}

resource appInsights 'microsoft.insights/components@2020-02-02' = {
  name: appInsightsName
  location: location
  kind: 'web'
  properties: {
    Application_Type: 'web'
  }
}

resource appServicePlan 'Microsoft.Web/serverfarms@2021-02-01' = {
  name: planName
  location: location
  sku: {
    name: 'Y1'
    tier: 'Dynamic'
  }
  properties: {
    reserved: true
  }
}

resource functionApp 'Microsoft.Web/sites@2021-02-01' = {
  name: functionName
  location: location
  kind: 'functionapp,linux'
  identity: {
    type: 'SystemAssigned'
  }
  properties: {
    serverFarmId: appServicePlan.id
    siteConfig: {
      linuxFxVersion: 'PYTHON|3.9'
      appSettings: [
        {
          name: 'FUNCTIONS_WORKER_RUNTIME'
          value: 'python'
        }
        {
          name: 'AzureWebJobsStorage'
          value: 'DefaultEndpointsProtocol=https;AccountName=' + storageAccount.name + ';AccountKey=' + listKeys(storageAccount.id, '2021-04-01').keys[0].value + ';EndpointSuffix=core.windows.net'
        }
        {
          name: 'APPINSIGHTS_INSTRUMENTATIONKEY'
          value: appInsights.properties.InstrumentationKey
        }
        {
          name: 'WEBSITE_RUN_FROM_PACKAGE'
          value: '1'
        }
      ]
    }
  }
  dependsOn: [storageAccount, appServicePlan, appInsights]
}

output functionAppUrl string = 'https://' + functionApp.properties.defaultHostName + '/api/Hello'
