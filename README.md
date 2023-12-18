# 🚀 Intune Automation with GitHub Actions

![Intune Logo](https://github.com/RovxBot/Intune-ConfigAsCode/blob/main/Images/_a1fb46ba-043d-484e-beb7-d8edc7036886.jpeg)

Automate the configuration of device compliance policies and Windows configuration profiles in Microsoft Intune using GitHub Actions, PowerShell, and JSON configurations.

## Table of Contents

- [👋 Introduction](#introduction)
- [🚀 Getting Started](#getting-started)
- [⚙️ GitHub Actions Workflow](#github-actions-workflow)
- [🛠️ Configuration](#configuration)
  - [📱 Device Compliance Policies](#device-compliance-policies)
    - [Android](#android)
    - [macOS](#macos)
    - [Windows](#windows)
    - [iOS](#ios)
  - [💻 Windows Configuration Profiles](#windows-configuration-profiles)
    - [Windows App](#windows-app)
    - [Windows Network](#windows-network)
    - [Windows Security](#windows-security)
- [🤝 Contributing](#contributing)
- [📄 License](#license)

## 👋 Introduction

This project aims to simplify the management of device profiles in Microsoft Intune using GitHub Actions. By using automation, and DevOps practices.

In the long term I hope I can get this project to a point that it can be used to jumpstart a fresh enviroment to the point it can start being used. Obviously there is an incredible amount of configuration that goes into most Intune enviroments, but my hope is that this repo can give organisations the boost that it needs to enter into the world of cloud management.

## 🚀 Getting Started

1. **Clone the Repository:**
   ```bash
   git clone https://github.com/RovxBot/Intune-ConfigAsCode.git
   cd Intune-ConfigAsCode```

2. **Secrets:**
The majority of these profiles will require you to enter secrets of some kind. Please use Keyvault or GitHub Actions and secrets, and dont enter secrests in plain text.

### ⚙️ GitHub Actions Workflow
This project leverages GitHub Actions workflows for automated deployment. The workflow is triggered on each push to the main branch.

## 🛠️ Configuration

### 📱 Device Compliance Policies

#### Android
![Android](https://github.com/RovxBot/Intune-ConfigAsCode/blob/main/Images/_50291bf9-05e9-4e71-a7c5-aa8872105617.jpeg)
- Minimum OS Version: GreaterThan 9.0
- Maximum Failed Login Attempts: LessThan 5
- Require Password: Equals true
- Password Expiration Days: GreaterThan 0
- Password Minimum Length: GreaterThan 8
- Require Encryption: Equals true
- Device Threat Level: Equals "Low"
- Device Health Attestation State: Equals "Healthy"
- Require Approved System Apps: Equals true
- Minimum Security Patch Level: GreaterThan "2021-01-01"

#### macOS
- Minimum OS Version: GreaterThan 10.14
- Require FileVault: Equals true
- Require Firewall: Equals true
- Require Antivirus: Equals true
- Minimum Free Disk Space (GB): GreaterThan 10
- Require Strong Password: Equals true
- Maximum Inactivity Time (minutes): LessThan 30

#### Windows
![Windows](https://github.com/RovxBot/Intune-ConfigAsCode/blob/main/Images/_fc90c5ba-2cbf-4ce9-a629-1cede219a1ad.jpeg)
- Minimum OS Version: GreaterThan 10.0
- Require BitLocker: Equals true
- Require Antivirus: Equals true
- Minimum Free Disk Space (GB): GreaterThan 20
- Minimum Memory (MB): GreaterThan 4096
- Maximum Inactivity Time (minutes): LessThan 15
- Minimum CPU Speed (MHz): GreaterThan 2000
- Require Strong Password: Equals true
- Require Firewall: Equals true

#### iOS
- Minimum OS Version: GreaterThan 12.0
- Require Passcode: Equals true
- Minimum Passcode Length: GreaterThan 6
- Passcode Expiration Days: GreaterThan 7
- Maximum Failed Passcode Attempts: LessThan 5
- Device Threat Level: Equals "Low"
- Require Encrypted Backup: Equals true

### 💻 Windows Configuration Profiles

#### Windows App
- Install Office 365:
- Disable Unnecessary Apps: Cortana, Xbox
- Configure Default Browser: Microsoft Edge

#### Windows Network
- Set DNS Servers: 192.168.1.1, 8.8.8.8
- Enable Wi-Fi
- Configure Proxy Settings: "http://proxy.example.com:8080"

#### Windows Security
- Enforce BitLocker:
- Require Antivirus:
- Minimum Password Length: 8
- Password Expiration Days: 90

## 🤝 Contributing
Contributions are welcome! I would love input on configurations that others use in their enviroments. The Idea is to get this repo to a point that can be set and deployed to a fresh enviremont and be ready to start using.

## 📄 License
This project is licensed under the MIT License.
