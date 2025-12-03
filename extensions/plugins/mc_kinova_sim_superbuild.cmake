include(${CMAKE_CURRENT_LIST_DIR}/../superbuild-extensions/simulation/MuJoCo.cmake)

AptInstall(libxrandr-dev libxinerama-dev libxcursor-dev libxi-dev libglew-dev)

AddProject(mc_mujoco
  GITHUB_PRIVATE bastien-muraccioli/mc_mujoco
  GIT_TAG origin/safe-rl-qp
  CMAKE_ARGS -DMUJOCO_ROOT_DIR=${MUJOCO_ROOT_DIR}
  DEPENDS mc_rtc
)

if(NOT WITH_ROS_SUPPORT)
  message(FATAL_ERROR "ROS support is required to use the Kinova robot")
endif()

if(ROS_IS_ROS2)
  #AptInstall(
    #ros-${ROS_DISTRO}-kortex-api ros-${ROS_DISTRO}-kortex-bringup
    #ros-${ROS_DISTRO}-kortex-description ros-${ROS_DISTRO}-kortex-driver
  #)

  AddCatkinProject(ros2_kortex
    GITHUB_PRIVATE bastien-muraccioli/ros2_kortex
    GIT_TAG origin/main
    WORKSPACE data_ws
  )

  AddProject(mc_kinova
  GITHUB_PRIVATE mathieu-celerier/mc_kinova
  GIT_TAG origin/external-forces-no-bota
  DEPENDS mc_rtc
  #APT_PACKAGES mc_rtc ros-${ROS_DISTRO}-kortex-api ros-${ROS_DISTRO}-kortex-bringup
                 #ros-${ROS_DISTRO}-kortex-description ros-${ROS_DISTRO}-kortex-driver
  )
else()
  AddCatkinProject(
    ros_kortex
    GITHUB Kinovarobotics/ros_kortex
    GIT_TAG origin/${ROS_DISTRO}-devel
    WORKSPACE data_ws
  )

  #AddProject(
    #mc_kinova
    #GITHUB isri-aist/mc_kinova
    #GIT_TAG origin/main
    #DEPENDS mc_rtc ros_kortex
  #)
  AddProject(mc_kinova
  GITHUB_PRIVATE mathieu-celerier/mc_kinova
  GIT_TAG origin/main-external-forces
  DEPENDS mc_rtc ros_kortex
  )
endif()


#if(NOT WITH_ROS_SUPPORT)
  #message(FATAL_ERROR "ROS support is required to use the Kinova robot")
#endif()

#if(${ROS_DISTRO} STREQUAL "jazzy")
  #execute_process(COMMAND bash -c "sudo curl https://packages.osrfoundation.org/gazebo.gpg --output /usr/share/keyrings/pkgs-osrf-archive-keyring.gpg")
  #set(GAZEBO_MIRROR "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/pkgs-osrf-archive-keyring.gpg] http://packages.osrfoundation.org/gazebo/ubuntu-stable $(lsb_release -cs)")
  #execute_process(COMMAND sudo bash -c "echo \"${GAZEBO_MIRROR} main\" | sudo tee /etc/apt/sources.list.d/gazebo-stable.list > /dev/null")
  #AptInstall(gz-harmonic)
#else()
  #AptInstall(ros-${ROS_DISTRO}-gazebo-ros)
#endif()

#AptInstall(
  #ros-${ROS_DISTRO}-controller-manager
  #ros-${ROS_DISTRO}-control-msgs
  #ros-${ROS_DISTRO}-control-toolbox
  #ros-${ROS_DISTRO}-moveit-ros-planning-interface
#)

## Install conan if needed
#find_program(CONAN conan)
#if(NOT CONAN)
  #find_program(PYTHON3 python3)
  #if(NOT PYTHON3)
    #message(FATAL_ERROR "Must have python3 to install conan to use the Kinova robot")
  #endif()
  ##execute_process(COMMAND /usr/bin/python3 -m pip install --break-system-packages conan>=1.60.1 COMMAND_ERROR_IS_FATAL ANY)
  #find_program(CONAN conan)
  #if(NOT CONAN)
    #message(FATAL_ERROR "Conan installation went wrong")
  #endif()
  #file(REAL_PATH ${CMAKE_C_COMPILER} CONAN_C_COMPILER)
  #file(REAL_PATH ${CMAKE_CXX_COMPILER} CONAN_CXX_COMPILER)
  #execute_process(COMMAND ${CMAKE_COMMAND} -E env CC=${CONAN_C_COMPILER} CXX=${CONAN_CXX_COMPILER} ${CONAN} profile new default --detect COMMAND_ERROR_IS_FATAL ANY)
  #execute_process(COMMAND ${CONAN} profile update settings.compiler.libcxx=libstdc++11 default COMMAND_ERROR_IS_FATAL ANY)
#endif()
#if(CONAN_VERSION_OUTPUT MATCHES "Conan version (1\\.[0-9]+\\.[0-9]+)")
  ## Conan 1.x
  #execute_process(
    #COMMAND ${CONAN} config set general.revisions_enabled=1
    #RESULT_VARIABLE CONAN_RESULT
  #)
#else()
  ## Conan 2.x
  #file(WRITE "${CMAKE_CURRENT_BINARY_DIR}/conan_global.conf" "core.revisions_enabled=1\n")
  #execute_process(
    #COMMAND ${CONAN} config install "${CMAKE_CURRENT_BINARY_DIR}/conan_global.conf"
    #RESULT_VARIABLE CONAN_RESULT
  #)
#endif()

#if(NOT CONAN_RESULT EQUAL 0)
  #message(FATAL_ERROR "Failed to set Conan revisions_enabled option")
#endif()
#if(${ROS_DISTRO} STREQUAL "humble")
  #AptInstall(
    #ros-humble-kortex-bringup
    #ros-humble-kinova-gen3-7dof-robotiq-2f-85-moveit-config
  #)
  #AddCatkinProject(ros2_kortex
    #GITHUB_PRIVATE Kinovarobotics/ros2_kortex
    #GIT_TAG origin/main
    #WORKSPACE data_ws
  #)
#else()
  #AddCatkinProject(ros2_kortex
    #GITHUB_PRIVATE Kinovarobotics/ros2_kortex
    #GIT_TAG origin/main
    #WORKSPACE data_ws
  #)
#endif()
#AddProject(mc_kinova
  #GITHUB_PRIVATE mathieu-celerier/mc_kinova
  #GIT_TAG origin/main-external-forces
  #DEPENDS mc_rtc
#)

function(AddKinovaMujocoModel)
  if(NOT TARGET mc_mujoco)
    return()
  endif()
  AddProject(kinova_mj_description
    GITHUB_PRIVATE bastien-muraccioli/kinova_mj_description
    GIT_TAG origin/main
    DEPENDS mc_mujoco mc_kinova
  )
endfunction()
cmake_language(DEFER CALL AddKinovaMujocoModel)
