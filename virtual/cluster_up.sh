#!/bin/bash
set -ex

#####################################
# Set up a virtual DeepOps cluster
#####################################

# Get absolute path for the virtual DeepOps directory
VIRT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"
ROOT_DIR="${VIRT_DIR}/.."

# Create the config for deepops servers (and use the virtual inventory)
export DEEPOPS_CONFIG_DIR="${VIRT_DIR}/config"
cp -r "${ROOT_DIR}/config.example/" "${DEEPOPS_CONFIG_DIR}/"
cp "${VIRT_DIR}/virtual_inventory" "${DEEPOPS_CONFIG_DIR}/inventory"

# Set up VMs for the virtual cluster
"${VIRT_DIR}"/scripts/setup_vagrant.sh

# Set up Kubernetes (enabled by default)
if [ -z "${DEEPOPS_DISABLE_K8S}" ]; then
	"${VIRT_DIR}"/scripts/setup_k8s.sh
fi

# Set up Slurm (disabled by default)
if [ -n "${DEEPOPS_ENABLE_SLURM}" ]; then
	"${VIRT_DIR}"/scripts/setup_slum.sh
fi
