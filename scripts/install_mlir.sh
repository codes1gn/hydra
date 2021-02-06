#!/bin/bash
# Usage:
#   ./scripts/install_mlir.sh
# For arbitrary build/install directories, set the env variables:
# - HYDRA_BUILD_PATH
# - LLVM_BUILD_PATH
# - LLVM_INSTALL_PATH
# - LLVM_SRC_PATH

# ninja - 1.9.0

set -e

fast_cd() {
  mkdir -p $1 && cd $1 && pwd
}

# setting building paths
top_dir="$(fast_cd $(dirname $0)/..)"
build_dir="$(fast_cd "${HYDRA_BUILD_PATH:-$top_dir/build}")"
mlir_build="${LLVM_BUILD_PATH:-$build_dir/mlir_build}"
mlir_install="${LLVM_INSTALL_PATH:-$build_dir/mlir_install}"
# 
# Find LLVM source (assumes it is adjacent to this directory).
LLVM_SRC_DIR="$(fast_cd "${LLVM_SRC_PATH:-$top_dir/external/llvm-project}")"
# 
if ! [ -f "$LLVM_SRC_DIR/llvm/CMakeLists.txt" ]; then
  echo "Expected LLVM_SRC_DIR variable to be set correctly (got '$LLVM_SRC_DIR')"
  exit 1
fi
echo "Using LLVM source dir: $LLVM_SRC_DIR"
echo "Building MLIR in $mlir_build"
mkdir -p "$mlir_build"

echo "Install MLIR to $mlir_install"
mkdir -p "$mlir_install"

echo "Beginning build (commands will echo)"
set -x

# tool function to probe a python executor
function probe_python() {
  local python_exe="$1"
  local found
  local command
  command="import sys
if sys.version_info.major == 2 and sys.version_info.minor == 7: print(sys.executable)"
  found="$("$python_exe" -c "$command")"
  if ! [ -z "$found" ]; then
    echo "$found"
  fi
}
# 
python_exe=""
for python_candidate in python; do
  python_exe="$(probe_python "$python_candidate")"
  if ! [ -z "$python_exe" ]; then
    break
  fi
done

echo "Using python: $python_exe"
if [ -z  "$python_exe" ]; then
  echo "Could not find python"
  exit 1
fi
# use release with debug info
# switch on assertion
# switch llvm dynamic lib on
# enabled filecheck and not - on
# 

export CC=clang
export CXX=clang++
export LDFLAGS=-fuse-ld=$(which ld.lld)
export CMAKE_C_COMPILER=/usr/local/clang10/bin/clang
export CMAKE_CXX_COMPILER=/usr/local/clang10/bin/clang++

cmake -GNinja \
  "-H$LLVM_SRC_DIR/llvm" \
  "-B$mlir_build" \
  -DCMAKE_EXPORT_COMPILE_COMMANDS=TRUE \
  "-DPython_EXECUTABLE=$python_exe" \
  -DLLVM_BUILD_LLVM_DYLIB=ON \
  -DLLVM_LINK_LLVM_DYLIB=ON \
  -DLLVM_INSTALL_UTILS=ON \
  -DLLVM_ENABLE_PROJECTS=mlir \
  -DLLVM_TARGETS_TO_BUILD="X86" \
  -DLLVM_INCLUDE_TOOLS=ON \
  "-DCMAKE_INSTALL_PREFIX=$mlir_install" \
  -DCMAKE_BUILD_TYPE=RelWithDebInfo \
  -DLLVM_USE_SPLIT_DWARF=ON \
  -DLLVM_ENABLE_ASSERTIONS=On \
  -DMLIR_BINDINGS_PYTHON_ENABLED=ON \
  "$@"
# 
cmake --build "$mlir_build" --target install
