#!/bin/bash
set -e
source "$HOME/.bashrc"
{
    chmod 777 -R /home/hariharan/
    echo "Container is Running"
    exec su hariharan
} || {
    echo "container failed, please report to Hariharan"
}
