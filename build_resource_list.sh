#!/bin/bash

THIS_DIR=$(cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd)

write_resources() {
    PLATFORM_DIR="$THIS_DIR/$1"
    pushd $PLATFORM_DIR

    QRC="$PLATFORM_DIR/resources.qrc"

    echo '<!DOCTYPE RCC>' > $QRC
    echo '<RCC version="1.0">' >> $QRC
    echo '  <qresource prefix="/gdal">' >> $QRC

    # for each files/folder in the folder "theFokderName"
    for a in $(find "$PLATFORM_DIR/share/gdal" -name *.csv)
    do
        # if this is not a folder
        if [ ! -d "$a" ]; then
            name=$(basename "$a")
            echo "      <file alias=\"$name\">share/gdal/$name</file>" >> $QRC
        fi
    done

    echo '  </qresource>' >> $QRC
    echo '</RCC>' >> $QRC

    popd
}

write_resources macos
write_resources linux
write_resources android
write_resources android-arm64
write_resources windows
