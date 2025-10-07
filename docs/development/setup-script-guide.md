# Setup Script Guide

The `setup.sh` script is a comprehensive automation tool that handles project setup, customization, and Node.js version management for the generic framework.

## 🚀 Quick Start

```bash
# Run complete setup and customization
./setup.sh

# Update Node.js versions only
./setup.sh --update-node

# Show help
./setup.sh --help
```

## 📋 Features

### 1. **Prerequisites Management**
- ✅ **Node.js**: Automatically detects, installs, or updates to latest LTS version
- ✅ **Flutter**: Installs and configures Flutter SDK
- ✅ **Python** (Optional): Conditionally installs if user needs it
- ✅ **Docker**: Checks Docker installation and starts services
- ✅ **Dependencies**: Installs and updates all project dependencies

### 2. **Node.js Version Management**
The script provides comprehensive Node.js version management:

#### **Automatic Version Detection**
- Fetches latest Node.js version from official Node.js API
- Falls back to version 20 if API is unavailable
- Supports both `curl` and `wget` for version detection

#### **Smart Installation Logic**
- **Not installed**: Prompts for version (latest/specific) and installs
- **Already installed**: Asks if user wants to update to latest version
- **Version comparison**: Only updates if newer version is available

#### **Comprehensive Configuration Updates**
Updates Node.js versions in all relevant files:

**Package.json Files:**
- `package.json` (root)
- `scripts/package.json`
- `apps/backend/package.json`

**Configuration Files:**
- `.nvmrc` (creates if doesn't exist)
- `.node-version`
- `docker/Dockerfile.backend`
- GitHub Actions workflows (`.github/workflows/*.yml`)

### 3. **Project Customization**
- ✅ **Sample Code Removal**: Deletes all sample entities and controllers
- ✅ **Configuration Updates**: Updates all config files with project details
- ✅ **Documentation Updates**: Removes sample references from docs
- ✅ **Platform Configuration**: Updates Android, iOS, Web, Windows configs
- ✅ **Docker Configuration**: Updates container names and database settings
- ✅ **Business Mode Switch**: Automatically switches .cursorrules from framework mode to business mode

### 4. **Python Management (Optional)**
The script conditionally installs Python based on user needs:

#### **User Prompt**
- Asks if Python is needed for the project
- Default: No (Python not required by default)

#### **Version Options**
- **latest**: Installs latest Python 3.x
- **3.11**: Specific version
- **3.10**: Specific version  
- **3.9**: Specific version

#### **What Gets Installed**
- Python 3.x
- pip (package manager)
- python3-venv (virtual environment support)

#### **Use Cases for Python**
- Machine Learning / AI features
- Data processing scripts
- Python-based automation tools
- Scientific computing libraries

### 5. **JSON Handling**
- Uses `jq` for precise JSON manipulation (installs if missing)
- Falls back to `sed` if `jq` not available
- Handles both approaches gracefully

## 🔧 Command Line Options

### **Full Setup (Default)**
```bash
./setup.sh
```
Runs the complete setup process including:
- Prerequisites installation
- Node.js version management
- Project customization
- Dependency installation
- Database setup

### **Node.js Version Update Only**
```bash
./setup.sh --update-node
./setup.sh -n
```
Updates Node.js versions in configuration files without:
- Installing Node.js
- Running full customization
- Installing dependencies

### **Help**
```bash
./setup.sh --help
./setup.sh -h
```
Shows usage information and available options.

## 📁 Files Updated by Node.js Version Management

When the script updates Node.js versions, it modifies:

### **Package.json Files**
```json
{
  "engines": {
    "node": ">=24.0.0"
  }
}
```

### **Docker Files**
```dockerfile
FROM node:24
```

### **Version Files**
```
# .nvmrc
24

# .node-version
24
```

### **CI/CD Workflows**
```yaml
- uses: actions/setup-node@v3
  with:
    node-version: '24'
```

## 🎯 Usage Examples

### **New Project Setup**
```bash
# Clone the framework
git clone <repository-url>
cd gym-manager

# Run complete setup
./setup.sh
# Follow prompts for project details
```

### **Update Node.js Versions**
```bash
# Update to latest Node.js version in all config files
./setup.sh --update-node
```

### **Check Current Setup**
```bash
# Show help and current capabilities
./setup.sh --help
```

## 🔍 Troubleshooting

### **Node.js Installation Issues**

#### **macOS**
```bash
# If Homebrew is not installed
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

# Then run setup again
./setup.sh
```

#### **Linux**
```bash
# If curl is not available
sudo apt-get update && sudo apt-get install -y curl

# Then run setup again
./setup.sh
```

### **Permission Issues**
```bash
# Make script executable
chmod +x setup.sh

# Run with proper permissions
./setup.sh
```

### **JSON Parsing Issues**
```bash
# Install jq for better JSON handling
# macOS
brew install jq

# Linux
sudo apt-get install -y jq

# Then run setup again
./setup.sh
```

## 🚀 Business Mode Switch

### **What is Business Mode?**

The framework has two operational modes:

1. **Framework Development Mode** (Default in repository)
   - Enforces generic terminology (Entity, Tenant, User)
   - Prevents business-specific naming
   - Maintains framework purity for contributions

2. **Business Application Mode** (Activated by setup script)
   - Allows business-specific terminology
   - Enables domain-specific logic
   - Supports business customization

### **Automatic Mode Switching**

The setup script automatically switches all `.cursorrules` files to Business Mode:

**Files Modified:**
- `/.cursorrules` (root)
- `/apps/backend/.cursorrules`
- `/apps/frontend/.cursorrules` (if exists)

**What Happens:**
- Adds "BUSINESS APPLICATION MODE" header
- Comments out framework-only restrictions
- Disables generic terminology enforcement
- Allows business-specific development

**Benefits:**
- ✅ AI agent supports business development
- ✅ No more "use generic terminology" errors
- ✅ Freedom to use domain-specific names
- ✅ Can add business logic to entities

## 🎨 Customization Flow

The script follows this flow for project customization:

1. **Prerequisites Check** → Install missing tools
2. **Node.js Management** → Install/update and configure versions
3. **Flutter Setup** → Install Flutter SDK
4. **Python Setup (Optional)** → Conditionally install if needed
5. **Docker Setup** → Install and configure Docker
6. **Project Details** → Prompt for project information
7. **Sample Code Removal** → Delete framework examples
8. **Configuration Updates** → Update all config files
9. **Documentation Updates** → Remove sample references
10. **Business Mode Switch** → Enable business-specific development
11. **Dependency Management** → Install and update packages
12. **Database Setup** → Start PostgreSQL container
13. **Final Setup** → Complete project initialization

## 🔄 Version Management Details

### **Latest Version Detection**
The script fetches the latest Node.js version using:
```bash
curl -s https://nodejs.org/dist/index.json | grep -o '"version":"[^"]*' | head -1
```

### **Version Comparison**
```bash
# Current version
CURRENT=$(node --version | cut -d'v' -f2 | cut -d'.' -f1)

# Latest version
LATEST=$(get_latest_node_version)

# Only update if different
if [ "$LATEST" != "$CURRENT" ]; then
    # Update logic
fi
```

### **Cross-Platform Support**
- **macOS**: Uses Homebrew for installation
- **Linux**: Uses NodeSource repository
- **Error handling**: Graceful fallbacks for unsupported OS

## 📊 Benefits

✅ **Always Up-to-Date**: Uses latest Node.js version by default  
✅ **User Choice**: Can specify exact version or use latest  
✅ **Comprehensive**: Updates all relevant configuration files  
✅ **Safe**: Only updates if newer version available  
✅ **Flexible**: Can update configs without reinstalling Node.js  
✅ **Cross-Platform**: Works on macOS and Linux  
✅ **Automated**: Handles entire project setup process  
✅ **Consistent**: Ensures all config files use same Node.js version  
✅ **Business-Ready**: Automatically switches from framework to business mode  
✅ **AI-Friendly**: AI agent supports business development after setup  

## 🔗 Related Documentation

- [Development Setup](development-setup.md) - Complete development environment setup
- [Project Customization Checklist](project-customization-checklist.md) - Manual customization guide
- [Framework Customization Checklist](framework-customization-checklist.md) - What to update/delete
- [Testing Guide](../testing/testing-guide.md) - Testing setup and configuration
