FROM ubuntu:focal

ARG UNAME=hariharan
ARG UID=1000
ARG GID=1000


ENV UNAME=${UNAME}


RUN apt-get update && apt-get install -y locales lsb-release
RUN apt-get install -y gnupg2
ARG DEBIAN_FRONTEND=noninteractive
RUN dpkg-reconfigure locales




ENV TZ=Europe/London
RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone




RUN sh -c 'echo "deb http://packages.ros.org/ros/ubuntu $(lsb_release -sc) main" > /etc/apt/sources.list.d/ros-latest.list'
RUN apt-get install -y curl
RUN curl -s https://raw.githubusercontent.com/ros/rosdistro/master/ros.asc | apt-key add -
RUN apt-get update --fix-missing
RUN apt-get install -y ros-noetic-desktop-full
RUN apt-get install ros-noetic-navigation ros-noetic-pr2-simulator ros-noetic-costmap-converter ros-noetic-mbf-costmap-core ros-noetic-libg2o ros-noetic-mbf-msgs ros-noetic-pr2-tuckarm python3-pip python3-catkin-tools python-is-python3 ros-noetic-marti-common-msgs ros-noetic-vision-msgs -y
RUN apt-get install python3-rosdep python3-rosinstall python3-rosinstall-generator python3-wstool build-essential python3-rosdep -y
RUN apt-get install tmux nano -y
RUN apt-get install apt-transport-https ca-certificates gnupg software-properties-common wget -y



RUN rosdep init
RUN rosdep update




RUN groupadd -g ${GID} ${UNAME}
RUN useradd -m -u ${UID} -g ${GID} -s /bin/bash ${UNAME} 
RUN echo "${UNAME}:${UNAME}" | chpasswd
RUN usermod -aG sudo ${UNAME}



WORKDIR /home/${UNAME}


RUN mkdir -p catkin_ws/src custom_dockers

RUN apt-get install libopenblas-dev -y




 
RUN echo "source /opt/ros/noetic/setup.bash" >> /home/${UNAME}/.bashrc
RUN echo "alias t='tmux new -s $1'" >> /home/${UNAME}/.bashrc
RUN echo 'alias ta="tmux a -t $1"' >> /home/${UNAME}/.bashrc
RUN echo 'alias tk="tmux kill-session -t $1"' >> /home/${UNAME}/.bashrc
RUN echo 'alias tls="tmux ls"' >> /home/${UNAME}/.bashrc 
RUN echo 'if [ -d "/home/${UNAME}/catkin_ws/devel" ]; then source /home/${UNAME}/catkin_ws/devel/setup.bash; fi' >> /home/${UNAME}/.bashrc


RUN pip3 install scipy
RUN pip install langchain-ollama langchain-core playsound gtts
COPY entrypoint.sh /home/${UNAME}/custom_dockers/entrypoint.sh
RUN chmod +x /home/${UNAME}/custom_dockers/entrypoint.sh


USER ${UNAME}


ENTRYPOINT [ "/bin/bash" , "/home/hariharan/custom_dockers/entrypoint.sh" ]


