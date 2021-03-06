### BASE STAGE ###

# Build from ros dev box
FROM jgkawell/ros:base AS base

# Install MoveIt! (https://moveit.ros.org/install/source/):
RUN apt -y update && apt -y install python-catkin-tools clang-format-3.9
RUN cd ~/ \
        && mkdir catkin_ws \
        && cd catkin_ws \
        && wstool init src \
        && wstool merge -t src https://raw.githubusercontent.com/cairo-robotics/moveit/custom-cost-kinetic/moveit.rosinstall \
        && wstool update -t src \
        && rosdep -y install --from-paths src --ignore-src --rosdistro kinetic \
        && catkin config --extend /opt/ros/kinetic --cmake-args -DCMAKE_BUILD_TYPE=Release \
        && catkin config --blacklist \
                moveit_chomp_optimizer_adapter \
                moveit_planners_chomp \
                chomp_motion_planner

# Install OMPL (http://ompl.kavrakilab.org/installation.html):
RUN apt -y update && apt -y install pkg-config libboost-serialization-dev libboost-filesystem-dev libboost-system-dev libboost-program-options-dev libboost-test-dev libode-dev wget
RUN cd  ~/catkin_ws/src \
        && git clone https://github.com/cairo-robotics/ompl.git \
        && cd ompl \
        && git checkout custom-cost

# Copy in package.xml into OMPL for ROS building
COPY ./config/package.xml /root/catkin_ws/src/ompl/package.xml

# Finally install MoveIt! with our source OMPL
RUN cd ~/catkin_ws && catkin build

# Copy over config files
RUN cd ~/catkin_ws && mkdir config
COPY ./config/panda_demo.rviz /root/catkin_ws/config/panda_demo.rviz
COPY ./config/pillar.scene /root/catkin_ws/config/pillar.scene

# Source the workspace with each new terminal
RUN echo "source ~/catkin_ws/devel/setup.bash" >> ~/.bashrc

# Clean up apt
RUN rm -rf /var/lib/apt/lists/*


### NVIDIA STAGE ###

# Extra needed setup for Nvidia-based graphics
FROM base AS nvidia

# Copy over needed OpenGL files from Nvidia's image
COPY --from=nvidia/opengl:1.0-glvnd-runtime-ubuntu16.04 /usr/local /usr/local
COPY --from=nvidia/opengl:1.0-glvnd-runtime-ubuntu16.04 /etc/ld.so.conf.d/glvnd.conf /etc/ld.so.conf.d/glvnd.conf
