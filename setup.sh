#!/bin/bash

# SaaS Framework Setup Script
# This script sets up the SaaS framework for a new project

set -e

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
PURPLE='\033[0;35m'
CYAN='\033[0;36m'
NC='\033[0m' # No Color

# Function to print colored output
print_header() {
    echo -e "${BLUE}================================${NC}"
    echo -e "${BLUE}$1${NC}"
    echo -e "${BLUE}================================${NC}"
}

print_status() {
    echo -e "${CYAN}[INFO]${NC} $1"
}

print_success() {
    echo -e "${GREEN}[SUCCESS]${NC} $1"
}

print_warning() {
    echo -e "${YELLOW}[WARNING]${NC} $1"
}

print_error() {
    echo -e "${RED}[ERROR]${NC} $1"
}

print_step() {
    echo -e "${PURPLE}[STEP]${NC} $1"
}

# Function to prompt for input
prompt_input() {
    local prompt="$1"
    local default="$2"
    local var_name="$3"
    
    if [ -n "$default" ]; then
        read -p "$prompt [$default]: " input
        eval "$var_name=\${input:-$default}"
    else
        read -p "$prompt: " input
        eval "$var_name=\"$input\""
    fi
}

# Function to check if command exists
command_exists() {
    command -v "$1" >/dev/null 2>&1
}

# Function to install Node.js
# Function to check and install jq if needed
check_jq() {
    if ! command_exists jq; then
        print_warning "jq is not installed. Installing jq for better JSON handling..."
        if [[ "$OSTYPE" == "darwin"* ]]; then
            # macOS
            if command_exists brew; then
                brew install jq
            else
                print_warning "Homebrew not found. jq installation skipped. Using sed fallback."
            fi
        elif [[ "$OSTYPE" == "linux-gnu"* ]]; then
            # Linux
            sudo apt-get update && sudo apt-get install -y jq
        else
            print_warning "Unsupported OS. jq installation skipped. Using sed fallback."
        fi
    fi
}

# Function to check Docker
check_docker() {
    if command_exists docker; then
        print_success "Docker is available"
        return 0
    else
        print_warning "Docker is not installed."
        return 1
    fi
}

# Function to install Docker (Linux only)
install_docker() {
    if [[ "$OSTYPE" == "linux-gnu"* ]]; then
        print_status "Installing Docker on Linux..."
        sudo apt-get update
        sudo apt-get install -y docker.io
        sudo systemctl start docker
        sudo systemctl enable docker
        sudo usermod -aG docker $USER
        print_success "Docker installed successfully"
        print_warning "Please log out and log back in for Docker group permissions to take effect."
        return 0
    else
        print_error "Docker installation is only supported on Linux via this script."
        print_status "For macOS, please install Docker Desktop from https://docker.com"
        return 1
    fi
}

# Function to install Docker Compose
install_docker_compose() {
    print_status "Installing Docker Compose..."
    
    # First check if Docker is installed
    if ! check_docker; then
        print_error "Docker is required for Docker Compose but is not installed."
        print_status "Please install Docker first:"
        print_status "  - macOS: Install Docker Desktop from https://docker.com"
        print_status "  - Linux: sudo apt-get install docker.io"
        return 1
    fi
    
    if [[ "$OSTYPE" == "darwin"* ]]; then
        # macOS
        if command_exists brew; then
            print_status "Installing Docker Compose via Homebrew..."
            brew install docker-compose
        else
            print_error "Homebrew not found. Please install Docker Desktop from https://docker.com"
            return 1
        fi
    elif [[ "$OSTYPE" == "linux-gnu"* ]]; then
        # Linux
        print_status "Installing Docker Compose plugin..."
        sudo apt-get update
        sudo apt-get install -y docker-compose-plugin
        
        # Also try to install standalone docker-compose as fallback
        if ! command_exists docker-compose; then
            print_status "Installing standalone docker-compose..."
            sudo curl -L "https://github.com/docker/compose/releases/latest/download/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
            sudo chmod +x /usr/local/bin/docker-compose
        fi
    else
        print_error "Unsupported OS. Please install Docker Compose manually."
        return 1
    fi
}

# Function to check Docker Compose
check_docker_compose() {
    if command_exists docker-compose; then
        print_success "Docker Compose is available"
        return 0
    elif command_exists docker && docker compose version >/dev/null 2>&1; then
        print_success "Docker Compose (plugin) is available"
        return 0
    else
        print_warning "Docker Compose is not installed or not available."
        return 1
    fi
}

# Function to get Docker Compose command
get_docker_compose_cmd() {
    if command_exists docker-compose; then
        echo "docker-compose"
    elif command_exists docker && docker compose version >/dev/null 2>&1; then
        echo "docker compose"
    else
        echo ""
    fi
}

# Function to get latest Node.js version
get_latest_node_version() {
    print_status "Fetching latest Node.js version..." >&2
    local latest_version
    if command_exists curl; then
        latest_version=$(curl -s https://nodejs.org/dist/index.json | grep -o '"version":"[^"]*' | head -1 | cut -d'"' -f4 | cut -d'v' -f2 | cut -d'.' -f1)
    elif command_exists wget; then
        latest_version=$(wget -qO- https://nodejs.org/dist/index.json | grep -o '"version":"[^"]*' | head -1 | cut -d'"' -f4 | cut -d'v' -f2 | cut -d'.' -f1)
    else
        print_warning "Cannot fetch latest version. Using fallback version 20" >&2
        latest_version="20"
    fi
    
    if [ -z "$latest_version" ] || [ "$latest_version" = "null" ]; then
        print_warning "Failed to fetch latest version. Using fallback version 20" >&2
        latest_version="20"
    fi
    
    echo "$latest_version"
}

# Function to check if nvm is installed
check_nvm() {
    if command_exists nvm; then
        return 0
    elif [ -s "$HOME/.nvm/nvm.sh" ]; then
        # Load nvm if it exists but isn't in PATH
        source "$HOME/.nvm/nvm.sh"
        return 0
    else
        return 1
    fi
}

# Function to install nvm
install_nvm() {
    print_status "Installing nvm (Node Version Manager)..."
    
    if curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.0/install.sh | bash; then
        # Load nvm in current shell
        export NVM_DIR="$HOME/.nvm"
        [ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"
        [ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"
        
        print_success "nvm installed successfully"
        print_warning "Please restart your terminal or run: source ~/.bashrc"
        return 0
    else
        print_error "Failed to install nvm"
        return 1
    fi
}

# Function to install Node.js using nvm
install_nodejs_with_nvm() {
    local version="$1"
    print_status "Installing Node.js $version using nvm..."
    
    if ! check_nvm; then
        print_warning "nvm is not installed. Installing nvm first..."
        if ! install_nvm; then
            print_error "Failed to install nvm"
            return 1
        fi
    fi
    
    # Load nvm
    export NVM_DIR="$HOME/.nvm"
    [ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"
    
    # Install the specified Node.js version
    if nvm install "$version"; then
        nvm use "$version"
        nvm alias default "$version"
        print_success "Node.js $version installed and set as default"
        return 0
    else
        print_error "Failed to install Node.js $version using nvm"
        return 1
    fi
}

# Function to install Node.js (fallback method)
install_nodejs_fallback() {
    local version="$1"
    print_status "Installing Node.js $version (fallback method)..."
    
    if [[ "$OSTYPE" == "darwin"* ]]; then
        # macOS
        if command_exists brew; then
            # Check if node@$version is available, otherwise install latest node
            if brew list --formula | grep -q "node@$version"; then
                brew install node@$version
            else
                print_warning "node@$version not available via Homebrew. Installing latest node instead."
                brew install node
            fi
        else
            print_error "Homebrew not found. Please install Homebrew first or install Node.js manually."
            return 1
        fi
    elif [[ "$OSTYPE" == "linux-gnu"* ]]; then
        # Linux
        curl -fsSL https://deb.nodesource.com/setup_${version}.x | sudo -E bash -
        sudo apt-get install -y nodejs
    else
        print_error "Unsupported OS. Please install Node.js manually."
        return 1
    fi
}

# Function to update Node.js version in package.json files
update_node_version_in_package_json() {
    local version="$1"
    local min_version="$2"
    
    print_status "Updating Node.js version requirements in package.json files..."
    
    # Update root package.json
    if [ -f "package.json" ]; then
        print_status "Updating root package.json..."
        if command_exists jq; then
            # Use jq if available for precise JSON manipulation
            jq ".engines.node = \">=${min_version}.0.0\"" package.json > package.json.tmp && mv package.json.tmp package.json
        else
            # Fallback to sed for basic replacement
            sed -i.bak "s/\"node\": \">=[0-9]*\\.0\\.0\"/\"node\": \">=${min_version}.0.0\"/g" package.json
            rm -f package.json.bak
        fi
        print_success "Updated root package.json with Node.js >=${min_version}.0.0"
    fi
    
    # Update scripts/package.json
    if [ -f "scripts/package.json" ]; then
        print_status "Updating scripts/package.json..."
        if command_exists jq; then
            jq ".engines.node = \">=${min_version}.0.0\"" scripts/package.json > scripts/package.json.tmp && mv scripts/package.json.tmp scripts/package.json
        else
            sed -i.bak "s/\"node\": \">=[0-9]*\\.0\\.0\"/\"node\": \">=${min_version}.0.0\"/g" scripts/package.json
            rm -f scripts/package.json.bak
        fi
        print_success "Updated scripts/package.json with Node.js >=${min_version}.0.0"
    fi
    
    # Update backend package.json
    if [ -f "apps/backend/package.json" ]; then
        print_status "Updating backend package.json..."
        if command_exists jq; then
            jq ".engines.node = \">=${min_version}.0.0\"" apps/backend/package.json > apps/backend/package.json.tmp && mv apps/backend/package.json.tmp apps/backend/package.json
        else
            sed -i.bak "s/\"node\": \">=[0-9]*\\.0\\.0\"/\"node\": \">=${min_version}.0.0\"/g" apps/backend/package.json
            rm -f apps/backend/package.json.bak
        fi
        print_success "Updated backend package.json with Node.js >=${min_version}.0.0"
    fi
}

# Function to update Node.js version in other configuration files
update_node_version_in_config_files() {
    local version="$1"
    
    print_status "Updating Node.js version in configuration files..."
    
    # Update .nvmrc if it exists
    if [ -f ".nvmrc" ]; then
        echo "$version" > .nvmrc
        print_success "Updated .nvmrc with Node.js $version"
    fi
    
    # Create .nvmrc if it doesn't exist
    if [ ! -f ".nvmrc" ]; then
        echo "$version" > .nvmrc
        print_success "Created .nvmrc with Node.js $version"
    fi
    
    # Update .node-version if it exists
    if [ -f ".node-version" ]; then
        echo "$version" > .node-version
        print_success "Updated .node-version with Node.js $version"
    fi
    
    # Update Docker files
    if [ -f "docker/Dockerfile.backend" ]; then
        print_status "Updating Docker backend file..."
        sed -i.bak "s/FROM node:[0-9]*/FROM node:$version/g" docker/Dockerfile.backend
        rm -f docker/Dockerfile.backend.bak
        print_success "Updated docker/Dockerfile.backend with Node.js $version"
    fi
    
    # Update any GitHub Actions workflows
    if [ -d ".github/workflows" ]; then
        print_status "Updating GitHub Actions workflows..."
        find .github/workflows -name "*.yml" -o -name "*.yaml" | while read -r file; do
            if grep -q "node-version:" "$file"; then
                sed -i.bak "s/node-version: '[0-9]*'/node-version: '$version'/g" "$file"
                rm -f "$file.bak"
                print_success "Updated $file with Node.js $version"
            fi
        done
    fi
}

# Function to update Node.js versions only (without installation)
update_node_versions_only() {
    print_header "Node.js Version Update"
    
    if ! command_exists node; then
        print_error "Node.js is not installed. Please install Node.js first."
        exit 1
    fi
    
    CURRENT_NODE_VERSION=$(node --version | cut -d'v' -f2 | cut -d'.' -f1)
    print_status "Current Node.js version: $CURRENT_NODE_VERSION"
    
    prompt_input "Do you want to change the Node.js version? (y/n)" "n" CHANGE_NODE
    if [ "$CHANGE_NODE" = "y" ] || [ "$CHANGE_NODE" = "Y" ] || [ "$CHANGE_NODE" = "yes" ]; then
        prompt_input "What Node.js version do you want? (22/latest/specific version)" "latest" NEW_NODE_VERSION
        if [ "$NEW_NODE_VERSION" = "latest" ]; then
            NEW_NODE_VERSION=$(get_latest_node_version)
            print_status "Latest Node.js version: $NEW_NODE_VERSION"
        fi
        
        if [ "$NEW_NODE_VERSION" != "$CURRENT_NODE_VERSION" ]; then
            print_status "Updating configuration files from Node.js $CURRENT_NODE_VERSION to $NEW_NODE_VERSION"
            update_node_version_in_package_json "$NEW_NODE_VERSION" "$NEW_NODE_VERSION"
            update_node_version_in_config_files "$NEW_NODE_VERSION"
            print_success "Configuration files updated to Node.js $NEW_NODE_VERSION"
            print_warning "Note: You still need to install Node.js $NEW_NODE_VERSION manually"
        else
            print_success "Already using Node.js version $CURRENT_NODE_VERSION"
            update_node_version_in_package_json "$CURRENT_NODE_VERSION" "$CURRENT_NODE_VERSION"
            update_node_version_in_config_files "$CURRENT_NODE_VERSION"
        fi
    else
        # Update with current version
        update_node_version_in_package_json "$CURRENT_NODE_VERSION" "$CURRENT_NODE_VERSION"
        update_node_version_in_config_files "$CURRENT_NODE_VERSION"
        print_success "Configuration files updated with current Node.js version ($CURRENT_NODE_VERSION)"
    fi
}

# Function to install Flutter
install_flutter() {
    local version="$1"
    print_status "Installing Flutter $version..."
    
    # Download Flutter
    cd ~
    if [ -d "flutter" ]; then
        print_warning "Flutter directory already exists. Updating..."
        cd flutter
        git pull
    else
        git clone https://github.com/flutter/flutter.git -b $version
    fi
    
    # Add to PATH
    echo 'export PATH="$PATH:$HOME/flutter/bin"' >> ~/.bashrc
    echo 'export PATH="$PATH:$HOME/flutter/bin"' >> ~/.zshrc
    export PATH="$PATH:$HOME/flutter/bin"
    
    # Run flutter doctor
    flutter doctor
}

# Function to check Python
check_python() {
    if command_exists python3; then
        print_success "Python $(python3 --version) is installed"
        return 0
    else
        return 1
    fi
}

# Function to check pip
check_pip() {
    if command_exists pip3; then
        print_success "pip $(pip3 --version | cut -d' ' -f2) is installed"
        return 0
    else
        return 1
    fi
}

# Function to install Python
install_python() {
    local version="$1"
    print_status "Installing Python $version..."
    
    if [[ "$OSTYPE" == "darwin"* ]]; then
        # macOS
        if command_exists brew; then
            if [ "$version" = "latest" ]; then
                brew install python3
            else
                # Try to install specific version
                if brew list --formula | grep -q "python@$version"; then
                    brew install python@$version
                else
                    print_warning "Python@$version not available via Homebrew. Installing latest python3 instead."
                    brew install python3
                fi
            fi
            print_success "Python installed successfully"
        else
            print_error "Homebrew not found. Please install Homebrew first or install Python manually."
            return 1
        fi
    elif [[ "$OSTYPE" == "linux-gnu"* ]]; then
        # Linux
        sudo apt-get update
        if [ "$version" = "latest" ]; then
            sudo apt-get install -y python3 python3-pip python3-venv
        else
            sudo apt-get install -y python${version} python${version}-pip python${version}-venv
        fi
        print_success "Python installed successfully"
    else
        print_error "Unsupported OS. Please install Python manually."
        return 1
    fi
    
    # Verify pip is installed
    if ! check_pip; then
        print_status "Installing pip..."
        if [[ "$OSTYPE" == "darwin"* ]]; then
            curl https://bootstrap.pypa.io/get-pip.py -o get-pip.py
            python3 get-pip.py
            rm get-pip.py
        elif [[ "$OSTYPE" == "linux-gnu"* ]]; then
            sudo apt-get install -y python3-pip
        fi
    fi
}

# Function to install Docker
install_docker() {
    print_status "Installing Docker..."
    
    if [[ "$OSTYPE" == "darwin"* ]]; then
        # macOS
        if command_exists brew; then
            brew install --cask docker
        else
            print_error "Homebrew not found. Please install Homebrew first or install Docker manually."
            exit 1
        fi
    elif [[ "$OSTYPE" == "linux-gnu"* ]]; then
        # Linux
        curl -fsSL https://get.docker.com -o get-docker.sh
        sudo sh get-docker.sh
        sudo usermod -aG docker $USER
    else
        print_error "Unsupported OS. Please install Docker manually."
    exit 1
fi
}

# Function to check and update package versions
check_and_update_package() {
    local package_file="$1"
    local package_name="$2"
    
    if [ -f "$package_file" ]; then
        print_status "Checking $package_name dependencies..."
        
        # Check for outdated packages
        if command_exists npm; then
            cd "$(dirname "$package_file")"
            outdated=$(npm outdated --json 2>/dev/null || echo "{}")
            
            if [ "$outdated" != "{}" ]; then
                print_warning "Outdated packages found in $package_name:"
                echo "$outdated" | jq -r 'to_entries[] | "  \(.key): \(.value.current) -> \(.value.latest)"'
                
                read -p "Update outdated packages? (y/N): " update_confirm
                if [[ $update_confirm =~ ^[Yy]$ ]]; then
                    npm update
                    print_success "Updated $package_name dependencies"
                fi
            else
                print_success "$package_name dependencies are up to date"
            fi
            cd - > /dev/null
        fi
    fi
}

# Function to replace text in file
replace_in_file() {
    local file="$1"
    local old_text="$2"
    local new_text="$3"
    
    if [ -f "$file" ]; then
        sed -i.bak "s|$old_text|$new_text|g" "$file"
        rm -f "$file.bak"
        print_status "Updated $file"
    else
        print_warning "File not found: $file"
    fi
}

# Function to replace text in multiple files
replace_in_files() {
    local pattern="$1"
    local old_text="$2"
    local new_text="$3"
    
    find . -name "$pattern" -type f -exec sed -i.bak "s|$old_text|$new_text|g" {} \;
    find . -name "*.bak" -delete
    print_status "Updated files matching pattern: $pattern"
}

# Function to delete backend sample entities
delete_sample_entities_backend() {
    print_status "Deleting backend sample entities..."
    
    # List of backend sample entity files to delete
    local backend_files=(
        "apps/backend/src/core/entities/sample.entity.ts"
        "apps/backend/src/application/dto/sample-entity.dto.ts"
        "apps/backend/src/application/use-cases/sample-entity.use-case.ts"
        "apps/backend/src/infrastructure/repositories/sample-entity.repository.ts"
        "apps/backend/src/presentation/controllers/sample-entity.controller.ts"
        "apps/backend/src/presentation/modules/sample-entity.module.ts"
    )
    
    for file in "${backend_files[@]}"; do
        if [ -f "$file" ]; then
            rm -f "$file"
            print_status "Deleted $file"
        fi
    done
    
    # Remove sample entity references from app.module.ts
    if [ -f "apps/backend/src/app.module.ts" ]; then
        sed -i.bak '/SampleEntityModule/d' "apps/backend/src/app.module.ts"
        rm -f "apps/backend/src/app.module.ts.bak"
        print_status "Removed SampleEntityModule from app.module.ts"
    fi
}

# Function to delete frontend sample entities
delete_sample_entities_frontend() {
    print_status "Deleting frontend sample entities..."
    
    # List of frontend sample entity files to delete
    local frontend_files=(
        "apps/frontend/lib/features/home/domain/entities/sample_entity.dart"
        "apps/frontend/lib/features/home/data/models/sample_entity_model.dart"
        "apps/frontend/lib/features/home/data/repositories/sample_entity_repository.dart"
        "apps/frontend/lib/features/home/data/datasources/sample_entity_remote_datasource.dart"
        "apps/frontend/lib/features/home/data/datasources/sample_entity_local_datasource.dart"
        "apps/frontend/lib/features/home/data/mappers/sample_entity_mapper.dart"
        "apps/frontend/lib/features/home/domain/repositories/sample_entity_repository_interface.dart"
    )
    
    for file in "${frontend_files[@]}"; do
        if [ -f "$file" ]; then
            rm -f "$file"
            print_status "Deleted $file"
        fi
    done
}

# Function to delete sample controllers and screens
delete_sample_controllers_screens() {
    print_status "Deleting sample controllers and screens..."
    
    # List of frontend controller and screen files to delete
    local controller_files=(
        "apps/frontend/lib/features/home/presentation/controllers/home_controller.dart"
        "apps/frontend/lib/features/home/presentation/screens/home_screen.dart"
        "apps/frontend/lib/features/home/presentation/widgets/home_widgets.dart"
    )
    
    for file in "${controller_files[@]}"; do
        if [ -f "$file" ]; then
            rm -f "$file"
            print_status "Deleted $file"
        fi
    done
}

# Function to update backend configuration
update_backend_config() {
    local project_name="$1"
    local project_display_name="$2"
    local database_name="$3"
    
    print_status "Updating backend configuration..."
    
    # Update backend package.json
    replace_in_file "apps/backend/package.json" "generic-framework-backend" "${project_name}-backend"
    replace_in_file "apps/backend/package.json" "SaaS Framework Backend" "$project_display_name Backend"
    
    # Update database configuration
    if [ -f "apps/backend/src/config/database.config.ts" ]; then
        replace_in_file "apps/backend/src/config/database.config.ts" "app_database" "$database_name"
    fi
    
    # Update app configuration
    if [ -f "apps/backend/src/config/app.config.ts" ]; then
        replace_in_file "apps/backend/src/config/app.config.ts" "SaaS Framework" "$project_display_name"
    fi
    
    # Update environment files
    replace_in_file "apps/backend/env.example" "saas_framework" "$database_name"
}

# Function to update frontend configuration
update_frontend_config() {
    local project_name="$1"
    local project_display_name="$2"
    local package_name="$3"
    
    print_status "Updating frontend configuration..."
    
    # Update pubspec.yaml
    replace_in_file "apps/frontend/pubspec.yaml" "saas_framework_app" "${project_name//-/_}_app"
    replace_in_file "apps/frontend/pubspec.yaml" "SaaS Framework App" "$project_display_name App"

    replace_in_file "apps/frontend/pubspec.yaml" ""multi-tenant application" "$project_display_name Application"
    replace_in_file "apps/frontend/pubspec.yaml" ""Multi-tenant Application" "$project_display_name Application"
    
    # Update main.dart
    replace_in_file "apps/frontend/lib/main.dart" "SaaS Framework" "$project_display_name"
    
    # Update app_en.arb
    replace_in_file "apps/frontend/lib/l10n/app_en.arb" "SaaS Framework App" "$project_display_name App"
    replace_in_file "apps/frontend/lib/l10n/app_en.arb" "Multi-tenant SaaS Application Platform" "Multi-tenant Application"
    replace_in_file "apps/frontend/lib/l10n/app_en.arb" "Welcome to SaaS Framework" "Welcome to $project_display_name"
    
    # Update bootstrap.dart
    if [ -f "apps/frontend/lib/core/config/bootstrap.dart" ]; then
        replace_in_file "apps/frontend/lib/core/config/bootstrap.dart" "SaaS Framework" "$project_display_name"
    fi
}

# Function to update platform configurations
update_platform_configs() {
    local project_name="$1"
    local project_display_name="$2"
    local package_name="$3"
    
    print_status "Updating platform configurations..."
    
    # Android configuration
    if [ -f "apps/frontend/android/app/build.gradle.kts" ]; then
        replace_in_file "apps/frontend/android/app/build.gradle.kts" "com.example.saas_framework_app" "$package_name"
    fi
    
    # iOS configuration
    if [ -f "apps/frontend/ios/Runner/Info.plist" ]; then
        replace_in_file "apps/frontend/ios/Runner/Info.plist" "SaaS Framework App" "$project_display_name App"
    fi
    
    # Web configuration
    replace_in_file "apps/frontend/web/index.html" "SaaS Framework App" "$project_display_name App"
    replace_in_file "apps/frontend/web/manifest.json" "SaaS Framework App" "$project_display_name App"
    replace_in_file "apps/frontend/web/manifest.json" "SaaS Framework" "$project_display_name"
    
    # Windows configuration
    if [ -f "apps/frontend/windows/runner/main.cpp" ]; then
        replace_in_file "apps/frontend/windows/runner/main.cpp" "SaaS Framework App" "$project_display_name App"
    fi
    
    # Test configuration
    replace_in_file "apps/frontend/dart_test.yaml" "saas_framework_app" "${project_name//-/_}_app"
}

# Function to update Docker configuration
update_docker_config() {
    local project_name="$1"
    local database_name="$2"
    local admin_email="$3"
    
    print_status "Updating Docker configuration..."
    
    # Update docker-compose.yml
    replace_in_file "docker/docker-compose.yml" "saas_framework" "$database_name"
    replace_in_file "docker/docker-compose.yml" "saas-framework" "$project_name"
    replace_in_file "docker/docker-compose.yml" "admin@saasframework.com" "$admin_email"
    
    # Update Docker README
    if [ -f "docker/README.md" ]; then
        replace_in_file "docker/README.md" "SaaS Framework" "$project_name"
    fi
}

# Function to update main documentation
update_main_documentation() {
    local project_display_name="$1"
    local project_description="$2"
    local database_name="$3"
    
    print_status "Updating main documentation..."
    
    # Update README.md
    replace_in_file "README.md" "SaaS Framework - Multi-Tenant SaaS Application Platform" "$project_display_name - $project_description"
    replace_in_file "README.md" "saas_framework" "$database_name"
    
    # Update development documentation
    replace_in_files "docs/development/*.md" "saas_framework" "$database_name"
    replace_in_files "docs/development/*.md" "SaaS Framework" "$project_display_name"
}

# Function to update database documentation
update_database_documentation() {
    print_status "Updating database documentation..."
    
    # Delete sample entity documentation
    if [ -f "docs/database/entities/sample-entity.md" ]; then
        rm -f "docs/database/entities/sample-entity.md"
        print_status "Deleted sample-entity.md"
    fi
    
    # Update schema overview
    if [ -f "docs/database/schema-overview.md" ]; then
        sed -i.bak '/SampleEntity/d' "docs/database/schema-overview.md"
        rm -f "docs/database/schema-overview.md.bak"
        print_status "Removed SampleEntity references from schema-overview.md"
    fi
    
    # Update entity relationships
    if [ -f "docs/database/relationships/entity-relationships.md" ]; then
        sed -i.bak '/SampleEntity/d' "docs/database/relationships/entity-relationships.md"
        rm -f "docs/database/relationships/entity-relationships.md.bak"
        print_status "Removed SampleEntity references from entity-relationships.md"
    fi
    
    # Update foreign keys
    if [ -f "docs/database/relationships/foreign-keys.md" ]; then
        sed -i.bak '/sample_entities/d' "docs/database/relationships/foreign-keys.md"
        rm -f "docs/database/relationships/foreign-keys.md.bak"
        print_status "Removed sample_entities references from foreign-keys.md"
    fi
    
    # Update migration history
    if [ -f "docs/database/migrations/migration-history.md" ]; then
        sed -i.bak '/SampleEntities/d' "docs/database/migrations/migration-history.md"
        rm -f "docs/database/migrations/migration-history.md.bak"
        print_status "Removed SampleEntities references from migration-history.md"
    fi
    
    # Update ERD diagram
    if [ -f "docs/database/diagrams/erd-diagram.md" ]; then
        sed -i.bak '/SampleEntity/d' "docs/database/diagrams/erd-diagram.md"
        rm -f "docs/database/diagrams/erd-diagram.md.bak"
        print_status "Removed SampleEntity references from erd-diagram.md"
    fi
    
    # Update schema diagram
    if [ -f "docs/database/diagrams/schema-diagram.md" ]; then
        sed -i.bak '/sample_entities/d' "docs/database/diagrams/schema-diagram.md"
        rm -f "docs/database/diagrams/schema-diagram.md.bak"
        print_status "Removed sample_entities references from schema-diagram.md"
    fi
}

# Function to update API documentation
update_api_documentation() {
    print_status "Updating API documentation..."
    
    # Update entity APIs
    if [ -f "docs/api/entity-apis.md" ]; then
        sed -i.bak '/SampleEntity/d' "docs/api/entity-apis.md"
        rm -f "docs/api/entity-apis.md.bak"
        print_status "Removed SampleEntity references from entity-apis.md"
    fi
    
    # Update backend API endpoints
    if [ -f "apps/backend/docs/api/endpoints/entity-endpoints.md" ]; then
        sed -i.bak '/SampleEntity/d' "apps/backend/docs/api/endpoints/entity-endpoints.md"
        rm -f "apps/backend/docs/api/endpoints/entity-endpoints.md.bak"
        print_status "Removed SampleEntity references from entity-endpoints.md"
    fi
}

# Function to update frontend documentation
update_frontend_documentation() {
    print_status "Updating frontend documentation..."
    
    # Update clean architecture docs
    if [ -f "apps/frontend/docs/architecture/clean-architecture.md" ]; then
        sed -i.bak '/SampleEntity/d' "apps/frontend/docs/architecture/clean-architecture.md"
        rm -f "apps/frontend/docs/architecture/clean-architecture.md.bak"
        print_status "Removed SampleEntity references from clean-architecture.md"
    fi
    
    # Update state management docs
    if [ -f "apps/frontend/docs/architecture/state-management.md" ]; then
        sed -i.bak '/SampleEntity/d' "apps/frontend/docs/architecture/state-management.md"
        rm -f "apps/frontend/docs/architecture/state-management.md.bak"
        print_status "Removed SampleEntity references from state-management.md"
    fi
    
    # Update testing guide
    if [ -f "apps/frontend/docs/testing/testing-guide.md" ]; then
        sed -i.bak '/SampleEntity/d' "apps/frontend/docs/testing/testing-guide.md"
        rm -f "apps/frontend/docs/testing/testing-guide.md.bak"
        print_status "Removed SampleEntity references from testing-guide.md"
    fi
    
    # Update test tagging guide
    if [ -f "apps/frontend/docs/testing/test-tagging-guide.md" ]; then
        sed -i.bak '/SampleEntity/d' "apps/frontend/docs/testing/test-tagging-guide.md"
        rm -f "apps/frontend/docs/testing/test-tagging-guide.md.bak"
        print_status "Removed SampleEntity references from test-tagging-guide.md"
    fi
}

# Function to delete sample test files
delete_sample_test_files() {
    print_status "Deleting sample test files..."
    
    # List of frontend test files to delete
    local test_files=(
        "apps/frontend/test/features/home/domain/entities/sample_entity_test.dart"
        "apps/frontend/test/features/home/data/repositories/sample_entity_repository_test.dart"
        "apps/frontend/test/features/home/presentation/controllers/home_controller_test.dart"
        "apps/frontend/test/features/home/presentation/screens/home_screen_test.dart"
    )
    
    for file in "${test_files[@]}"; do
        if [ -f "$file" ]; then
            rm -f "$file"
            print_status "Deleted $file"
        fi
    done
    
    # Remove empty test directories
    find "apps/frontend/test" -type d -empty -delete 2>/dev/null || true
    print_status "Cleaned up empty test directories"
}

# Function to switch .cursorrules from framework mode to business mode
switch_to_business_mode() {
    local project_display_name="$1"
    
    print_status "Switching .cursorrules files from FRAMEWORK MODE to BUSINESS MODE..."
    
    # Function to update a single cursorrules file
    update_cursorrules_file() {
        local file="$1"
        local context="$2"
        
        if [ ! -f "$file" ]; then
            print_warning "File not found: $file"
            return
        fi
        
        print_status "Updating $context .cursorrules..."
        
        # Create a temporary file for the updated content
        local temp_file="${file}.tmp"
        
        # Add business mode header
        cat > "$temp_file" << 'EOF'
# 🚀 BUSINESS APPLICATION MODE - ACTIVE

> **This framework is now configured for business application development.**
> 
> You are now free to:
> - Use business-specific terminology and naming
> - Add business logic to entities and services
> - Customize the framework for your specific domain
> - Create business-specific entities and controllers
> 
> The generic framework restrictions have been removed.

---

EOF
        
        # Append the original file content, but comment out framework-specific restrictions
        while IFS= read -r line; do
            # Comment out lines that enforce generic/framework rules
            if echo "$line" | grep -qE "(Keep everything generic|Use generic terminology|Avoid business-specific|NO business-specific|Generic framework|FRAMEWORK.*MODE|generic framework)" && ! echo "$line" | grep -q "^#"; then
                echo "# [FRAMEWORK MODE - DISABLED] $line" >> "$temp_file"
            # Remove old mode indicators
            elif echo "$line" | grep -qE "CURRENT MODE.*FRAMEWORK|FRAMEWORK DEVELOPMENT MODE"; then
                echo "# $line" >> "$temp_file"
            else
                echo "$line" >> "$temp_file"
            fi
        done < "$file"
        
        # Replace original file with updated version
        mv "$temp_file" "$file"
        print_success "Updated $context .cursorrules to BUSINESS MODE"
    }
    
    # Update root .cursorrules
    if [ -f ".cursorrules" ]; then
        update_cursorrules_file ".cursorrules" "root"
    fi
    
    # Update backend .cursorrules
    if [ -f "apps/backend/.cursorrules" ]; then
        update_cursorrules_file "apps/backend/.cursorrules" "backend"
    fi
    
    # Update frontend .cursorrules if it exists
    if [ -f "apps/frontend/.cursorrules" ]; then
        update_cursorrules_file "apps/frontend/.cursorrules" "frontend"
    fi
    
    print_success "✅ All .cursorrules files switched to BUSINESS MODE"
    print_status "The AI agent will now support business-specific development for $project_display_name"
}

# Main setup function
main() {
    # Check command line arguments
    if [ "$1" = "--update-node" ] || [ "$1" = "-n" ]; then
        update_node_versions_only
        exit 0
    elif [ "$1" = "--help" ] || [ "$1" = "-h" ]; then
        echo "Usage: $0 [OPTIONS]"
        echo
        echo "Options:"
        echo "  --update-node, -n    Update Node.js versions in configuration files only"
        echo "  --help, -h          Show this help message"
        echo
        echo "Without options, runs the full framework setup process."
        exit 0
    fi
    
    print_header "🚀 SaaS Framework Setup"
    echo "This script will set up the generic framework for your new project."
    echo
    
    # Step 1: Check prerequisites
    print_step "1. Checking Prerequisites"
    
    # Check and install jq if needed
    check_jq
    
    # Check Docker
    if ! check_docker; then
        print_warning "Docker is not installed."
        if [[ "$OSTYPE" == "linux-gnu"* ]]; then
            prompt_input "Do you want to install Docker automatically? (y/n)" "y" INSTALL_DOCKER
            if [ "$INSTALL_DOCKER" = "y" ] || [ "$INSTALL_DOCKER" = "Y" ] || [ "$INSTALL_DOCKER" = "yes" ]; then
                if install_docker; then
                    print_success "Docker installed successfully"
                else
                    print_error "Failed to install Docker automatically."
                    print_warning "Continuing with setup, but database startup will fail without Docker."
                fi
            else
                print_warning "Docker installation skipped."
                print_warning "Continuing with setup, but database startup will fail without Docker."
            fi
        else
            print_status "Docker is required for running the database. Please install Docker Desktop from https://docker.com"
            print_warning "Continuing with setup, but database startup will fail without Docker."
        fi
    fi
    
    # Check Docker Compose
    if ! check_docker_compose; then
        print_warning "Docker Compose is not installed."
        prompt_input "Do you want to install Docker Compose automatically? (y/n)" "y" INSTALL_DOCKER_COMPOSE
        if [ "$INSTALL_DOCKER_COMPOSE" = "y" ] || [ "$INSTALL_DOCKER_COMPOSE" = "Y" ] || [ "$INSTALL_DOCKER_COMPOSE" = "yes" ]; then
            if install_docker_compose; then
                print_success "Docker Compose installed successfully"
            else
                print_error "Failed to install Docker Compose automatically."
                print_warning "You may need to install Docker Compose manually to start the database."
            fi
        else
            print_warning "Docker Compose installation skipped."
            print_warning "You may need to install Docker Compose manually to start the database."
        fi
    fi
    
    # Check Node.js
    if ! command_exists node; then
        print_warning "Node.js is not installed."
        prompt_input "What Node.js version to install? (22/latest/specific version)" "latest" NODE_VERSION
        if [ "$NODE_VERSION" = "latest" ]; then
            NODE_VERSION=$(get_latest_node_version)
            print_status "Latest Node.js version: $NODE_VERSION"
        fi
        
        # Try to install using nvm first, fallback to system package manager
        if install_nodejs_with_nvm "$NODE_VERSION"; then
            print_success "Node.js $NODE_VERSION installed successfully using nvm"
        else
            print_warning "nvm installation failed, trying fallback method..."
            if install_nodejs_fallback "$NODE_VERSION"; then
                print_success "Node.js $NODE_VERSION installed successfully using fallback method"
            else
                print_error "Failed to install Node.js. Please install manually."
                exit 1
            fi
        fi
        
        # Update package.json files with the installed version
        update_node_version_in_package_json "$NODE_VERSION" "$NODE_VERSION"
        # Update other configuration files
        update_node_version_in_config_files "$NODE_VERSION"
    else
        CURRENT_NODE_VERSION=$(node --version | cut -d'v' -f2 | cut -d'.' -f1)
        print_success "Node.js $(node --version) is installed"
        
        # Ask if user wants to change the Node.js version
        prompt_input "Do you want to change the Node.js version? (y/n)" "n" CHANGE_NODE
        if [ "$CHANGE_NODE" = "y" ] || [ "$CHANGE_NODE" = "Y" ] || [ "$CHANGE_NODE" = "yes" ]; then
            prompt_input "What Node.js version do you want? (22/latest/specific version)" "latest" NEW_NODE_VERSION
            if [ "$NEW_NODE_VERSION" = "latest" ]; then
                NEW_NODE_VERSION=$(get_latest_node_version)
                print_status "Latest Node.js version: $NEW_NODE_VERSION"
            fi
            
            if [ "$NEW_NODE_VERSION" != "$CURRENT_NODE_VERSION" ]; then
                print_status "Changing from Node.js $CURRENT_NODE_VERSION to $NEW_NODE_VERSION"
                
                # Try to install using nvm first, fallback to system package manager
                if install_nodejs_with_nvm "$NEW_NODE_VERSION"; then
                    print_success "Node.js $NEW_NODE_VERSION installed and activated using nvm"
                    NODE_VERSION="$NEW_NODE_VERSION"
                else
                    print_warning "nvm installation failed, trying fallback method..."
                    if install_nodejs_fallback "$NEW_NODE_VERSION"; then
                        print_success "Node.js $NEW_NODE_VERSION installed using fallback method"
                        NODE_VERSION="$NEW_NODE_VERSION"
                    else
                        print_error "Failed to install Node.js $NEW_NODE_VERSION. Keeping current version."
                        NODE_VERSION="$CURRENT_NODE_VERSION"
                    fi
                fi
                
                # Update package.json files with the new version
                update_node_version_in_package_json "$NODE_VERSION" "$NODE_VERSION"
                update_node_version_in_config_files "$NODE_VERSION"
            else
                print_success "Already using Node.js version $CURRENT_NODE_VERSION"
                NODE_VERSION="$CURRENT_NODE_VERSION"
            fi
        else
            # Keep current version and update package.json files
            print_status "Keeping current Node.js version: $CURRENT_NODE_VERSION"
            update_node_version_in_package_json "$CURRENT_NODE_VERSION" "$CURRENT_NODE_VERSION"
            update_node_version_in_config_files "$CURRENT_NODE_VERSION"
            NODE_VERSION="$CURRENT_NODE_VERSION"
        fi
    fi
    
    # Check Flutter
    if ! command_exists flutter; then
        print_warning "Flutter is not installed."
        prompt_input "What Flutter version to install?" "stable" FLUTTER_VERSION
        install_flutter "$FLUTTER_VERSION"
    else
        print_success "Flutter $(flutter --version | head -n1) is installed"
    fi
    
    # Check Python (Optional)
    echo
    print_status "Python is optional for this framework (not required by default)"
    prompt_input "Do you need Python for your project? (y/N)" "n" NEED_PYTHON
    
    if [ "$NEED_PYTHON" = "y" ] || [ "$NEED_PYTHON" = "Y" ] || [ "$NEED_PYTHON" = "yes" ]; then
        if ! check_python; then
            print_warning "Python is not installed."
            echo
            echo "Available Python versions:"
            echo "  - latest (recommended)"
            echo "  - 3.11"
            echo "  - 3.10"
            echo "  - 3.9"
            echo
            prompt_input "What Python version to install?" "latest" PYTHON_VERSION
            install_python "$PYTHON_VERSION"
        else
            check_python
            check_pip
        fi
    else
        print_status "Skipping Python installation (not needed for this framework)"
    fi
    
    # Check Docker
    if ! command_exists docker; then
        print_warning "Docker is not installed."
        read -p "Install Docker? (y/N): " install_docker_confirm
        if [[ $install_docker_confirm =~ ^[Yy]$ ]]; then
            install_docker
        else
            print_error "Docker is required for database setup. Please install it manually."
    exit 1
fi
    else
        print_success "Docker $(docker --version) is installed"
    fi
    
    echo
    print_success "All prerequisites are installed!"
    
    # Step 2: Project Customization
    print_step "2. Project Customization"
    
    # Get project details
    prompt_input "Enter project name (kebab-case)" "my-project" PROJECT_NAME
    prompt_input "Enter project display name" "My Project" PROJECT_DISPLAY_NAME
    prompt_input "Enter project description" "Multi-tenant Application" PROJECT_DESCRIPTION
    prompt_input "Enter database name" "${PROJECT_NAME//-/_}_db" DATABASE_NAME
    prompt_input "Enter package name (com.company.app)" "com.example.${PROJECT_NAME//-/_}" PACKAGE_NAME
    prompt_input "Enter admin email" "admin@${PROJECT_NAME//-/.}.com" ADMIN_EMAIL
    
    print_status "Customizing project with:"
    echo "  Project Name: $PROJECT_NAME"
    echo "  Display Name: $PROJECT_DISPLAY_NAME"
    echo "  Description: $PROJECT_DESCRIPTION"
    echo "  Database: $DATABASE_NAME"
    echo "  Package: $PACKAGE_NAME"
    echo "  Admin Email: $ADMIN_EMAIL"
    echo
    
    # Confirm before proceeding
    read -p "Continue with customization? (y/N): " confirm
    if [[ ! $confirm =~ ^[Yy]$ ]]; then
        print_error "Customization cancelled"
    exit 1
fi

    # Customize project files
    print_status "Customizing project files..."
    
    # Step 2.1: Delete Sample Entities and Controllers
    print_status "Deleting sample entities and controllers..."
    
    # Delete Backend Sample Entities
    delete_sample_entities_backend
    
    # Delete Frontend Sample Entities
    delete_sample_entities_frontend
    
    # Delete Sample Controllers & Screens
    delete_sample_controllers_screens
    
    # Step 2.2: Update Configuration Files
    print_status "Updating configuration files..."
    
    # Update root package.json
    replace_in_file "package.json" "saas-framework" "$PROJECT_NAME"
    replace_in_file "package.json" "Multi-Tenant SaaS Application Framework" "$PROJECT_DESCRIPTION"
    
    # Update backend configuration
    update_backend_config "$PROJECT_NAME" "$PROJECT_DISPLAY_NAME" "$DATABASE_NAME"
    
    # Update frontend configuration
    update_frontend_config "$PROJECT_NAME" "$PROJECT_DISPLAY_NAME" "$PACKAGE_NAME"
    
    # Update platform configurations
    update_platform_configs "$PROJECT_NAME" "$PROJECT_DISPLAY_NAME" "$PACKAGE_NAME"
    
    # Update Docker configuration
    update_docker_config "$PROJECT_NAME" "$DATABASE_NAME" "$ADMIN_EMAIL"
    
    # Step 2.3: Update Documentation References
    print_status "Updating documentation references..."
    
    # Update main documentation
    update_main_documentation "$PROJECT_DISPLAY_NAME" "$PROJECT_DESCRIPTION" "$DATABASE_NAME"
    
    # Update database documentation
    update_database_documentation
    
    # Update API documentation
    update_api_documentation
    
    # Update frontend documentation
    update_frontend_documentation
    
    # Delete sample test files
    delete_sample_test_files
    
    # Step 2.4: Switch to Business Mode
    print_status "Switching framework to business mode..."
    switch_to_business_mode "$PROJECT_DISPLAY_NAME"
    
    print_success "Project customization completed!"
    
    # # Step 3: Remove git connection
    # print_step "3. Removing Git Connection"
    
    # print_status "Removing git connection to framework repository..."
    # rm -rf .git
    # print_success "Git connection removed. You can now initialize your own repository."
    
    # Step 4: Check and update dependencies
    print_step "4. Checking Dependencies"
    
    # Check root dependencies
    check_and_update_package "package.json" "root"
    
    # Check backend dependencies
    check_and_update_package "apps/backend/package.json" "backend"
    
    # Check frontend dependencies
    check_and_update_package "apps/frontend/pubspec.yaml" "frontend"
    
    # Step 5: Install dependencies
    print_step "5. Installing Dependencies"

# Install root dependencies
    print_status "Installing root dependencies..."
npm install

# Install backend dependencies
    print_status "Installing backend dependencies..."
cd apps/backend && npm install && cd ../..

# Install Flutter dependencies
    print_status "Installing Flutter dependencies..."
cd apps/frontend && flutter pub get && cd ../..

    # Step 6: Setup environment
    print_step "6. Setting Up Environment"

# Copy environment file
if [ ! -f "apps/backend/.env" ]; then
    cp apps/backend/env.example apps/backend/.env
        print_success "Created .env file from template"
    else
        print_success ".env file already exists"
    fi
    
    # Step 7: Start database
    print_step "7. Starting Database"
    
    # Check if Docker daemon is running
    if ! docker info >/dev/null 2>&1; then
        print_error "Docker daemon is not running."
        print_status "Please start Docker Desktop or Docker daemon and try again."
        print_warning "You can start the database later with:"
        print_status "  docker-compose -f docker/docker-compose.yml up -d postgres"
        print_status "  # or"
        print_status "  docker compose -f docker/docker-compose.yml up -d postgres"
        return 0
    fi
    
    print_status "Starting PostgreSQL database..."
    
    # Get the correct Docker Compose command
    DOCKER_COMPOSE_CMD=$(get_docker_compose_cmd)
    
    if [ -n "$DOCKER_COMPOSE_CMD" ]; then
        print_status "Using Docker Compose command: $DOCKER_COMPOSE_CMD"
        if [ "$DOCKER_COMPOSE_CMD" = "docker compose" ]; then
            # Use docker compose (plugin)
            if docker compose -f docker/docker-compose.yml up -d postgres; then
                print_success "Database started successfully"
                print_status "Waiting for database to be ready..."
                sleep 10
            else
                print_error "Failed to start database with docker compose"
                return 1
            fi
        else
            # Use docker-compose (standalone)
            if docker-compose -f docker/docker-compose.yml up -d postgres; then
                print_success "Database started successfully"
                print_status "Waiting for database to be ready..."
                sleep 10
            else
                print_error "Failed to start database with docker-compose"
                return 1
            fi
        fi
    else
        print_error "Docker Compose not available. Cannot start database."
        print_status "Please install Docker Compose and run manually:"
        print_status "  docker-compose -f docker/docker-compose.yml up -d postgres"
        print_status "  # or"
        print_status "  docker compose -f docker/docker-compose.yml up -d postgres"
    fi
    
    # Final success message
    print_header "🎉 Setup Complete!"
    echo
    print_success "Your $PROJECT_DISPLAY_NAME project is ready!"
    echo
echo "🚀 To start development:"
echo "   npm run dev"
    echo
echo "🌐 Access points:"
echo "   - Frontend: http://localhost:8080"
echo "   - Backend API: http://localhost:3000"
    echo "   - pgAdmin: http://localhost:5050 ($ADMIN_EMAIL / admin)"
echo "   - PostgreSQL: localhost:5432 (postgres / password)"
    echo
    echo "📚 Next steps:"
    echo "   1. Initialize your own git repository: git init"
    echo "   2. Configure framework checkers with your business terms"
    echo "   3. Create your business entities and controllers"
    echo "   4. Customize localization content"
    echo "   5. Update platform-specific configurations"
    echo
    echo "📖 For more information, see README.md"
    echo
    print_success "✅ Framework customization completed:"
    echo "  - Deleted all sample entities and controllers"
    echo "  - Updated all configuration files"
    echo "  - Updated all documentation references"
    echo "  - Deleted sample test files"
    echo "  - Switched .cursorrules to BUSINESS MODE (framework restrictions removed)"
    echo
    print_success "🎯 Business Mode Active:"
    echo "  - You can now use business-specific terminology"
    echo "  - Add business logic to entities and services"
    echo "  - Create domain-specific features"
    echo "  - The AI agent will support your business development"
    echo
    print_warning "Next steps:"
    echo "  - Create your business entities extending BaseEntity/TenantEntity"
    echo "  - Update database migrations for your entities"
    echo "  - Build your business-specific features"
    echo "  - Customize the UI for your brand"
}

# Run main function
main "$@"