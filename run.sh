#!/bin/bash

set -exu

mkdir -p workspace archives

export TAG=opencv-blas-check

run_test() {
    docker run -it \
        --user $(id -u):$(id -g) \
        -v `pwd`/../opencv:/opencv:ro \
        -v `pwd`/../opencv_extra:/opencv_extra:ro \
        -v `pwd`/scripts:/scripts:ro \
        -v `pwd`/workspace:/workspace \
        --rm \
        ${TAG} \
        /bin/bash -c /scripts/check.sh
}

build_ubuntu() {
    docker build -t ${TAG} \
        --build-arg VER="${ver}" \
        --build-arg PKG="${pkg}" \
        -f Dockerfile-ubuntu .
        # /bin/bash -c "/scripts/build.sh $(id -u) $(id -g)"
}

build_fedora() {
    docker build -t ${TAG} \
        --build-arg VER="${ver}" \
        --build-arg PKG="${pkg}" \
        -f Dockerfile-fedora .
        # /bin/bash -c "/scripts/build.sh $(id -u) $(id -g)"
}

#==================================================================

fedora_versions=(
    41
    42
    43
    44
)

fedora_packages=(
    "openblas-devel"
)

for pkg in "${fedora_packages[@]}" ; do
for ver in "${fedora_versions[@]}" ; do
    PKG=${pkg} VER=${ver} \
        build_fedora
    run_test
done
done

#==================================================================

ubuntu_packages=(
    # "libmkl-dev"
    "libopenblas-dev liblapacke-dev"
    "libatlas-base-dev liblapacke-dev"
    "libblas-dev liblapacke-dev"
)

ubuntu_versions=(
    20.04
    22.04
    24.04
)

for pkg in "${ubuntu_packages[@]}" ; do
for ver in "${ubuntu_versions[@]}" ; do
    PKG=${pkg} VER=${ver} \
        build_ubuntu
    run_test
done
done

#==================================================================

# Standalone OpenBLAS
docker build -t ${TAG} -f Dockerfile-openblas .
docker run -it \
    --user $(id -u):$(id -g) \
    -v `pwd`/../opencv:/opencv:ro \
    -v `pwd`/../opencv_extra:/opencv_extra:ro \
    -v `pwd`/scripts:/scripts:ro \
    -v `pwd`/workspace:/workspace \
    --rm \
    ${TAG} \
    /bin/bash -c /scripts/check.sh


docker image rm ${TAG}

echo "DONE!"
