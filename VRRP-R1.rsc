/system identity set name=R1
/ip dhcp-client remove [find interface=ether1]  
/ip address add address=192.168.122.2/24 interface=ether1
/ip route add gateway=192.168.122.1
/ip address add address=192.168.88.2/24 interface=ether2
/ip firewall nat add chain=srcnat out-interface=ether1 action=masquerade
/interface vrrp add interface=ether2 name=vrrp1 priority=200 vrid=220 version=3 \
sync-connection-tracking=yes remote-address=192.168.88.3
/ip address add address=192.168.88.1/24 interface=vrrp1
/tool netwatch add host=192.168.122.1 interval=3s \
up-script="/interface vrrp set [find name=vrrp1] priority=200" \
down-script="/interface vrrp set [find name=vrrp1] priority=50"
/system backup save