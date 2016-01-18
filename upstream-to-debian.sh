#!/bin/bash

SOURCE_FILE='README.md'
ZERONET_REPO='https://github.com/HelloZeroNet/ZeroNet.git'
ZERONET_COMMIT='675bd462556c541d65e2d95f91f899146a373aad'
UPSTREAM_DIR=~/.zeronet_package
CURR_DIR=$(pwd)

if [ $1 ]; then
    ZERONET_COMMIT='675bd462556c541d65e2d95f91f899146a373aad'
fi

if [ ! -d gnu-social ]; then
    git clone $ZERONET_REPO $UPSTREAM_DIR
else
    cd $UPSTREAM_DIR
    git stash
    git checkout master
    git pull
    cd $CURR_DIR
fi

cd $UPSTREAM_DIR
git stash
git checkout $ZERONET_COMMIT -b $ZERONET_COMMIT
cd $CURR_DIR

cp -r $UPSTREAM_DIR/* src/

# update git
git add src

# remove excess licences
rm src/LICENSE
rm src/src/lib/PySocks/LICENSE
rm src/src/lib/pybitcointools/LICENSE
rm src/src/lib/subtl/LICENCE

# Make scripts executable
chmod +x src/plugins/Sidebar/maxminddb/ipaddr.py
chmod +x src/src/Test/BenchmarkSsl.py
chmod +x src/src/lib/PySocks/setup.py
chmod +x src/src/lib/PySocks/sockshandler.py
chmod +x src/src/lib/PySocks/test/httpproxy.py
chmod +x src/src/lib/PySocks/test/socks4server.py
chmod +x src/src/lib/PySocks/test/test.sh
chmod +x src/src/lib/opensslVerify/opensslVerify-alter2.py
chmod +x src/src/lib/pybitcointools/bitcoin/bci.py
chmod +x src/src/lib/pybitcointools/bitcoin/main.py
chmod +x src/src/lib/pybitcointools/bitcoin/transaction.py
chmod +x src/src/lib/pybitcointools/pybtctool
chmod +x src/src/lib/pybitcointools/setup.py
chmod +x src/start.py
chmod +x src/zeronet.py

echo "Synced with upstream to commit $ZERONET_COMMIT"
exit 0
