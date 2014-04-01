docker-kafka
============

This kafka container expects to be linked to zookeeper. Assuming you have a [zookeeper container](https://github.com/disintegrator/docker-zookeeper) called 'zk', this is an example of how to build and run this container:

    sudo docker build -t $USER/kafka github.com/disintegrator/docker-kafka
    sudo docker run --link zk:zk --name kafka1_1 $USER/kafka

To set a different broker id:

    sudo docker run --link zk:zk --name kafka1_2 --env BROKER_ID=2 $USER/kafka

The container will look for environment variables for zookeeper containers aliased `zk[0-9]*` and add them to kafka's config file. So if there are multiple zookeepers:

    sudo docker run --link zk:zk --link zk1:zk1 --link zk2:zk2 --link zk3:zk3 --name kafka1_1 $USER/kafka

If you don't want to run kafka but instead want to open a shell and run other commands (e.g. for creating topics):

    sudo docker run --link zk:zk --name kafka1_1 --entrypoint="/bin/bash" $USER/kafka -l

