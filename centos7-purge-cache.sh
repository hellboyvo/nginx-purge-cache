#!/bin/bash

yum group install -y "Development Tools"

yum install -y gcc-c++ pcre-devel zlib-devel make unzip perl-XML-LibXML libxslt-devel libxslt-python perl-XML-LibXSLT gd-devel libXpm-devel perl-ExtUtils-Embed gperftools gperftools-devel gcc-c++ pcre-devel zlib-devel make unzip geoip-devel

cd /root/addons/nginx/nginx-1.16.1
wget https://github.com/FRiCKLE/ngx_cache_purge/archive/2.3.tar.gz
wget https://github.com/FRiCKLE/ngx_coolkit/archive/0.2.tar.gz
wget https://github.com/FRiCKLE/ngx_slowfs_cache/archive/1.10.tar.gz
wget https://github.com/openresty/headers-more-nginx-module/archive/v0.32.tar.gz
wget https://github.com/pagespeed/ngx_pagespeed/archive/v1.12.34.3-stable.tar.gz

mv 2.3.tar.gz ngx_cache_purge-2.3.tar.gz
tar -xvf ngx_cache_purge-2.3.tar.gz
mv 0.2.tar.gz ngx_coolkit-0.2.tar.gz
tar -xvf ngx_coolkit-0.2.tar.gz
mv 1.10.tar.gz ngx_slowfs_cache-1.10.tar.gz
tar -xvf ngx_slowfs_cache-1.10.tar.gz
mv v0.32.tar.gz ngx_headers-more-v0.32.tar.gz
tar -xvf ngx_headers-more-v0.32.tar.gz
mv headers-more-nginx-module-0.32 ngx_headers-more-0.32
tar -xzf v1.12.34.3-stable.tar.gz
cd ngx_pagespeed-1.12.34.3-stable
wget https://dl.google.com/dl/page-speed/psol/1.12.34.2-x64.tar.gz
tar -xzvf 1.12.34.2-x64.tar.gz
rm 1.12.34.2-x64.tar.gz
cd ..
rm *.gz

cd /usr/share/nginx/modules
git clone https://github.com/google/ngx_brotli.git
cd ngx_brotli/
git submodule update --init --recursive

cd /usr/share
git clone https://github.com/openssl/openssl.git
cd openssl
git checkout tls1.3-draft-18

./config shared enable-tls1_3 --prefix=/usr/share/openssl --openssldir=/usr/share/openssl -Wl,-rpath,'$(LIBRPATH)'


cd /root/addons/nginx/nginx-1.16.1

mkdir -p /usr/share/nginx/modules/ngx_cache_purge-2.3
rsync -r /root/addons/nginx/nginx-1.16.1/ngx_cache_purge-2.3/* /usr/share/nginx/modules/ngx_cache_purge-2.3
mkdir -p /usr/share/nginx/modules/ngx_coolkit-0.2
rsync -r /root/addons/nginx/nginx-1.16.1/ngx_coolkit-0.2/* /usr/share/nginx/modules/ngx_coolkit-0.2
mkdir -p /usr/share/nginx/modules/ngx_slowfs_cache-1.10
rsync -r /root/addons/nginx/nginx-1.16.1/ngx_slowfs_cache-1.10/* /usr/share/nginx/modules/ngx_slowfs_cache-1.10
mkdir -p /usr/share/nginx/modules/ngx_headers-more-0.32
rsync -r /root/addons/nginx/nginx-1.16.1/ngx_headers-more-0.32/* /usr/share/nginx/modules/ngx_headers-more-0.32
mkdir -p /usr/share/nginx/modules/ngx_pagespeed-1.12.34.3-stable
rsync -r /root/addons/nginx/nginx-1.16.1/incubator-pagespeed-ngx-1.12.34.3-stable/* /usr/share/nginx/modules/ngx_pagespeed-1.12.34.3-stable
cd /usr/share/nginx/modules/ngx_pagespeed-1.12.34.3-stable
wget https://dl.google.com/dl/page-speed/psol/1.12.34.2-x64.tar.gz
tar -xzvf 1.12.34.2-x64.tar.gz # expands to psol/



cd /root/addons/nginx/nginx-1.16.1

./configure --prefix=/etc/nginx \
    --sbin-path=/usr/sbin/nginx \
    --modules-path=/usr/lib64/nginx/modules \
    --conf-path=/etc/nginx/nginx.conf \
    --error-log-path=/var/log/nginx/error.log \
    --http-log-path=/var/log/nginx/access.log \
    --lock-path=/var/lock/nginx.lock \
    --pid-path=/var/run/nginx.pid \
    --http-client-body-temp-path=/var/lib/nginx/body \
    --http-fastcgi-temp-path=/var/lib/nginx/fastcgi \
    --http-proxy-temp-path=/var/lib/nginx/proxy \
    --http-scgi-temp-path=/var/lib/nginx/scgi \
    --http-uwsgi-temp-path=/var/lib/nginx/uwsgi \
    --user=nginx \
    --group=nginx \
    --with-debug \
    --with-file-aio \
    --with-google_perftools_module \
    --with-mail \
    --with-mail_ssl_module \
    --with-threads \
    --with-select_module \
    --with-stream \
    --with-stream_ssl_module \
    --with-http_addition_module \
    --with-http_auth_request_module \
    --with-http_dav_module \
    --with-http_flv_module \
    --with-http_geoip_module \
    --with-http_gunzip_module \
    --with-http_gzip_static_module \
    --with-http_image_filter_module \
    --with-http_mp4_module \
    --with-http_perl_module \
    --with-http_random_index_module \
    --with-http_realip_module \
    --with-http_secure_link_module \
    --with-http_stub_status_module \
    --with-http_sub_module \
    --with-http_ssl_module \
    --with-http_v2_module \
    --with-http_xslt_module \
    --with-poll_module \
    --with-openssl=/usr/share/openssl \
    --with-openssl-opt=enable-tls1_3 \
    --add-module=/usr/share/nginx/modules/ngx_brotli \
    --add-module=/usr/share/nginx/modules/ngx_pagespeed-1.12.34.3-stable \
    --add-module=/usr/share/nginx/modules/ngx_cache_purge-2.3 \
    --add-module=/usr/share/nginx/modules/ngx_coolkit-0.2 \
    --add-module=/usr/share/nginx/modules/ngx_slowfs_cache-1.10 \
    --add-module=/usr/share/nginx/modules/ngx_headers-more-0.32

make
make install

cd /usr/share/nginx/modules/
rm *.conf
