# gentoo-docker
Dockerfiles for Gentoo development

# How to build
Build by cding into the respective directory and running ./build.sh --arch <architecture>
The base image requires a stage3 tarball - it uses stage3-$ARCH.tar.zst , you can override this with --stagefile <file>
The build script checks for docker, buildah, podman in that succession. Override with --buildtool <tool>
The images can make use of local gentoo repositories and distfiles with --localrepo true --localdist true, or -r -d
If your repo / distfiles is in another location, override with --repodir <dir> and --distdir <dir>

# How to use
very mundane docs on the docker page https://hub.docker.com/r/jannik2099/gentoo
more coming soon
