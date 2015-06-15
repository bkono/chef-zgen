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
log "Set users array to: #{users}"

users.flatten.each do |u|
  log "zgen iterating over user #{u}"

  user u do
    action :modify
    shell shell_loc
  end

  zgen_home = "/home/#{u}/.zgen"
  zgen_repo = "/home/#{u}/.zgen/repo"

  directory zgen_home do
    owner u
    mode '0755'
    action :create
  end

  git zgen_repo do
    repository 'https://github.com/tarjoilija/zgen.git'
    revision 'master'
    user u
    action :sync
  end

  template "/home/#{u}/.zshrc" do
    source "zshrc.erb"
    owner u
    mode 0644
    variables({
      zgen_repo: zgen_repo,
      omz_entries: (node['zgen']['oh-my-zsh'] || []),
      zgen_load_entries: (node['zgen']['load'] || [])
    })
    action :create
  end
end

