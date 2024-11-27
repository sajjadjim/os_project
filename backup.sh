#!/bin/bash

PURPLE='\033[0;35m'
NC='\033[0m'  # No Colorb  Hlw Nafiz Gandu Sala 


echo -e "${PURPLE}====================================${NC}"
echo -e "${PURPLE}||        💾   Automated Backup    ||${NC}"
echo -e "${PURPLE}====================================${NC}"

# Function to get backup frequency in cron format
get_cron_frequency() {
    echo "Enter the frequency of the backup:"
    echo "1) Hourly"
    echo "2) Daily"
    echo "3) Weekly"
    echo "4) Monthly"
    read -p "Select an option (1-4): " frequency

    case $frequency in
        1) echo "0 * * * *";;
        2) echo "0 2 * * *";;
        3) echo "0 2 * * 0";;
        4) echo "0 2 1 * *";;
        *) echo "Invalid option! Defaulting to daily." 
           echo "0 2 * * *";;
    esac
}

# Get user input for source and backup directories
read -p "Enter the source directory to back up: " SOURCE_DIR
read -p "Enter the backup directory: " BACKUP_DIR

# Check if the directories exist
if [ ! -d "$SOURCE_DIR" ]; then
    echo "Source directory does not exist. Exiting."
    exit 1
fi

if [ ! -d "$BACKUP_DIR" ]; then
    echo "Backup directory does not exist. Creating it..."
    mkdir -p "$BACKUP_DIR"
fi

# Generate a backup file name with a timestamp
DATE=$(date +'%Y-%m-%d_%H-%M-%S')
BACKUP_FILE="backup_$DATE.tar.gz"

# Perform the backup
echo "Starting backup of $SOURCE_DIR to $BACKUP_DIR/$BACKUP_FILE"
tar -czf "$BACKUP_DIR/$BACKUP_FILE" "$SOURCE_DIR"

# Verify if the backup was successful
if [ $? -eq 0 ]; then
    echo "Backup completed successfully!"
else
    echo "Backup failed!"
    exit 1
fi

# Clean up backups older than 7 days (optional)
find "$BACKUP_DIR" -type f -name "backup_*.tar.gz" -mtime +7 -exec rm {} \;

echo "Old backups cleaned up!"

# Get the backup frequency from the user
CRON_FREQUENCY=$(get_cron_frequency)

# Set up a cron job for automatic backups at the specified frequency
(crontab -l 2>/dev/null; echo "$CRON_FREQUENCY /path/to/backup.sh") | crontab -

echo "Cron job set up for automatic backups!"
