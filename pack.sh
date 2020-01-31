#!/bin/bash
set -x

# Prepare icon file
pushd contrib/icons/
mkdir dosbox-staging.iconset
cp              dosbox-staging-16.png         dosbox-staging.iconset/icon_16x16.png
sips -z 32 32   dosbox-staging-1024.png --out dosbox-staging.iconset/icon_16x16@2x.png
sips -z 32 32   dosbox-staging-1024.png --out dosbox-staging.iconset/icon_32x32.png
sips -z 64 64   dosbox-staging-1024.png --out dosbox-staging.iconset/icon_32x32@2x.png
sips -z 128 128 dosbox-staging-1024.png --out dosbox-staging.iconset/icon_128x128.png
sips -z 256 256 dosbox-staging-1024.png --out dosbox-staging.iconset/icon_128x128@2x.png
sips -z 256 256 dosbox-staging-1024.png --out dosbox-staging.iconset/icon_256x256.png
sips -z 512 512 dosbox-staging-1024.png --out dosbox-staging.iconset/icon_256x256@2x.png
sips -z 512 512 dosbox-staging-1024.png --out dosbox-staging.iconset/icon_512x512.png
cp              dosbox-staging-1024.png       dosbox-staging.iconset/icon_512x512@2x.png
iconutil -c icns dosbox-staging.iconset
popd

# Prepare content
install -d dist/dosbox-staging.app/Contents/MacOS/
install -d dist/dosbox-staging.app/Contents/Resources/
install -d dist/dosbox-staging.app/Contents/SharedSupport/

# install -d dosbox-staging.app/Contents/_CodeSignature/ # ?

install        src/dosbox                       dist/dosbox-staging.app/Contents/MacOS/dosbox
install -m 644 contrib/macos/Info.plist         dist/dosbox-staging.app/Contents/Info.plist
install -m 644 contrib/macos/PkgInfo            dist/dosbox-staging.app/Contents/PkgInfo
install -m 644 contrib/icon/dosbox-staging.icns dist/dosbox-staging.app/Contents/Resources/dosbox-staging.icns
install -m 644 docs/README.template             dist/dosbox-staging.app/Contents/SharedSupport/README
install -m 644 COPYING                          dist/dosbox-staging.app/Contents/SharedSupport/COPYING
install -m 644 README                           dist/dosbox-staging.app/Contents/SharedSupport/manual.txt
install -m 644 docs/README.video                dist/dosbox-staging.app/Contents/SharedSupport/video.txt

ln -s /Applications dist/

hdiutil create \
    -volname "dosbox-staging" \
    -srcfolder dist \
    -ov -format UDZO "dosbox-staging v0.75.0-500-g0000.dmg"
