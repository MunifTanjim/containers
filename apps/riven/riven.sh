#!/bin/ash

cd /riven/src

cd /riven/src

echo "💥 For the option to reset your database, press the 'x' key within 10 seconds.."

# Read a single character with a timeout of 10 seconds
read -n 1 -t 10 key
clear # clear after user pressed Cancel

# Check if the key pressed is 'x'
if [[ "$key" == "x" ]]; then
    read -p "Wipe Riven's database first (y/n)?" choice
    case "$choice" in 
    y|Y ) 
        python main.py --hard_reset_db
        # workaround
        PGPASSWORD=postgres psql -U postgres -d riven -h localhost -c "DROP SCHEMA public CASCADE; CREATE SCHEMA public;"
        rm -rf /riven/alembic
        ;;
    * ) ;; # do nothing
    esac
    clear # clear after user pressed Cancel
elif [[ "$key" == "z" ]]; then
    bash # drop to a shell
fi

echo "📺 Waiting for streamer (${ELF_STREAMER_URL:-plex:32400}) to be up..."
/usr/local/bin/wait-for -t 3600 ${ELF_STREAMER_URL:-plex:32400} -- echo "✅"

# echo "👽 Waiting for zurg to be up in ${ZURG_URL:-"zurg:9999"}..."
# /usr/local/bin/wait-for -t 3600 ${ZURG_URL:-"zurg:9999"} -- echo "✅"

# Wait until the directory exists
while [ ! -d "$RIVEN_SYMLINK_LIBRARY_PATH" ]; do
    echo "Waiting for directory $RIVEN_SYMLINK_LIBRARY_PATH to be ready..."
    sleep 1
done

echo "Directory $RIVEN_SYMLINK_LIBRARY_PATH exists. Proceeding..."



echo "🎉 let's go!"
poetry run python3 main.py 

