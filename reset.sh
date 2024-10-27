CONTAINER_NAME='my-pop'

docker stop $CONTAINER_NAME
docker rm $CONTAINER_NAME

docker build -t sankalpmukim/pop_os_me --build-arg PWD='hello world' .
docker run -d --name=$CONTAINER_NAME sankalpmukim/pop_os_me
docker exec -it $CONTAINER_NAME bash
