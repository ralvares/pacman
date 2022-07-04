FROM registry.access.redhat.com/ubi8/ubi AS ubi-micro-build
RUN mkdir -p /mnt/rootfs
RUN dnf module enable nodejs:16 -y
RUN yum install --installroot /mnt/rootfs --releasever 8 --setopt install_weak_deps=false --nodocs -y coreutils-single glibc-minimal-langpack nodejs; yum clean all
RUN rm -rf /mnt/rootfs/var/cache/*

FROM registry.access.redhat.com/ubi8/ubi-micro AS ubi8-micro

COPY --from=ubi-micro-build /mnt/rootfs/ /

MAINTAINER Rodrigo Alvares  <ralvares@redhat.com>
RUN mkdir -p /opt/app-root/src/pacman

COPY . /opt/app-root/src/pacman
WORKDIR /opt/app-root/src/pacman
RUN npm install
EXPOSE 8080

USER 1001

CMD ["npm", "start"]
