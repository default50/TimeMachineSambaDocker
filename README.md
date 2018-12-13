# TimeMachine on Samba for Docker

In this repo you will find instructions and resources on how to run a Docker container with Samba 4 to support Apple's TimeMachine. You will also be able to build your own Docker image if you don't want to use the pre-built one.

Features:
- [Alpine Linux](https://alpinelinux.org/) based.
- [Avahi](https://www.avahi.org/) discovery service configured.
- Configuration options:
    - Group name & ID
    - User name & ID
    - Samba user password
    - Limit storage size

## How to run the container

### Via `docker run`

```
docker run -d --net=host \
            --volume /opt/timemachine:/timemachine/ \
            --volume /etc/localtime:/etc/localtime:ro \
            -e TM_PWD=notsosecretpassword \
            --restart=always \
            --name=timemachine default50/timemachinesambadocker
```

For more information about the options for `docker run` visit https://docs.docker.com/engine/reference/run/

### Via `docker-compose`

You can modify the parameters in the sample `docker-compose.sample.yml` file to suit your needs and then rename it to `docker-compose.yml`. To launch the service container just do `docker-compose up -d` in the same directory of of the composer file.

**Note**: you may need to install `compose`. Check https://docs.docker.com/compose/install/

### Environment variables

This is a summary of the environment variables that can be used to override any of the default values.

| Variable  | Function                             | Default.    |
| ----------|:------------------------------------:|------------:|
| TM_USER   | POSIX user name inside container     | timemachine |
| TM_GROUP  | POSIX group name inside container    | timemachine |
| TM_UID    | POSIX user ID inside container       | 1000        |
| TM_GID    | POSIX group ID inside container      | 1000        |
| TM_PWD    | Samba password                       | timemachine |
| TM_SIZE   | Time Machine storage size limit (MB) | 512000      |

## How to build your own image

You can always build your own image instead of using the image provided through my public repository.

It's as simple as doing `docker build .` in the root of the repository, but it's better if you tag the image with something like this:

```
docker build --tag default50/timemachinesambadocker .
```

### Credits

The contents here were mostly obtained from [willtho89/docker-samba-timemachine](https://github.com/willtho89/docker-samba-timemachine)'s repository with some improvements.

And according to **willtho89**'s own words:

>It's mostly based on u/KervyN's [HowTo](https://www.reddit.com/r/homelab/comments/83vkaz/howto_make_time_machine_backups_on_a_samba/) and [dperson's](https://github.com/dperson) [Samba docker container](https://github.com/dperson/samba).
