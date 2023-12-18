param (
    [string]$AndroidWPA2Personal = "WiFiProfiles\WPA2Personal\AndroidWPA2Personal.json",
    [string]$IOSWPA2Personal = "WiFiProfiles\WPA2Personal\IOSWPA2Personal.json",
    [string]$MacOSWPA2Personal = "WiFiProfiles\WPA2Personal\MacOSWPA2Personal.json",
    [string]$WindowsWPA2Personal = "WiFiProfiles\WPA2Personal\WindowsWPA2Personal.json"
)

# Function to deploy Windows Configuration Profiles in Intune
function Deploy-WPA2PersonalWifiConfiguration {
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
        Deploy-WPA2PersonalWifiConfiguration -ConfigPath $AndroidWPA2Personal -ProfileType "Android WPA2 WiFi"

        # Deploy IOS Enterprise WiFi Configuration
        Deploy-WPA2PersonalWifiConfiguration -ConfigPath $IOSWPA2Personal -ProfileType "IOS WPA2 WiFi"

        # Deploy MacOS Enterprise WiFi Configuration
        Deploy-WPA2PersonalWifiConfiguration -ConfigPath $MacOSWPA2Personal -ProfileType "MacOS WPA2 WiFi"

        # Deploy Windows Enterprise WiFi Configuration
        Deploy-WPA2PersonalWifiConfiguration -ConfigPath $WindowsWPA2Personal -ProfileType "Windows WPA2 WiFi"
    }
}
