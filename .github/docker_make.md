# Docker Build System

The regular Docker build system has the disadvantage,
that only the cache system prevents a repetitive rebuild.
But when running the build in a VM this cache is initially
empty, resulting in a rebuild of all images on every run.
This not only increases the CPU load of the VM, but also
creates a lot of updated Docker images, that differ only
in the timestamps of the files.

This Docker build system wants to improve this situation.
It rebuilds only, when the base image or the build context
has changed. There are some other situations, where an
image needs to be recreated, that are not detected.
This mainly affects installation packages and external
files, that got an update. Then a manual trigger is needed.


## Build Tool

The `docker_make` tool reads a configuration file and
then starts building images with `docker buildx build`.

If `docker_make` is launched without arguments, it checks
all configured images for an update of the base image.
Additionally it checks, if `git` shows an update of
the directory containing the docker build context.
When at least one of these conditions is met, the tool
starts a rebuild of that image.

When `docker_make` is run with some image names as
arguments, then these images are additionally built.
When using a base image name as an argument, then all
images with that base image are rebuilt.

When using the option -a/--all, all images are forcibly
rebuild, except those specified on the command line.


## Configuration File

The build tool reads a configuration file, by default
'docker_images', located in the current directory. For each
target image, it contains its name, its context directory
and optionally the base image and some build options.

The fields are separated by one or more \<tab\> characters.
Comments start with a `#` as its first field character.
An empty line or an all-comments line is ignored.

A line with only one field is used for build options,
which are effective from that point until they are redefined.
This global build option and an optional image specific option
are combined and sent to the `docker buildx` command.

Here an example:

```
# Name		Directory	[Base Image]	[Build Options]

--platform=linux/arm64,linux/amd64		# global options

alpine-1	alpine-1	alpine		--image-specific-option
alpine-1:test	alpine-1a	--another-image-specific-option
```

If the base image is `NONE` (all caps), the target
image is not checked against its real base image.
Changes to the base image will then not cause a rebuild.

The target image may contain the full name, in which
case it will contain one or more '/' characters.

Another option is to specify only the last part of the
image name. Then `docker_make` uses the `DOCKER_REPOSITORY`
environment variable as its initial part. For example, an
DOCKER_REPOSITORY value of "ghcr.io/b-ehlers" plus the image
name of "alpine-1" results in "ghcr.io/b-ehlers/alpine-1".
When `DOCKER_REPOSITORY` contains a list of repositories,
then the name-only targets will be build for all of them.

This method is not applied to the base images, they always
have to contain the complete name.

But there is a workaround.

If the base image name starts with `$DOCKER_REPOSITORY`
or `${DOCKER_REPOSITORY}` the variable DOCKER_REPOSITORY
gets replaced by the base part of the target image.
In the Dockerfile the variable must be declared by a
`ARG DOCKER_REPOSITORY` instruction. A Dockerfile would
then start with:

```
ARG DOCKER_REPOSITORY
FROM $DOCKER_REPOSITORY/base-image
```


## Environment Variables

In addition to the DOCKER_REPOSITORY variable described above
the build tool uses the environment variables whose names begin
with "DOCKER_LOGIN". Each variable contains the user/password
of a docker registry. The format is: `<registry> <user> <password>`.

Example:

```
DOCKER_LOGIN_DH="docker.io dockerhub-user dockerhub-password"
DOCKER_LOGIN_GH="ghcr.io github-user github-password"
```


## Workflow Definition

[GitHub Actions](https://docs.github.com/en/actions)
uses YAML files in the .github/workflows directory
to define, which tasks should be run.

Before `docker_make` can be run the following steps
need to be done:

* Check out the repository code
* Set up QEMU (for multi-arch building)
* Set up Docker Buildx
* Login to the Container Registries
* Install python requirements

Then `docker_make` can be executed,
normally without any arguments.

But what, when an image build needs to be forced?  
For that, run the action manually and enter the list
of images, separated by spaces, into the input field.
