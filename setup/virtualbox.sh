VBoxManage natnetwork add --netname natnet1 --network "192.168.15.0/24" --enable --dhcp on
VBoxManage natnetwork start --netname natnet1
VBoxManage hostonlyif create
VBoxManage hostonlyif ipconfig vboxnet0 --ip 192.168.16.1 --netmask 255.255.255.0
# see https://www.virtualbox.org/manual/ch07.html#network_nat_service