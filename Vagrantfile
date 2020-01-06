# -*- mode: ruby -*-
# vi: set ft=ruby :

require_relative 'vagrant_rancheros_guest_plugin.rb'
require 'yaml'

config = YAML.load_file('config.yml')
cluster = YAML.load_file('base_cluster.yml')


Vagrant.configure("2") do |vagrant|
  nodes = []
  config['master']['count'].times do |i|
    name, ip = create_node(vagrant, config, i, 'master')
    nodes << {
      'address'=> ip,
      'internal_address' => ip,
      'role' => ['controlplane', 'etcd'],
      'hostname_override' => name,
      'user' => 'rancher',
      'labels' => { 'role' => 'master' },
    }
  end

  config['worker']['count'].times do |i|
    name, ip = create_node(vagrant, config, i, 'worker')
    nodes << {
      'address'=> ip,
      'internal_address' => ip,
      'role' => ['worker'],
      'hostname_override' => name,
      'user' => 'rancher',
      'labels' => { 'role' => 'worker' },
    }
  end

  cluster['nodes'] = nodes
  File.open('cluster.yml', 'w') { |f| f.puts cluster.to_yaml }
end

def generate_name_and_ip(obj, count, type)
  name  = "#{type}%02d" % (count+1)
  split = obj['specs']['eth1'].split('.')
  ip    = "#{split[0]}.#{split[1]}.#{split[2]}.#{(split[3].to_i-1)+(count+1)}"
  return name, ip
end

def create_node(vagrant, config, count, type='master')
  obj = config[type]
  name, ip = generate_name_and_ip(obj, count, type)

  vagrant.vm.define name do |node|
    node.vm.box = obj['specs']['box']
    node.vm.guest = :linux
    node.vm.hostname = name
    node.vm.network :private_network, ip: ip
    node.vm.boot_timeout = 600

    node.vm.provider "virtualbox" do |v|
      v.customize ["modifyvm", :id, "--memory",  obj['specs']['mem']]
      v.customize ["modifyvm", :id, "--cpus",    obj['specs']['cpu']]
      v.customize ["modifyvm", :id, "--natnet1", '192.168/16']
    end
    node.vm.provision "shell", path: 'provision.sh', args: [ config['dockerVersion'], config['publicKey'] ]
  end
  return name, ip
end

