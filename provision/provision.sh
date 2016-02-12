#!/bin/bash

start_time=`date`

# This file is specified as the provisioning script to be used during `vagrant up`
# via the `config.vm.provision` parameter in the Vagrantfile.

# When `vagrant up` is first run, a large number of packages are installed through
# apt-get. We then create a file in the Vagrant contained file system that acts as
# a flag to indicate that these do not need to be processed again. This will persist
# through `vagrant suspend`, `vagrant halt`, `vagrant reload`, or `vagrant provision`.
# When `vagrant destroy` is run, the virtual machine's drives disappear, our flag file
# with them. This speeds the boot time up on subsequent `vagrant up` commands significantly.
if [ -f /home/vagrant/initial_provision_run ]
then
	printf "\nSkipping package installation, not initial boot...\n\n"
else
	# Add any custom package sources to help install more current software
	# cat /vagrant/config/apt-source-append.list >> /etc/apt/sources.list
	cat /vagrant/config/sources.list > /etc/apt/sources.list

	# update all of the package references before installing anything
	printf "Running apt-get update....\n\n"
	apt-get autoremove --force-yes -y
	apt-get update --force-yes -y

	# PACKAGE INSTALLATION
	#
	# Build a bash array to pass all of the packages we want to install to
	# a single apt-get command. This avoids having to do all the leg work
	# each time a package is set to install. It also allows us to easily comment
	# out or add single packages.
	apt_package_list=(
		# MISC Packages
		curl
		git-core
		unzip
		curl
		make
		vim-nox
		bzip2
		expect
		git

		# maven
		maven

		# dependencies
		python
		g++
		make
		checkinstall

		# Install dos2unix, which allows conversion of DOS style line endings
		dos2unix
		xclip
	)

	printf "Install all apt-get packages...\n"
	apt-get install --force-yes -y ${apt_package_list[@]}

	# Clean up apt caches
	apt-get clean

	# add hosts
	cat /vagrant/config/hosts.conf >> /etc/hosts

	bash /vagrant/provision/mysql.sh
	bash /vagrant/provision/node.sh
	bash /vagrant/provision/tools.sh
	bash /vagrant/provision/db-import.sh

	printf "\nSetting up timezone: \n"
	echo "Europe/Stockholm" > /etc/timezone
	dpkg-reconfigure -f noninteractive tzdata

	# create a flag that provision has already been run
	touch /home/vagrant/initial_provision_run
fi

# Start Services
printf "\nStarting services...\n"

# Your host IP is set in Vagrantfile, but it's nice to see the interfaces anyway
printf "\nNetwork configuration: \n"
ifconfig | grep "inet addr"

printf "\n\nAdd this line to /etc/hosts on your machine if it does not already exist: \n"
printf "# --------------------------------------------------- #\n"
printf "192.168.50.20    sensor-register.dev\n"
printf "# --------------------------------------------------- #\n"
printf "\n"

echo $start_time
date
echo Everything is setup!
