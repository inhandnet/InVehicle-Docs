# OBD Listen Mode Setup Guide

Using the following commands to add J1939 PGs and enable Listen mode
```sh
10:35:12 VG710(config)# show running-config j1939
!
#j1939 config
j1939-group basic
  enable
  interval 1
!
j1939-group listen
  enable
!
10:35:59 VG710(config)# j1939-group listen
11:42:13 VG710(j1939-group-listen)# pgn 61440 src-addr 37
11:42:18 VG710(j1939-group-listen)# pgn 61441 src-addr 37
11:42:22 VG710(j1939-group-listen)# pgn 61443 src-addr 37
11:42:26 VG710(j1939-group-listen)# pgn 61444 src-addr 37
11:42:29 VG710(j1939-group-listen)# pgn 61445 src-addr 37
11:42:34 VG710(j1939-group-listen)# pgn 61449 src-addr 37
11:42:38 VG710(j1939-group-listen)# pgn 64695 src-addr 37
11:42:41 VG710(j1939-group-listen)# pgn 64777 src-addr 37
11:42:45 VG710(j1939-group-listen)# pgn 64893 src-addr 37
11:42:49 VG710(j1939-group-listen)# pgn 64932 src-addr 37
11:42:53 VG710(j1939-group-listen)# pgn 64933 src-addr 37
11:42:56 VG710(j1939-group-listen)# pgn 64962 src-addr 37
11:43:00 VG710(j1939-group-listen)# pgn 64977 src-addr 37
11:43:07 VG710(j1939-group-listen)# pgn 65102 src-addr 37
11:43:11 VG710(j1939-group-listen)# pgn 65110 src-addr 37
11:43:15 VG710(j1939-group-listen)# pgn 65112 src-addr 37
11:43:19 VG710(j1939-group-listen)# pgn 65131 src-addr 37
11:43:32 VG710(j1939-group-listen)# pgn 65132 src-addr 37
11:43:36 VG710(j1939-group-listen)# pgn 65136 src-addr 37
11:43:40 VG710(j1939-group-listen)# pgn 65198 src-addr 37
11:43:43 VG710(j1939-group-listen)# pgn 65199 src-addr 37
11:43:48 VG710(j1939-group-listen)# pgn 65216 src-addr 37
11:43:52 VG710(j1939-group-listen)# pgn 65217 src-addr 37
11:43:56 VG710(j1939-group-listen)# pgn 65237 src-addr 37
11:44:01 VG710(j1939-group-listen)# pgn 65253 src-addr 37
11:44:04 VG710(j1939-group-listen)# pgn 65254 src-addr 37
11:44:08 VG710(j1939-group-listen)# pgn 65257 src-addr 37
11:44:13 VG710(j1939-group-listen)# pgn 65258 src-addr 37
11:44:21 VG710(j1939-group-listen)# pgn 65260 src-addr 37
11:44:21 VG710(j1939-group-listen)# pgn 65262 src-addr 37
11:44:25 VG710(j1939-group-listen)# pgn 65265 src-addr 37
11:44:29 VG710(j1939-group-listen)# pgn 65266 src-addr 37
11:44:33 VG710(j1939-group-listen)# pgn 65269 src-addr 37
11:44:37 VG710(j1939-group-listen)# pgn 65276 src-addr 37

10:37:15 VG710(j1939-group-listen)# !
10:37:20 VG710(config)# show running-config j1939
!
#j1939 config
j1939-group basic
  enable
  interval 1
!
j1939-group listen
  enable
  pgn 61443 src-addr 37
  pgn 61444 src-addr 37
  pgn 61440 src-addr 37
  pgn 61441 src-addr 37
  pgn 61445 src-addr 37
  pgn 61449 src-addr 37
  pgn 64695 src-addr 37
  pgn 64777 src-addr 37
  pgn 64893 src-addr 37
  pgn 64932 src-addr 37
  pgn 64933 src-addr 37
  pgn 64962 src-addr 37
  pgn 64977 src-addr 37
  pgn 65102 src-addr 37
  pgn 65110 src-addr 37
  pgn 65112 src-addr 37
  pgn 65131 src-addr 37
  pgn 65132 src-addr 37
  pgn 65136 src-addr 37
  pgn 65198 src-addr 37
  pgn 65199 src-addr 37
  pgn 65216 src-addr 37
  pgn 65217 src-addr 37
  pgn 65237 src-addr 37
  pgn 65253 src-addr 37
  pgn 65254 src-addr 37
  pgn 65257 src-addr 37
  pgn 65258 src-addr 37
  pgn 65260 src-addr 37
  pgn 65262 src-addr 37
  pgn 65265 src-addr 37
  pgn 65266 src-addr 37
  pgn 65269 src-addr 37
  pgn 65276 src-addr 37
!        
10:38:04 VG710(config)# obd protocol j1939 bitrate 250000 listen
10:38:10 VG710(config)# copy running-config startup-config
10:38:11 VG710(config)# reboot
```

