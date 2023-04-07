data "azurerm_resource_group" "udacity_app" {
  name     = "Regroup_4rPTYYAclOap_"
}

resource "azurerm_container_group" "udacity_app" {
  name                = "udacity-melsheikh-azure-continst"
  location            = data.azurerm_resource_group.udacity_app.location
  resource_group_name = data.azurerm_resource_group.udacity_app.name
  ip_address_type     = "Public"
  dns_name_label      = "udacity-melsheikh-azure"
  os_type             = "Linux"

  container {
    name   = "udacity-melsheikh-azure-container-app"
    image  = "docker.io/tscotto5/azure_app:1.0"
    cpu    = "0.5"
    memory = "1.5"
    environment_variables = {
      "AWS_S3_BUCKET"       = "udacity-melsheikh-aws-s3-bucket",
      "AWS_DYNAMO_INSTANCE" = "udacity-melsheikh-aws-dynamodb"
    }
    ports {
      port     = 3000
      protocol = "TCP"
    }
  }
  tags = {
    environment = "staging"
  }
}

resource "azurerm_mssql_server" "udacity_app" {
  name                         = "udacity-melsheikh-azure-sql"
  resource_group_name          = data.azurerm_resource_group.udacity_app.name
  location                     = data.azurerm_resource_group.udacity_app.location
  version                      = "12.0"
  administrator_login          = "mc-admin"
  administrator_login_password = "p@$$w0rD@123"
  minimum_tls_version          = "1.2"

  tags = {
    environment = "staging"
  }
}

resource "azurerm_service_plan" "udacity_app" {
  name                = "udacity-melsheikh-azure-service-plan"
  resource_group_name = data.azurerm_resource_group.udacity_app.name
  location            = data.azurerm_resource_group.udacity_app.location
  os_type             = "Linux"
  sku_name            = "P1v2"
}

resource "azurerm_linux_web_app" "udacity_app" {
  name                = "udacity-melsheikh-azure-dotnet-app"
  resource_group_name = data.azurerm_resource_group.udacity_app.name
  location            = azurerm_service_plan.udacity_app.location
  service_plan_id     = azurerm_service_plan.udacity_app.id

  site_config {}
}
