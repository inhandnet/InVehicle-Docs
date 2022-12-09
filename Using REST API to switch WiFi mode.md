# Using REST API to switch Wi-Fi mode

### 1. Device connectivity topology

`on-board computer`  ------**LAN(wired/wireless)**-------`VG710`

### 2. Access REST API(chapter 1.3)

REST API enabled in `Localhost` mode  by default.

![image-20200729155517243](/home/dengzt/Documents/VG710/wiki/images/FlexAPI/flexapi-restapi-settings.png)

- **Enable**: Options include **None**, **localhost** and **localhost & LAN**. 
- **Localhost Listen Address**: Server settings for APPs run on VG710
- **LAN Listen Address**:  Server settings for APPs within VG710 LAN
- **LAN Access Token**: Required **ONLY** for **Bearer** authentication in HTTP header for LAN Access. 
- **Include Invalid Data**:  if enabled, FlexAPI will also return invalid data items with `null` value besides valid data items.
- **FlexAPI Config File**: Mange FlexAPI configuration file of REST API

### 2. Using HTTP(s) to set 5G to STA(0:ap, 1:sta, chapter 3.3.2)

```http
POST /v1/app/control HTTP/1.1
Host: {deviceIP}:{port}
Authorization: Bearer iWUFB4y7720f841yLcR10dLTuo2TO4JR
Content-Type: application/json

{
    "app.wifi_mode_5g": 1
}
```

**Success result**

```http
HTTP/1.1 200
Content-type: application/json

{
    "result": {
    	"app.wifi_mode_5g": 1
	}
}
```

### 3. In APP， read value of `app.wifi_mode_5g`(chapter 3.2.9)

```http
GET /v1/app/refresh HTTP/1.1
Host: {deviceIP}:{port}
Authorization: Bearer iWUFB4y7720f841yLcR10dLTuo2TO4JR
```

**Success result**

```http
HTTP/1.1 200
Content-type: application/json

{
    "result": {
    	"app.wifi_mode_5g": 1
	}
}
```

Then APP will set Wi-Fi mode according to `app.wifi_mode_5g`

