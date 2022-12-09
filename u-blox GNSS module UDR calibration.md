# u-blox GNSS UDR Fusion Mode Check

## 1.  Download u-center software

Please download and install u-center software as below:

![image-20220105183726239](images/image-20220105183726239.png)

## 2. Enable GNSS debug mode

### 2.1 Enable GNSS

![image-20220105183851367](images/image-20220105183851367.png)

### 2.2 Enable GNSS debug mode

GNSS program will forward GNSS data to `ip:port` via TCP when you enable GNSS debug.

- `ip` is the device ip
- `port` is defined as below

![image-20220105184303247](images/image-20220105184303247.png)

## 3.  Setup debug environment

### 3.1 Connect to device

![image-20220105184504368](images/image-20220105184504368.png)

![image-20220105184605880](images/image-20220105184605880.png)

### 3.2 Check Fusion Filter Mode

![image-20220105195556705](images/image-20220105195556705.png)

**Method 1**: poll query

![image-20220106093722839](images/image-20220106093722839.png)

**Method 2**: Report periodically

If you set as the picture below, you can check `Fusion Filter Mode` as Method 1 described without poll action

![image-20220106095742691](images/image-20220106095742691.png)

### 3.2 Calibration for UDR

If mode is not `FUSION`, you should refer to **section 29.3.2** of `u-blox8-M8_ReceiverDescrProtSpec_UBX-13003221.pdf` to perform fast initialization and calibration.

You can get `u-blox8-M8_ReceiverDescrProtSpec_UBX-13003221.pdf` as below:

![image-20220105200125587](images/image-20220105200125587.png)

If you have done the calibration as described above, please follow [3.2 Check Fusion Filter Mode](#32-check-fusion-filter-mode) to check `Fusion Filter Mode` again.