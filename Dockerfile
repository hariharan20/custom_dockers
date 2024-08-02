FROM ubuntu:bionic
ENV TZ=Europe/London
RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone

RUN apt-get update && apt-get install -y locales lsb-release
RUN apt-get install -y gnupg2
ARG DEBIAN_FRONTEND=noninteractive
RUN dpkg-reconfigure locales





# ENV ROS_DISTRO humble
# ARG INSTALL_PACKAGE=desktop
RUN sh -c 'echo "deb http://packages.ros.org/ros/ubuntu $(lsb_release -sc) main" > /etc/apt/sources.list.d/ros-latest.list'
RUN apt-get install -y curl
RUN curl -s https://raw.githubusercontent.com/ros/rosdistro/master/ros.asc | apt-key add -
RUN apt-get update
RUN apt-get install -y ros-melodic-desktop-full
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


RUN mkdir -p /catkin_ws/src 
# RUN cd /catkin_ws; ./opt/ros/melodic/setup.bash
# RUN cd /catkin_ws; colcon build --symlink-install --executor sequential


RUN apt-get install -y python-rosdep python-rosinstall python-rosinstall-generator python-wstool build-essential && rosdep init

RUN rosdep update
ARG UNAME=hariharan
ARG UID=1000
ARG GID=1000
RUN groupadd -g ${GID} -o${UNAME}
RUN useradd -m -u ${UID} -o -s /bin/bash ${UNAME}
RUN echo 'hariharan:hariharan' | chpasswd
RUN adduser ${UNAME} sudo
WORKDIR /home/hariharan/catkin_ws
RUN cp -r /catkin_ws /home/hariharan
RUN chown -R $UNAME:${UNAME} /home/hariharan
RUN chmod 775 /home/hariharan
RUN echo "source /opt/ros/melodic/setup.bash" >> ~/.bashrc 
RUN echo "source /home/hariharan/catkin_ws/devel/setup.bash" >> /home/hariharan/.bashrc
# RUN echo "source /opt/ros/humble/setup.bash" >> /home/hariharan/.bashrc
RUN apt-get update; apt-get install tmux -y
RUN apt-get install nano -y
RUN apt-get install ros-melodic-costmap-2d -y
RUN apt-get install ros-melodic-base-local-planner -y
RUN apt-get install ros-melodic-costmap-converter -y
# RUN apt-get install ros-melodic-mbf-costmap-msgs - y
RUN apt-get install ros-melodic-navigation -y
RUN apt-get install apt-transport-https ca-certificates gnupg software-properties-common wget -y
RUN wget -O - https://apt.kitware.com/keys/kitware-archive-latest.asc 2>/dev/null | sudo apt-key add -
RUN apt-add-repository 'deb https://apt.kitware.com/ubuntu/ bionic main'
RUN apt-get install cmake -y
RUN add-apt-repository ppa:ubuntu-toolchain-r/test
RUN apt-get update
RUN apt install gcc-10 g++-10 -y
# RUN update-alternatives --remove-all gcc && update-alternatives --remove-all g++
RUN update-alternatives --install /usr/bin/gcc gcc /usr/bin/gcc-10 30  && update-alternatives --install /usr/bin/g++ g++ /usr/bin/g++-10 30 
# RUN update-alternatives --config gcc &&
RUN apt-get install ros-melodic-mbf-costmap-core ros-melodic-mbf-msgs -y
RUN apt-get install libsuitesparse-dev libopenblas-dev -y
RUN apt-get install ros-melodic-pr2-simulator -y
#RUN source /opt/ros/humble/setup.bash
# RUN apt install ros-humble-xacro -y
# RUN apt install ros-humble-ros2-control -y
# RUN apt install ros-humble-ros2-controllers -y
# RUN apt install ros-humble-gazebo-ros2-control -y
# RUN apt-get update 
# RUN apt-get install build-essential
RUN cd home/hariharan/catkin_ws;sudo chmod 777 -R .
# colcon build --symlink-install --executor sequential
USER root 
ENTRYPOINT [ "/bin/bash" , "/home/hariharan/catkin_ws/src/custom_dockers/entrypoint.sh" ]


