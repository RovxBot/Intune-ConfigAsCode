param (
    [string]$AndroidConfigFile = "DeviceCompliance\AndroidComplianceConfig.json",
    [string]$IOSConfigFile = "DeviceCompliance\IOSComplianceConfig.json",
    [string]$MacOSConfigFile = "DeviceCompliance\MacOSComplianceConfig.json",
    [string]$WindowsConfigFile = "DeviceCompliance\WindowsComplianceConfig.json"
)

# Function to apply Compliance Policies in Intune
function Apply-CompliancePolicies {
    param (
        [string]$ConfigPath,
        [string]$Platform
    )

    # Read JSON file
    $config = Get-Content $ConfigPath | ConvertFrom-Json

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

# Apply Compliance Policies only if changes detected
if ($env:GITHUB_EVENT_NAME -eq 'push') {
    if (git diff --name-only $env:GITHUB_SHA^..$env:GITHUB_SHA -Intersect $AndroidConfigFile, $IOSConfigFile, $MacOSConfigFile, $WindowsConfigFile) {
        # Apply Compliance Policies for Android
        Apply-CompliancePolicies -ConfigPath $AndroidConfigFile -Platform "Android"

        # Apply Compliance Policies for iOS
        Apply-CompliancePolicies -ConfigPath $IOSConfigFile -Platform "iOS"

        # Apply Compliance Policies for macOS
        Apply-CompliancePolicies -ConfigPath $MacOSConfigFile -Platform "macOS"

        # Apply Compliance Policies for Windows
        Apply-CompliancePolicies -ConfigPath $WindowsConfigFile -Platform "Windows"
    }
}
