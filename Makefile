proj_name := arch-grit

# Errors out if bind mounts are left over from a previous build
build:
	findmnt | grep $(proj_name) && printf "\nERROR: Clean up bind mounts!\n\n"
	mkarchiso -v -w ./work -o ./out ./src

clean:
	sudo rm -rf ./work ./out
