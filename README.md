# Docker Builder Container

The purpose of this container is for use in a CI/CD pipeline. By running Docker-in-Docker in privileged mode, we can mount a project directory inside this container and use the `Docker` runtime in this container to build an image specified by a `Dockerfile` in that project directory. The build script automatically resolves names, tags, and repositories to defaults.

## Building

The bootstrap process is simple

```sh
> build_docker.sh
```

## Usage

CI/CD servers can invoke this container to build projects containing a `Dockerfile`. The command to kick off such a build process is simple. In the project repository root directory which contains the `Dockerfile`, execute the following command:

```sh
docker run \
       -it \
       --rm \
       --privileged \
       -v $(pwd):/build \
       -v /var/run/docker.sock:/var/run/docker.sock \
       docker-builder:<VERSION>
```

## Overriding Defaults

You can override certain defaults by passing in environment variables to the `docker-builder` run command.

- `BUILD` specifies the build number. Will default to `${bamboo_buildNumber}` set by the CI server. If that does not exist, will use a default of `0`.
- `DOCKER_REGISTRY` specifies the Docker image repository URL to use. Defaults to host local repository of `nicbet/`.
- `DOCKER_IMAGE_NAME` specifies the image name. Defaults to the Git repository's origin name.
