param environment string = split(resourceGroup().name, '-')[1]

param location string = resourceGroup().location
param storageAccountName string = 'counterappstorageacc${environment}'
param containerName string = 'storage${environment}'

resource storage 'Microsoft.Storage/storageAccounts@2023-05-01' = {
  name: storageAccountName
  location: location
  sku: {
    name: 'Standard_RAGRS'
  }
  kind: 'StorageV2'
  properties: { accessTier: 'Hot' }
  resource container1 'blobServices' = {
    name: 'default'
    resource profilepictures 'containers' = {
      name: containerName
    }
  }
}

var config = {
  dev: {
    name: 'S1'
    tier: 'Standard'
  }
  prod: {
    name: 'B1'
    tier: 'Basic'
  }
}

resource app_service_plan 'Microsoft.Web/serverfarms@2023-12-01' = {
  name: 'todo-app-${environment}'
  location: location
  sku: config[environment]
}

resource app_service 'Microsoft.Web/sites@2023-12-01' = {
  name: 'todo-app-site-${environment}'
  location: location
  properties: {
    serverFarmId: app_service_plan.id
  }
  resource app_settings 'config' = {
    name: 'appsettings'
    properties: {
      WEBSITE_RUN_FROM_PACKAGE: '1'
    }
  }
}
