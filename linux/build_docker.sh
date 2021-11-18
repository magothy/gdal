#!/bin/bash

# How to run
# docker run -v ${PWD}:/scripts --rm -it mavlink/qgc-build-linux /scripts/build_docker.sh
# This will build the libs in the current folder

apt update
apt install -y python pkg-config automake autoconf autogen libtool git

GDAL_LIB=libgdal.so
PROJ_LIB=libproj.so

COPY_DIR="/scripts" # where final output is copied to

WORKING_DIR="/build"
INSTALL_DIR="/external" # where libraries are installed to via make install

mkdir -p "$WORKING_DIR"
mkdir -p "$INSTALL_DIR"

pushd "$WORKING_DIR"

## Compile PROJ

git clone https://github.com/OSGeo/PROJ/
pushd PROJ/
git checkout 5.2.0
./autogen.sh
./configure --prefix="$INSTALL_DIR/proj"
make -j16
make install
popd

## Compile GDAL

git clone https://github.com/OSGeo/gdal.git
pushd gdal
git checkout v2.4.2
pushd gdal

./autogen.sh

./configure \
 --prefix="$INSTALL_DIR/gdal" \
 --with-libtiff=internal \
 --with-geotiff=internal \
 --with-libjson-c=internal \
 --with-static-proj4="$INSTALL_DIR/proj" \
 --with-hide-internal-symbols=yes \
 --with-threads  \
 --with-libz=internal  \
 --without-geos \
 --without-zstd \
 --without-sse  \
 --without-ssse3  \
 --without-avx \
 --without-liblzma  \
 --without-pg  \
 --without-grass  \
 --without-libgrass  \
 --without-cfitsio  \
 --without-pcraster  \
 --with-png=internal \
 --without-dds \
 --without-gta \
 --without-pcidsk \
 --without-jpeg      \
 --without-gif  \
 --without-ogdi      \
 --without-fme        \
 --without-sosi         \
 --without-mongocxx        \
 --without-boost-lib-path   \
 --without-hdf4      \
 --without-hdf5      \
 --without-kea       \
 --without-netcdf    \
 --without-jasper    \
 --without-openjpeg  \
 --without-fgdb      \
 --without-ecw       \
 --without-kakadu    \
 --without-mrsid       \
 --without-jp2mrsid    \
 --without-mrsid_lidar  \
 --without-msg           \
 --without-bsb        \
 --without-oci        \
 --without-grib           \
 --without-gnm             \
 --without-mysql  \
 --without-ingres \
 --without-xerces \
 --without-expat  \
 --without-libkml  \
 --without-odbc \
 --without-curl \
 --without-xml2 \
 --without-spatialite \
 --without-sqlite3 \
 --without-rasterlite2 \
 --without-pcre \
 --without-teigha  \
 --without-idb \
 --without-sde \
 --without-epsilon \
 --without-webp \
 --without-sfcgal \
 --without-qhull \
 --without-opencl \
 --without-freexl \
 --without-pam      \
 --without-poppler  \
 --without-podofo \
 --without-pdfium \
 --without-macosx-framework    \
 --without-perl            \
 --without-python \
 --without-java     \
 --without-mdb       \
 --without-jvm-lib \
 --without-rasdaman   \
 --without-armadillo  \
 --without-cryptopp   \
 --without-mrf

make -j8
make install

popd
popd

rm -fr "$COPY_DIR/lib" "$COPY_DIR/include" "$COPY_DIR/share" 
mkdir -p "$COPY_DIR/lib"
cp -r "$INSTALL_DIR/gdal/include" "$COPY_DIR"
cp -r "$INSTALL_DIR/gdal/share" "$COPY_DIR"
cp -L "$INSTALL_DIR/gdal/lib/$GDAL_LIB" "$COPY_DIR/lib"
cp -L "$INSTALL_DIR/proj/lib/$PROJ_LIB" "$COPY_DIR/lib"
