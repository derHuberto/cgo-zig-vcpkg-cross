#!/bin/sh

find_packages() {
    grep -oP 'find_package\s*\(\s*\K[\w-]+' "./CMakeLists.txt"
}

targets=("x86_64-linux-gnu" "x86_64-windows-gnu")
target=$1
if [ $# -eq 0 ]; then
echo "Error: Please provide a target [${targets[@]}]"
exit 1
fi
if !([[ " ${targets[@]} " =~ " $target " ]]); then
echo "Error: Please provide a valid target [${targets[@]}]"
exit 1
fi
if ! command -v zig >/dev/null 2>&1; then
echo "Error: zig is not installed."
exit 1
fi
if ! command -v go >/dev/null 2>&1; then
echo "Error: go is not installed."
exit 1
fi
if ! command -v vcpkg >/dev/null 2>&1; then
echo "Error: vcpkg is not installed."
exit 1
fi
if [ ! -f "CMakeLists.txt" ]; then
    echo "Error: CMakeLists.txt file not found."
    exit 1
fi

vcpkg_dir=$(dirname "$(which vcpkg)")
if [ ! -d "$vcpkg_dir/triplets" ]; then
        echo "vcpkg/triplets folder not found. Exiting."
        exit 1
    fi
    
    # Copy missing triplet files from the local triplets folder to vcpkg/triplets
    for triplet_file in triplets/*; do
        if [ -f "$triplet_file" ]; then
            triplet_name=$(basename "$triplet_file")
            if [ ! -f "$vcpkg_dir/triplets/$triplet_name" ]; then
                if ! cp "$triplet_file" "$vcpkg_dir/triplets/"; then
                    echo "Failed to copy triplet file: $triplet_file. Exiting."
                    exit 1
                fi
            fi
        fi
    done


packages=$(find_packages)

if [ "$target" = "x86_64-windows-gnu" ]; then
# Check if any packages were found
if [ -n "$packages" ]; then   
    # Install packages using vcpkg
    vcpkg_install_cmd="vcpkg install"
    for pkg in $packages; do
        vcpkg_install_cmd+=" $pkg:zig-windows"
    done
    
    # Run the vcpkg install command
    eval "$vcpkg_install_cmd"
else
    echo "Info: No packages found in CMakeLists.txt."
fi
wait $!
cmake -B $target -S . "-DCMAKE_TOOLCHAIN_FILE=/home/tim/vcpkg/scripts/buildsystems/vcpkg.cmake" -DVCPKG_TARGET_TRIPLET=zig-windows
elif [ "$target" = "x86_64-linux-gnu" ]; then
if [ -n "$packages" ]; then   
    # Install packages using vcpkg
    vcpkg_install_cmd="vcpkg install"
    for pkg in $packages; do
        vcpkg_install_cmd+=" $pkg:zig-linux"
    done
    
    # Run the vcpkg install command
    eval "$vcpkg_install_cmd"
    wait $!
else
    echo "Info: No packages found in CMakeLists.txt."
fi
cmake -B $target -S . "-DCMAKE_TOOLCHAIN_FILE=/home/tim/vcpkg/scripts/buildsystems/vcpkg.cmake" -DVCPKG_TARGET_TRIPLET=zig-linux
else
echo "Error: Unsupported target."
exit 1
fi
cd $target
cmake --build . --target install
echo "-- Done"
exit 0