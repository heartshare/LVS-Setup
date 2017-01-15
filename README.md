# LVS-Setup USER INTRODUCTION

Authored by PrexusTech Microsystems.Licensed by Apache 2.0.
This scipt was designed to setup and configure the LVS Clusters.
By running this script,you can set up LVS usder DR,IP-TUN and/or NAT modes with ease.

# USAGE
In Linux distributions
`# chmod a+x lvs_setup.sh`


```
# ./lvs_setup.sh -<Options> [ld|rs]
Options:
				-nat:Using LVS NAT mode;
				-dr:Using LVS DR mode;
				-iptun:Using Linux IPIP Tunnel;
ld : Configure the load balancer;
rs : Configure the real server.
```
