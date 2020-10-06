# gentoo-docker
Dockerfiles for Gentoo development

# How to build
./build.sh --arch <architecture> --target <build taget - currently implemented are base and devtools>
The base image requires a stage3 tarball which is automatically fetched from --mirror (default osuosl) <file>
The build script checks for docker, podman, buildah in that succession. Override with --buildtool <tool>

# How to use
very mundane docs on the docker page https://hub.docker.com/r/jannik2099/gentoo
more coming soon
