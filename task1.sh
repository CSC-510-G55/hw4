processid=$(pgrep -f infinite.sh)

# Check if the processid was found
if [ -n "$processid" ]; then
    echo "Terminating process with ProcessID: $processid"
    kill "$processid"
else
    echo "No running process found for infinite.sh"
fi
