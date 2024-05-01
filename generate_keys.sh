#!/bin/bash

KEYSTORE_DIR="/opt/ros2_keystore"

if [ ! -d "$KEYSTORE_DIR" ]; then
    echo "Creating keystore directory at $KEYSTORE_DIR"
    mkdir -p "$KEYSTORE_DIR"
else
    echo "Keystore directory already exists."
fi

echo "Creating ROS2 keystore..."
ros2 security create_keystore "$KEYSTORE_DIR"

NODE_NAMES=("/node_name1" "/node_name2" "/node_name3")

for NODE_NAME in "${NODE_NAMES[@]}"; do
    echo "Generating keys for $NODE_NAME..."
    ros2 security create_key "$KEYSTORE_DIR" "$NODE_NAME"
done

echo "Key generation complete."
