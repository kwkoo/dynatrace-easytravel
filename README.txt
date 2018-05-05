This is a dockerized version of easyTravel designed to send data to Dynatrace
SAAS or Managed.

To run this,
1. Provision a Linux VM with a distribution like CentOS, Debian, or Ubuntu. I
used CentOS 7.
2. Install Docker from the docker.io repository in order to get the latest
version of docker.
3. Edit the buildimage script and set the DTXTenant and DTXServerHost
environment variables appropriately.
4. Run the buildimage script to build the image.
5. Run the run script to run a container.

When the container starts up, you will be able to access the easyTravel app at:
http://DOCKERSERVER:8079

You can access the easyTravel configuration UI at:
http://DOCKERSERVER:8094

When you first start easyTravel, you'll notice that the applications are not
linked to the services and vice-versa.

In order to fix this, edit the "com.dynatrace.easytravel.weblauncher.jar
easytravel-*-x*" process group and turn off deep monitoring.

