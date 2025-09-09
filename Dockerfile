FROM ubuntu:22.04


ARG UNAME=hariharan
ARG UID=1000
ARG GID=1000


RUN apt-get update && apt-get install -y --no-install-recommends \
    locales software-properties-common curl wget lsb-release gnupg \
    python3-pip tmux nano sudo lbzip2

RUN locale-gen en_US.UTF-8
RUN update-locale LC_ALL=en_US.UTF-8 LANG=en_US.UTF-8 
RUN rm -rf /var/lib/apt/lists/*



ENV LANG=en_US.UTF-8
ENV TZ=Europe/London
RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone




RUN curl -L -o /tmp/ros2-apt-source.deb https://github.com/ros-infrastructure/ros-apt-source/releases/download/1.1.0/ros2-apt-source_1.1.0.jammy_all.deb
RUN apt-get update
RUN apt install -y /tmp/ros2-apt-source.deb

ENV ROS_DISTRO=humble


RUN apt-get update && apt-get install -y \
    ros-humble-desktop ros-dev-tools \
    ros-humble-joint-state-publisher-gui \
    ros-humble-xacro \
    ros-humble-sdformat-urdf \
    python3-rosdep

RUN rosdep init && rosdep update 
RUN rm -rf /var/lib/apt/lists/*



RUN curl https://packages.osrfoundation.org/gazebo.gpg --output /usr/share/keyrings/pkgs-osrf-archive-keyring.gpg
RUN echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/pkgs-osrf-archive-keyring.gpg] http://packages.osrfoundation.org/gazebo/ubuntu-stable $(lsb_release -cs) main" \
    > /etc/apt/sources.list.d/gazebo-stable.list 
RUN apt-get update
RUN apt-get install gz-harmonic -y
RUN rm -rf /var/lib/apt/lists/*



RUN groupadd -g ${GID} ${UNAME}
RUN useradd -m -u ${UID} -g ${GID} -s /bin/bash ${UNAME} 
RUN echo "${UNAME}:${UNAME}" | chpasswd
RUN usermod -aG sudo ${UNAME}



WORKDIR /home/${UNAME}


RUN mkdir -p colcon_ws/src custom_dockers
RUN echo "source /opt/ros/humble/setup.bash" >> /home/${UNAME}/.bashrc
RUN echo 'if [ -f "/home/${UNAME}/colcon_ws/install/setup.bash" ]; then source /home/${UNAME}/colcon_ws/install/setup.bash; fi' >> /home/${UNAME}/.bashrc 
RUN echo "alias t='tmux new -s \$1'" >> /home/${UNAME}/.bashrc
RUN echo 'alias ta="tmux a -t $1"' >> /home/${UNAME}/.bashrc
RUN echo 'alias tk="tmux kill-session -t $1"' >> /home/${UNAME}/.bashrc
RUN echo 'alias tls="tmux ls"' >> /home/${UNAME}/.bashrc 
RUN echo 'alias l="ls"' >> /home/${UNAME}/.bashrc




ENV ROS_DOMAIN_ID=94
RUN pip3 install scipy

COPY entrypoint.sh /home/${UNAME}/custom_dockers/entrypoint.sh
RUN chmod +x /home/${UNAME}/custom_dockers/entrypoint.sh
USER ${UNAME}





ENTRYPOINT [ "/bin/bash" , "/home/hariharan/custom_dockers/entrypoint.sh" ]


