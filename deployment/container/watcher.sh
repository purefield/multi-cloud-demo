#!/bin/bash
# Infinite loop
while true; do
    # Execute your script here, for example, calling another script or command
    /app/watch-container.sh

    # Sleep for a specified amount of time before the next execution
    sleep 1  # Adjust the sleep duration as needed
done
