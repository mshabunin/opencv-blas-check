#!/bin/bash

set -exu

mkdir -p workspace archives

packages=(
    # "libmkl-dev"
    "libopenblas-dev liblapacke-dev"
    "libatlas-base-dev liblapacke-dev"
    "libblas-dev liblapacke-dev"
)

versions=(
    20.04
    22.04
    24.04
)

tag=blas-test

# System packages
for pkg in "${packages[@]}" ; do
for ver in "${versions[@]}" ; do

docker build -t ${tag} \
    --build-arg VER="${ver}" \
    --build-arg PKG="${pkg}" \
    -f Dockerfile-ubuntu .
docker run -it \
    --user $(id -u):$(id -g) \
    -v `pwd`/../opencv:/opencv:ro \
    -v `pwd`/../opencv_extra:/opencv_extra:ro \
    -v `pwd`/scripts:/scripts:ro \
    -v `pwd`/workspace:/workspace \
    --rm \
    ${tag} \
    /bin/bash -c /scripts/check.sh
    # /bin/bash -c "/scripts/build.sh $(id -u) $(id -g)"

done
done

# Standalone OpenBLAS
docker build -t ${tag} -f Dockerfile-openblas .
docker run -it \
    --user $(id -u):$(id -g) \
    -v `pwd`/../opencv:/opencv:ro \
    -v `pwd`/../opencv_extra:/opencv_extra:ro \
    -v `pwd`/scripts:/scripts:ro \
    -v `pwd`/workspace:/workspace \
    --rm \
    ${tag} \
    /bin/bash -c /scripts/check.sh


docker image rm ${tag}

echo "DONE!"
