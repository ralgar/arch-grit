FROM archlinux:latest

RUN pacman -Syu --noconfirm archiso make

WORKDIR /repo

ENTRYPOINT ["make"]
