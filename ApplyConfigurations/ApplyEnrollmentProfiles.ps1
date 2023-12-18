param (
    [string]$UserDrivenConfigFile = "Enrollment\StandardAutopilot.json",
    [string]$CompanyOwnedMacOSConfigFile = "Enrollment\MacOSEnrollment.json",
    [string]$CompanyOwnedAndroidConfigFile = "Enrollment\AndroidEnrollment.json",
    [string]$CompanyOwnedIOSConfigFile = "Enrollment\IOSEnrollment.json"
)

# Function to apply Enrollment Profiles in Intune
function Apply-EnrollmentProfiles {
    param (
        [string]$ConfigPath,
        [string]$ProfileType
    )

    # Read JSON file
    $config = Get-Content $ConfigPath | ConvertFrom-Json

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
        Apply-EnrollmentProfiles -ConfigPath $UserDrivenConfigFile -ProfileType "User-Driven Autopilot"
        Apply-EnrollmentProfiles -ConfigPath $CompanyOwnedMacOSConfigFile -ProfileType "Company-Owned macOS"
        Apply-EnrollmentProfiles -ConfigPath $CompanyOwnedAndroidConfigFile -ProfileType "Company-Owned Android"
        Apply-EnrollmentProfiles -ConfigPath $CompanyOwnedIOSConfigFile -ProfileType "Company-Owned iOS"
    }
}
