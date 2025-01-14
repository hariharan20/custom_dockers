image_name=ahn_laas_noetic
#xhost + local:docker

echo "Starting docker container..."
docker run --privileged --network host \
           --gpus all \
           -e DISPLAY=$DISPLAY \
           --env="QT_X11_NO_MITSHM=1" \
           --volume="$HOME/.Xauthority:/home/hariharan/.Xauthority:rw" \
           --env XAUTHORITY=/home/hariharan/.Xauthority \
	   -v /tmp/.X11-unix:/tmp/.X11-unix \
           -v $(pwd)/../:/home/hariharan/catkin_ws/src \
           -v /dev/dri:/dev/dri \
  	   -v /dev/bus/usb:/dev/bus/usb \
	   -v /dev/input:/dev/input \
           --rm \
           -it ${image_name}
