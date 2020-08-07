#!/bin/bash
options=$(getopt -o rd --long arch:,localrepo:,localdist:,repodir:,distdir:,buildtool:,stagefile: -- "${@}")
eval set -- "${options}"
function istrue(){
case "${1}" in
	true|yes|y)
		true
		;;
	false|no|n)
		false
		;;
	*)
		echo "invalid boolean"
		exit 1
		;;
esac
}
while true; do
	case "${1}" in
		--arch)
			shift
			ARCH="${1}"
			;;
		--localrepo)
			shift
			istrue "${1}" && LOCALREPO="true"
			;;
		--localdist)
			shift
			istrue "${1}" && LOCALDIST="true"
			;;
		--repodir)
			shift
			REPODIR="${1}"
			;;
		--distdir)
			shift
			DISTDIR="${1}"
			;;
		--buildtool)
			shift
			BUILDTOOL="${1}"
			;;
		--stagefile)
			shift
			STAGEFILE="${1}"
			;;
		-r)
			LOCALREPO="true"
			;;
		-d)
			LOCALDIST="true"
			;;
		--)
			shift
			break
			;;
	esac
	shift
done
REPODIR="${REPODIR:-/var/db/repos/gentoo}"
DISTDIR="${DISTDIR:-/var/cache/distfiles}"
STAGEFILE="${STAGEFILE:-stage3-${ARCH}.tar.zst}"

if [ -z "${ARCH}" ]; then
	echo "error: must specify an ARCH"
	exit 1
fi

if [ -z "${BUILDTOOL}" ]; then
	if test -f "$(command -v docker)"; then
		BUILDTOOL=docker
	elif test -f "$(command -v buildah)"; then
		BUILDTOOL=buildah
	elif test -f "$(command -v podman)"; then
		BUILDTOOL=podman
	else
		echo "no OCI build tool found, exiting"
		exit 1
	fi
fi

CMDLINE="--build-arg STAGEFILE=${STAGEFILE} --arch=${ARCH} -t gentoo"
if [ "${LOCALREPO}" = "true" ]; then
	CMDLINE="-v ${REPODIR}:/var/db/repos/gentoo:ro ${CMDLINE}"
fi
if [ "${LOCALDIST}" = "true" ]; then
	CMDLINE="-v ${DISTDIR}:/var/cache/distfiles:rw ${CMDLINE}"
fi

case "${BUILDTOOL}" in
	docker)
		docker build ${CMDLINE} .
		;;
	buildah)
		buildah bud ${CMDLINE} .
		;;
	podman)
		podman build ${CMDLINE} .
		;;
	*)
		echo "buildtool not supported"
		exit 1
		;;
esac
