#!/bin/bash

set -exu

export OPENCV_DOWNLOAD_PATH=/workspace/dlcache
export CCACHE_DIR=/workspace/ccache
export PATH=/usr/lib/ccache:${PATH}

check_opencv()
{
    mkdir -p /workspace/build-opencv
    pushd /workspace/build-opencv && rm -rf *
    # --trace \
    # --trace-source=cmake/OpenCVFindLAPACK.cmake \
    # --trace-source=cmake/OpenCVFindMKL.cmake \
    # --trace-source=cmake/OpenCVFindAtlas.cmake \
    # --trace-redirect=trace.txt \
    # -Wno-dev \
    cmake \
        -GNinja \
        /opencv
    grep -q HAVE_LAPACK=1 CMakeVars.txt
    ninja opencv_test_core opencv_test_imgproc
    popd
}

check_opencv
