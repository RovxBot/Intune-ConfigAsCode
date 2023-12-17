param (
    [string]$AndroidConfigFile = "AndroidComplianceConfig.yml",
    [string]$IOSConfigFile = "IOSComplianceConfig.yml",
    [string]$MacOSConfigFile = "MacOSComplianceConfig.yml",
    [string]$WindowsConfigFile = "WindowsComplianceConfig.yml"
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

# Function to apply Compliance Policies in Intune
function Apply-CompliancePolicies {
    param (
        [string]$ConfigPath,
        [string]$Platform
    )

    # Read YAML file
    $config = Get-Content $ConfigPath | ConvertFrom-Yaml

    # Define the API endpoint for compliance policies in Intune
    $intuneApiEndpoint = "https://graph.microsoft.com/v1.0/deviceManagement/managedDevice/deviceCompliancePolicies"

    # Iterate through compliance policy settings and send them to Intune
    foreach ($setting in $config.deviceCompliancePolicy.settings) {
        $body = @{
            settingName = $setting.settingName
            value       = $setting.value
        }

        # Send the compliance policy to Intune
        Invoke-RestMethod -Uri $intuneApiEndpoint -Method Post -Headers (Connect-Intune) -Body ($body | ConvertTo-Json)
        Write-Output "Compliance Policy setting $($setting.settingName) applied for $Platform."
    }

    Write-Output "Intune Compliance Policies applied for $Platform."
}

# Apply Compliance Policies for Android
Apply-CompliancePolicies -ConfigPath $AndroidConfigFile -Platform "Android"

# Apply Compliance Policies for iOS
Apply-CompliancePolicies -ConfigPath $IOSConfigFile -Platform "iOS"

# Apply Compliance Policies for macOS
Apply-CompliancePolicies -ConfigPath $MacOSConfigFile -Platform "macOS"

# Apply Compliance Policies for Windows
Apply-CompliancePolicies -ConfigPath $WindowsConfigFile -Platform "Windows"
