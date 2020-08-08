FROM scratch
ARG STAGEFILE
ADD ${STAGEFILE} /
ADD package.use/rsync /etc/portage/package.use/
ADD bashrc /root/.bashrc
ENTRYPOINT bash
RUN bash -c "echo "EMERGE_DEFAULT_OPTS="--quiet --verbose --autounmask --autounmask-continue"" >> /etc/portage/make.conf"
RUN mkdir -p /etc/portage/repos.conf
RUN bash -c "if ! mountpoint /var/db/repos/gentoo; then emerge-webrsync; fi"
RUN eselect news read --quiet
RUN bash -i -c "emerge -u gentoolkit"
RUN euse -E bindist
RUN bash -i -c "emerge -uDUN @world"
RUN bash -i -c "emerge --depclean"
RUN bash -i -c "emerge @preserved-rebuild"
RUN bash -c "if ! mountpoint /var/db/repos/gentoo; then rm -rf /var/db/repos/gentoo; fi"
RUN bash -c "if ! mountpoint /var/cache/distfiles; then rm -rf /var/cache/distfiles/*; fi"
