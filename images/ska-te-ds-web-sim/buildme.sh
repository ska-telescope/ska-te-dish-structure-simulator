# Set the build-arg CETC_TARBALL_LOCATION to the directory within this repo
# that contains the CETC simulator tarball. If you build the image from the top
# level directory of this repo, then set the location to:
# CECT_TARBALL_LOCATION=images/ska-te-ds-web-sim
# You can then build the image like so:
#
# docker build --build-arg=CETC_TARBALL_LOCATION=images/ska-te-ds-web-sim -t simulator:1.0 -f images/ska-te-ds-web-sim/Dockerfile .
#
# If you build from the same directory where the Dockerfile is located, then just specify the current directory as it is now.
docker build --build-arg=CETC_TARBALL_LOCATION=${PWD} -t simulator:1.0 -f Dockerfile .
