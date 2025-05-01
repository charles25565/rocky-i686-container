FROM ghcr.io/charles25565/rocky-i686-container@sha256:af66318215165b2d0bef9311d891249ea34660133d88051b9a421d56f144f3b7 AS installer 
COPY i686.repo /etc/yum.repos.d
RUN dnf install --setopt=tsflags=noscripts --skip-broken --repo=rocky --repo=kernel --releasever=9 --installroot=/out --forcearch=i686 $(rpm -qa --queryformat '%{NAME} ') -y
RUN rm -rf /out/etc/yum.repos.d
COPY i686.repo /out/etc/yum.repos.d/i686.repo
RUN dnf clean all --installroot=/out
RUN chroot /out /sbin/ldconfig
RUN chroot /out /usr/bin/ca-legacy install
RUN chroot /out /usr/bin/update-ca-trust
FROM scratch AS target
COPY --from=installer /out /
CMD ["/bin/bash"]
