# -*- mode: ruby -*-
# vi: set ft=ruby :

dir = Dir.pwd

$server_root_password ||= "vagrant"

Vagrant.configure("2") do |config|

  # Configurations from 1.0.x can be placed in Vagrant 1.1.x specs like the following.
  config.vm.provider :virtualbox do |v|
	v.customize ["modifyvm", :id, "--memory", 1024]
	# Speed up access to the webserver on guest OS
	v.customize ["modifyvm", :id, "--natdnshostresolver1", "on"]
  end

  # Default Debian Box
  #
  # This box is provided by ABWP backend and is a nicely sized (606MB)
  # box containing the Debian 7.0.0 Wheezy 64 bit release.
  config.vm.box = "ubuntu-trusty-64-v1"
  config.vm.box_url = "https://cloud-images.ubuntu.com/vagrant/trusty/current/trusty-server-cloudimg-amd64-vagrant-disk1.box"
  config.vm.hostname = "sensor-register"

  config.vm.network :private_network, ip: "192.168.50.20" 
  # config.vm.network "forwarded_port", guest: 81, host: 81
  # config.vm.network "forwarded_port", guest: 3306, host: 3306

  # with this enabled you can connect over ssh inside a vagrant box like if you were on your host machine
  config.ssh.forward_agent = true
  config.ssh.forward_x11 = true

  # provision.sh or provision.sh
  #
  # By default, Vagrantfile is set to use the provision.sh bash script located in the
  # provision directory. If it is detected that a provision-custom.sh script has been
  # created, that is run as a replacement. This is an opportunity to replace the entirety
  # of the provisioning provided by default.
  if File.exists?('provision/provision.sh') then
    config.vm.provision :shell, :path => File.join( "provision", "provision.sh" )
  end
end

