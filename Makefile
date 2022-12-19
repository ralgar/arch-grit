PROJECT := arch-grit
CONTAINER_ENGINE := podman

help:
	$(info ################################)
	$(info ###   Arch-GRIT Build Help   ###)
	$(info ################################)
	$(info #)
	$(info #  Usage: make [target])
	$(info #)
	$(info #  Targets:)
	$(info #      build    Build the ISO using the containerized build system)
	$(info #      clean    Clean up all generated build files)
	$(info #)
	$(info ################################)

archiso:
	pacman-key --init
	pacman-key --populate
	pacman-key -r DDF7DB817396A49B2A2723F7403BD972F75D9D76
	pacman-key --lsign-key DDF7DB817396A49B2A2723F7403BD972F75D9D76
	mkarchiso -v -w ./work -o ./out ./src

build: build-env
	sudo $(CONTAINER_ENGINE) run --rm -it \
		--privileged \
		--name arch-grit-buildenv \
		-v $(PWD):/repo \
		arch-grit:buildenv

build-env:
	sudo $(CONTAINER_ENGINE) build -t $(PROJECT):buildenv $(PWD)

.PHONY: clean
clean:
	sudo rm -rf ./work ./out
