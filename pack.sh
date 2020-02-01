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

opt=/usr/local/opt
dst=dist/dosbox-staging.app/Contents/

# Prepare content
install -d "$dst/MacOS/"
install -d "$dst/Resources/"
install -d "$dst/SharedSupport/"

# install -d dosbox-staging.app/Contents/_CodeSignature/ # ?

install_name_tool -change "$opt/libpng/lib/libpng16.16.dylib"         @rpath/libpng16.16.dylib src/dosbox
install_name_tool -change "$opt/opusfile/lib/libopusfile.0.dylib"     @rpath/libopusfile.0.dylib src/dosbox 
install_name_tool -change "$opt/sdl2/lib/libSDL2-2.0.0.dylib"         @rpath/libSDL2-2.0.0.dylib src/dosbox 
install_name_tool -change "$opt/sdl2_net/lib/libSDL2_net-2.0.0.dylib" @rpath/libSDL2_net-2.0.0.dylib src/dosbox 

install        "src/dosbox"                                "$dst/MacOS/"
install        "$opt/libpng/lib/libpng16.16.dylib"         "$dst/MacOS/"
install        "$opt/opusfile/lib/libopusfile.0.dylib"     "$dst/MacOS/"
install        "$opt/sdl2/lib/libSDL2-2.0.0.dylib"         "$dst/MacOS/"
install        "$opt/sdl2_net/lib/libSDL2_net-2.0.0.dylib" "$dst/MacOS/"
install -m 644 "contrib/macos/Info.plist"                  "$dst/Info.plist"
install -m 644 "contrib/macos/PkgInfo"                     "$dst/PkgInfo"
install -m 644 "contrib/icons/dosbox-staging.icns"         "$dst/Resources/"
install -m 644 "docs/README.template"                      "$dst/SharedSupport/README"
install -m 644 "COPYING"                                   "$dst/SharedSupport/COPYING"
install -m 644 "README"                                    "$dst/SharedSupport/manual.txt"
install -m 644 "docs/README.video"                         "$dst/SharedSupport/video.txt"

ln -s /Applications dist/

hdiutil create \
    -volname "dosbox-staging" \
    -srcfolder dist \
    -ov -format UDZO "dosbox-staging $(git describe --abbrev=5).dmg"
