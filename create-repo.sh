#!/bin/bash

# Global variables
APTLY_CONFIG_PATH=${APTLY_CONFIG_PATH:-"/root/.aptly.conf"}
APTLY_ROOT=${APTLY_ROOT:-"/opt/aptly"}

# Initialize directories
init_directories() {
    echo "[INFO] Creating aptly root directory..."
    mkdir -p "$APTLY_ROOT"

    chown -R root:root "$APTLY_ROOT"
    chmod 755 "$APTLY_ROOT"
}

# create aptly configuration file
create_aptly_conf() {
    cat << EOF > ${APTLY_CONFIG_PATH}
    {
        "rootDir": "${APTLY_ROOT}",
        "downloadConcurrency": 4,
        "architectures": [],
        "dependencyFollowSuggests": false,
        "dependencyFollowRecommends": false,
        "dependencyFollowAllVariants": false,
        "dependencyFollowSource": false,
        "gpgDisableSign": false,
        "gpgDisableVerify": false,
        "gpgProvider": "gpg",
        "downloadSourcePackages": false,
        "ppaDistributorID": "",
        "ppaCodename": "",
        "skipLegacyPool": false,
        "enableMetrics": false,
        "S3PublishEndpoints": {},
        "SwiftPublishEndpoints": {},
        "APIEndpoints": {
            "": {
                "Listen": ":80",
                "EnableXForwardedFor": true
            }
        }
    }
EOF
}

clean_old_repo() {
    echo "[INFO] Cleaning old repository..."
    aptly repo drop iproute2-repo || true
}

# Create new repository
create_new_repo() {
    echo "[INFO] Creating new repository..."
    aptly -config="$APTLY_CONFIG_PATH" \
        repo create \
        -distribution=stable \
        -component=main \
        iproute2-repo
}

# Download and add iproute2 package
download_and_add_iproute2() {
    local download_dir="/tmp/download"
    
    echo "[INFO] Creating download directory..."
    mkdir -p "$download_dir"
    
    echo "[INFO] Setting directory permissions..."
    chown -R _apt:root "$download_dir"
    
    echo "[INFO] Downloading iproute2 package and dependencies..."
    cd "$download_dir"
    PACKAGE_NAME="net-tools"
    apt-get download $PACKAGE_NAME
    apt-get download $(apt-cache depends $PACKAGE_NAME | grep Depends | cut -d: -f2 | tr -d '<>' | tr -d ' ')
    
    echo "[INFO] Adding package to repository..."
    aptly repo add iproute2-repo iproute2_*.deb || true
}

# Publish repository
publish_repo() {
    echo "[INFO] Publishing repository..."
    aptly -config="$APTLY_CONFIG_PATH" \
        publish repo \
        -architectures=amd64 \
        -skip-signing \
        iproute2-repo
}

# Setup and start nginx
setup_nginx() {
    cat << EOF > /etc/nginx/nginx.conf
events {
    worker_connections 1024;
}

http {
    server {
        listen 80;
        root ${APTLY_ROOT}/public;

        location / {
            autoindex on;
        }
    }
}
EOF

    echo "[INFO] Creating nginx group..."
    groupadd nginx || true
    
    echo "[INFO] Creating nginx user..."
    useradd -g nginx nginx || true
    
    echo "[INFO] Setting permissions for aptly root..."
    chmod 755 $APTLY_ROOT
    
    echo "[INFO] Setting ownership for public directory..."
    mkdir -p "$APTLY_ROOT/public"
    chown -R nginx:nginx "$APTLY_ROOT/public" || true
    
    echo "[INFO] Starting nginx server..."
    nginx -g "daemon off;" -c /etc/nginx/nginx.conf
}

# Main function to orchestrate all operations
main() {
    echo "[INFO] Starting repository creation process..."
    init_directories
    create_aptly_conf
    clean_old_repo
    create_new_repo
    download_and_add_iproute2
    publish_repo
    setup_nginx
}

# Execute main function
main
