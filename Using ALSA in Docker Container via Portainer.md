# Using ALSA in Docker Container

## 1. Pull Base Image

![image-20220919093418910](images/image-20220919093418910.png)

## 2. Create ALSA base Image

![image-20220919094716347](images/image-20220919094716347.png)

![image-20220919094011018](images/image-20220919094011018.png)

![image-20220919094032420](images/image-20220919094032420.png)



## 3. ALSA Settings In Container

Enter into Container as below picture

![image-20220919094825370](images/image-20220919094825370.png)

![image-20220919094832441](images/image-20220919094832441.png)

Next, enter the command in the following window

![image-20220919094923351](images/image-20220919094923351.png)

```sh
# replace package source(optional)
sed -i -e 's|ports.ubuntu.com|mirrors.tuna.tsinghua.edu.cn|g' /etc/apt/sources.list
# update apt database
apt update
# install alse and tftp packages
apt install alsa-base tftp
```

Finally, use tftp to download test audio file

**Note:** You need to setup a tftp server 

```sh
tftp 10.5.47.8
tftp> get yesterday_once_more.wav
Received 42799386 bytes in 44.8 seconds
tftp> quit
```

## 4. ALSA Test

Check playback hardware devices

![image-20220919095755026](images/image-20220919095755026.png)

Check capture hardware devices

![image-20220919095842598](images/image-20220919095842598.png)

Please refer to VG814 Specifications (Road Transport) V2.3.1.pdf  to connect cables.

![image-20220919105223435](images/image-20220919105223435.png)

Test play

```sh
aplay -Dhw:0,0 yesterday_once_more.wav
```

Test capture and play(capture then play)

```sh
arecord -Dhw:0,0 -f cd -r 44100 -c 1 -t wav  | aplay -Dhw:0,0
```

## 5. Save Container to Image

You can follow the steps below to create audio base image.

- remove audio file and disconect

![image-20220919102419945](images/image-20220919102419945.png)

![image-20220919100830811](images/image-20220919100830811.png)

- create image

![image-20220919102521965](images/image-20220919102521965.png)

![image-20220919102622608](images/image-20220919102622608.png)

Then we can export image as below picture

![image-20220919102806312](images/image-20220919102806312.png)