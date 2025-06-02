FROM ubuntu:jammy




RUN apt update &&  apt install locales -y 
RUN locale-gen en_US en_US.UTF-8
RUN update-locale LC_ALL=en_US.UTF-8 LANG=en_US.UTF-8
RUN export LANG=en_US.UTF-8
RUN apt install software-properties-common -y
RUN add-apt-repository universe




RUN apt install curl -y
RUN apt install wget -y
RUN export ROS_APT_SOURCE_VERSION=1.1.0
RUN curl -L -o /tmp/ros2-apt-source.deb https://github.com/ros-infrastructure/ros-apt-source/releases/download/1.1.0/ros2-apt-source_1.1.0.jammy_all.deb
RUN apt install /tmp/ros2-apt-source.deb

RUN mkdir /ros2_humble

RUN wget -O /ros2_humble/ros2_file.tar.bz2 https://github.com/ros2/ros2/releases/download/humble-20250331/ros2-humble-20250331-linux-jammy-amd64.tar.bz2
RUN cd /ros2_humble && ls 
RUN apt-get update && apt-get install -y lbzip2

RUN cd /ros2_humble && tar xf /ros2_humble/ros2_file.tar.bz2


ENV TZ=Europe/London
RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone


RUN apt update
RUN apt install -y python3-rosdep
RUN rosdep init

ENV ROS_DISTRO=humble

RUN rosdep update
RUN apt upgrade -y
RUN apt update
RUN rosdep install --from-paths /ros2_humble/ros2-linux/share --ignore-src -y --skip-keys "cyclonedds fastcdr fastrtps rti-connext-dds-6.0.1 urdfdom_headers"
RUN apt install -y ros-humble-desktop --fix-missing
RUN apt install ros-dev-tools -y
RUN apt install ros-dev-tools


ARG UNAME=hariharan
ARG UID=1000
ARG GID=1000
RUN groupadd -g ${GID} -o${UNAME}
RUN useradd -m -u ${UID} -o -s /bin/bash ${UNAME}
RUN echo 'hariharan:hariharan' | chpasswd
RUN adduser ${UNAME} sudo
WORKDIR /home/hariharan



RUN mkdir /home/hariharan/colcon_ws
RUN mkdir /custom_dockers
RUN cp -r /custom_dockers /home/hariharan
RUN chown -R $UNAME:${UNAME} /home/hariharan
RUN apt-get update; apt-get install tmux -y
RUN apt-get install nano -y


RUN apt-get install -y python3-pip
RUN pip3 install scipy
RUN echo "alias t='tmux new -s $1'" >> /home/hariharan/.bashrc
RUN echo 'alias ta="tmux a -t $1"' >> /home/hariharan/.bashrc
RUN echo 'alias tk="tmux kill-session -t $1"' >> /home/hariharan/.bashrc
RUN echo 'alias tls="tmux ls"' >> /home/hariharan/.bashrc 
RUN echo "source /opt/ros/humble/setup.bash" >> /home/hariharan/.bashrc
RUN echo 'alias l="ls"' >> /home/hariharan/.bashrc

RUN echo 'if [ -d "/home/hariharan/colcon_ws/install" ]; then source /home/hariharan/colcon_ws/install/setup.bash; fi' >> /home/hariharan/.bashrc

RUN chmod -R 777 /home/hariharan
USER root 


ENTRYPOINT [ "/bin/bash" , "/home/hariharan/custom_dockers/entrypoint.sh" ]


