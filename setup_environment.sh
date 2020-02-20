#!/bin/bash

# Install ROS melodic
sudo sh -c 'echo "deb http://packages.ros.org/ros/ubuntu $(lsb_release -sc) main" > /etc/apt/sources.list.d/ros-latest.list'
sudo apt-key adv --keyserver 'hkp://keyserver.ubuntu.com:80' --recv-key C1CF6E31E6BADE8868B172B4F42ED6FBAB17C654
curl -sSL 'http://keyserver.ubuntu.com/pks/lookup?op=get&search=0xC1CF6E31E6BADE8868B172B4F42ED6FBAB17C654' | sudo apt-key add -
sudo apt update
sudo apt install ros-melodic-desktop-full -y

# Initialize rosdep
sudo rosdep init
rosdep update

# ROS environment setup
echo "source /opt/ros/melodic/setup.bash" >> ~/.bashrc
source ~/.bashrc

# Install ROS dependencies for building packages
sudo apt install python-rosinstall python-rosinstall-generator python-wstool build-essential -y

# Install catkin
sudo apt install ros-melodic-catkin python-catkin-tools -y

# Create a catkin Workspace
mkdir -p ~/ws_moveo/src
cd ~/ws_moveo/src

wstool init .
wstool merge -t . https://raw.githubusercontent.com/ros-planning/moveit/master/moveit.rosinstall
wstool update -t .

# Clone moveo_ros project into src
git clone https://github.com/urbots/moveo_ros.git

# Build catkin Workspace
rosdep install -y --from-paths . --ignore-src --rosdistro melodic
cd ~/ws_moveo
catkin config --extend /opt/ros/melodic --cmake-args -DCMAKE_BUILD_TYPE=Release
catkin build
source ~/ws_moveo/devel/setup.bash
echo 'source ~/ws_moveo/devel/setup.bash' >> ~/.bashrc
source ~/.bashrc