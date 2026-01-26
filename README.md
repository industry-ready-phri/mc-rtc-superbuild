# Industry Ready PHRI: A Control Framework for Physical Human-Robot Interaction Toward Industrial Applications

This repository contains the complete code base used in the paper:

> **"Demonstrating a Control Framework for Physical Human-Robot Interaction Toward Industrial Applications"**

![Static Badge](https://img.shields.io/badge/Paper_status-Accepted-brightgreen?style=flat)

This work presents a novel control framework for physical human-robot interaction (PHRI) aimed at industrial applications. The repository is built on a modified version of the [mc-rtc-superbuild](https://github.com/mc-rtc/mc-rtc-superbuild) infrastructure. It has been adapted to automatically install all required dependencies and build the code necessary for the controller used to perform the experiments and results described in the paper.

For more details, please visit the project website:  
[https://industry-ready-phri.github.io/](https://industry-ready-phri.github.io/)

---

## Overview

This superbuild repository will:
1. **Install all required system dependencies.**
2. **Clone and configure all necessary project repositories.**
3. **Build and install the projects** in a consistent and reproducible manner.

By using this repository, you can reproduce the experiments from the paper, test modifications, or extend the framework for your own research.

---

## Requirements

- **CMake ≥ 3.20**  
  [Download CMake](https://cmake.org/download/)
- **Git**  
  [Download Git](https://git-scm.com/)
- **Build Tools** (e.g., `build-essential` on Debian/Ubuntu)  
- **Operating System:** Tested on Linux (Debian/Ubuntu) and macOS  
  *(For Windows users, Visual Studio 2019 or later is required.)*

---

## Installation

First, make sure you have configured `git`:
```sh
git config --global user.name "Full Name"
git config --global user.email "your.email@provider.com"
```

### 1. Clone the Repository in your Workspace

```sh
mkdir -p ~/workspace && cd ~/workspace
git clone https://github.com/industry-ready-phri/mc-rtc-superbuild.git
```

### 2. Bootstrap the Environment
Navigate to the cloned repository’s superbuild folder:
```sh
cd ~/workspace/mc-rtc-superbuild
```

Then run the bootstrap script to install system dependencies:
- On Debian-like systems:
```sh
./utils/bootstrap-linux.sh
```

- On macOS:
```sh
./utils/bootstrap-macos.sh
```

### 3. Configure and Build

Configure the superbuild by specifying where the source code should be cloned and where the build files will be generated. For example:

```sh
cd ~/workspace
cmake -S mc-rtc-superbuild -B mc-rtc-superbuild/build -DSOURCE_DESTINATION=${HOME}/workspace/src -DBUILD_DESTINATION=${HOME}/workspace/build -DCMAKE_INSTALL_PREFIX=${HOME}/workspace/install
```

Then, build the complete project:
```sh
cmake --build mc-rtc-superbuild/build --target install --config RelWithDebInfo
```

Please make sure to copy given source command to your `bashrc` or `zshrc`.
If they are not provided try to do:
```bash
cd ~/workspace/mc-rtc-superbuild/build
cmake .
```

Otherwise you should add at least (edit username and python version):
```bash
export PATH=/home/{$USER}/workspace/install/bin:$PATH
export PKG_CONFIG_PATH=/home/{$USER}/workspace/install/lib/pkgconfig:$PKG_CONFIG_PATH
export LD_LIBRARY_PATH=/home/{$USER}/workspace/install/lib:$LD_LIBRARY_PATH
export PYTHONPATH=/home/{$USER}/workspace/install/lib/python3.{$VERSION}/site-packages:$PYTHONPATH
source /home/{$USER}/workspace/src/catkin_ws/install/setup.bash
```

You can execute the command `ccmake .` in the build folder (`~/workspace/mc-rtc-superbuild/build`) to look at the available options (You need to install at least the documentation to use Rviz). NB: You may need to build again after ccmake

If you encounter an error with this file: ~/workspace/src/catkin_data_ws/install/share/kortex_description/grippers/robotiq_2f_85/urdf/robotiq_2f_85_macro.xacro --> You can remove the arguments after use_fake_hardware (the lines with: mock_sensor_commands, sim_gazebo, sim_isaac, isaac_joint_commands, isaac_joint_states)

If you want to use the bota sensor you must install the bota_driver in ~/workspace/src/catkin_data/src and follow the official tutorial here: https://gitlab.com/botasys/legacy/bota_driver/-/tree/iron-devel?ref_type=heads

---

# Files to create
###  mc_rtc config file:
```shell
mkdir -p ~/.config/mc_rtc && nano ~/.config/mc_rtc/mc_rtc.yaml
```
With this content:

```yaml
# MainRobot: Kinova
MainRobot: KinovaCamera
# MainRobot: KinovaCameraGripper
# MainRobot: KinovaBotaDS4
# MainRobot: KinovaBota
Enabled: MonodzukuriKinovaDemo
Plugins: [ExternalForcesEstimator, mc_joystick_plugin]
Timestep: 0.001
LogPolicy: threaded

Kortex:
  init_posture:
    on_startup: false
    posture: [0.0,0.4173, 3.1292, -2.1829, 0.0, 1.0342, 1.5226]
  torque_control:
    mode: custom
    lambda: [1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0]
    friction_compensation:
        velocity_threshold: 0.05 # in rad
        acceleration_threshold: 5 # in rad, for cases where velocity is below threshold
        stiction: [2.7, 2.7, 2.7, 2.7, 1.5, 1.5, 1.5]
        coulomb: [2.7, 2.7, 2.7, 2.7, 1.5, 1.5, 1.5]
        viscous: [1.0, 1.0, 1.0, 1.0, 0.0, 0.0, 0.0]
    integral_term:
      theta: 2
      gain: 10

  kinova: # Name of the robot in the controller
    ip: 192.168.1.10
    username: admin
    password: admin

  kinova_bota: # Name of the robot in the controller
    ip: 192.168.1.10
    username: admin
    password: admin

  kinova_bota_ds4: # Name of the robot in the controller
    ip: 192.168.1.10
    username: admin
    password: admin

  kinova_camera: # Name of the robot in the controller
    ip: 192.168.1.10
    username: admin
    password: admin

  kinova_camera_gripper: # Name of the robot in the controller
    ip: 192.168.1.10
    username: admin
    password: admin
```

###  External forces plugin config file:
```shell
mkdir -p ~/.config/mc_rtc/plugins && nano ~/.config/mc_rtc/plugins/ExternalForcesEstimator.yaml
```

With this content:
	
```yaml
# KinovaGen3
residual_gain: 50
# reference_frame: tool_frame
reference_frame: end_effector_link
verbose: false
ft_sensor_name: none
use_force_sensor: false
# ft_sensor_name: EEForceSensor
# use_force_sensor: true
torque_source_type: JointTorqueMeasurement
residual_speed_gain: 100
```

# Some convenient alias to add to .bashrc
-  building mc_rtc:
```
alias mc_build='cd ~/workspace/mc-rtc-superbuild/build; cmake --build . --config RelWithDebInfo'
```
-  Launch rviz:
```
alias mc_rviz="ros2 launch mc_rtc_ticker display.launch" 
```
-  Modify the mc_rtc config:
```
alias mc_config="nano ~/.config/mc_rtc/mc_rtc.yaml &" 
```
# Running time

#### To run the controller in simulation
```bash
mc_mujoco --sync
```
#### To run the controller on the real-robot
```
mc_kortex
```
#### For the GUI on real-robot
```shell
mc_rviz
```

### Kinova Gen3 – Required setup before running on the real robot

Before running the `mc_kortex` command, make sure the robot is in the **home position**. In addition, you must reset the **joint torque sensors** every time the robot is powered on and periodically during operation (approximately once per hour).

To reset the torque offsets, open the [Kinova web application](http://192.168.1.10/monitoring):

1. **Move the robot to the zero position**

   * Click **Actions**.
   * Select **Zero**.
   * Press the **Play** button and wait until the robot reaches the zero position.

2. **Reset the torque offsets**

   * Click the **three-line menu** (top left).
   * Go to **Configurations → Robot**.
   * In the **Arm** tab, select **Base**.
   * Click **Set All Actuators Torque Offset to Zero**.

3. **Verify the reset**

   * Open the **three-line menu** again.
   * Go to **Systems → Monitoring**.
   * Check that all actuator torque values are close to zero.

4. **Return the robot to the home position**

   * Use the same procedure as above via **Actions**, **or**
   * Press the **`B` button** on the Kinova Xbox controller.

Only after completing these steps should you start the controller on the real robot.

## Details

For further details on how to extend the superbuild, please refer to the original [mc-rtc-superbuild documentation](https://github.com/mc-rtc/mc-rtc-superbuild).

---

## Citation

If you use this code in your research, please cite the paper as follows:

```BibTex
@INPROCEEDINGS{muraccioli2025rss, 
    AUTHOR    = {Bastien Muraccioli AND Mathieu Celerier AND Mehdi Benallegue AND Gentiane Venture}, 
    TITLE     = {{Demonstrating a Control Framework for Physical Human-Robot Interaction Toward Industrial Applications}}, 
    BOOKTITLE = {Proceedings of Robotics: Science and Systems}, 
    YEAR      = {2025}, 
    ADDRESS   = {LosAngeles, CA, USA}, 
    MONTH     = {June}, 
    DOI       = {10.15607/RSS.2025.XXI.084} 
}
```

---

## Contact

For any questions or issues, please open an issue in this repository or contact [bastien.muraccioli@aist.go.jp] or [mathieu.celerier@aist.go.jp].


---

This modified README now serves as a self-contained guide for reproducing the work associated with the paper, while maintaining the original superbuild functionality. Adjust paths, URLs, and other details as appropriate for your repository and project requirements.
