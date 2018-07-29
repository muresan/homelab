###
### Cookbook Name:: enterprise_linux
### Recipe:: firewall
###
### Copyright 2013-2018, Andrew Wyatt
###
### Licensed under the Apache License, Version 2.0 (the "License");
### you may not use this file except in compliance with the License.
### You may obtain a copy of the License at
###
###    http://www.apache.org/licenses/LICENSE-2.0
###
### Unless required by applicable law or agreed to in writing, software
### distributed under the License is distributed on an "AS IS" BASIS,
### WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
### See the License for the specific language governing permissions and
### limitations under the License.
###

yum_package 'firewalld' do
  action :install
end

service 'iptables' do
  action [:disable, :stop]
end

service 'firewalld' do
  action [:enable, :start]
  only_if { node['linux']['firewall']['enable'] == true }
end

service 'firewalld' do
  action [:disable, :stop]
  only_if { node['linux']['firewall']['enable'] == false }
end

###
### Configure firewall ports.
###

current_ports = Array.new(`firewall-cmd --list-ports 2>/dev/null`.split(' '))
desired_ports = String.new((node['linux']['firewall']['ports'].keys).join(' '))

###
### Remove ports from the firewall
###

current_ports.each do | current_port |
  execute "Removing #{current_port} from the firewall" do
    command "firewall-cmd --remove-port=#{current_port} --permanent && firewall-cmd --reload"
    action :run
    sensitive node['linux']['runtime']['sensitivity']
    not_if { desired_ports.include?(current_port) }
    only_if { node['linux']['firewall']['enable'] = true }
  end
end

###
### Add ports to the firewall.
###

(node['linux']['firewall']['ports'].keys).each do | desired_port |
  execute "Adding #{desired_port} to the firewall" do
    command "firewall-cmd --add-port=#{desired_port} --permanent && firewall-cmd --reload"
    action :run
    sensitive node['linux']['runtime']['sensitivity']
    not_if { (current_ports.join(' ')).include?(desired_port) }
    only_if { node['linux']['firewall']['enable'] == true }
  end
end

###
### Configure firewall services.
###

current_services = Array.new(`firewall-cmd --list-services 2>/dev/null`.split(' '))
desired_services = String.new((node['linux']['firewall']['services'].keys).join(' '))

###
### Remove services from the firewall
###

current_services.each do | current_service |
  execute "Removing #{current_service} from the firewall" do
    command "firewall-cmd --remove-service=#{current_service} --permanent && firewall-cmd --reload"
    action :run
    sensitive node['linux']['runtime']['sensitivity']
    not_if { desired_services.include?(current_service) }
    only_if { node['linux']['firewall']['enable'] == true }
  end
end

###
### Add services to the firewall.
###

(node['linux']['firewall']['services'].keys).each do | desired_service |
  execute "Adding #{desired_service} to the firewall" do
    command "firewall-cmd --add-service=#{desired_service} --permanent && firewall-cmd --reload"
    action :run
    sensitive node['linux']['runtime']['sensitivity']
    not_if { (current_services.join(' ')).include?(desired_service) }
    only_if { node['linux']['firewall']['enable'] == true }
  end
end
