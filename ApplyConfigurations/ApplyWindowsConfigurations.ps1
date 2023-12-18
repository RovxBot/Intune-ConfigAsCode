param (
    [string]$ApplicationConfigFile = "WindowsConfigProfiles\ApplicationConfig.json",
    [string]$OneDriveConfigFile = "WindowsConfigProfiles\OneDriveConfig.json"
)

# Function to deploy Windows Configuration Profiles in Intune
function Deploy-WindowsConfigurations {
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
        # Deploy Application Configuration Profile
        Deploy-WindowsConfigurations -ConfigPath $ApplicationConfigFile -ProfileType "Application Configuration"

        # Deploy OneDrive Configuration Profile
        Deploy-WindowsConfigurations -ConfigPath $OneDriveConfigFile -ProfileType "OneDrive"
    }
}
