FROM ubuntu:20.04

ENV LANG C.UTF-8
ENV LC_ALL C.UTF-8

RUN apt update && sudo apt install curl gnupg lsb-release
RUN sudo curl -sSL https://raw.githubusercontent.com/ros/rosdistro/master/ros.key -o /usr/share/keyrings/ros-archive-keyring.gpg

RUN echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/ros-archive-keyring.gpg] http://packages.ros.org/ros2/ubuntu $(source /etc/os-release && echo $UBUNTU_CODENAME) main" | sudo tee /etc/apt/sources.list.d/ros2.list > /dev/null

RUN apt update

RUN DEBIAN_FRONTEND=noninteractive apt install -y ros-galactic-desktop


# setting up workspace
WORKDIR /root/dev_ws/src
# cloning main repo
RUN git clone https://github.com/illini-robosub/onboard-submarine.git 
WORKDIR /root/dev_ws

RUN apt update
RUN apt-get install python3-rosdep -y
RUN rosdep init
RUN rosdep update

RUN rosdep install --from-paths ~/ros2_galactic/ros2-linux/share --ignore-src -y --skip-keys "cyclonedds fastcdr fastrtps rti-connext-dds-5.3.1 urdfdom_headers"
RUN sudo apt install -y libpython3-dev python3-pip
RUN apt install python3-colcon-common-extensions -y

COPY ros2_entrypoint.sh /root/.
ENTRYPOINT ["/root/ros2_entrypoint.sh"]
CMD ["bash"]

