#!/bin/bash

# This script is used to install and manage the RTMPS docker

# Function to install Docker
install_docker() {
    echo "Installing Docker..."
    apt-get update && sudo apt-get install -y ca-certificates curl || { echo "Failed to install dependencies."; exit 1; }

    install -m 0755 -d /etc/apt/keyrings
    curl -fsSL https://download.docker.com/linux/debian/gpg | sudo tee /etc/apt/keyrings/docker.asc > /dev/null
    chmod a+r /etc/apt/keyrings/docker.asc

    # Add Docker repository
    echo "Adding Docker repository..."
    echo "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.asc] https://download.docker.com/linux/debian $(. /etc/os-release && echo "$VERSION_CODENAME") stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null

    apt-get update
    apt-get install -y git docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin || { echo "Docker installation failed."; exit 1; }

    echo "Docker installation completed."
}

# Function to build the RTMPS Docker image
build_rtmps() {
    echo "Building RTMPS Docker image..."
    docker build -t secure-rtmps-server . || { echo "Docker build failed."; exit 1; }
    echo "Build completed."
}

# Function to run the RTMPS container
run_rtmps() {
    echo "Starting RTMPS container..."
    docker run -d -p 443:443 --name rtmps-server secure-rtmps-server || { echo "Failed to start container."; exit 1; }
    echo "RTMPS container is running."
}

# Function to stop the RTMPS container
stop_rtmps() {
    echo "Stopping RTMPS container..."
    CONTAINER_ID=$(docker ps -q --filter "ancestor=secure-rtmps-server")
    
    if [ -n "$CONTAINER_ID" ]; then
        docker stop "$CONTAINER_ID" || { echo "Failed to stop container."; exit 1; }
        echo "RTMPS container stopped."
    else
        echo "No running RTMPS container found."
    fi
}

# Function to remove the RTMPS container
remove_rtmps() {
    echo "Removing RTMPS container..."
    CONTAINER_ID=$(docker ps -a -q --filter "ancestor=secure-rtmps-server")
    
    if [ -n "$CONTAINER_ID" ]; then
        docker rm "$CONTAINER_ID" || { echo "Failed to remove container."; exit 1; }
        echo "RTMPS container removed."
    else
        echo "No RTMPS container found to remove."
    fi
}

# Function to update keys inside the Docker container
update_keys() {
    echo "Updating keys..."
    CONTAINER_ID=$(docker ps -q --filter "ancestor=secure-rtmps-server")
    
    if [ -n "$CONTAINER_ID" ]; then
        docker cp keys.txt "$CONTAINER_ID:/auth/keys.txt" || { echo "Failed to update keys."; exit 1; }
        echo "Keys updated successfully."
    else
        echo "RTMPS container is not running."
    fi
}

# Function to update IPs inside the Docker container
update_ips() {
    echo "Updating IPs..."
    CONTAINER_ID=$(docker ps -q --filter "ancestor=secure-rtmps-server")
    
    if [ -n "$CONTAINER_ID" ]; then
        docker cp ips.txt "$CONTAINER_ID:/auth/ips.txt" || { echo "Failed to update IPs."; exit 1; }
        echo "IPs updated successfully."
    else
        echo "RTMPS container is not running."
    fi
}

# Function to update scripts inside the Docker container
update_scripts() {
    echo "Updating scripts..."
    CONTAINER_ID=$(docker ps -q --filter "ancestor=secure-rtmps-server")
    
    if [ -n "$CONTAINER_ID" ]; then
        docker cp auth.php "$CONTAINER_ID:/auth/auth.php" || { echo "Failed to update auth.php."; exit 1; }
        docker cp play_auth.php "$CONTAINER_ID:/auth/play_auth.php" || { echo "Failed to update play_auth.php."; exit 1; }
        echo "Scripts updated successfully."
    else
        echo "RTMPS container is not running."
    fi
}

# Main menu loop
while true; do
    echo ""
    echo "Choose an option:"
    echo "1. Install Docker"
    echo "2. Build RTMPS"
    echo "3. Run RTMPS"
    echo "4. Stop RTMPS"
    echo "5. Remove RTMPS"
    echo "6. Update keys"
    echo "7. Update IPs"
    echo "8. Update scripts"
    echo "9. Exit"
    read -r option

    case $option in
        1) install_docker ;;
        2) build_rtmps ;;
        3) run_rtmps ;;
        4) stop_rtmps ;;
        5) remove_rtmps ;;
        6) update_keys ;;
        7) update_ips ;;
        8) update_scripts ;;
        9) echo "Exiting..."; exit 0 ;;
        *) echo "Invalid option. Please select a valid number." ;;
    esac
done
