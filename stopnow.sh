cd `dirname $0`

_pack="cross.wall"

kill -9 `jps -l |grep $_pack.Server |awk '{print $1}'` > null 2>&1

rm -f server.lock
