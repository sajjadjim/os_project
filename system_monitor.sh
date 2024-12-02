#!/bin/bash

# Colors for formatting
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[0;33m'
BLUE='\033[0;34m'
PURPLE='\033[0;35m'
NC='\033[0m'  # No Color

# Function to check CPU usage
check_cpu() {
    echo -e "${BLUE}=== CPU USAGE ===${NC}"
    top -bn2 | grep "Cpu(s)" | tail -1 | awk '{printf "CPU Load: %.2f%%\n", $(2) + $(4)}'
    echo ""
}

# Function to check memory usage
check_memory() {
    echo -e "${GREEN}=== MEMORY USAGE ===${NC}"
    free -h | awk '/^Mem/ {printf "Memory Used: %s / Total Memory: %s (%.2f%%)\n", $3, $2, $3/$2 * 100.0}'
    echo ""
}

# Function to check disk usage
check_disk() {
    echo -e "${YELLOW}=== DISK USAGE ===${NC}"
    df -h | grep '^/dev/' | awk '{printf "Disk Usage: %s on %s\n", $5, $1}'
    echo ""
}

# Function to check network activity
check_network() {
    echo -e "${RED}=== NETWORK ACTIVITY ===${NC}"
    ip -brief a | awk '{printf "%s: %s\n", $1, $3}'
    echo ""
}

# Function to list top processes with application name
list_processes() {
    echo -e "${BLUE}=== TOP PROCESSES BY MEMORY USAGE ===${NC}"
    ps aux --sort=-%mem | head -10 | awk '{printf "%-10s %-10s %-10s %-10s %-s\n", $1, $2, $3, $4, $11}'
    echo ""
}

# Main function to call all checks
main() {
    echo -e "${PURPLE}==================================${NC}"
    echo -e "${PURPLE}||       🖥️   System Monitor     ||${NC}"
    echo -e "${PURPLE}==================================${NC}"
    check_cpu
    check_memory
    check_disk
    check_network
    list_processes
}

main
