uthor£ºwenjun.fang
#E-mail:hsweib@163.com
#Data:2015.04.26
#Version:1.0.3
#Runing_PATH:Ubuntu14.04 15.04 x86 x86_x64


PATH=/bin:/sbin:/usr/bin:/usr/sbin:/usr/local/bin:/usr/local/sbin:~/bin
export PATH
#system info
x64=`uname -a | awk '{print $12}'`
sys_version="x86_64"
cpu=`cat /proc/cpuinfo | grep "model name" | uniq -w1 | awk '{print $4$5$6}'`
meminfo=`cat /proc/meminfo | grep "MemTotal" | awk '{print $2/1024}'`

echo "\033[33m +++++++++++++System info++++++++++++++++++ \033[0m"
echo "\033[33m System_CPU:$cpu \033[0m"
echo "\033[33m System_Mem:$meminfo \033[0m"
echo "\033[33m System_version:$sys_version \033[0m"
echo "\033[33m +++++++++++++System info++++++++++++++++++ \033[0m"
echo "\033[31m Ubuntu: sudo sh gns3.sh,input password runing...\033[0m"

# Check if user is root
if [ $(id -u) != "0" ]; then
    echo "\033[31m Warning: You must be root to run this script, please use root to install gns3 \033[0m"
    exit 1
fi
#install lib
sudo apt-get install python3-setuptools python3-pyqt4 python3-ws4py python3-netifaces -y
sudo apt-get install cmake libelf-dev uuid-dev libpcap-dev -y
sudo apt-get install libssl1.0.0:i386 bison flex git -y
sudo apt-get install wireshark -y
sudo chmod +x /usr/bin/dumpcap
sudo apt-get install dos2unix
#gns3 1.3.0

sudo rm -rf dynamips-0.2.*
sudo rm -rf gns3-server-*
sudo rm -rf gns3-gui-*
sudo rm -rf iouyap-*
sudo rm -rf vpcs-*

if [ -f "GNS3-1.3.9.source.zip" ];then
unzip GNS3-1.3.9.source.zip
else
wget -c https://github.com/GNS3/gns3-gui/releases/download/v1.3.9/GNS3-1.3.9.source.zip
unzip GNS3-1.3.9.source.zip
fi

#dynamips
unzip dynamips-0.2.14.zip
cd dynamips-0.2.14
mkdir build
cd build
cmake ..
make
sudo make install
sudo setcap cap_net_admin,cap_net_raw=ep /usr/local/bin/dynamips
cd ../../
#install gns3 server
unzip gns3-server-1.3.9.zip
cd gns3-server-1.3.9
sudo python3 setup.py install
cd ..
#gns3 gui
unzip gns3-gui-1.3.9.zip
cd gns3-gui-1.3.9
sudo python3 setup.py install
cd ..
#iouyap
sudo ln -s /lib/i386-linux-gnu/libcrypto.so.1.0.0 /lib/libcrypto.so.4
git clone http://github.com/ndevilla/iniparser.git
cd iniparser
make
sudo cp libiniparser.* /usr/lib/
sudo cp src/iniparser.h /usr/local/include/
sudo cp src/dictionary.h /usr/local/include/
cd ..
unzip iouyap-0.95.zip
cd iouyap-0.95
sudo make install
sudo cp iouyap /usr/local/bin/
cd ..
#vpcs
unzip vpcs-0.6.zip
cd vpcs-0.6/src/
if [ "$x64"="$sys_version" ];then
./mk.sh 64
else
./mk.sh
fi
sudo cp vpcs /usr/local/bin/

#check iourc.txt unicode
cd ../..
dos2unix iourc.txt

#reg Cisco IOU
python3 CiscoIOUKeygen.py > tmp
cat tmp | sed -n '7,8p' > iourc.txt
sudo chmod 777 iourc.txt
echo '127.0.0.127 xml.cisco.com' >> /etc/hosts
rm -rf tmp
#gns3
echo "++++++++++++++++++++++++++++++++++++++++++++"
echo "GNS3 1.3.1 install Success!!!"
echo "Please open Terminal input gns3 runing..."
echo "++++++++++++++++++++++++++++++++++++++++++++"


