FROM scratch
ARG STAGEFILE
ADD ${STAGEFILE} /
ADD make.conf /etc/portage/
ADD bashrc /root/.bashrc
ENTRYPOINT ["bash"]
RUN ["bash", "-c", "if ! mountpoint /var/db/repos/gentoo; then emerge-webrsync; fi"]
RUN ["eselect", "news", "read", "--quiet"]
RUN ["bash", "-i", "-c", "emerge -vuDUN @world"]
RUN ["bash", "-c", "if ! mountpoint /var/db/repos/gentoo; then rm -rf /var/db/repos/gentoo; fi"]
RUN ["bash", "-c", "if ! mountpoint /var/cache/distfiles; then rm -rf /var/cache/distfiles/*; fi"]
