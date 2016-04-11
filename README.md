# ubker-docker

## Building the image

There is a helper script used to build the image. Edit the top of build_image script for your image/tag names, etc. The image pulls down gcc 5.3 from the linaro release page.

## Running the docker container

There is a helper script to drop into the terminal with a shared directory mounted. Simply

```
./run_terminal.sh
```

Scripts to run in an automated fashion will be added in additional branches.

