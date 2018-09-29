#/bin/bash

create_volume() {
        if [  -f fc24.qcow2 ]; then
                echo "Criando volume $1.qcow2"
                cp fc24.qcow2 $1.qcow2
                echo "Volume $1.qcow2 criado" 
        fi
} 

create_vm() {
        if [ -f $1.qcow2 ]; then
                qemu-kvm -m 1024 -drive file=$1.qcow2,media=disk,index=0 \
                        -netdev type=tap,ifname=$3$2,id=net$2,script=no \
                        -device virtio-net-pci,netdev=net$2,mac=00:16:16:15:A5:5$2 \
                        -vnc :$2  \
                        -serial unix:/tmp/serial$1,server,nowait \
                        -chardev socket,path=/tmp/monitor$1,server,nowait,id=unixmon$2 \
                        -mon chardev=unixmon$2 -daemonize
        fi

}

for arg in $@ ; do
        if [ $arg == "huguinho" ]; then
                i=0
		vmname=huguinho
        elif [ $arg == "zezinho" ]; then
		vmname=zezinho
                i=1
        elif [ $arg == "luizinho" ]; then
		vmname=luizinho
                i=2
	elif [ $arg == "tap" ]; then
		net=tap
        else
                exit 1
        fi

done

create_volume $vmname
create_vm $vmname $i $net

