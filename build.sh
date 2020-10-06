#!/bin/bash
location="$(readlink -f ${0})"
location=${location%build.sh}
options=$(getopt --longoptions arch:,buildtool:,mirror:,profile:,target: --options "" -- "${@}")
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
		--buildtool)
			shift
			BUILDTOOL="${1}"
			;;
		--profile)
			shift
			PROFILE="${1}"
			;;
		--mirror)
			shift
			MIRROR="${1}"
			;;
		--target)
			shift
			TARGET="${1}"
			;;
		--)
			shift
			break
			;;
	esac
	shift
done

PROFILE="${PROFILE:-1}"

if [ -z "${ARCH}" ]; then
	echo "error: must specify an ARCH"
	exit 1
fi

if [ -z "${BUILDTOOL}" ]; then
	if test -f "$(command -v docker)"; then
		BUILDTOOL=docker
	elif test -f "$(command -v podman)"; then
		BUILDTOOL=podman
	elif test -f "$(command -v buildah)"; then
		BUILDTOOL=buildah
	else
		echo "no OCI build tool found, exiting"
		exit 1
	fi
fi

MIRROR="${MIRROR:-https://gentoo.osuosl.org}"
STAGE3PATH="/releases/${ARCH}/autobuilds/$(wget -O- "${MIRROR}/releases/${ARCH}/autobuilds/latest-stage3-${ARCH}.txt" 2>/dev/null | tail -n 1 | cut -f 1 -d ' ')"
STAGE3=$(basename ${STAGE3PATH})
if ! test -f "base/${STAGE3}"; then
	rm -f "base/stage3*"
	wget -O "base/${STAGE3}" -q "${MIRROR}/${STAGE3PATH}"
fi

CMDLINE="--build-arg CACHEBUST=$(date +%Y-%m-%d) -v ${location}/.tmpfiles/gentoo:/var/db/repos/gentoo:rw -v ${location}/.tmpfiles/distfiles:/var/cache/distfiles:rw"
case "${TARGET}" in
	base)
		CMDLINE="${CMDLINE} --build-arg STAGEFILE=${STAGE3} --build-arg PROFILE=${PROFILE}"
		;;
	devtools)
		;;
	*)
		echo "ERROR: invalid target"
		exit 1
		;;
esac

CMDLINE="${CMDLINE} -t gentoo:${ARCH}-${TARGET}"
mkdir -p .tmpfiles
mkdir -p .tmpfiles/gentoo
mkdir -p .tmpfiles/distfiles

case "${BUILDTOOL}" in
	docker)
		docker build ${CMDLINE} ${TARGET}
		;;
	podman)
		podman build --cap-add CAP_SYS_PTRACE --format docker ${CMDLINE} ${TARGET}
		;;
	buildah)
		buildah bud --cap-add CAP_SYS_PTRACE --format docker ${CMDLINE} ${TARGET}
		;;
	*)
		echo "buildtool not supported"
		exit 1
		;;
esac
