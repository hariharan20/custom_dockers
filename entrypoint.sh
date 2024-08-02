#!/bin/bash
set -e
source "$HOME/.bashrc"
{
    chmod 777 -R /home/hariharan/catkin_ws/
    #colcon build --symlink-install
    #source /home/hariharan/ros2_ws/installsetup.bash
    echo "Container is Running"
    exec su hariharan
    colcon build --symlink-install
    # source /home/hariharan/catkin_ws/devel/setup.bash

} || {
    echo "container failed, please report to Hariharan"
}
