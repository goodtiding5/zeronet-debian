#!/bin/bash

SOURCE_FILE='README.md'
APP=zeronet
PREV_VERSION=0.0.1
VERSION=$(cat $SOURCE_FILE | grep 'Version:' | head -n 1 | awk -F ':' '{print $2}' | sed -e 's/^[ \t]*//')
RELEASE=$(cat $SOURCE_FILE | grep 'Release:' | head -n 1 | awk -F ':' '{print $2}' | sed -e 's/^[ \t]*//')
ZERONET_COMMIT=$(cat $SOURCE_FILE | grep 'Upstream commit:' | head -n 1 | awk -F ':' '{print $2}' | sed -e 's/^[ \t]*//')
ARCH_TYPE='all'
DIR=${APP}-${VERSION}
export DH_ALWAYS_EXCLUDE=.git

# Update version numbers automatically - so you don't have to
sed -i "s/VERSION=.*/VERSION='${VERSION}'/g" Makefile
sed -i "s/RELEASE=.*/RELEASE='${RELEASE}'/g" Makefile
sed -i "s/ZERONET_COMMIT=.*/ZERONET_COMMIT='${ZERONET_COMMIT}'/g" upstream-to-debian.sh
sed -i "s/-'${PREV_VERSION}'.so/-'${VERSION}'.so/g" debian/*.links

if ! grep -q "$VERSION" debian/changelog; then
	echo "Edit debian/changelog and add version $VERSION-$RELEASE at the top"
	exit 1
fi

make clean
make
if [ ! "$?" = "0" ]; then
	exit 1
fi

# change the parent directory name to debian format
mv ../${APP}-debian ../${DIR}

# Create a source archive
make source
if [ ! "$?" = "0" ]; then
    mv ../${DIR} ../${APP}-debian
	exit 2
fi

# Build the package
dpkg-buildpackage -i -F
if [ ! "$?" = "0" ]; then
    mv ../${DIR} ../${APP}-debian
	exit 3
fi

# sign files
#gpg -ba ../${APP}_${VERSION}-1_${ARCH_TYPE}.deb
#gpg -ba ../${APP}_${VERSION}.orig.tar.gz

# restore the parent directory name
mv ../${DIR} ../${APP}-debian
