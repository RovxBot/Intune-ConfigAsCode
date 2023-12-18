param (
    [string]$AndroidEnterprise = "WiFiProfiles\Enterprise\AndroidEnterprise.json",
    [string]$IOSEnterprise = "WiFiProfiles\Enterprise\IOSEnterprise.json",
    [string]$MacOSEnterprise = "WiFiProfiles\Enterprise\MacOSEnterprise.json",
    [string]$WindowsEnterprise = "WiFiProfiles\Enterprise\WindowsEnterprise.json"
)

# Function to deploy Windows Configuration Profiles in Intune
function Deploy-EnterpriseWifiConfiguration {
    param (
        [string]$ConfigPath,
        [string]$ProfileType
    )

    # Read JSON file
    $config = Get-Content $ConfigPath | ConvertFrom-Json

    # Define the API endpoint for Windows Configuration Profiles in Intune
    $intuneApiEndpoint = "https://graph.microsoft.com/v1.0/deviceManagement/deviceConfigurations"

    # Deploy Windows Configuration Profile
    Invoke-RestMethod -Uri $intuneApiEndpoint -Method Post -Headers (Connect-Intune) -Body ($config.deviceConfiguration | ConvertTo-Json)
    Write-Output "Windows Configuration Profile deployed for $ProfileType."
}

# Deploy Windows Configuration Profiles only if changes detected
if ($env:GITHUB_EVENT_NAME -eq 'push') {
    if (git diff --name-only $env:GITHUB_SHA^..$env:GITHUB_SHA -Intersect $ApplicationConfigFile, $OneDriveConfigFile) {
        # Deploy Android Enterprise WiFi Configuration
        Deploy-EnterpriseWifiConfiguration -ConfigPath $AndroidEnterprise -ProfileType "Android Enterprise WiFi"

        # Deploy IOS Enterprise WiFi Configuration
        Deploy-EnterpriseWifiConfiguration -ConfigPath $IOSEnterprise -ProfileType "IOS Enterprise WiFi"

        # Deploy MacOS Enterprise WiFi Configuration
        Deploy-EnterpriseWifiConfiguration -ConfigPath $MacOSEnterprise -ProfileType "MacOS Enterprise WiFi"

        # Deploy Windows Enterprise WiFi Configuration
        Deploy-EnterpriseWifiConfiguration -ConfigPath $WindowsEnterprise -ProfileType "Windows Enterprise WiFi"
    }
}
