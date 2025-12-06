#!/bin/bash

NOTIFY_ENV_FILE="/mnt/TimNAS2/Container/tgmsgbot/.env"
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
    --network host \
    -v "${BASE_DIR}/db/:/db/" \
    -v "${BASE_DIR}/config.ini:/config.ini" \
    -v "${LOG_FILE}:/pixivutil.log" \
    -v "${DOWNLOAD_DIR}:/downloads/" \
    -e TZ=America/Los_Angeles \
    ghcr.io/tim4431/pixivutil2-docker \
    -s 6 --sp 1 --ep 3 -x # bookmark images backup,from page 1 to page3, telegram report, and exit


# --- 2. Prepare the Notification Message ---
if [ -f "$LOG_FILE" ]; then
    # Extract top 5 and bottom 5 lines
    HEAD_LOG=$(head -n 20 "$LOG_FILE")
    TAIL_LOG=$(tail -n 20 "$LOG_FILE")

    # Construct message with Markdown formatting
    # Note: We use quotes around EOF to prevent variable expansion if needed,
    # but here we want expansion for the log variables.
    read -r -d '' MESSAGE <<EOM
*Pixiv Bookmark Backup Task*

*Start of Log:*
\`\`\`
${HEAD_LOG}
\`\`\`

*End of Log:*
\`\`\`
${TAIL_LOG}
\`\`\`
EOM

    echo "Sending Telegram Notification..."

    # --- 3. Send Notification using the Bot Container ---
    docker run --rm \
        --env-file "$NOTIFY_ENV_FILE" \
        ghcr.io/tim4431/tgmsgbot:latest \
        -s "$MESSAGE"

else
    echo "Error: Log file was not created."
fi