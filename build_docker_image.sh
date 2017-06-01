#!/bin/sh
# I invoke docker with sudo to remind me that it's
# running as root. USR pulls back out the actual invokers
# user name.

DIR="$PWD"
#USR=`who mom likes | awk '{print $1}'`
# Gitlab CI
USR=developer

# --- Configure Here ---
MAINTAINER="Devin Hughes <devin@jd2.com>"
D_IMAGE_NAME="dkhughes/ubker:latest"
D_SHARE_PATH=/home/"$USR"/docker-share/ubker
D_UBOOT_TOOLS_RPATH=u-boot-xlnx/tools
D_LINUX_DTC_RPATH=linux-xlnx/scripts/dtc

# Populate the docker file with the config
sed -e "s|@maintainer@|$MAINTAINER|" \
    -e "s|@u-boot-tools@|$D_UBOOT_TOOLS_RPATH|" \
    -e "s|@linux-dtc@|$D_LINUX_DTC_RPATH|" \
    "$DIR"/Dockerfile.in > \
    "$DIR"/Dockerfile

# Now build the base image
docker build --build-arg b_uid=`id -u $USR` \
    --build-arg b_gid=`id -g $USR` \
    -t "$D_IMAGE_NAME" .

if [ $? -ne 0 ]; then
    echo ERROR: Failed to build image.
    exit 1
fi

D_IMG_SNAME=`echo $D_IMAGE_NAME | sed "s|[:].*||"`

echo Creating the run script
cd "$DIR"
# Create the run script
cat << EOF > run_terminal.sh
#!/bin/sh
# Runs to terminal and cleans up when done.
docker run --rm -ti --user developer \
-v $D_SHARE_PATH:/home/developer \
$D_IMG_SNAME

EOF

# Fixup file ownership
chown $USR:$USR run_terminal.sh
chmod +x run_terminal.sh

echo Done.
