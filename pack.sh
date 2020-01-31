#!/bin/bash
set -x
# Prepare content
install -d dist/dosbox-staging.app/Contents/MacOS/
install -d dist/dosbox-staging.app/Contents/Resources/
install -d dist/dosbox-staging.app/Contents/SharedSupport/

# install -d dosbox-staging.app/Contents/_CodeSignature/ # ?

install        src/dosbox               dist/dosbox-staging.app/Contents/MacOS/dosbox
install -m 644 contrib/macos/Info.plist dist/dosbox-staging.app/Contents/Info.plist
install -m 644 contrib/macos/PkgInfo    dist/dosbox-staging.app/Contents/PkgInfo
install -m 644 docs/README.template     dist/dosbox-staging.app/Contents/SharedSupport/README
install -m 644 COPYING                  dist/dosbox-staging.app/Contents/SharedSupport/COPYING
install -m 644 README                   dist/dosbox-staging.app/Contents/SharedSupport/manual.txt
install -m 644 docs/README.video        dist/dosbox-staging.app/Contents/SharedSupport/video.txt

ln -s /Applications dist/

hdiutil create \
    -volname "dosbox-staging" \
    -srcfolder dist \
    -ov -format UDZO "dosbox-staging v0.75.0-500-g0000.dmg"
