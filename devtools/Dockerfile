FROM docker.io/jannik2099/gentoo:base
ADD package.use/devtools /etc/portage/package.use/
ADD profile/package.use.mask/rust /etc/portage/profile/package.use.mask/
RUN emerge-webrsync
RUN emerge -uDUN @world
RUN emerge --depclean
RUN emerge @preserved-rebuild
RUN emerge -u sys-devel/clang
RUN emerge -u dev-lang/rust
RUN emerge -u dev-vcs/git
RUN emerge -u app-portage/repoman
RUN emerge -u app-eselect/eselect-repository
RUN emerge -u dev-lang/go
RUN emerge -u app-arch/tatt
RUN eselect news read --quiet
