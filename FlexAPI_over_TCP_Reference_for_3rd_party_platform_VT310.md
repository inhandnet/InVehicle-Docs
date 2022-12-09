# FlexAPI Over TCP Reference



### *For VT3 series*

<div style="page-break-after: always;"></div>

## Revision History

| Revision | Date | Author | Item(s) changed | Note |
| :------- | :--- | :--- | :-------------- | :--- |
| 1.0.1 | 12/7/2021 | liyb | Created this document based on <FlexAPI_Reference_for_3rd_party_platform> | |
|          |           |        |                                                              | |

<div style="page-break-after: always;"></div>
## 1. Introduction

We introduced FlexAPI for the fast evolving IoT applications, which highly value easy integration, openness, flexibility, extensibility and programmability.

FlexAPI is designed to be efficient, clean and ready to use. It's network oriented and programming language independent, and is ideal for cloud platform integration.

FlexAPI provides unified data and control services via TCP messages for 3rd party platforms.

For data service, each topic corresponds to a group of data, and we have ready to use reserved groups such as: GNSS, OBD, Motion, IO ,cellular.

Besides, user can use sysinfo group to obtain device basic information.

In general, reserved groups are enough for user's need. 

For advanced users, they can even define their interested groups and set their uploading intervals.

We employ a request & response scheme for user initiated service requests. 

<div style="page-break-after: always;"></div>
### 1.1 Architecture

![image-20210712154229833](C:\Users\Evan\AppData\Roaming\Typora\typora-user-images\image-20210712154229833.png)

## 2 FlexAPI Overview

FlexAPI organizes data as groups and provides ready to use reserved groups for users to develop their applications.

FlexAPI allow users to change reserved and custom group settings.

Users can get timer triggered group data periodically and event triggered data. Besides, FlexAPI also allow users to actively get group data on demand.

For user initiated service requests we employ a request & response scheme.

Request & response scheme means users need to subscribe to the response topics, and they request service by publishing a message to the request topics.


This overview part gives summary on: FlexAPI general information, error codes and supported topics.

For Basic Usage, see [3. Basic usage](#3-basic-usage).

For Advanced Usage, see [4. Advanced usage](#4-advanced-usage).

For FlexAPI supported Parameters, see [Appendix A. FlexAPI supported Parameters](#appendix-a-flexapi-supported-parameters).

<div style="page-break-after: always;"></div>
### 2.1 FlexAPI Return Information and Errors

### 2.1.0 FlexAPI Message Format.

![image-20210712152833649](C:\Users\Evan\AppData\Roaming\Typora\typora-user-images\image-20210712152833649.png)

**Head**: The start character of packet.
**JSON Data**: The message in JSON format in packet.
**CRC16**: Checksum, Only the JSON data part is calculated. CRC parameter: POLY: 0x8005
(x^16 + x^15 + x^2 + 1), INIT: 0x0000, XOROUT: 0x0000.
**End**: The end sequence of packet.  

#### 2.1.1 General Information

| Parameter Name | Description       | Type    | Note                                                         |
| :------------- | :---------------- | :----- | :----------------------------------------------------------- |
| client_token   | client token      | string | A unique string for users to match responses with the corresponding requests. |
| result         | result            | object | When the request succeeds, there will be result field in response message body.<br>API callers should check the content of the result field to <br>determine whether the request has been successfully processed. |
| error          | error code        | string | When the request fails, it is added to the response message body.<br>For more information, see [General Error Codes](#212-general-error-codes) |
| error_desc     | error description | string | When the request fails, it is added to the response message body.<br>For more information, see [General Error Codes](#212-general-error-codes) |
| ts             | time stamp        | number | UNIX timestamp since Epoch. Indicates when the message was transmitted by device.        |


#### 2.1.2 General Error Codes

| Error Code        | Description           | Error Handling                                                   |
| :---------------- | :-------------------- | :-----------------------------------------------------------     |
| auth_failed       | authentication failed | check username and password                                      |
| invalid_parameter | invalid parameter     | check request parameter                                          |
| not_found         | resource not exist    | make sure related service is enabled and running                 |
| device_busy       | device busy           | retry request                                                    |
| device_error      | device internal error | retry request                                                    |
| data_invalid      | resource invalid      | retry request                                                    |

<div style="page-break-after: always;"></div>
### 2.3 FlexAPI Limits

| Resource                                  | Limit |
| :---------------------------------------- | :---- |
| Minimum retry interval of `settings`, `refresh`, `get` requests | 3 s |
| Minimum retry interval of `io control` request | 5 s |
| `client_id` size | SN of VT3 series |
| `client_token` size | up to 32 bytes of arbitrary string |
| Available custom groups | up to 8 |
| Maximum data items per group | 32 |

<div style="page-break-after: always;"></div>
## 3. Basic Usage

### 3.1 Timer Triggered Reserved Group Data Get

#### 3.1.1 OBD Data

**JSON data**：

```json
{
	"topic":"v1/{client_id}/obd/info",
	"payload":{
		"obd.ts" : 1592820539,
		"obd.rpm" : 1234,
		"obd.speed" : 20
}

```

Parameter description, See [General Information](#211-general-information) & [OBD Parameters](#a4-obd-parameters).

Use [OBD settings](#323-obd-settings) to modify group setting(`interval` & `interest`).

#### 3.1.2 GNSS Data

You will periodically receive the related data by default.

**JSON data **

```json
{
    "topic":"v1/{client_id}/gnss/info",
    "payload":{
    	"gnss.ts" : 1592820539,
    	"gnss.latitude": 40.232213,
    	"gnss.longitude": 116.34366,
    	"gnss.altitude": 346.0,
    	"gnss.speed": 87.6,
    	"gnss.heading": 234.0,
    	"gnss.hdop": 1.2,
    	"gnss.fix": 3,
    	"gnss.num_sv": 7
    }
}
```

Parameter description, See [General Information](#211-general-information) & [GNSS Parameters](#a1-gnss-parameters).

Use [GNSS settings](#324-gnss-settings) to modify group setting(`interval` & `interest`).

<div style="page-break-after: always;"></div>
#### 3.1.3 Motion Data

You will periodically receive the related data by default.

**JSON data**：

```json
{
    "topic":"v1/{client_id}/motion/info",
    "payload":{
    	"motion.ts": 1592820539,
    	"motion.ax": 0.08,
    	"motion.ay": 0.0,
    	"motion.az": 0.0,
    	"motion.gx": 0.15,
    	"motion.gy": 0.03,
    	"motion.gz": -0.47
    }
}
```

Parameter description, See [General Information](#211-general-information) & [Motion Parameters](#a2-motion-parameters).

Use [Motion settings](#325-motion-settings) to modify group setting(`interval` & `interest`).

<div style="page-break-after: always;"></div>
#### 3.1.4 IO Data

You will periodically receive the related data by default.

**JSON data**：

```json
{
    "topic":"v1/{client_id}/io/info",
    "payload":{
    	"io.ts": 1592820539,
        "io.AI1": 0.0,
    	"io.DI1": 0,
    	"io.DI1_pullup": 0,
    	"io.DI2": 0,
    	"io.DI2_pullup": 0,
    	"io.DI3": 0,
    	"io.DI3_pullup": 0,
    	"io.DI4": 0,
    	"io.DI4_pullup": 0,
    	"io.DO1": 0,
    	"io.DO2": 0,
    	"io.DO3": 0,
    	"io.IGT": 0
    }
}
```

Parameter description, See [General Information](#211-general-information) & [IO Parameters](#a3-io-parameters).

Use [IO settings](#326-io-settings) to modify group setting(`interval` & `interest`).

<div style="page-break-after: always;"></div>
#### 3.1.5 Cellular1 Data

You will periodically receive the related data by default.

**JSON data **：

```json
{
    "topic":"v1/{client_id}/modem1/info",
    "payload":{
    	"modem1.ts": 1598425365,
    	"modem1.imei": "862104021247207",
    	"modem1.imsi": "460013231603009",
    	"modem1.iccid": "89860118802836799717",
    	"modem1.signal_lvl": 28,
    	"modem1.reg_status": 1,
    	"modem1.operator": "46001",
    	"modem1.network": 3,
    	"modem1.lac": "EA00",
    	"modem1.cell_id": "71CF520",
    	"cellular1.status": 3,
    	"cellular1.ip": "10.210.255.168",
    	"cellular1.netmask": "255.255.255.255",
    	"cellular1.gateway": "1.1.1.3",
    	"cellular1.dns1": "119.7.7.7",
    	"cellular1.up_at": 1598424985
    }
}
```

Parameter description, See [General Information](#211-general-information) & [Cellular Parameters](#a5-cellular-parameters).

Use [Cellular settings](#327-cellular1-settings) to modify group setting(`interval` & `interest`).

<div style="page-break-after: always;"></div>
### 3.2 Reserved Group Settings

#### 3.2.1 General Settings

| Parameter Name | Description                                                  | Type   | Range    | Units | Optional | Note                                                         |
| :--------- | :----------------------------------------------------------- | :----- | :------- | :---- | :------- | :----------------------------------------------------------- |
| client_token | A unique string for users to match responses with the corresponding requests. | string |  |  | mandatory |  |
| interval   | uploading interval                                           | int    | [0,3600] | s     | optional | 0: disable timer upload                                      |
| interest   | interest parameter<br>List of interested item, each item is represented as key: alias.<br>alias is used in reported messages to rewrite key,<br>a value of "" means no alias.<br>For example,<br>set interest with alias: {"obd.mil": "MIL", "obd.dtcs": "dtcNum"}<br>reported data: {"MIL": "1", "dtcNum": "3"}<br><br>set interest without alias: {"obd.mil": "", "obd.dtcs": ""}<br/>reported data: {"obd.mil": "1", "obd.dtcs": "3"}<br/> | object |          |       | optional | 'key': FlexAPI Supported parameters<br> 'alias': parameter alias <br>OBD group, see [OBD Parameters](#a4-obd-parameters)<br>GNSS group, see [GNSS Parameters](#a1-gnss-parameters)<br/>Motion group, see [Motion Parameters](#a2-motion-parameters)<br/>IO group, see [IO Parameters](#a3-io-parameters)<br/> |

<div style="page-break-after: always;"></div>
**For `interval` and `interest` parameters, there are four use cases which apply to both reserved and custom groups.**

**Case 1. Disable Group Data Uploading**

   Specify only `interval` field and set its value to 0 in message body.

   **Note**: `group_name` is obd, gnss, motion, io, summary, or custom group name.

   **Request JSON data**：

   ```json
   { 
      "topic":"v1/{client_id}/{group_name}/set",
      "payload":{
      	"interval": 0
      }
   }
   ```

   **Response JSON data**：

   Success：

   ```json
   {
      "topic":"v1/{client_id}/{group_name}/set/resp",
      "result": {
         "interval": 0
      }
   }
   ```

   Failure：

   ```json
   {
       "topic":"v1/{client_id}/{group_name}/set/resp",
       "result":{
       		"error": "invalid_parameter",
       		"error_desc": "Invalid request parameter"
       }
   }
   ```

   Parameter description, see [General Information](#211-general-information). 

**Case 2. Change Only Group Data Uploading Interval**

   Specify only `interval` field in message body.

   **Request JSON data**：

   ```json
   { 
       "topic":"v1/{client_id}/{group_name}/set",
 	   "payload":{
      	 	"interval": 60
       }
   }
   ```

   **Response Topic**： `v1/{client_id}/{group_name}/set/resp` 

   **Response JSON data**：

   Success：

   ```json
   {
       "topic":"v1/{client_id}/{group_name}/set/resp",
       "result": {
    	   "interval": 60
       }
   }
   ```

   Failure：

   ```json
   {
       "topic":"v1/{client_id}/{group_name}/set/resp",
       "result": {
       		"error": "invalid_parameter",
       		"error_desc": "Invalid request parameter"
       }
   }
   ```

   Parameter description, see [General Information](#211-general-information).

**Case 3. Change only group data interest**

   Specify only `interest` field in message body.

   **Request JSON data**：

   ```json
   { 
       "topic":"v1/{client_id}/{group_name}/set",
       "payload":{
       		"interest": {"gnss.latitude": "lat", "gnss.longitude": "lon", "obd.speed": "speed", "obd.odo": ""}
       }
   }
   ```

   **Response JSON data**：

   Success：

   ```json
   {
       "topic":"v1/{client_id}/{group_name}/set/resp",
       "result": {
    	   "interest": {"gnss.latitude": "lat", "gnss.longitude": "lon", "obd.speed": "speed", "obd.odo": ""}
       }
   }
   ```

   Failure：

   ```json
   {
       "topic":"v1/{client_id}/{group_name}/set/resp",
       "result":{
       		"error": "invalid_parameter",
       		"error_desc": "Invalid request parameter"
       }
   }
   ```

   Parameter description, see [General Information](#211-general-information).

**Case 4. Change Both Interest and Uploading Interval**

   Specify both `interest` and `interval` fields in message body.

   **Request JSON data**：

   ```json
   { 
       "topic":"v1/{client_id}/{group_name}/set",
       "payload":{
       		"interval": 60,
       		"interest": {"gnss.latitude": "lat", "gnss.longitude": "lon", "obd.speed": "speed", "obd.odo": ""}
       }
   }
   ```

   **Response JSON data**：

   Success：

   ```json
   {
       "topic":"v1/{client_id}/{group_name}/set/resp",
       "result": {
          "interval": 60,
          "interest": {"gnss.latitude": "lat", "gnss.longitude": "lon", "obd.speed": "speed", "obd.odo": ""}
       }
   }
   ```

   Failure：

   ```json
   {
       "topic":"v1/{client_id}/{group_name}/set/resp",
       "result":{
       		"error": "invalid_parameter",
       		"error_desc": "Invalid request parameter"
       }
   }
   ```

   Parameter description, see [General Information](#211-general-information).



<div style="page-break-after: always;"></div>
#### 3.2.3 OBD Settings

Publish a message to this topic to set your interested data and uploading interval.

Default interval is 10s. Default interest is available parameters from the [OBD Parameters](#a4-obd-parameters).

**Request JSON data**：

```json
{ 
    "topic": "v1/{client_id}/obd/set",
    "payload":{
    	"interval": 60,
    	"interest": {"obd.mil": "MIL", "obd.dtcs": "dtcNum", "obd.rpm": "engineSpeed"}
    }
}
```

**Response JSON data**：

Success：

```json
{
    "topic":"v1/{client_id}/obd/set/resp",
    "result": {
    	"interval": 60,
    	"interest": {"obd.mil": "MIL", "obd.dtcs": "dtcNum", "obd.rpm": "engineSpeed"}
    }
}
```

Failure：

```json
{
    "topic":"v1/{client_id}/obd/set/resp",
    "result":{
    	"error": "invalid_parameter",
    	"error_desc": "Invalid request parameter"
    }
}
```

Parameter description,  see [General Information](#211-general-information). 

<div style="page-break-after: always;"></div>
#### 3.2.4 GNSS Settings

Publish a message to this topic to set your interested data and uploading interval.

default interval is 10s. default interest is available parameters from the [GNSS Parameters](#A1-gnss-parameters).

**Request Topic**：`v1/{client_id}/gnss/set`

**Request  JSON data**：

```json
{ 
    "topic": "v1/{client_id}/gnss/set",
    "payload":{
    	"interval": 60,
    	"interest": {"gnss.latitude": "lat", "gnss.longitude": "lon", "gnss.altitude": "alt"}
    }
}
```

**Response Topic**： `v1/{client_id}/gnss/set/resp` 

**Response  JSON data**：

Success：

```json
{
    "topic":"v1/{client_id}/gnss/set/resp",
    "result": {
    	"interval": 60,
    	"interest": {"gnss.latitude": "lat", "gnss.longitude": "lon", "gnss.altitude": "alt"}
    }
}
```

Failure：

```json
{
    "topic":"v1/{client_id}/gnss/set/resp",
	"result":{
   	 	"error": "invalid_parameter",
    	"error_desc": "Invalid request parameter"
    }
}
```

Parameter description,  see [General Information](#211-general-information). 

<div style="page-break-after: always;"></div>
#### 3.2.5 Motion Settings

Publish a message to this topic to set your interested data and uploading interval.

default interval is 10s. default interest is available parameters from the [Motion Parameters](#a2-motion-parameters).

**Request Topic**：`v1/{client_id}/motion/set`

**Request  JSON data**：

```json
{ 
    "topic": "v1/{client_id}/motion/set",
	"payload":{
    	"interval": 60,
    	"interest": {"motion.ax": "acceleration_x", "motion.ay": "acceleration_y", "motion.az": "acceleration_z"}
    }
}
```

**Response Topic**： `v1/{client_id}/motion/set/resp` 

**Response  JSON data**：

Success：

```json
{
    "topic":"v1/{client_id}/motion/set/resp",
    "result": {
    	"interval": 60,
    	"interest": {"motion.ax": "acceleration_x", "motion.ay": "acceleration_y", "motion.az": "acceleration_z"}
    }
}
```

Failure：

```json
{
    "topic":"v1/{client_id}/motion/set/resp",
	"result":{
    	"error": "invalid_parameter",
    	"error_desc": "Invalid request parameter"
    }
}
```

Parameter description,  see [General Information](#211-general-information). 

<div style="page-break-after: always;"></div>
#### 3.2.6 IO Settings

Publish a message to this topic to set your interested data and uploading interval.

default interval is 10s. default interest is available parameters from the [IO Parameters](#a3-io-parameters).

**Request  JSON data**：

```json
{ 
    "topic": "v1/{client_id}/io/set",
	"payload":{
    	"interval": 60,
    	"interest": {"io.AI1": "ai1", "io.AI2": "ai2", "io.AI3": "ai3"}
    }
}
```

**Response  JSON data**：

Success：

```json
{
    "topic":"v1/{client_id}/io/set/resp",
    "result": {
    	"interval": 60,
    	"interest": {"io.AI1": "ai1", "io.AI2": "ai2", "io.AI3": "ai3"}
    }
}
```

Failure：

```json
{
	"topic":"v1/{client_id}/io/set/resp",
	"result":{
    	"error": "invalid_parameter",
    	"error_desc": "Invalid request parameter"
    }
}
```

Parameter description, see [General Information](#211-general-information). 

<div style="page-break-after: always;"></div>
#### 3.2.7 Cellular1 Settings

Publish a message to this topic to set your interested data and uploading interval.

default interval is 30s. default interest is available parameters from the [Cellular Parameters](#a5-cellular-parameters).

**Request  JSON data**：

```json
{ 
    "topic": "v1/{client_id}/cellular1/set",
	"payload":{
    	"interval": 60,
    	"interest": {"modem1.active_sim": "active_sim", "modem1.signal_lvl": "signal_lvl", "cellular1.status": "status"}
    }
}
```

**Response  JSON data**：

Success：

```json
{
    "topic":"v1/{client_id}/cellular1/set/resp",
    "result": {
    	"interval": 60,
    	"interest": {"modem1.active_sim": "active_sim", "modem1.signal_lvl": "signal_lvl", "cellular1.status": "status"}
    }
}
```

Failure：

```json
{
    "topic":"v1/{client_id}/cellular1/set/resp",
	"result":{
    	"error": "invalid_parameter",
    	"error_desc": "Invalid request parameter"
    }
}
```

Parameter description, see [General Information](#211-general-information). 

<div style="page-break-after: always;"></div>
<div style="page-break-after: always;"></div>
### 3.3 On Demand Reserved Group Information Get

#### 3.3.1 OBD Data

**Request  JSON data**：

```json
{ 
    "topic": "v1/{client_id}/obd/refresh"
}
```

**Response  JSON data：

Success：

```json
{
    "topic":"v1/{client_id}/obd/refresh/resp",
    "result": {
    	"obd.rpm": 34245,
        "obd.speed": 53255
    }
}
```

Failure：

```json
{
   "topic":"v1/{client_id}/obd/refresh/resp",
	"result":{
    	"error": "invalid_parameter",
    	"error_desc": "Invalid request parameter"
    }
}
```

Parameter description,  reference [General Information](#211-general-information) & [OBD Parameters](#a4-obd-parameters).

<div style="page-break-after: always;"></div>
#### 3.3.3 GNSS Data

Publish a message to get GNSS data on demand.

**Request  JSON data**：

```json
{ 
    "topic": "v1/{client_id}/gnss/refresh"
}
```

**Response Topic**： `v1/{client_id}/gnss/refresh/resp` 

**Response  JSON data**：

Success：

```json
{
    "topic":"v1/{client_id}/gnss/refresh/resp",
    "result": {
    	"gnss.latitude": 40.232213,
        "gnss.longitude": 116.34366,
        "gnss.altitude": 346.0,
        "gnss.speed": 87.6,
        "gnss.heading": 234.0,
        "gnss.hdop": 1.2,
        "gnss.pdop": 2.1,
        "gnss.hacc": 1.0,
        "gnss.fix": 3,
        "gnss.num_sv": 7,
        "gnss.date": "2020-4-17",
        "gnss.time": "10:16:21"
    }
}
```

Failure：

```json
{
    "topic":"v1/{client_id}/gnss/refresh/resp",
	"result":{
    	"error": "invalid_parameter",
    	"error_desc": "Invalid request parameter"
    }
}
```

Parameter description,  reference [General Information](#211-general-information) & [GNSS Parameters](#a1-gnss-parameters).

<div style="page-break-after: always;"></div>
#### 3.3.4 Motion Data

Publish a message to get motion data on demand.

**Request  JSON data：

```json
{ 
   "topic": "v1/{client_id}/motion/refresh"
}
```

**Response  JSON data**：

Success：

```json
{
    "topic":"v1/{client_id}/motion/refresh/resp",
    "result": {
    	"motion.ax": 0.08,
        "motion.ay": 0.0,
        "motion.az": 0.0,
        "motion.gx": 0.15,
        "motion.gy": 0.03,
        "motion.gz": -0.47,
        "motion.roll": -0.65,
        "motion.pitch": 1.03,
        "motion.yaw": 302.49
    }
}
```

Failure：

```json
{
    "topic":"v1/{client_id}/motion/refresh/resp",
	"result":{
    	"error": "invalid_parameter",
    	"error_desc": "Invalid request parameter"
    }
}
```

Parameter description,  reference [General Information](#211-general-information) & [Motion Parameters](#a2-motion-parameters).

<div style="page-break-after: always;"></div>
#### 3.3.5 IO Data

Publish a message to get IO data on demand.

**Request  JSON data**：

```json
{ 
    "topic": "v1/{client_id}/io/refresh"
}
```

**Response Topic**： `v1/{client_id}/io/refresh/resp` 

**Response  JSON data**：

Success：

```json
{
    "topic":"v1/{client_id}/io/refresh/resp",
    "result": {
    	"io.AI1": 0.0,
        "io.DI1": 0,
        "io.DI1_pullup": 0,
        "io.DI2": 0,
        "io.DI2_pullup": 0,
        "io.DI3": 0,
        "io.DI3_pullup": 0,
        "io.DI4": 0,
        "io.DI4_pullup": 0,
        "io.DO1": 0,
        "io.DO2": 0,
        "io.DO3": 0
    }
}
```

Failure：

```json
{
    "topic":"v1/{client_id}/io/refresh/resp",
	"result":{
    	"error": "invalid_parameter",
    	"error_desc": "Invalid request parameter"
    }
}
```

Parameter description,  reference [General Information](#211-general-information) & [IO Parameters](#a3-io-parameters).

<div style="page-break-after: always;"></div>
#### 3.3.6 Cellular1 Data

Publish a message to get cellular data on demand.

**Request  JSON data**：

```json
{ 
    "topic": "v1/{client_id}/cellular1/refresh"
}
```

**Response Topic**： `v1/{client_id}/cellular1/refresh/resp` 

**Response  JSON data**：

Success：

```json
{
    "topic":"v1/{client_id}/cellular1/refresh/resp",
	"result": {
        "modem1.ts": 1598425245,
        "modem1.imei": "862104021247207",
        "modem1.imsi": "460013231603009",
        "modem1.iccid": "89860118802836799717",
        "modem1.signal_lvl": 29,
        "modem1.reg_status": 1,
        "modem1.operator": "46001",
        "modem1.network": 3,
        "modem1.lac": "EA00",
        "modem1.cell_id": "71CF520",
        "cellular1.ts": 1598425316,
        "cellular1.status": 3,
        "cellular1.ip": "10.210.255.168",
        "cellular1.netmask": "255.255.255.255",
        "cellular1.gateway": "1.1.1.3",
        "cellular1.dns1": "119.7.7.7",
        "cellular1.up_at": 1598424985
    }
}
```

Failure：

```json
{
    "topic":"v1/{client_id}/cellular1/refresh/resp",
	"result":{
    	"error": "invalid_parameter",
    	"error_desc": "Invalid request parameter"
    }
}
```

Parameter description,  reference [General Information](#211-general-information) & [Cellular Parameters](#a5-cellular-parameters).

<div style="page-break-after: always;"></div>
#### 3.3.7 System Info

Publish a message to get system info on demand.

**Request  JSON data**：

```json
{ 
    "topic": "v1/{client_id}/sysinfo/refresh"
}
```

**Response  JSON data**：

Success：

```json
{
    "topic":"v1/{client_id}/sysinfo/refresh/resp",
    "result": {
        "sysinfo.ts": 1598424935,
        "sysinfo.model_name": "VT310",
        "sysinfo.oem_name": "inhand",
        "sysinfo.serial_number": "VF3102020122201",
        "sysinfo.firmware_version": "VT3_V1.0.22",
        "sysinfo.product_number": "FQ58",
        "sysinfo.description": "www.inhand.com.cn"
    }
}
```

Failure：

```json
{
    "topic":"v1/{client_id}/sysinfo/refresh/resp",
	"result":{
    	"error": "invalid_parameter",
    	"error_desc": "Invalid request parameter"
    }
}
```

Parameter description,  reference [General Information](#211-general-information) & [System Parameters](#a6-system-parameters).

<div style="page-break-after: always;"></div>
<div style="page-break-after: always;"></div>
<div style="page-break-after: always;"></div>
### 3.4 Control Service

#### 3.4.1 IO Control

Publish a message to this topic to turn on/off the digital output.

**Request  JSON data**：

```json
{ 
    "topic": "v1/{client_id}/io/control",
    "payload":{
    	"io.DO1": 0,
    	"io.DO2": 0,
    	"io.DO3": 0
    }
}
```

**Response  JSON data**：

Success：

```json
{
    "topic":"v1/{client_id}/io/control/resp",
    "result": {
        "io.DO1": 0,
        "io.DO2": 0,
        "io.DO3": 0
	}
}
```

Failure：

```json
{
    "topic":"v1/{client_id}/io/control/resp",
	"result":{
    	"error": "invalid_parameter",
    	"error_desc": "Invalid request parameter"
    }
}
```

Parameter description,  see [General Information](#211-general-information) & [IO Parameters](#a3-io-parameters) digital output part。

<div style="page-break-after: always;"></div>
<div style="page-break-after: always;"></div>
<div style="page-break-after: always;"></div>
<div style="page-break-after: always;"></div>
## 4. Advanced Usage

### 4.1 Custom Group Settings

#### 4.1.1 Create/Update Custom Group

Use the following topics to define your interested groups and set their uploading intervals.

For `interval` and `interest` parameters, there are four use cases. See [General settings](#321-general-settings).

**Request Topic**：`v1/{client_id}/group/set`

**Request  JSON data**：

```json
{ 
    "topic": "v1/{client_id}/group/set",
    "payload":{
    	"settings": [{
            "group_name": "group1",
            "interval": 60,
            "interest": {"gnss.latitude": "lat","gnss.longitude": "lon","gnss.altitude": "alt","obd.speed": "speed","obd.odo": "odo","userdata.custom_key":"custom_key"}
        },{
            "group_name": "group2",
    	    "interval": 30,
    	    "interest": {"io.DI1": "DI1","io.DI2": "DI2","io.DI3": "DI3","io.DI4": "DI4","io.DO1": "DO1","io.DO2": "DO2","io.DO3": "DO3"}
        }
    	]
    }
}
```

**Response Topic**： `v1/{client_id}/group/set/resp` 

**Response  JSON data**：

Success：

```json
{
   "topic":"v1/{client_id}/group/set/resp",
    "result": [{
            "group_name": "group1",
            "interval": 60,
            "interest": {"gnss.latitude": "lat","gnss.longitude": "lon","gnss.altitude": "alt","obd.speed": "speed","obd.odo": "odo","userdata.custom_key":"custom_key"}
        },{
            "group_name": "group2",
    	    "interval": 30,
    	    "interest": {"io.DI1": "DI1","io.DI2": "DI2","io.DI3": "DI3","io.DI4": "DI4","io.DO1": "DO1","io.DO2": "DO2","io.DO3": "DO3"}
        }
    ]
}
```

Failure：

```json
{
    "topic":"v1/{client_id}/group/set/resp",
	"result":{
    	"error": "invalid_parameter",
    	"error_desc": "Invalid request parameter"
    }
}
```

Parameter description,  see [General Information](#211-general-information) & [General settings](#321-general-settings).

<div style="page-break-after: always;"></div>
#### 4.1.2 Get Custom Group Settings

Use the following topics to get custom group settings.

**Request  JSON data**：

```json
{ 
    "topic": "v1/{client_id}/group/get"
}
```

**Response  JSON data**：

Success：

```json
{
    "topic":"v1/{client_id}/group/get/resp",
    "result": [{
        "group_name": "group1",
    	"interval": 60,
    	"interest": {"gnss.latitude": "lat","gnss.longitude": "lon","gnss.altitude": "alt","obd.speed": "speed","obd.odo": "odo","userdata.custom_key":"custom_key"}  
    },{
        "group_name": "group2",
    	"interval": 30,
    	"interest": {"io.DI1": "DI1","io.DI2": "DI2","io.DI3": "DI3","io.DI4": "DI4","io.DO1": "DO1","io.DO2": "DO2","io.DO3": "DO3"} 
    }]
}
```

Failure：

```json
{
    "topic":"v1/{client_id}/group/get/resp",
	"result":{
    	"error": "invalid_parameter",
    	"error_desc": "Invalid request parameter"
    }
}
```

Parameter description,  see [General Information](#211-general-information) & [General settings](#321-general-settings).

<div style="page-break-after: always;"></div>
<div style="page-break-after: always;"></div>
### 4.2 Timer Triggered Custom Group Data Get

Once you have subscribed to this topic, you will periodically receive the related data.

**Topic**：`v1/{client_id}/{group_name}/info`

**JSON data**：

```json
{	
    "topic":"v1/{client_id}/{group_name}/info",
	"payload":{
    	"lat": 40.232213,
    	"ai1": 1.0,
    	"obd.speed": 50,
    	"userdata.custom_key":"custom_value"
    }
}
```

Parameter description, see [General Information](#211-general-information) & [FlexAPI supported Parameters](#appendix-a-flexapi-supported-parameters).

### 4.3 On Demand Custom Group Data Get

Publish a message to get `group_name` data on demand.

**Request  JSON data**：

```json
{ 
    "topic": "v1/{client_id}/{group_name}/refresh"
}
```

**Response  JSON data**：

Success：

```json
{
    "topic":"v1/{client_id}/{group_name}/refresh/resp",
    "result": {
        "lat": 40.232213,
        "ai1": 1.0,
        "obd.speed": 50,
        "userdata.custom_key":"custom_value"
    }
}
```

Failure：

```json
{
    "topic":"v1/{client_id}/{group_name}/refresh/resp",
	"result":{
    	"error": "invalid_parameter",
    	"error_desc": "Invalid request parameter"
    }
}
```

Parameter description, see [General Information](#211-general-information) & [FlexAPI supported Parameters](#appendix-a-flexapi-supported-parameters).

## 5. Event Service

### 5.1 Event Level

| Level Name | Value | Description                       |
| :--------- | :---: | :-------------------------------- |
| Emergency  |   5   | System is unusable.               |
| Alert      |   4   | Action must be taken immediately. |
| Error      |   3   | Error conditions.                 |
| Warning    |   2   | Warning conditions.               |
| Notice     |   1   | Normal but significant condition. |

### 5.2 Event Types

#### 5.2.1 General event Types

| Event Name   | Event Type | Description                                           | Level | Note |
| :----------- | :--------- | :---------------------------------------------------- | :---- | :--- |
| Ignition On  | IGON       | The ignition input has transitioned from low to high. | 1     |      |
| Ignition Off | IGOFF      | The ignition input has transitioned from high to low. | 1     |      |

#### 5.2.2 DTC event Types

| Event Name | Event Type      | Description                          | Level | Note                                                         |
| :--------- | :-------------- | :----------------------------------- | :---- | :----------------------------------------------------------- |
| OBDII DTC  | OBDII_DTC_{dtc} | OBDII diagnostic trouble code event. | 2     | dtc: diagnostic trouble code string. see [OBD-II DTC](#5431-obd-ii-dtc) |
| J1939 DTC  | J1939_DTC_{spn} | J1939 diagnostic trouble code event. | 2     | spn: see [J1939 DTC](#5432-j1939-dtc)                        |

### 5.3 Event parameters

| Parameter Name | Description                             | Type   | Range        | Units | Optional | Note                                                         |
| :------------- | :-------------------------------------- | :----- | :----------- | :---- | :------- | :----------------------------------------------------------- |
| starts_at      | Event start time                        | number |              | s     |          | UNIX timestamp, in seconds since the epoch                   |
| ends_at        | Event end time                          | number |              | s     | Optional | UNIX timestamp, in seconds since the epoch.<br>When the event is cleared, it is added to the event message body |
| status         | Event status                            | string | raise\|clear |       |          | raise：event  occur<br>clear：event recovery                 |
| type           | Event type                              | string |              |       |          | see [Event Types](#52-event-types)                           |
| level          | Event level                             | number |              |       |          | see [Event Level](#51-event-level)                           |
| gnss.xxx       | Additional location information(if any) |        |              |       | Optional | Location information associated with the event. see [GNSS Parameters](#a1-gnss-parameters) |
| motion.xxx     | Additional motion information(if any)   |        |              |       | Optional | Motion information associated with the event. see [Motion Parameters](#a2-motion-parameters) |
| obd.xxx        | Additional obd information(if any)      |        |              |       | Optional | OBD information associated with the event. see [OBD Parameters](#a4-obd-parameters) |

### 5.4 Event examples

#### 5.4.1 General event

Once you have subscribed to this topic, you will receive the related event information.

**JSON data**：

```json
{	
    "topic": "v1/{client_id}/event/notice",
    "payload":{
    	"starts_at": 1609901560,
    	"status": "raise",
    	"type": "IGON",
    	"level": 1,
    	"gnss.longitude": -111.33,
    	"gnss.latitude": 38.2222,
    	"gnss.altitude": 230,
    	"gnss.heading": 42.5,
    	"gnss.speed": 0,
    	"gnss.hdop": 2.1,
    	"obd.speed": 0,
    	"obd.f_lvl": 21,
    	"obd.odo": 2000,
    	"motion.ax": 0.0,
    	"motion.ay": 0.0,
    	"motion.az": 0.0,
    	"motion.gx": 0.0,
    	"motion.gy": 0.0,
    	"motion.gz": 0.0
    }
}
```

Parameter description, See [Event parameters](#53-event-parameters) & [FlexAPI supported Parameters](#appendix-a-flexapi-supported-parameters).

#### 5.4.3 DTC event

Once you have subscribed to this topic, you will receive the related event information.

##### 5.4.3.1 OBD-II DTC

**Event occur**:

**JSON data**：

```json
{
    "topic": "v1/{client_id}/event/notice",
    "payload":{
    	"starts_at": 1609901565,
    	"status": "raise",
    	"type": "OBDII_DTC_P070F",
    	"level": 2,
    	"dtc": "P070F",
    	"desc": "Transmission Fluid Level Too Low",
    	"gnss.longitude": -111.33,
    	"gnss.latitude": 38.2222,
    	"gnss.altitude": 230,
    	"gnss.heading": 42.5,
    	"gnss.speed": 55,
    	"gnss.hdop": 2.1,
    	"obd.speed": 55,
    	"obd.f_lvl": 21,
    	"obd.odo": 2025,
    	"motion.ax": 0.0,
    	"motion.ay": 0.0,
    	"motion.az": 0.0,
    	"motion.gx": 0.0,
    	"motion.gy": 0.0,
    	"motion.gz": 0.0
    }
}
```

**Event recovery**:

**JSON data**：

```json
{
    "topic": "v1/{client_id}/event/notice",
    "payload":{
    	"starts_at": 1609901565,
    	"ends_at": 1609901820,
    	"status": "clear",
    	"type": "OBDII_DTC_P070F",
    	"level": 2,
    	"dtc": "P070F",
    	"desc": "Transmission Fluid Level Too Low",
    	"gnss.longitude": -111.33,
    	"gnss.latitude": 38.2222,
    	"gnss.altitude": 230,
    	"gnss.heading": 42.5,
    	"gnss.speed": 0,
    	"gnss.hdop": 2.1,
    	"obd.speed": 0,
    	"obd.f_lvl": 21,
    	"obd.odo": 2025,
    	"motion.ax": 0.0,
    	"motion.ay": 0.0,
    	"motion.az": 0.0,
    	"motion.gx": 0.0,
    	"motion.gy": 0.0,
    	"motion.gz": 0.0
    }
}
```

**Parameter description:**

| Parameter Name | Description                         | Type   | Range | Units | Optional | Note |
| :------------- | :---------------------------------- | :----- | :---- | :---- | :------- | :--- |
| dtc            | Diagnostic trouble code             | string |       |       |          |      |
| desc           | Diagnostic trouble code description | string |       |       | optional |      |

More parameter description, See [Event parameters](#53-event-parameters) & [FlexAPI supported Parameters](#appendix-a-flexapi-supported-parameters).

##### 5.4.3.2 J1939 DTC

**Event occur**:

**JSON data**：

```json
{
    "topic": "v1/{client_id}/event/notice",
    "payload":{
    	"starts_at": 1609901565,
    	"status": "raise",
    	"type": "J1939_DTC_173",
    	"level": 2,
    	"src_addr": 0,
    	"fmi": 3,
    	"oc": 1,
    	"spn": 173,
    	"gnss.longitude": -111.33,
    	"gnss.latitude": 38.2222,
    	"gnss.altitude": 230,
    	"gnss.heading": 42.5,
    	"gnss.speed": 0,
    	"gnss.hdop": 2.1,
    	"obd.speed": 0,
    	"obd.f_lvl": 21,
    	"obd.odo": 2000,
    	"motion.ax": 0.0,
    	"motion.ay": 0.0,
    	"motion.az": 0.0,
    	"motion.gx": 0.0,
    	"motion.gy": 0.0,
    	"motion.gz": 0.0
    }
}
```

**Event recovery**:

**JSON data**：

```json
{
    "topic": "v1/{client_id}/event/notice",
    "payload":{
    	"starts_at": 1609901565,
    	"ends_at": 1609901820,
    	"status": "clear",
    	"type": "J1939_DTC_173",
    	"level": 2,
    	"src_addr": 0,
    	"fmi": 3,
    	"oc": 1,
    	"spn": 173,
    	"gnss.longitude": -111.33,
    	"gnss.latitude": 38.2222,
    	"gnss.altitude": 230,
    	"gnss.heading": 42.5,
    	"gnss.speed": 0,
    	"gnss.hdop": 2.1,
    	"obd.speed": 0,
    	"obd.f_lvl": 21,
    	"obd.odo": 2000,
    	"motion.ax": 0.0,
    	"motion.ay": 0.0,
    	"motion.az": 0.0,
    	"motion.gx": 0.0,
    	"motion.gy": 0.0,
    	"motion.gz": 0.0
    }
}
```

**Parameter description:**

| Parameter Name | Description              | Type | Range | Units | Optional | Note |
| :------------- | :----------------------- | :--- | :---- | :---- | :------- | :--- |
| src_addr       | Source Address           | int  |       |       |          |      |
| fmi            | Failure Mode Indicator   | int  |       |       |          |      |
| oc             | Occurrence Count         | int  |       |       |          |      |
| spn            | Suspect Parameter Number | int  |       |       |          |      |

More parameter description, See [Event parameters](#53-event-parameters) & [FlexAPI supported Parameters](#appendix-a-flexapi-supported-parameters).

<div style="page-break-after: always;"></div>
## Appendix A. FlexAPI Supported Parameters

### A.1 GNSS Parameters

| Parameter Name | Description                  | Type   | Range                                                        | Units | Optional  | Note             |
| :------------- | :--------------------------- | :----- | :----------------------------------------------------------- | :---- | :-------- | :--------------- |
| gnss.ts        | The last time the GNSS info was updated | int   |   | s |  | UNIX timestamp, in seconds since the epoch  |
| gnss.latitude  | latitude                     | float  |                                                              | deg   | mandatory |                  |
| gnss.longitude | longitude                    | float  |                                                              | deg   | mandatory |                  |
| gnss.altitude  | altitude                     | float  |                                                              | deg   | mandatory |                  |
| gnss.speed     | speed                        | float  |                                                              | knots  | mandatory |                  |
| gnss.heading   | heading                      | float  | [0.0,360.0]                                                  | °     |           |                  |
| gnss.hdop      | Horizontal DOP               | float  |                                                              |       |           |                  |
| gnss.fix       | GNSS fix status              | int    | 0: NoFix; 1: DR Only<br>2: 2D; 3: 3D<br>4: GNSS+DR; 5: Time Only<br> |       |           |                  |
| gnss.num_sv    | number of satellites used    | int    | [0,12] |       |           |                  |

<div STYLE="page-break-after: always;"></div>

### A.2 Motion Parameters

| Parameter Name | Description          | Type  | Range | Units | Optional  | Note          |
| :------------- | :------------------- | :---- | :---- | :---- | :-------- | :------------ |
| motion.ts      | The last time the Motion info was updated | int   |   |   s   |  | UNIX timestamp, in seconds since the epoch  |
| motion.ax      | x-axis accelerometer | float |       | g     | mandatory | accelerometer |
| motion.ay      | y-axis accelerometer | float |       | g     | mandatory | accelerometer |
| motion.az      | z-axis accelerometer | float |       | g     | mandatory | accelerometer |
| motion.gx      | x-axis gyroscope     | float |       | deg/s | mandatory | gyroscope     |
| motion.gy      | y-axis gyroscope     | float |       | deg/s | mandatory | gyroscope     |
| motion.gz      | z-axis gyroscope     | float |       | deg/s | mandatory | gyroscope     |

<div STYLE="page-break-after: always;"></div>

### A.3 IO Parameters

| Parameter Name  | Description             | Type  | Range                              | Units | Optional  | Note     |
| :-------------- | :---------------------- | :---- | :--------------------------------- | :---- | :-------- | :------- |
| io.ts           | The last time the IO info was updated | int   |   | s  |  | UNIX timestamp, in seconds since the epoch  |
| io.AI{n}        | Analog Input n          | float | [0,36.0]<br>null：invalid          | V     | mandatory | n: [1,1] |
| io.DI{n}        | Digital Input n         | int   | 0: low<br>1: high<br>null：invalid |       | mandatory | n: [1,4] |
| io.DI{n}_pullup | Digital Input pullup n  | int   | 0: down<br>1: up<br>null：invalid  |       | mandatory | n: [1,4] |
| io.DO{n}        | Digital Output n        | int   | 0: low<br>1: high<br>null：invalid |       | mandatory | n: [1,3] |
| io.IGT | Digital Input for ignition signal | int | 0: low<br/>1: high<br/>null：invalid | |  |  |

<div STYLE="page-break-after: always;"></div>

### A.4 OBD Parameters

| Parameter Name       | Description                                       | PGN:SPN of J1939           | Type    | Range                                          | Units | Optional | Note |
| :------------------- | ------------------------------------------------- | :------ | :--------------------------------------------- | :---- | -------- | ---- | ---- |
| obd.ts               | The last time the OBD info was updated            | N/A         | int     |            | s   |          | UNIX timestamp, in seconds since the epoch     |
| obd.vin              | Vehicle Identification Number                     | 65260:237            | string  |                                                |       |          |      |
| obd.e_load           | Engine Load                                  | 61443:92                               | double  | [0,250.00] 0: stopped >0: started              | %     |          |      |
| obd.c_temp           | Engine Coolant Temp                               | 65262:110                      | int     | [-40,215]                                      | ℃     |          |      |
| obd.rpm              | Engine Speed                                      | 61444:190                             | double  | [0,16383.75]                                   | RPM   |          |      |
| obd.speed            | Vehicle Speed                                     | 65265:84                             | int     | [0,255]                                        | km/h  |          |      |
| obd.f_lvl            | Fuel Level                                        | 65276:96                                | double  | [0,100.00]                                     | %     |          |      |
| obd.f_rate           | Fuel Rate                                         | 65266:183                               | double  | [0,3276.75]                                    | l/h   |          |      |
| obd.dtcs             | DTC Count                                         | N/A                                    | int     | [0,250]                                        |       |          |      |
| obd.mil              | MIL Status                                        | 65227:1213                              | boolean | 0:off 1:on                                     |       |          |      |
| obd.b_volt           | Battery Voltage                                   | 65271:168                          | double  | [0,3212.75]                                    | V     |          |      |
| obd.a_temp           | Ambient Air Temp                                  | 65269:171                         | int     | [-273,1734]                                    | ℃     |          |      |
| obd.o_temp           | Engine Oil Temp                                   | 65262:175                          | int     | [-273,1734]                                    | ℃     |          |      |
| obd.up_time          | Engine Start Time                                 | 94952:3310                       | int     | [0,65535]                                      | sec   |          |      |
| obd.m_dist           | Distance traveled while MIL is Activated          | 49408:3069 | int     | [0,65535]                                      | km    |          |      |
| obd.d_dist           | Distance traveled since DTCs cleared              | 49408:3294    | int     | [0,65535]                                      | km    |          |      |
| obd.m_time           | Engine run time while MIL activated               | 49408:3295     | int     | [0,65535]                                      | min   |          |      |
| obd.d_time           | Engine run time since DTCs cleared                | 49408:3296      | int     | [0,65535]                                      | min   |          |      |
| obd.f_press          | Fuel Pressure                                     | 64929:3480                           | int     | [0,6425]                                       | kPa   |          |      |
| obd.t_pos            | Throttle Position                                 | 65266:51                         | double  | [0,100.00]                                     | %     |          |      |
| obd.brake            | Brake Switch Status                               | 65265:597                      | boolean | 0:brake pedal released 1:brake pedal depressed |       |          |      |
| obd.parking          | Parking Brake Switch Status                       | 65265:70               | boolean | 0:parking brake not set 1:parking brake set    |       |          |      |
| obd.s_w_angle        | Steering Wheel Angle                              | 61449:1807                    | double  | [-31.374,31.374]                               | rad   |          |      |
| obd.f_econ           | Fuel Economy                                      | 65266:185                             | double  | [0,125.50]                                     | km/L  |          |      |
| obd.odo              | Odometer                                          | 65248:245                                 | double  | [0,526385151.875]                              | km    |          |      |
| obd.a_pos            | Accelerator Pedal Position                        | 61443:91                | double  | [0,100.00]                                     | %     |          |      |
| obd.t_dist           | trip distance                                     | 65248:244                            | double  | [0,526385151.875]                              | km    |          |      |
| obd.i_temp           | Intake Manifold Temp                              | 65270:102                    | int     | [-40,215]                                      | ℃     |          |      |
| obd.i_press          | Intake Manifold Pressure                          | 65270:105                | int     | [0,255]                                        | kPa   |          |      |
| obd.b_press          | Barometirc Pressure                               | 65269:108                      | int     | [0,255]                                        | kPa   |          |      |
| obd.f_r_press        | Fuel Rail Pressure                                | 64765:5313                    | int     | [0,65530]                                      | kPa   |          |      |
| obd.r_torque         | Engine reference Torque                           | 65251:544               | int     | [0,64255]                                      | Nm    |          |      |
| obd.f_torque         | Engine friction Torque                            | 65247:514                   | float   | [-125.00,125.00]                               | %     |          |      |
| obd.max_avl_torque   | Engine Maximum Available Torque                   | 61443:3357 | float   | [0,100.00]                                     | %     |          |      |
| obd.a_torque         | Engine actual Torque                              | 61444:513                     | float   | [-125.00,125.00]                               | %     |          |      |
| obd.d_e_f_vol        | Diesel Exhaust Fluid Volume                       | 65110:1761             | float   | [0,100.00]                                     | %     |          |      |
| obd.mf_mon           | Misfire Monitor Status                            | 65230:1221                  | int     | 0:not completed 1:completed                    |       |          |      |
| obd.f_s_mon          | Fuel System Monitor Status                        | 65230:1221              | int     | 0:not completed 1:completed                    |       |          |      |
| obd.c_c_mon          | Comprehensive Component Monitor Status            | 65230:1221  | int     | 0:not completed 1:completed                    |       |          |      |
| obd.c_mon            | Catalyst Monitor Status                           | 65230:1222                | int     | 0:not completed 1:completed                    |       |          |      |
| obd.h_c_mon          | Heated Catalyst Monitor Status                    | 65230:1222         | int     | 0:not completed 1:completed                    |       |          |      |
| obd.e_s_mon          | Evaporative System Monitor Status                 | 65230:1222       | int     | 0:not completed 1:completed                    |       |          |      |
| obd.s_a_s_mon        | Secondary Air System Monitor Status               | 65230:1222     | int     | 0:not completed 1:completed                    |       |          |      |
| obd.a_s_r_mon        | A/C System Refrigerant Monitor Status             | 65230:1222   | int     | 0:not completed 1:completed                    |       |          |      |
| obd.e_g_s_mon        | Exhaust Gas Sensor Monitor Status                 | 65230:1222       | int     | 0:not completed 1:completed                    |       |          |      |
| obd.e_g_s_h_mon      | Exhaust Gas Sensor heater Monitor Status          | 65230:1222 | int     | 0:not completed 1:completed                    |       |          |      |
| obd.e_v_s_mon        | EGR/VVT System Monitor Status | 65230:1222 | int     | 0:not completed 1:completed                    |       |          |      |
| obd.c_s_a_s_mon      | Cold Start Aid System Monitor Status              | 65230:1222    | int     | 0:not completed 1:completed                    |       |          |      |
| obd.b_p_c_s_mon      | Boost Pressure Control System Monitor Status      | 65230:1222 | int     | 0:not completed 1:completed                    |       |          |      |
| obd.dpf_mon          | DPF Monitor Status                                | 65230:1222                      | int     | 0:not completed 1:completed                    |       |          |      |
| obd.n_c_mon          | NOx Catalyst Monitor Status                       | 65230:1222             | int     | 0:not completed 1:completed                    |       |          |      |
| obd.nmhc_mon         | NMHC Catalyst Monitor Status                      | 65230:1222            | int     | 0:not completed 1:completed                    |       |          |      |
| obd.o_s_mon          | Oxygen Sensor Monitor Status                      | Not supported      | int     | 0:not completed 1:completed                    |       |          |      |
| obd.o_s_h_mon        | Oxygen Sensor heater Monitor Status               | Not supported  | int     | 0:not completed 1:completed                    |       |          |      |
| obd.pf_mon           | PF Monitor Status                                 | Not supported                    | int     | 0:not completed 1:completed                    |       |          |      |
| obd.brake_prim_press | Brake Primary Pressure                            | Not supported               | float   |                                                | kPa   |          | unavailable |
| obd.brake_sec_press  | Brake Secondary Pressure                          | Not supported             | float   |                                                | kPa   |          | unavailable |
| obd.e_hours | "Engine Total Hours of Operation | 65253:247 | int | | h | |  |
| obd.ab_level | Aftertreatment 1 Diesel Exhaust Fluid Tank Volume | 65110:1761 | float | | % | |  |

<div STYLE="page-break-after: always;"></div>

### A.5 Cellular Parameters

| Parameter Name       | Description                                   | Type   | Range                              | Units | Optional  | Note     |
| :------------------- | :-------------------------------------------- | :----- | :--------------------------------- | :---- | :-------- | :------- |
| modem1.ts            | The last time the modem1 info was updated        | int     |            | s   |          | UNIX timestamp, in seconds since the epoch     |
| modem1.imei          | IMEI code                              | string |        |      |          |                                                              |
| modem1.imsi          | IMSI code                              | string |        |      |          |                                                              |
| modem1.iccid         | ICCID code                             | string |        |      |          |                                                              |
| modem1.phone_num     | phone number                                  | string |        |      |          |                                                              |
| modem1.signal_lvl    | signal level                                  | number |        | asu  |          |                                                              |
| modem1.reg_status    | register status                               | number | [0,6]  |      |          | 0: Not registered, ME is not currently searching an operator to register to<br>1: Registered, home network<br>2: Not registered, but ME is currently trying to attach or searching an operator to register to<br>3: Registration denied<br>4: Unknown, e.g. out of LTE coverage<br>5: Registered, roaming |
| modem1.operator      | operator                                      | string |        |      |          |                                                              |
| modem1.network       | network type                                  | number | [0,3]  |      |          | 0: NA, 1: 2G, 2: 3G, 3: 4G            |
| modem1.lac           | LAC                                           | string |        |      |          | hexadecimal                                                  |
| modem1.cell_id       | Cell ID                                       | string |        |      |          | hexadecimal                                         |
| modem1.rssi          | RSSI(Received Signal Strength Indication)     | number |        | dBm  |          |                                                  |
| modem1.rsrp          | RSRP(Reference Signal Receiving Power)        | number |        | dBm  |          |                                              |
| modem1.rsrq          | RSRQ(Reference Signal Receiving Quality)      | number |        | dB   |          |                                              |
| modem1.sinr          | SINR(Signal to Interference plus Noise Ratio) | number |        | dB   |          |                                            |
| cellular1.status     | cellular1 network status | number | [0,3] |      |    | 0: destroy<br>1: create<br>2: down<br>3: up |
| cellular1.ip         | cellular1 ip address    | string |                      |      |  |                      |
| cellular1.netmask    | cellular1 netmask | string |                      |      |       |                      |
| cellular1.gateway    | cellular1 gateway     | string |                      |      |       |                      |
| cellular1.dns1       | cellular1 dns1     | string |                      |      |          |                      |
| cellular1.up_at      | cellular1 connected time | number |                | s    |          |    |

<div STYLE="page-break-after: always;"></div>

### A.6 System Parameters

| Parameter Name       | Description                                   | Type   | Range                              | Units | Optional  | Note     |
| :------------------- | :-------------------------------------------- | :----- | :--------------------------------- | :---- | :-------- | :------- |
| sysinfo.ts           | The last time the modem1 info was updated    | int     |            | s   |          | UNIX timestamp, in seconds since the epoch     |
| sysinfo.hostname | hostname | string |        |  |     |       |
| sysinfo.model_name | model name | string |        |  |     |       |
| sysinfo.oem_name | OEM name | string |        |  |     |       |
| sysinfo.serial_number | serial number | string |        |  |     |       |
| sysinfo.firmware_version | firmware version | string |        |  |     |       |
| sysinfo.product_number | product number | string |        |  |     |       |
| sysinfo.description | description | string |        |  |     |       |



