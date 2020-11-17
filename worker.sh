
###############Tomcat 연동#############


wget http://www.apache.org/dist/tomcat/tomcat-connectors/jk/tomcat-connectors-1.2.40-src.tar.gz -P /tmp
cd /tmp/tomcat-connectors-1.2.40-src/native
./configure --with-apxs=$PREFIX/bin/apxs
make && make install


echo -e '# Load mod_jk module' >> "$PREFIX"/conf/httpd.conf
echo -e 'LoadModule jk_module modules/mod_jk.so' >> "$PREFIX"/conf/httpd.conf
echo -e '# Where to find workers.properties' >> "$PREFIX"/conf/httpd.conf
echo -e 'JkWorkersFile conf/workers.properties' >> "$PREFIX"/conf/httpd.conf
echo -e '# Where to put jk shared memory' >> "$PREFIX"/conf/httpd.conf
echo -e 'JkShmFile     logs/mod_jk.shm' >> "$PREFIX"/conf/httpd.conf
echo -e '# Where to put jk logs' >> "$PREFIX"/conf/httpd.conf
echo -e 'JkLogFile     logs/mod_jk.log' >> "$PREFIX"/conf/httpd.conf
echo -e '# Set the jk log level [debug/error/info]' >> "$PREFIX"/conf/httpd.conf
echo -e 'JkLogLevel    info' >> "$PREFIX"/conf/httpd.conf
echo -e '# Select the timestamp log format' >> "$PREFIX"/conf/httpd.conf
echo -e 'JkLogStampFormat "[%a %b %d %H:%M:%S %Y] "' >> "$PREFIX"/conf/httpd.conf
echo -e 'JkMount /* ajp13_worker' >> "$PREFIX"/conf/httpd.conf
echo -e 'JkUnMount /resource/* ajp13_worker3' >> "$PREFIX"/conf/httpd.conf

cat <<EOF > /data/web/conf/workers.properties

# workers.properties -
#
# This file is a simplified version of the workers.properties supplied
# with the upstream sources. The jni inprocess worker (not build in the
# debian package) section and the ajp12 (deprecated) section are removed.
#
# As a general note, the characters $( and ) are used internally to define
# macros. Do not use them in your own configuration!!!
#
# Whenever you see a set of lines such as:
# x=value
# y=$(x)\something
#
# the final value for y will be value\something
#
# Normaly all you will need to do is un-comment and modify the first three
# properties, i.e. workers.tomcat_home, workers.java_home and ps.
# Most of the configuration is derived from these.
#
# When you are done updating workers.tomcat_home, workers.java_home and ps
# you should have 3 workers configured:
#
# - An ajp13 worker that connects to localhost:8009
# - A load balancer worker
#
#

# OPTIONS ( very important for jni mode )

#
# workers.tomcat_home should point to the location where you
# installed tomcat. This is where you have your conf, webapps and lib
# directories.
#
workers.tomcat_home=/data/was

#
# workers.java_home should point to your Java installation. Normally
# you should have a bin and lib directories beneath it.
#
workers.java_home=/usr/java/jdk1.8.0_144

#
# You should configure your environment slash... ps=\ on NT and / on UNIX
# and maybe something different elsewhere.
#
ps=/

#
#------ ADVANCED MODE ------------------------------------------------
#---------------------------------------------------------------------
#

#
#------ worker list ------------------------------------------
#---------------------------------------------------------------------
#
#
# The workers that your plugins should create and work with
#
worker.list=ajp13_worker

#
#------ ajp13_worker WORKER DEFINITION ------------------------------
#---------------------------------------------------------------------
#

#
# Defining a worker named ajp13_worker and of type ajp13
# Note that the name and the type do not have to match.
#
worker.ajp13_worker.port=8009
worker.ajp13_worker.host=localhost
worker.ajp13_worker.type=ajp13
#
# Specifies the load balance factor when used with
# a load balancing worker.
# Note:
#  ----> lbfactor must be > 0
#  ----> Low lbfactor means less work done by the worker.
worker.ajp13_worker.lbfactor=1

#
# Specify the size of the open connection cache.
#worker.ajp13_worker.cachesize

#
#------ DEFAULT LOAD BALANCER WORKER DEFINITION ----------------------
#---------------------------------------------------------------------
#

#
# The loadbalancer (type lb) workers perform wighted round-robin
# load balancing with sticky sessions.
# Note:
#  ----> If a worker dies, the load balancer will check its state
#        once in a while. Until then all work is redirected to peer
#        workers.
worker.loadbalancer.type=lb
worker.loadbalancer.balance_workers=ajp13_worker
EOF
