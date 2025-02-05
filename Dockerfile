FROM ubuntu:focal
ENV TZ=Europe/London
RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone

RUN apt-get update && apt-get install -y locales lsb-release
RUN apt-get install -y gnupg2
ARG DEBIAN_FRONTEND=noninteractive
RUN dpkg-reconfigure locales

RUN sh -c 'echo "deb http://packages.ros.org/ros/ubuntu $(lsb_release -sc) main" > /etc/apt/sources.list.d/ros-latest.list'
RUN apt-get install -y curl
RUN curl -s https://raw.githubusercontent.com/ros/rosdistro/master/ros.asc | apt-key add -
RUN apt-get update --fix-missing
RUN apt-get install -y ros-noetic-desktop-full
RUN mkdir /custom_dockers
RUN apt-get update --fix-missing
RUN apt-get install python3-rosdep python3-rosinstall python3-rosinstall-generator python3-wstool build-essential python3-rosdep -y
RUN rosdep init
RUN rosdep update
ARG UNAME=hariharan
ARG UID=1000
ARG GID=1000
RUN groupadd -g ${GID} -o${UNAME}
RUN useradd -m -u ${UID} -o -s /bin/bash ${UNAME}
RUN echo 'hariharan:hariharan' | chpasswd
RUN adduser ${UNAME} sudo
WORKDIR /home/hariharan
RUN mkdir /home/hariharan/catkin_ws
RUN cp -r /custom_dockers /home/hariharan
RUN chown -R $UNAME:${UNAME} /home/hariharan
RUN chmod 775 /home/hariharan
RUN echo "source /opt/ros/noetic/setup.bash" >> /home/hariharan/.bashrc 
RUN apt-get update; apt-get install tmux -y
RUN apt-get install nano -y
RUN apt-get install apt-transport-https ca-certificates gnupg software-properties-common wget -y



RUN apt-get update 
RUN apt-get install ros-noetic-navigation ros-noetic-pr2-simulator ros-noetic-costmap-converter ros-noetic-mbf-costmap-core ros-noetic-libg2o ros-noetic-mbf-msgs ros-noetic-pr2-tuckarm python3-pip python3-catkin-tools python-is-python3 ros-noetic-marti-common-msgs ros-noetic-vision-msgs -y
RUN pip3 install scipy
RUN apt-get install libopenblas-dev -y
RUN echo "alias t='tmux new -s $1'" >> /home/hariharan/.bashrc
RUN echo 'alias ta="tmux a -t $1"' >> /home/hariharan/.bashrc
RUN echo 'alias tk="tmux kill-session -t $1"' >> /home/hariharan/.bashrc
RUN echo 'alias tls="tmux ls"' >> /home/hariharan/.bashrc 
RUN echo 'if [ -d "/home/hariharan/catkin_ws/devel" ]; then source /home/hariharan/catkin_ws/devel/setup.bash; fi' >> /home/hariharan/.bashrc
RUN cd home/hariharan;sudo chmod 777 -R .
USER root 
ENTRYPOINT [ "/bin/bash" , "/home/hariharan/custom_dockers/entrypoint.sh" ]


