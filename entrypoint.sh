#!/bin/bash
KEY_GENERATOR="generate_keys.sh"
echo "Running key generation script..."
chmod +x $KEY_GENERATOR
$KEY_GENERATOR

if [ $? -ne 0 ]; then
    echo "Key generation failed. Exiting."
    exit 1
fi

source /opt/ros/humble/setup.bash
source /workspace/install/setup.bash

echo "Key generation successful. Proceeding to launch application..."
exec "$@"
