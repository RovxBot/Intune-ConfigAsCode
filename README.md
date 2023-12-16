# Intune Compliance Policy Automation

![Intune Logo](https://yourimagehost.com/intune-logo.png)

Automate the configuration of device compliance policies in Microsoft Intune using PowerShell and YAML configurations.

## Table of Contents

- [Introduction](#introduction)
- [Getting Started](#getting-started)
- [Usage](#usage)
- [Configuration](#configuration)
  - [Android](#android)
  - [macOS](#macos)
  - [Windows](#windows)
  - [iOS](#ios)
- [Contributing](#contributing)
- [License](#license)

## Introduction

This project aims to simplify the management of device compliance policies in Microsoft Intune by providing PowerShell scripts and YAML configuration files. By using this automation, you can ensure that your devices meet the specified compliance requirements without manual intervention.

## Getting Started

1. **Clone the Repository:**
   ```bash
   git clone https://github.com/yourusername/Intune-Compliance-Automation.git
   cd Intune-Compliance-Automation```

## Install Required PowerShell Module:
`Install-Module -Name Microsoft.Graph.Intune -Force -Scope CurrentUser`

## Connect to Microsoft Graph:
`Import-Module Microsoft.Graph.Intune` 
`Connect-MSGraph`

## Run the Automation Script:
```.\ApplyCompliancePolicies.ps1 -AndroidConfig "AndroidComplianceConfig.yml" -MacOSConfig "MacOSComplianceConfig.yml" -WindowsConfig "WindowsComplianceConfig.yml" -iOSConfig "iOSComplianceConfig.yml"```

### Usage
Ensure you have the required permissions and Microsoft Intune access to apply compliance policies. Customize the YAML configuration files to match your organization's compliance requirements.

### Configuration
## Android
Minimum OS Version: 9.0
Maximum Failed Login Attempts: 5
Require Password: true
...

## macOS
Minimum OS Version: 10.14
Require FileVault: true
...

## Windows
Minimum OS Version: 10.0
Require BitLocker: true
...

## iOS
Minimum OS Version: 12.0
Require Passcode: true
...

## Contributing
Contributions are welcome! Please check the Contribution Guidelines for details on how to contribute to this project.

## License
This project is licensed under the MIT License.