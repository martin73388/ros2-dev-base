FROM osrf/ros:jazzy-desktop-full
ARG USERNAME=rosuser
ARG USER_UID=1000
ARG USER_GID=1000
USER root
RUN groupadd --gid $USER_GID $USERNAME \
    && useradd -s /bin/bash --uid $USER_UID --gid $USER_GID -m $USERNAME \
    && echo $USERNAME ALL=\(ALL\) NOPASSWD:ALL > /etc/sudoers.d/$USERNAME
USER $USERNAME
ENV HOME /home/$USERNAME
WORKDIR /home/$USERNAME/ros2_ws
RUN sudo apt-get update && sudo apt-get install -y \
    python3-pip \
    python3-colcon-common-extensions \
    git \
    nano \
    ros-jazzy-rosbridge-suite \
    ros-jazzy-tf2-ros \
    ros-jazzy-message-filters \
    && sudo rm -rf /var/lib/apt/lists/*
RUN echo "source /opt/ros/jazzy/setup.bash" >> ~/.bashrc \
    && echo "source /home/$USERNAME/ros2_ws/install/setup.bash" >> ~/.bashrc
RUN mkdir -p /home/$USERNAME/ros2_ws/src
