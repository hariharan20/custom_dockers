image_name=ahn_laas_humble
# xhost + local:docker

echo "Starting docker container..."
docker run --privileged --network host \
           --gpus all \
           --env="DISPLAY=$DISPLAY" \
           --env="QT_X11_NO_MITSHM=1" \
           --volume="$HOME/.Xauthority:/home/hariharan/.Xauthority:rw" \
           --env XAUTHORITY=/home/hariharan/.Xauthority \
           --volume="/tmp/.X11-unix:/tmp/.X11-unix:rw" \
           -v $(pwd)/../../../:/home/hariharan/colcon_ws \
           -v $(pwd)/:/home/hariharan/custom_dockers \
           -v /dev/dri:/dev/dri \
           -v /dev/bus/usb:/dev/bus/usb \
           -v /dev/input:/dev/input \
           --rm \
           -it ${image_name}
