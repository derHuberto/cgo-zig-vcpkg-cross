cmake -B build -S . "-DCMAKE_TOOLCHAIN_FILE=/path/to/vcpkg/scripts/buildsystems/vcpkg.cmake" -DVCPKG_TARGET_TRIPLET="zig-linux"

cmake --build . --target install

Copy the triplets from the folder into your vcpkg triplet folder to be able to use this template.

What does setup.sh do? The script sets the correct triplet to set the correct target for the Zig compiler and vcpkg. It also updates the go environment variables GOOS and GOARCH.  

What this script does not do: This script does not link any libraries. Neither the own C libraries, neither C and Go. The script also does not download any libraries. For this you use: vcpkg install pkg:zig-linux. This only works if the triplets have been copied into the vcpkg triplet folder.

What else needs to be done. If no CGO is used, change the CMake file to compile for an executable. If you are using CGO, you still need to link the library and run go build. 
