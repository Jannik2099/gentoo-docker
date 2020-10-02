FROM scratch
ARG STAGEFILE
ARG PROFILE
ADD ${STAGEFILE} /
ADD package.use/rsync /etc/portage/package.use/
ENTRYPOINT bash
# I could not get it to work with >> , bash gods are welcomed to submit a cleaner implementation
RUN echo EMERGE_DEFAULT_OPTS >> /etc/portage/make.conf
RUN sed -i "/EMERGE_DEFAULT_OPTS/c\EMERGE_DEFAULT_OPTS=\"--quiet --verbose --autounmask --autounmask-continue\"" /etc/portage/make.conf
RUN sed -i "/PORTDIR=.*/c\PORTDIR=\"/var/db/repos/gentoo\"" /etc/portage/make.conf
RUN sed -i "/DISTDIR=.*/c\DISTDIR=\"/var/cache/distfiles\"" /etc/portage/make.conf
RUN sed -i "/PKGDIR=.*/c\PKGDIR=\"/var/cache/binpkgs\"" /etc/portage/make.conf
RUN mkdir -p /etc/portage/repos.conf
ARG CACHEBUST
RUN emerge-webrsync
RUN eselect profile set ${PROFILE}
RUN emerge -u gentoolkit
RUN eselect news read --quiet
RUN euse -E bindist
RUN emerge -uDUN @world
RUN emerge --depclean
RUN emerge @preserved-rebuild
