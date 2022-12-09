# VG Docker SDK Install and Usage Guide

## 1. Device Login

Using a PC to connect to the network port of the VG device, and log in to the device as shown in the following figure

![image-20220913183424623](images/image-20220913183424623.png)

## 2. Docker SDK Install

Docker SDK integrates docker runtime and docker image manager required to run docker images. Docker SDK must be installed before using Docker.

![image-20220913183129035](images/image-20220913183129035.png)

After the installation is complete

![image-20220913183613444](images/image-20220913183613444.png)

## 3. Enable Docker

Enable Docker as below picture.

![image-20220913183828502](images/image-20220913183828502.png)

## 4. Using Portainer to Manage Docker Image and Container

### 4.1 Login Portainer

As below picture, click the link to jump to the portainer login page

![image-20220913183942760](images/image-20220913183942760.png)

If you encounter the following problems, please do as shown below

![image-20220913184250642](images/image-20220913184250642.png)

Input username and password(default is `admin/12345678`)

![image-20220913184407669](images/image-20220913184407669.png)

Choose `local` enviroment

![image-20220913184550535](images/image-20220913184550535.png)

![image-20220913184702395](images/image-20220913184702395.png)

### 4.2 Pull Docker Image

#### 4.2.1 Import Docker Image Locally

**NOTE**： Docker image should be in `armv7` architecture.

![image-20220913184908772](images/image-20220913184908772.png)

#### 4.2.2 Pull Docker Image via registry

Pull Docker image as below picture (`nginx:latest` is as an example)

**NOTE** : If image name does not contains tag, the tag is latest.

![image-20220913185048861](images/image-20220913185048861.png)

After the pull is successful, the picture is as follows

![image-20220913185302218](images/image-20220913185302218.png)

### 4.3 Create Docker Contaner

enter `Containers` page，choose `Add container`

![image-20220913185403317](images/image-20220913185403317.png)

Create Docker image as below picture（nginx-example is an example）

![image-20220913185935180](images/image-20220913185935180.png)

After the creation is successful, try to access in the browser as below picture.

![image-20220913200846727](images/image-20220913200846727.png)