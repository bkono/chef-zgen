#
# Cookbook Name:: chef-zgen
# Recipe:: default
#
# Copyright (c) 2015 The Authors, All Rights Reserved.

# start with zsh please
package 'zsh' do
  action [:install, :upgrade]
end

# current_user supports kitchenplan
case node['platform_family']
when "debian" then
  package "zsh-doc"
  shell_loc = '/bin/zsh'
when "rhel", "fedora" then
  package "zsh-html"
  shell_loc = '/bin/zsh'
when "darwin" then
  shell_loc = '/usr/local/bin/zsh'
end

package 'git'

users = []
users << node['current_user'] if node['current_user']
users << node['zgen']['users']

users.flatten.each do |u|
  user u do
    action :modify
    shell shell_loc
  end

  zgen_home = "/home/#{u}/.zgen"

  directory zgen_home do
    owner u
    mode '0755'
    action :create
  end

  git "#{zgen_home}/repo" do
    repository 'https://github.com/tarjoilija/zgen.git'
    revision 'master'
    user u
    action :sync
  end
end

