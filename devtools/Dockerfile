FROM docker.io/jannik2099/gentoo:base
ADD package.use/devtools /etc/portage/package.use/
ADD profile/package.use.mask/rust /etc/portage/profile/package.use.mask/
RUN if ! mountpoint /var/db/repos/gentoo; then emerge-webrsync; fi
RUN emerge -uDUN @world
RUN emerge --depclean
RUN emerge @preserved-rebuild
RUN emerge -u dev-vcs/git sys-devel/clang dev-lang/rust app-portage/repoman app-eselect/eselect-repository dev-lang/go
RUN eselect news read --quiet
RUN if ! mountpoint /var/db/repos/gentoo; then rm -rf /var/db/repos/gentoo; fi
RUN if ! mountpoint /var/cache/distfiles; then rm -rf /var/cache/distfiles/*; fi
