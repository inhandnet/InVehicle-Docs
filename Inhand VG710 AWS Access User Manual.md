# Inhand VG710 AWS Access User Manual

## 1. Configure AWS

### 1.1 create thing

- Login https://console.amazonaws.com, input `iot`

  ![image-20210824184124194](images/image-20210824184124194.png)

- **** `Manage->thing`, then click `Create`

  ![image-20210420164442147](images/image-20210420164442147.png)

- Click `Create a single thing`

  ![image-20210420133623383](images/image-20210420133623383.png)

- Input name of thing, then click `Next`

  ![image-20210420133847625](images/image-20210420133847625.png)

  ![image-20210420164617298](images/image-20210420164617298.png)
  
- Click `Create thing without certificate`

  ![image-20210420143036417](images/image-20210420143036417.png)


### 1.2 create certificate

- Enter `Secure->Certificate`, then click `Create`

  ![image-20210420143415550](images/image-20210420143415550.png)

- click `Create certificate`

  ![image-20210420143519378](images/image-20210420143519378.png)

- Download certificate and key, click `Activate`, then click `Done`

  ![image-20210420143650825](images/image-20210420143650825.png)

  ![image-20210420143747368](images/image-20210420143747368.png)

### 1.3 create policy

- Enter `Secure->Policies`, then click `Create`

  ![image-20210420143932204](images/image-20210420143932204.png)

- Set the policy rules as below, click `Create` to create policies.

  Please refer to [AWS IoT Core policies](https://docs.aws.amazon.com/iot/latest/developerguide/iot-policies.html?icmpid=docs_iot_console) for more details.

  ![image-20210511185253948](images/image-20210511185253948.png)
  
  ![image-20210511185659548](images/image-20210511185659548.png)

### 1.4 Attach thing and policies to certificate

- Enter `Secure->Certificates`, click the certificates you created earlier

  ![image-20210420145518295](images/image-20210420145518295.png)

- Click `Policies`, then click `Attach policy`, choose the policy you created earlier, finally click `Attach`

  ![image-20210420145818515](images/image-20210420145818515.png)

  ![image-20210420145955651](images/image-20210420145955651.png)

- Click `Things`, then click `Attach thing`, choose the thing you created earlier, finally click `Attach`

  ![image-20210420150343690](images/image-20210420150343690.png)

  ![image-20210420150359015](images/image-20210420150359015.png)
  
<div style="page-break-after: always;"></div>
## 2. Publish and subscribe test

We provide a python APP (`AWS_pubsub_demo`) to demonstrate publish and subscribe functions, please refer to ***VG710-Python-APP-Development-Guide.pdf*** to set up python APP development environment, then import all certificate and key to src/cert directory of `AWS_pubsub_demo` APP, then package it.

**AWS_pubsub_demo tree view**:

```
.
├── config.yaml
├── setup.py
├── src
│   ├── cert
│   │   ├── 5dd65b0ab3-certificate.pem.crt
│   │   ├── 5dd65b0ab3-private.pem.key
│   │   ├── 5dd65b0ab3-public.pem.key
│   │   └── AmazonRootCA1.pem
│   ├── parse_config.py
│   └── pubsub.py
└── .vscode
    └── sftp.json

3 directories, 9 files
```

**APP demo configuration instructions**:

- Endpoint

  ![image-20210421094538885](images/image-20210421094538885.png)

- Allow client id and topic according to policy

  ![image-20210421095249637](images/image-20210421095249637.png)

If you see the following log, the test is successful!

![image-20210420181816113](images/image-20210420181816113.png)

