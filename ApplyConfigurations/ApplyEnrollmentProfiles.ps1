param (
    [string]$UserDrivenConfigFile = "Enrollment\UserDrivenAutopilotConfig.yml",
    [string]$CompanyOwnedMacOSConfigFile = "Enrollment\CompanyOwnedMacOSAutopilotConfig.yml",
    [string]$CompanyOwnedAndroidConfigFile = "Enrollment\CompanyOwnedAndroidAutopilotConfig.yml",
    [string]$CompanyOwnedIOSConfigFile = "Enrollment\CompanyOwnedIOSAutopilotConfig.yml"
)

# Function to apply Enrollment Profiles in Intune
function Apply-EnrollmentProfiles {
    param (
        [string]$ConfigPath,
        [string]$ProfileType
    )

    # Read YAML file
    $config = Get-Content $ConfigPath | ConvertFrom-Yaml

    # Define the API endpoint for Autopilot profiles in Intune
    $intuneApiEndpoint = "https://graph.microsoft.com/v1.0/deviceManagement/autopilotProfiles"

    # Apply Autopilot profile
    Invoke-RestMethod -Uri $intuneApiEndpoint -Method Post -Headers (Connect-Intune) -Body ($config | ConvertTo-Json)
    Write-Output "Enrollment Profile applied for $ProfileType."
}

# Apply Enrollment Profiles only if changes detected
if ($env:GITHUB_EVENT_NAME -eq 'push') {
    if (git diff --name-only $env:GITHUB_SHA^..$env:GITHUB_SHA -Intersect $UserDrivenConfigFile, $CompanyOwnedMacOSConfigFile, $CompanyOwnedAndroidConfigFile, $CompanyOwnedIOSConfigFile) {
        # Apply Autopilot Profiles
        Apply-EnrollmentProfiles -ConfigPath $UserDrivenConfigFile -ProfileType "User-Driven"
        Apply-EnrollmentProfiles -ConfigPath $CompanyOwnedMacOSConfigFile -ProfileType "Company-Owned macOS"
        Apply-EnrollmentProfiles -ConfigPath $CompanyOwnedAndroidConfigFile -ProfileType "Company-Owned Android"
        Apply-EnrollmentProfiles -ConfigPath $CompanyOwnedIOSConfigFile -ProfileType "Company-Owned iOS"
    }
}
