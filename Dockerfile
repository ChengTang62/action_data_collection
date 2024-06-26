FROM ros:humble

RUN apt-get update && apt-get install -y \
    build-essential \
    cmake \
    git \
    python3-colcon-common-extensions \
    python3-pip \
    python3-rosdep \
    wget \
    gnutls-bin \
    libpoco-dev \ 
    ros-humble-hardware-interface \
    ros-humble-generate-parameter-library \
    ros-humble-ros2-control-test-assets \
    ros-humble-controller-manager \
    ros-humble-control-msgs \
    ros-humble-xacro \
    ros-humble-angles \
    ros-humble-ros2-control \
    ros-humble-realtime-tools \
    ros-humble-control-toolbox \
    ros-humble-moveit \
    ros-humble-ros2-controllers \
    ros-humble-joint-state-publisher \
    ros-humble-joint-state-publisher-gui \
    ros-humble-ament-cmake \
    ros-humble-ament-cmake-clang-format

RUN if [ ! -f /etc/ros/rosdep/sources.list.d/20-default.list ]; then rosdep init; fi
RUN rosdep update
RUN mkdir -p /workspace/src

RUN cd /workspace && \
    rosdep install --from-paths src --ignore-src -r -y

RUN . /opt/ros/humble/setup.sh && \
    cd /workspace && \
    colcon build --cmake-args -DCMAKE_BUILD_TYPE=Release

RUN echo "source /workspace/install/setup.bash" >> ~/.bashrc

ENV ROS_SECURITY_KEYSTORE=/workspace/keys/keystore
ENV ROS_SECURITY_ENABLE=true
ENV ROS_SECURITY_STRATEGY=Enforce

CMD ["bash"]
