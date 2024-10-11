param location string = resourceGroup().location
param storageAccountName string = 'lab01${uniqueString(resourceGroup().id)}'
param containerName string = 'profilepictures'

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

resource app_service 'Microsoft.Web/serverfarms@2023-12-01' = {
  name: 'todo-app'
  location: location
  properties: {
    
  }
}
