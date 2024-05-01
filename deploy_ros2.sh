#!/bin/bash
DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"
source $DIR/robot.env
IMAGE="c225tang/panda:latest"

if ! command -v docker &>/dev/null; then
    echo "Docker could not be found. Please install Docker."
    exit 1
fi

echo "Logging in to Docker Hub..."
docker login
echo "Pulling the Docker image: $IMAGE"
docker pull $IMAGE
echo "Running the Docker image..."
ADDITIONAL_FLAGS="--rm --interactive --tty \
  --device /dev/dri:/dev/dri --volume=/run/udev:/run/udev"

for filename in $(find /dev -name "video*"); do
    ADDITIONAL_FLAGS="${ADDITIONAL_FLAGS} --device ${filename}"
done

if [ ! -z "${DOCKER_ROBOT_FLAGS}" ]; then
    ADDITIONAL_FLAGS="${ADDITIONAL_FLAGS} ${DOCKER_ROBOT_FLAGS}"
fi

DOCKER_COMMAND="docker"
DOCKER_GPU_ARGS="--env DISPLAY=$DISPLAY --ipc=host --volume=/tmp/.X11-unix:/tmp/.X11-unix:rw"
which nvidia-docker &>/dev/null && {
    DOCKER_COMMAND="nvidia-docker"
    DOCKER_GPU_ARGS+=" --env NVIDIA_VISIBLE_DEVICES=all --env NVIDIA_DRIVER_CAPABILITIES=all"
}

xhost +SI:localuser:$(whoami)

CONTAINER_NAME="uw_${ROBOTNAME}_${USER}"
if ! docker container ps | grep -q ${CONTAINER_NAME}; then
    echo "Starting new container with name: ${CONTAINER_NAME}"
    $DOCKER_COMMAND run \
    -e "ENV_VAR_NAME=value" \
    -v "$HOME/chengt:/home/${USER}" \
    $DOCKER_GPU_ARGS \
    $ADDITIONAL_FLAGS \
    --user root \
    --name ${CONTAINER_NAME} \
    --workdir /home/$USER \
    --cap-add=SYS_PTRACE \
    --cap-add=SYS_NICE \
    --net host \
    --device /dev/bus/usb \
    $IMAGE
else
    echo "Starting shell in running container"
    docker exec -it --workdir /home/${USER} --user $(whoami) ${CONTAINER_NAME} bash -l -c "stty cols $(tput cols); stty rows $(tput lines); bash"
fi
