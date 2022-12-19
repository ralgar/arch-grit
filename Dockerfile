FROM archlinux:latest

WORKDIR /repo

RUN pacman -Syu --noconfirm \
    archiso \
    make

ENTRYPOINT ["/bin/sh", "-c", "make archiso"]
