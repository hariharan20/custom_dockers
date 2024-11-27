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
# RUN apt-get update -q && \
    # apt-get install -y curl gnupg2 lsb-release && \
    # curl -sSL https://raw.githubusercontent.com/ros/rosdistro/master/ros.key -o /usr/share/keyrings/ros-archive-keyring.gpg && \
    # echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/ros-archive-keyring.gpg] http://packages.ros.org/ros2/ubuntu $(lsb_release -cs) main" | tee /etc/apt/sources.list.d/ros2.list > /dev/null && \
    # apt-get update -q && \
    # apt-get install -y ros-${ROS_DISTRO}-${INSTALL_PACKAGE} \
    # python3-argcomplete \
    # python3-colcon-common-extensions \
    # python3-rosdep python3-vcstool && \
    # rosdep init && \
    # rm -rf /var/lib/apt/lists/*


# RUN mkdir -p /catkin_ws/src 
# RUN cd /catkin_ws; ./opt/ros/melodic/setup.bash
# RUN cd /catkin_ws; colcon build --symlink-install --executor sequential

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
# RUN cp -r /catkin_ws /home/hariharan
RUN chown -R $UNAME:${UNAME} /home/hariharan
RUN chmod 775 /home/hariharan
RUN echo "source /opt/ros/noetic/setup.bash" >> /home/hariharan/.bashrc 
# RUN echo "source /home/hariharan/catkin_ws/devel/setup.bash" >> /home/hariharan/.bashrc
# RUN echo "source /opt/ros/humble/setup.bash" >> /home/hariharan/.bashrc
RUN apt-get update; apt-get install tmux -y
RUN apt-get install nano -y
RUN apt-get install apt-transport-https ca-certificates gnupg software-properties-common wget -y



# ROS Packages 
RUN apt-get update 
RUN apt-get install ros-noetic-navigation ros-noetic-pr2-simulator ros-noetic-costmap-converter ros-noetic-mbf-costmap-core ros-noetic-libg2o ros-noetic-mbf-msgs ros-noetic-pr2-tuckarm python3-pip python3-catkin-tools python-is-python3 ros-noetic-marti-common-msgs ros-noetic-vision-msgs -y
RUN pip3 install scipy
RUN apt-get install libopenblas-dev -y
# RUN apt-get install ros-melodic-costmap-2d -y
# RUN apt-get install ros-melodic-base-local-planner -y
# RUN apt-get install ros-melodic-costmap-converter -y
# RUN apt-get install ros-melodic-navigation -y
# RUN apt-get install ros-melodic-mbf-costmap-core ros-melodic-mbf-msgs -y
# RUN apt-get install libsuitesparse-dev libopenblas-dev -y
# RUN apt-get install ros-melodic-pr2-simulator -y
RUN echo "alias t='tmux new -s $1'" >> /home/hariharan/.bashrc
RUN echo 'alias ta="tmux a -t $1"' >> /home/hariharan/.bashrc
RUN echo 'alias tk="tmux kill-session -t $1"' >> /home/hariharan/.bashrc
RUN echo 'alias tls="tmux ls"' >> /home/hariharan/.bashrc 

RUN cd home/hariharan;sudo chmod 777 -R .
# colcon build --symlink-install --executor sequential
USER root 
ENTRYPOINT [ "/bin/bash" , "/home/hariharan/custom_dockers/entrypoint.sh" ]


