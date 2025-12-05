#!/bin/bash
BASE_DIR="/mnt/TimNAS2/Container/pixivutil2-docker"
DOWNLOAD_DIR="/mnt/TimNAS2/NAS/Photos/Pixiv/PixivBookmark"
LOG_DIR="${BASE_DIR}/logs"
mkdir -p "$LOG_DIR" # Ensure log directory exists

NOW=$(date +"%Y-%m-%d_%H-%M-%S")
LOG_FILE="${LOG_DIR}/${NOW}.log"
echo "Starting Backup. Log: ${LOG_FILE}"
touch "$LOG_FILE"

# --- 1. Run the Main Task (PixivUtil) ---
docker run \
    --rm \
    -it \
    --network host \
    -v "${BASE_DIR}/db/:/db/" \
    -v "${BASE_DIR}/config.ini:/config.ini" \
    -v "${LOG_FILE}:/pixivutil.log" \
    -v "${DOWNLOAD_DIR}:/downloads/" \
    -e TZ=America/Los_Angeles \
    ghcr.io/tim4431/pixivutil2-docker