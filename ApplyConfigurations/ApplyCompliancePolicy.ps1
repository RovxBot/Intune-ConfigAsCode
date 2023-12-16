# ApplyCompliancePolicies.ps1

param (
    [string]$AndroidConfig = "AndroidComplianceConfig.yml",
    [string]$MacOSConfig = "MacOSComplianceConfig.yml",
    [string]$WindowsConfig = "WindowsComplianceConfig.yml",
    [string]$iOSConfig = "iOSComplianceConfig.yml"
)

# Install required module if not already installed
if (-not (Get-Module -Name Microsoft.Graph.Intune -ErrorAction SilentlyContinue)) {
    Install-Module -Name Microsoft.Graph.Intune -Force -Scope CurrentUser
}

Import-Module Microsoft.Graph.Intune
Connect-MSGraph

function Apply-CompliancePolicy {
    param (
        [string]$ConfigPath,
        [string]$Platform
    )

    # Read YAML file
    $config = Get-Content $ConfigPath | ConvertFrom-Yaml

    # Create compliance policy
    $compliancePolicy = New-DeviceCompliancePolicy @($config.compliancePolicy | ConvertTo-Hashtable)

    # Create compliance settings
    foreach ($setting in $config.complianceSettings) {
        $complianceSetting = @{
            SettingName = $setting.SettingName
            DataType = $setting.DataType
            Operator = $setting.Operator
            Value = $setting.Value
        }
        $complianceSetting.DeviceCompliancePolicyId = $compliancePolicy.id
        New-DeviceComplianceSetting @complianceSetting
    }

    # Create and apply assignment
    $assignment = New-DeviceCompliancePolicyAssignment @($config.assignment | ConvertTo-Hashtable)
    Start-DeviceCompliancePolicyAssignment -DeviceCompliancePolicyId $compliancePolicy.id

    Write-Output "Applied $Platform Compliance Policy"
}

# Apply Android Compliance Policy
Apply-CompliancePolicy -ConfigPath $AndroidConfig -Platform "Android"

# Apply macOS Compliance Policy
Apply-CompliancePolicy -ConfigPath $MacOSConfig -Platform "macOS"

# Apply Windows Compliance Policy
Apply-CompliancePolicy -ConfigPath $WindowsConfig -Platform "Windows"

# Apply iOS Compliance Policy
Apply-CompliancePolicy -ConfigPath $iOSConfig -Platform "iOS"
