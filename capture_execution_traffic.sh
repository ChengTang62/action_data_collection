#!/bin/bash

yaml_dir="/path/to/yaml/files"
interface="eth0"
for yaml_file in "$yaml_dir"/*.yaml
do
    base_name=$(basename "$yaml_file" .yaml)
    tcpdump -i "$interface" -w "$yaml_dir/${base_name}.pcap" &
    tcpdump_pid=$!
    python execute_task.py "$yaml_file"
    kill $tcpdump_pid
    sleep 2
done

echo "All tasks executed and traffic captured."
