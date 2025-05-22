FROM ghcr.io/charles25565/rocky-i686-container:r9 AS installer 
COPY i686.repo /etc/yum.repos.d
ARG packages
RUN dnf install --setopt=tsflags=noscripts --skip-broken --repo=rocky --repo=kernel --releasever=9 --installroot=/out --forcearch=i686 ${packages} -y
RUN rm -rf /out/etc/yum.repos.d
COPY i686.repo /out/etc/yum.repos.d/i686.repo
RUN dnf clean all --installroot=/out
RUN chroot /out /sbin/ldconfig
RUN chroot /out /usr/bin/ca-legacy install
RUN chroot /out /usr/bin/update-ca-trust
FROM scratch AS default
COPY --from=installer /out /
CMD ["/bin/bash"]
