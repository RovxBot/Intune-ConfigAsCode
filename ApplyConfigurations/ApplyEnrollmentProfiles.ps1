param (
    [string]$AutopilotConfigFile = "Enrollment\StandardAutopilot.yml"
)

# Replace the following placeholders with actual values
$intuneAppId = "your-intune-app-id"
$intuneTenantId = "your-intune-tenant-id"
$intuneSecret = "your-intune-secret"

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

# Function to apply Autopilot Profiles in Intune
function Apply-AutopilotProfiles {
    param (
        [string]$ConfigPath
    )

    # Read YAML file
    $config = Get-Content $ConfigPath | ConvertFrom-Yaml

    # Define the API endpoint for Autopilot profiles in Intune
    $intuneApiEndpoint = "https://graph.microsoft.com/v1.0/deviceManagement/importedWindowsAutopilotDeviceIdentities"

    # Iterate through Autopilot profiles and send them to Intune
    foreach ($profile in $config.autopilotProfiles) {
        $body = @{
            displayName = $profile.name
            description = $profile.description
        }

        # Send the Autopilot profile to Intune
        Invoke-RestMethod -Uri $intuneApiEndpoint -Method Post -Headers (Connect-Intune) -Body ($body | ConvertTo-Json)
        Write-Output "Autopilot Profile $($profile.name) applied."
    }

    Write-Output "Intune Autopilot Profiles applied."
}

# Apply Autopilot Profiles
Apply-AutopilotProfiles -ConfigPath $AutopilotConfigFile
