#!/bin/bash

# ./configure --disable-opus-cdda --disable-screenshots

set -x

opt=/usr/local/opt
dst=dist/dosbox-staging.app/Contents/

# Prepare content
install -d "$dst/MacOS/"
install -d "$dst/Resources/"
install -d "$dst/SharedSupport/"

# install -d dosbox-staging.app/Contents/_CodeSignature/ # ?

overwrite_load_path () {
	local -r lib_in=$1
	local -r bin_file=$2
	install_name_tool \
		-change "$lib_in" \
		@executable_path/$(basename "$lib_in") \
		"$bin_file"
}

install        "src/dosbox"                                "$dst/MacOS/"
# install        "$opt/libpng/lib/libpng16.16.dylib"         "$dst/MacOS/"
# install        "$opt/opusfile/lib/libopusfile.0.dylib"     "$dst/MacOS/"
install        "$opt/sdl2/lib/libSDL2-2.0.0.dylib"         "$dst/MacOS/"
# install        "$opt/sdl2_net/lib/libSDL2_net-2.0.0.dylib" "$dst/MacOS/"
install -m 644 "contrib/macos/Info.plist"                  "$dst/Info.plist"
install -m 644 "contrib/macos/PkgInfo"                     "$dst/PkgInfo"
install -m 644 "contrib/icons/dosbox-staging.icns"         "$dst/Resources/"
install -m 644 "docs/README.template"                      "$dst/SharedSupport/README"
install -m 644 "COPYING"                                   "$dst/SharedSupport/COPYING"
install -m 644 "README"                                    "$dst/SharedSupport/manual.txt"
install -m 644 "docs/README.video"                         "$dst/SharedSupport/video.txt"

# pushd "$dst/MacOS"
# overwrite_load_path "$opt/libpng/lib/libpng16.16.dylib"         dosbox
# overwrite_load_path "$opt/opusfile/lib/libopusfile.0.dylib"     dosbox 
# overwrite_load_path "$opt/sdl2/lib/libSDL2-2.0.0.dylib"         dosbox 
# overwrite_load_path "$opt/sdl2_net/lib/libSDL2_net-2.0.0.dylib" dosbox 
# overwrite_load_path "$opt/libpng/lib/libpng16.16.dylib"         libpng16.16.dylib
# overwrite_load_path "$opt/sdl2/lib/libSDL2-2.0.0.dylib"         libSDL2-2.0.0.dylib
# overwrite_load_path "$opt/sdl2_net/lib/libSDL2_net-2.0.0.dylib" libSDL2_net-2.0.0.dylib
# overwrite_load_path "$opt/sdl2/lib/libSDL2-2.0.0.dylib"         libSDL2_net-2.0.0.dylib
# popd

ln -s /Applications dist/

hdiutil create \
    -volname "dosbox-staging" \
    -srcfolder dist \
    -ov -format UDZO "dosbox-staging $(git describe --abbrev=5).dmg"
