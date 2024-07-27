#!/bin/ash

cd /riven/src


# Don't start unless plex/zurg is ready, or if the user is debugging with ILIKEDANGER
if [[ -z "$ILIKEDANGER" ]]; then
# Ensure plex is ready
echo "📺 Waiting for plex to be up..."
/usr/local/bin/wait-for -t 3600 plex:32400 -- echo "✅"

echo "👽 Waiting for zurg to be up..."
/usr/local/bin/wait-for -t 3600 zurg:9999 -- echo "✅"

echo "🎉 let's go!"
fi

if [[ ! -z "$ILIKEDANGER" ]]; then
    echo "Greetings, brave Elfie! Press any key to continue to pull the latest $ILIKEDANGER branch, or wait 10 seconds for a stable start..."
    
    # -t 5: Timeout of 5 seconds
    read -s -n 1 -t 10
    
    if [ $? -eq 0 ]; then
        echo "You pressed a key! Let's go to the danger zone, cloning the $ILIKEDANGER branch!"
        if [[ -d /tmp/riven ]]; then
            rm -rf /tmp/riven
        fi
        cd /tmp        
        git clone -b $ILIKEDANGER   https://github.com/rivenmedia/riven.git 
        cd riven
        # cp /app/.venv /tmp/ -rf
        export VIRTUAL_ENV=/tmp/.venv
        export PATH="/tmp/.venv/bin:$PATH"
        python3 -m venv $VIRTUAL_ENV
        source $VIRTUAL_ENV/bin/activate
        pip install poetry==1.8.3
        poetry install --without dev --no-root --no-cache
        mkdir -p /riven/data # failsafe incase we're testing locally with no data folder

        # make an ilikedanger version of settings
        if [[ ! -f /riven/data/settings-ilikedanger.json && -f /riven/data/settings.json ]]; then
            cp /riven/data/settings.json /riven/data/settings-ilikedanger.json
        fi
        mkdir -p /tmp/riven/data
        ln -s /riven/data/settings-ilikedanger.json /tmp/riven/data/settings.json
        cd src
        poetry run python3 main.py 
    else
        echo "Timeout reached. Continuing boring normal start..."
        poetry run python3 main.py 
    fi
else
    poetry run python3 main.py 
fi
echo "Riven has exited :( Press any key to restart..."
read -s -n 1

