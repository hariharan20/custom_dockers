#!/bin/bash
set -e
source "$HOME/.bashrc"
{
    echo "Container is Running"
    exec /bin/bash
} || {
    echo "container failed, please report to Hariharan"
    exit 1
}
