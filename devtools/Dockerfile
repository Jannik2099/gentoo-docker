FROM docker.io/jannik2099/gentoo:base
ADD package.use/devtools /etc/portage/package.use/
ADD profile/package.use.mask/rust /etc/portage/profile/package.use.mask/
RUN emerge-webrsync
RUN emerge -uDUN @world
RUN emerge --depclean
RUN emerge @preserved-rebuild
RUN emerge -u dev-vcs/git sys-devel/clang dev-lang/rust app-portage/repoman app-eselect/eselect-repository dev-lang/go
RUN eselect news read --quiet
