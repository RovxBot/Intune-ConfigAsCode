param (
    [string]$WindowsAppConfigFile = "WindowsConfigProfiles\WindowsAppConfig.yml",
    [string]$WindowsNetworkConfigFile = "WindowsConfigProfiles\WindowsNetworkConfig.yml",
    [string]$WindowsSecurityConfigFile = "WindowsConfigProfiles\WindowsSecurityConfig.yml",
    [string]$OneDriveSigninAndSyncFile = "WindowsConfigProfiles\OneDriveSigninAndSync.yml"
)

# Replace the following placeholders with actual values
$intuneAppId = "your-intune-app-id"
$intuneTenantId = "your-intune-tenant-id"
$intuneSecret = "your-intune-secret"
$intuneDeviceManagementId = "your-device-management-id"

# Function to authenticate with Microsoft Graph
function Connect-Intune {
    $body = @{
        grant_type    = "client_credentials"
        client_id     = $intuneAppId
        client_secret = $intuneSecret
        resource      = "https://graph.microsoft.com"
    }

    $tokenEndpoint = "https://login.microsoftonline.com/$intuneTenantId/oauth2/token"
    $tokenResponse = Invoke-RestMethod -Uri $tokenEndpoint -Method Post -Body $body

    $headers = @{
        Authorization = "Bearer $($tokenResponse.access_token)"
    }

    $headers
}

# Function to apply Configuration Policies in Intune
function Apply-ConfigurationPolicies {
    param (
        [string]$ConfigPath,
        [string]$PolicyType
    )

    # Read YAML file
    $config = Get-Content $ConfigPath | ConvertFrom-Yaml

    # Define the API endpoint for configuration policies in Intune
    $intuneApiEndpoint = "https://graph.microsoft.com/v1.0/deviceManagement/managedDevice/deviceConfiguration"

    # Iterate through configuration settings and send them to Intune
    foreach ($setting in $config.deviceConfiguration.settings) {
        $body = @{
            settingName = $setting.settingName
            value       = $setting.value
        }

        # Send the configuration to Intune
        Invoke-RestMethod -Uri $intuneApiEndpoint -Method Post -Headers (Connect-Intune) -Body ($body | ConvertTo-Json)
        Write-Output "$PolicyType setting $($setting.settingName) applied."
    }

    Write-Output "Intune $PolicyType Configuration Policies applied."
}

# Apply Windows App Configuration Policies
Apply-ConfigurationPolicies -ConfigPath $WindowsAppConfigFile -PolicyType "Windows App"

# Apply Windows Network Configuration Policies
Apply-ConfigurationPolicies -ConfigPath $WindowsNetworkConfigFile -PolicyType "Windows Network"

# Apply Windows Security Configuration Policies
Apply-ConfigurationPolicies -ConfigPath $WindowsSecurityConfigFile -PolicyType "Windows Security"

# Apply OneDrive Configuration Policy
Apply-ConfigurationPolicies -ConfigPath $OneDriveSigninAndSyncFile -PolicyType "OneDrive Policy"