echo ;
echo ;
echo 正在安装服务器，请稍候.......... ;
echo ;
cd /;
apt-get update > /dev/null ;
apt-get install default-jdk build-essential pwgen git -y -q > /dev/null ;
update-rc.d squid disabled > /dev/null ;
service squid stop > /dev/null ;

if [ -e "/wall.cross" ] ; then

echo "目录 /wall.cross 已经存在，安装退出" ;
echo ;
echo "如需重新安装，请先把目录 /wall.cross 改名或删除" ;

else

git clone https://github.com/TestForEducation/wall.cross.git ;

chmod a+x /wall.cross/server.sh ;
chmod a+x /wall.cross/stop.sh ;
for i in $( seq 20001 20003 )
do pwgen -n -s -B -c 10 | sed "s/^/$i /";
done > /wall.cross/user.tx_ ;
rm -f /wall.cross/user.txt ;
cp /wall.cross/user.tx_ /wall.cross/user.txt ;

sed -i "s/-Xms512M/-Xms256M/g" /wall.cross/server.sh ;
sed -i "s/-Xmx512M/-Xmx256M/g" /wall.cross/server.sh ;

# iptables -F ;
# iptables -A INPUT -p tcp --dport 26461 -j ACCEPT ;
# iptables -A INPUT -p tcp --dport 5128 -j ACCEPT ;
# iptables -A INPUT -p udp --dport 5128 -j ACCEPT ;
# iptables -A INPUT -p tcp --dport 443 -j ACCEPT ;
# iptables -A INPUT -p tcp --dport 25 -j ACCEPT ;
# iptables -A INPUT -p tcp --dport 110 -j ACCEPT ;
# iptables -A INPUT -p tcp --dport 20001:20003 -j ACCEPT ;
# iptables -A INPUT -p tcp --dport 28040:28050 -j ACCEPT ;
# iptables -P INPUT DROP ;
# iptables -P FORWARD DROP ;
# iptables -P OUTPUT ACCEPT ;
# iptables -A INPUT -i lo -j ACCEPT ;
# iptables -A INPUT -m state --state ESTABLISHED,RELATED -j ACCEPT ;
# iptables -A INPUT -p icmp -j ACCEPT ;
# iptables-save > /dev/null ;

fi;

cd /root ;
mkdir sockd;
cd sockd;
wget http://www.inet.no/dante/files/dante-1.4.2.tar.gz;
tar -xvzf dante-1.4.2.tar.gz > /dev/null ;
cd dante-1.4.2;
./configure > /dev/null ;
make > /dev/null ;
make install > /dev/null ;
cd ..;
#创建配置文件
echo internal: 127.0.0.1 port = 3128 > /etc/sockd.conf;
echo external: eth0 >> /etc/sockd.conf;
echo clientmethod: none >> /etc/sockd.conf;
echo socksmethod: none >> /etc/sockd.conf;
echo user.notprivileged: nobody >> /etc/sockd.conf;
echo errorlog: /var/log/sockd.err >> /etc/sockd.conf;
echo client pass { from: 0/0 to: 0/0 } >> /etc/sockd.conf;
echo socks block { from: 0/0 to: lo } >> /etc/sockd.conf;
echo socks pass { from: 0/0 to: 0/0 } >> /etc/sockd.conf;

#创建服务启动脚本
echo "killall sockd > /dev/null 2>&1" > sockd-start.sh;
echo /usr/local/sbin/sockd -D >> sockd-start.sh;

#创建服务停止脚本
echo "killall sockd > /dev/null 2>&1" > sockd-stop.sh;

#设置启动、停止脚本为可执行文件
chmod +x sockd-start.sh sockd-stop.sh
echo "/root/sockd/sockd-start.sh" >> /etc/rc.local;
echo ;
echo "已完成 wall.cross 服务器安装" ;
echo ;
echo "启动sockd请执行 /root/sockd/sockd-start.sh " ;
echo ;
echo "端口和密码在文件 /wall.cross/user.txt" ;
echo ;
echo "启动服务器请执行 /wall.cross/server.sh " ;
echo ;
echo ;
