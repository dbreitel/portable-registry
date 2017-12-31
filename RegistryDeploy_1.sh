#!/bin/bash
which docker

if [ $? -eq 0 ]
then
    docker --version | grep "Docker version"
    if [ $? -eq 0 ]
    then
        echo "docker existing"
    else
        echo "install docker"
        exit 1
    fi
else
    echo "install docker" >&2
    exit 1
fi

echo "extracting imagess ...."

# extract images
find . -type f  -name '*.gz' -exec gzip -d "{}" \;
# import images
find . -type f -name '*.tar' -exec docker load -q -i "{}" \;

# start registry server on 5000
docker run -d -p 5000:5000 --name registry registry:latest

# push images to registry
for i in `docker images |grep localhost | awk -F' ' '{print $1 ":" $2}'`;do DIEGO=$(docker push $i);done
