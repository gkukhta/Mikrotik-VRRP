# feb/12/2025 09:50:57 by RouterOS 7.8
# software id = 
#
:global myip "252"; # @master - 252; @backup - 253
:global hiPriority "200"; # @master - 200; @backup - 100
/system identity
set name=R1; # @master - R1; @backup - R2

/ip dhcp-client disable [find interface=ether1]
/interface ethernet
set [ find default-name=ether1 ] comment=Internet disable-running-check=no
set [ find default-name=ether2 ] comment=192.168.88.0/24 disable-running-check=no
set [ find default-name=ether3 ] disable-running-check=no
set [ find default-name=ether4 ] disable-running-check=no
set [ find default-name=ether5 ] comment=192.168.89.0/24 disable-running-check=no
/interface vrrp
add comment="vrrp 192.168.88.0/24" interface=ether2 name=vrrp-88 priority=$hiPriority vrid=88
add comment="vrrp 192.168.89.0/24" interface=ether5 name=vrrp-89 priority=$hiPriority vrid=89
add comment="vrrp 192.168.122.0/24" interface=ether1 name=vrrp-inet priority=$hiPriority vrid=122
/ip address
add address="192.168.122.$myip/24" interface=ether1 network=192.168.122.0
add address=192.168.122.251/24 interface=vrrp-inet network=192.168.122.0
add address="192.168.88.$myip/24" comment=192.168.88.0/24 interface=ether2 network=192.168.88.0
add address=192.168.88.251/24 interface=vrrp-88 network=192.168.88.0
add address="192.168.89.$myip/24" comment=192.168.89.0/24 interface=ether5 network=192.168.89.0
add address=192.168.89.251/24 interface=vrrp-89 network=192.168.89.0
/ip firewall nat
add action=masquerade chain=srcnat out-interface=vrrp-inet
/ip route
add comment=Internet gateway=192.168.122.1%vrrp-inet
/system scheduler
add interval=2s name=checkLinkDownScheduler on-event="/system script run checkLinkDown" policy=read,write,test start-time=startup
