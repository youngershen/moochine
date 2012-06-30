#export OPENRESTY_HOME=$HOME/Developer/openresty
export OPENRESTY_HOME=/usr/local/openresty
PWD=`PWD`
DEMO_DIR=$PWD"/demo/"
NGINX_TEMP=$DEMO_DIR"/nginx_temp"
 
mkdir -p $NGINX_TEMP
mkdir -p $NGINX_TEMP"/conf"
mkdir -p $NGINX_TEMP"/logs"

$OPENRESTY_HOME/nginx/sbin/nginx -p $DEMO_DIR  -c conf/nginx.conf 

#$OPENRESTY_HOME/nginx/sbin/nginx -p $NGINX_TEMP  -c conf/nginx.conf -s reload



