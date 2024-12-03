#!/bin/bash 

# Colors for formatting
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[0;33m'
BLUE='\033[0;34m'
PURPLE='\033[0;35m'
NC='\033[0m'  # No Color

# Function to print headers
print_header() {
    echo -e "${PURPLE}==================================${NC}"
    echo -e "${PURPLE}||       🖥️   System Monitor     ||${NC}"
    echo -e "${PURPLE}==================================${NC}"
}

# Function to check CPU usage
check_cpu() {
    echo -e "${BLUE}=== CPU USAGE ===${NC}"
    local cpu_load
    cpu_load=$(top -bn1 | grep "Cpu(s)" | awk '{printf "CPU Load: %.2f%%\n", $2 + $4}')
    if [[ -z $cpu_load ]]; then
        echo -e "${RED}Error: Could not fetch CPU usage.${NC}"
    else
        echo -e "$cpu_load"
    fi
    echo ""
}

# Function to check memory usage
check_memory() {
    echo -e "${GREEN}=== MEMORY USAGE ===${NC}"
    free -h | awk '/^Mem/ {printf "Memory Used: %s / %s (%.2f%%)\n", $3, $2, $3/$2 * 100}'
    echo ""
}

# Function to check disk usage
check_disk() {
    echo -e "${YELLOW}=== DISK USAGE ===${NC}"
    df -h | awk '/^\/dev\// {printf "Disk: %s | Used: %s | Usage: %s\n", $1, $3, $5}'
    echo ""
}

# Function to check network activity
check_network() {
    echo -e "${RED}=== NETWORK ACTIVITY ===${NC}"
    ip -brief addr | awk '{printf "Interface: %-10s IP: %s\n", $1, $3}'
    echo ""
}

# Function to list top processes
list_processes() {
    echo -e "${BLUE}=== TOP PROCESSES BY MEMORY USAGE ===${NC}"
    echo -e "USER       PID       %CPU      %MEM      COMMAND"
    ps aux --sort=-%mem | awk 'NR==1 || NR<=11 {printf "%-10s %-10s %-10s %-10s %-s\n", $1, $2, $3, $4, $11}'
    echo ""
}

# Main function to call all checks
main() {
    print_header
    check_cpu
    check_memory
    check_disk
    check_network
    list_processes
}

# Call the main function
main
