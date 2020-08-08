FROM docker.io/jannik2099/gentoo:base
ADD package.use/devtools /etc/portage/package.use/
ADD profile/package.use.mask/rust /etc/portage/profile/package.use.mask/
RUN bash -c "if ! mountpoint /var/db/repos/gentoo; then emerge-webrsync; fi"
RUN eselect news read --quiet
RUN bash -i -c "emerge -vuDUN @world"
RUN bash -i -c "emerge --depclean"
RUN bash -i -c "emerge @preserved-rebuild"
RUN bash -i -c "emerge --quiet --autounmask --autounmask-continue -u sys-devel/clang dev-lang/rust app-portage/repoman app-eselect/eselect-repository dev-lang/go"
RUN bash -c "if ! mountpoint /var/db/repos/gentoo; then rm -rf /var/db/repos/gentoo; fi"
RUN bash -c "if ! mountpoint /var/cache/distfiles; then rm -rf /var/cache/distfiles/*; fi"
