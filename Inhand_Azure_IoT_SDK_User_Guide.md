# Inhand Azure IoT SDK User Guide

## 1. Overview

Azure IoT Edge moves cloud analytics and custom business logic to  devices so that your organization can focus on business insights instead of data management. Scale out your IoT solution by packaging your  business logic into standard containers, then you can deploy those  containers to any of your devices and monitor it all from the cloud.

Analytics drives business value in IoT solutions, but not all  analytics needs to be in the cloud. If you want to respond to  emergencies as quickly as possible, you can run anomaly detection  workloads at the edge. If you want to reduce bandwidth costs and avoid  transferring terabytes of raw data, you can clean and aggregate the data locally then only send the insights to the cloud for analysis.

Azure IoT Edge is made up of three components:

- **IoT Edge modules** are containers that run Azure  services, third-party services, or your own code. Modules are deployed  to IoT Edge devices and execute locally on those devices.

- The **IoT Edge runtime** runs on each IoT Edge device and manages the modules deployed to each device.

- A **cloud-based interface** enables you to remotely monitor and manage IoT Edge devices.

![image-20200826110116999](images/image-20200826110116999.png)

## 2. Prerequisites

- Register an account from [Azure](https://docs.microsoft.com/en-us/azure/?product=featured)
- InVehicle G710 Gateway(VG710)
- VG710 Firmware Version: V1.0.1.r30020
- Docker SDK Version: 19.03.6
- Azure IoT Edge SDK Version: 1.1.3

## 3. Configure Azure IoT Edge

**Note**: If you have already configured the corresponding IoT Hub and IoT device on Azure IoT, you can skip this section.

### 3.1 Create IoT Hub

- Login [https://portal.azure.com](https://portal.azure.com)

- Click **IoT Hub**, next click **Add**

![image-20200826135850596](images/image-20200826135850596.png)

![image-20200826140039779](images/image-20200826140039779.png)

- Configure IoT Hub

![image-20200826140345772](images/image-20200826140345772.png)

- Configure its pricing and scale

![image-20200826140930592](images/image-20200826140930592.png)

- Finally, click **create** to finish the configuration

<img src="images/image-20200826141114718.png" alt="image-20200826141114718" style="zoom:80%;" />

- After successful creation, click **Go to resource** to enter IoT Hub page we created

![image-20200826141929501](images/image-20200826141929501.png)

### 3.2 Create IoT Edge device

- Choose **IoT Edge**, next click **Add an IoT Edge device**  

![image-20200826142238646](images/image-20200826142238646.png)

- Configure IoT Edge device name, then click **save** to finish creation

![image-20200826142516718](images/image-20200826142516718.png)

- After successful creation, record the device connection string for later use

![image-20200826142756078](images/image-20200826142756078.png)

### 3.3 Configure IoT Edge device running setting

- click **Set Modules**

![image-20200826145846046](images/image-20200826145846046.png)

- click **Running Setting**
  - Configure Edge Hub docker image version according to our chip architecture (`mcr.microsoft.com/azureiotedge-hub:1.1.3-linux-arm32v7`)
  
- map docker container 443 port to host 8443(any unused port) port due to our web service is already using port 443
  

![image-20210624163242384](images/image-20210624163242384.png)

![image-20210624155407924](images/image-20210624155407924.png)

  - (**Optional**) Restrict its memory and CPU usage. Please refer to [Restrict module memory and CPU usage](https://docs.microsoft.com/en-us/azure/iot-edge/how-to-use-create-options?view=iotedge-2018-06#restrict-module-memory-and-cpu-usage) to get more detail description.

  ![image-20210624154747818](images/image-20210624154747818.png)

- Configure Edge Agent docker image version according to our chip architecture  (`mcr.microsoft.com/azureiotedge-agent:1.1.3-linux-arm32v7`)
  

![image-20210624155650637](images/image-20210624155650637.png)

  - (**Optional**) Restrict its memory and CPU usage. Please refer to [Restrict module memory and CPU usage](https://docs.microsoft.com/en-us/azure/iot-edge/how-to-use-create-options?view=iotedge-2018-06#restrict-module-memory-and-cpu-usage) to get more detail description.

  ![image-20210624155536128](images/image-20210624155536128.png)


## 4. Configure VG710

**Note**: You should configure network to ensure that the device can access the Internet

### 4.1 Enable Docker

Because Azure IoT Edge Runtime is docker based, we should enable docker first. Steps are as follows:

<img src="images/image-20200826143757628.png" alt="image-20200826143757628" style="zoom:80%;" />

### 4.2 Enable Azure IoT Edge

- Install Azure IoT Edge SDK

![image-20200826151452778](images/image-20200826151452778.png)

- Export Azure IoT Edge configuration file

![image-20200826151931441](images/image-20200826151931441.png)

- open configuration file, change **device_connection_string** to what we recorded above, then save and import it back.

![image-20200826152445494](images/image-20200826152445494.png)

![image-20200826152703600](images/image-20200826152703600.png)

- Enable Azure IoT Edge

  ![image-20200826152922268](images/image-20200826152922268.png)

- The Azure IoT Edge daemon will pull the Agent image and create a container. The image file is large. so it will take about 5-20 minutes to complete.
You can check the container status through the Docker management page. When the Agent container is running, it means that Azure IoT Edge is already in normal working state.
  
  Steps are as follows:

![image-20200826153430375](images/image-20200826153430375.png)

![image-20200814154519669](images/image-20200814154519669.png)

![image-20200814154729127](images/image-20200814154729127.png)

![image-20200826160440915](images/image-20200826160440915.png)

## 5. Configure and deploy the module

- In Azure IoT Edge device, click **Set Moudles**

![image-20200826160931563](images/image-20200826160931563.png)

- Click **Add**, then choose **IoT Edge Module**

![image-20200826161128933](images/image-20200826161128933.png)
- Configure module name and its docker image name 

(`mcr.microsoft.com/azureiotedge-simulated-temperature-sensor:1.1.3-linux-arm32v7`)

![image-20210624160054462](images/image-20210624160054462.png)

- (**Optional**) Restrict module memory and CPU usage. Please refer to [Restrict module memory and CPU usage](https://docs.microsoft.com/en-us/azure/iot-edge/how-to-use-create-options?view=iotedge-2018-06#restrict-module-memory-and-cpu-usage) to get more detail description.

![image-20201221163522165](images/image-20201221163522165.png)

- Finally, click **Review + create** and **Create** in sequence to complete the addition.

![image-20200826165113090](images/image-20200826165113090.png)

![image-20200826165208197](images/image-20200826165208197.png)

- The Azure IoT Edge daemon will pull the added module image and create a container. It will take a few minutes. 
  You can check the container status through the Docker management page as above section

![image-20200826165746073](images/image-20200826165746073.png)

- Check module status by viewing its log

![image-20200826170026359](images/image-20200826170026359.png)

![image-20200826170211053](images/image-20200826170211053.png)