#!/bin/bash

set -e

echo "=== Sagan Test Environment Teardown ==="

# Check if terraform is installed
command -v terraform >/dev/null 2>&1 || { echo "Error: terraform is required but not installed."; exit 1; }

echo "WARNING: This will destroy all Azure resources for the Sagan test environment."
read -p "Are you sure you want to continue? (y/N): " -n 1 -r
echo
if [[ ! $REPLY =~ ^[Yy]$ ]]; then
    echo "Teardown cancelled."
    exit 0
fi

echo "Destroying Azure infrastructure..."
cd terraform/
terraform destroy -auto-approve

echo ""
echo "=== Teardown Complete ==="
echo "All Azure resources have been destroyed."
echo ""