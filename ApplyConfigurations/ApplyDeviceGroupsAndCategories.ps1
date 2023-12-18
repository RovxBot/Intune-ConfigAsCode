param (
    [string]$DeviceCategoriesConfigFile = "DeviceGroups\DeviceCategories.json",
    [string]$DynamicDeviceGroupsConfigFile = "DeviceGroups\DynamicDeviceGroups.json"
)

# Function to deploy Device Categories in Intune
function Deploy-DeviceCategories {
    param (
        [string]$ConfigPath
    )

    # Read JSON file
    $config = Get-Content $ConfigPath | ConvertFrom-Json

    # Define the API endpoint for Device Categories in Intune
    $intuneApiEndpoint = "https://graph.microsoft.com/v1.0/deviceManagement/deviceCategories"

    # Deploy Device Categories
    foreach ($category in $config.deviceCategories) {
        Invoke-RestMethod -Uri $intuneApiEndpoint -Method Post -Headers (Connect-Intune) -Body ($category | ConvertTo-Json)
        Write-Output "Device Category deployed: $($category.displayName)"
    }
}

# Function to deploy Dynamic Device Groups in Intune
function Deploy-DynamicDeviceGroups {
    param (
        [string]$ConfigPath
    )

    # Read JSON file
    $config = Get-Content $ConfigPath | ConvertFrom-Json

    # Define the API endpoint for Dynamic Device Groups in Intune
    $intuneApiEndpoint = "https://graph.microsoft.com/v1.0/deviceManagement/dynamicDeviceGroups"

    # Deploy Dynamic Device Groups
    foreach ($group in $config.dynamicDeviceGroups) {
        Invoke-RestMethod -Uri $intuneApiEndpoint -Method Post -Headers (Connect-Intune) -Body ($group | ConvertTo-Json)
        Write-Output "Dynamic Device Group deployed: $($group.displayName)"
    }
}

# Deploy Device Categories and Dynamic Device Groups only if changes detected
if ($env:GITHUB_EVENT_NAME -eq 'push') {
    if (git diff --name-only $env:GITHUB_SHA^..$env:GITHUB_SHA -Intersect $DeviceCategoriesConfigFile, $DynamicDeviceGroupsConfigFile) {
        # Deploy Device Categories
        Deploy-DeviceCategories -ConfigPath $DeviceCategoriesConfigFile

        # Deploy Dynamic Device Groups
        Deploy-DynamicDeviceGroups -ConfigPath $DynamicDeviceGroupsConfigFile
    }
}
