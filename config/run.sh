#!/bin/bash

# Run like so
# ./config/run.sh --report_path .//tmp --initial_url https://foo.com/ --scan_timeout 160 --license_path ./config/license.txt   --base_path .

# NOTE: For license, perhaps we need to use prefs.xml???

# Parse command line args
# See https://stackoverflow.com/questions/192249/how-do-i-parse-command-line-arguments-in-bash
while [[ "$#" -gt 0 ]]; do
    case $1 in
        -u|--initial_url) initial_url="$2"; shift ;;
        -r|--report_path) report_path="$2"; shift ;;
        -t|--scan_timeout) scan_timeout="$2"; shift ;;
        -l|--license_path) license_path="$2"; shift ;;
        -b|--base_path) base_path="$2"; shift ;;
        *) echo "Unknown parameter passed: $1"; exit 1 ;;
    esac
    shift
done

# Get all of our config file paths
MOLLY_CONFIG=$base_path/config/burp_molly_config.json
BURP_JAR_PATH=$base_path/config/burpsuite_pro.jar
USER_CONFIG=$base_path/config/burp_user_config.json
PROJECT_CONFIG=$base_path/config/scan_policy.json

# Generate out molly config
python3 $base_path/config/burp_molly_config_builder.py --report_path $report_path --initial_url $initial_url --scan_timeout $scan_timeout > $MOLLY_CONFIG

export MOLLY_CONFIG=$MOLLY_CONFIG
export LICENSE=cat $LICENSE_PATH

echo "Configs:"
echo "MOLLY_CONFIG:   $MOLLY_CONFIG"
echo "BURP_JAR_PATH:  $BURP_JAR_PATH"
echo "USER_CONFIG:    $USER_CONFIG"
echo "PROJECT_CONFIG: $PROJECT_CONFIG"
echo ""
echo "Scanning $initial_url..."

java -jar -Xmx2048m -Djava.awt.headless=true $BURP_JAR_PATH --user-config-file=$USER_CONFIG --config-file=$PROJECT_CONFIG

# TODO: Run burp using expect for license management?
# https://burpsuite.guide/blog/activate-burpsuite-inside-docker-container/
# /usr/bin/expect <<EOD
# spawn java -jar -Xmx2048m -Djava.awt.headless=true $BURP_JAR_PATH --user-config-file=$USER_CONFIG --config-file=$PROJECT_CONFIG

# expect "*Do you accept the license agreement*?" { send -- "y\r" }
# expect "*paste your license key below*" { send -- "$license_path\r" }
# expect "*Enter preferred activation method*" { send -- "o\r" }

# expect eof
# EOD

echo "Complete!"