#!/bin/bash
if ! pgrep -f "python3 ./app/main.py" > /dev/null; then
	cd /tmp && python3 ./app/main.py &
fi
