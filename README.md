# docker-scaleio-gw [![](https://images.microbadger.com/badges/image/vchrisb/scaleio-gw.svg)](https://microbadger.com/images/vchrisb/scaleio-gw "Get your own image badge on microbadger.com")

This image runs EMC ScaleIO-GW-2.5 as a container.

## How to use this image

```sudo docker run -d --name=docker-scaleio-gw sergeymatsak/docker-scaleio-gw```

The following environment variables are also honored for configuring your ScaleIO Gateway instance:
* `-e GW_PASSWORD=` (Gateway password, defaults to `Scaleio123`)
* `-e MDM1_IP_ADDRESS=` and `-e MDM2_IP_ADDRESS=` (MDM IP addresses)
* `-e MDM1_CRT=` and `-e MDM2_CRT=` (manually add the MDM public certificates to the truststore)
* `-e TRUST_MDM_CRT=` (if variable is set with a non empty value will the MDM certificate being trusted)
* `-e GW_KEY=` and `-e GW_CRT=` (public certificate and private key to be used)
* `-e BYPASS_CRT_CHECK=` (if variable is set with a non empty value will the certificate check for the MDMs and LIAs bypassed)

### Examples

```docker run -d --name=scaleio-gw --restart=always -p 443:443 -e GW_PASSWORD=Scaleio123 -e MDM1_IP_ADDRESS=192.168.100.1 -e MDM2_IP_ADDRESS=192.168.100.2 -e TRUST_MDM_CRT=true sergeymatsak/docker-scaleio-gw```

```docker run -d --name scaleio-gw --restart=always -p 443:443 -e GW_PASSWORD=Scaleio123 -e MDM1_IP_ADDRESS=192.168.100.1 -e MDM2_IP_ADDRESS=192.168.100.2 -e TRUST_MDM_CRT=true -e GW_KEY="$GW_KEY" -e GW_CRT="$GW_CRT" sergeymatsak/docker-scaleio-gw```

### Docker Tags

* latest -> v2.5.0.0

## certificates

#### Gateway certificate

It makes sense to have a common certificate when running multiple instances of scaleio-gw or to persist the certificate between scaleio-gw upgrades.
You can either generate your own self-signed certificate or add signed certificate from your certificate authority.
  
##### create a self-signed certificate is
```
openssl req -x509 -sha256 -newkey rsa:2048 -keyout certificate.key -out certificate.crt -days 1024 -nodes -subj '/CN=scaleio-gw.net'
export GW_KEY=$(cat certificate.key | sed ':a;N;$!ba;s/\n/\\n/g')
export GW_CRT=$(cat certificate.crt | sed ':a;N;$!ba;s/\n/\\n/g')
```

#### MDM certificates

Following commands can be used to get the `MDM1`and `MDM2` certificates:
```
export MDM1_IP_ADDRESS=x.x.x.x
export MDM2_IP_ADDRESS=x.x.x.x
export MDM1_CRT=$(ssh -q $MDM1_IP_ADDRESS sudo cat /opt/emc/scaleio/mdm/cfg/mdm_management_certificate.pem | sed -n -e '/-----BEGIN CERTIFICATE-----/,$p' | sed ':a;N;$!ba;s/\n/\\n/g')
export MDM2_CRT=$(ssh -q $MDM2_IP_ADDRESS sudo cat /opt/emc/scaleio/mdm/cfg/mdm_management_certificate.pem | sed -n -e '/-----BEGIN CERTIFICATE-----/,$p' | sed ':a;N;$!ba;s/\n/\\n/g')
```

If `requiretty` is not enabled in sudoers, please use following commands instead:
```
export MDM1_IP_ADDRESS=x.x.x.x  
export MDM2_IP_ADDRESS=x.x.x.x  
export MDM1_CRT=$(ssh -qt $MDM1_IP_ADDRESS sudo cat /opt/emc/scaleio/mdm/cfg/mdm_management_certificate.pem | sed -n -e '/-----BEGIN CERTIFICATE-----/,$p' | tr -d "\r" | sed ':a;N;$!ba;s/\n/\\n/g')
export MDM2_CRT=$(ssh -qt $MDM2_IP_ADDRESS sudo cat /opt/emc/scaleio/mdm/cfg/mdm_management_certificate.pem | sed -n -e '/-----BEGIN CERTIFICATE-----/,$p' | tr -d "\r" | sed ':a;N;$!ba;s/\n/\\n/g')
```

## Support

If you need generic help with the ScaleIO Gateway please reach out to the [ScaleIO Community ](https://community.emc.com/community/products/scaleio)  or the [EMC CodeCommunity](http://community.emccode.com/) on Slack in the `scaleio_rest`channel.
For problems or questions regarding the Docker Image please report an issue on [GitHub](https://github.com/sergeymatsak87/docker-scaleio-gw/issues).
