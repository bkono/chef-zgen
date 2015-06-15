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
when "mac_os_x" then
  shell_loc = '/usr/local/bin/zsh'
end
log "shell location is now set to: #{shell_loc}"

package 'git'

users = []
users << node['current_user']
users << node['zgen']['users']
users.compact!
log "Set users array to: #{users}"

users.flatten.each do |user|
  log "zgen iterating over user #{user}"

  user "#{user}" do
    action :modify
    shell shell_loc
  end

  user_home = node['etc']['passwd'][user]['dir']
  zgen_home = "#{user_home}/.zgen"
  zgen_repo = "#{zgen_home}/repo"

  directory zgen_home do
    owner user
    mode '0755'
    recursive true
    action :create
  end

  git zgen_repo do
    repository 'https://github.com/tarjoilija/zgen.git'
    revision 'master'
    user user
    action :sync
  end

  template_run = template "#{user_home}/.zshrc" do
    source "zshrc.erb"
    owner user
    mode 0644
    variables({
      zgen_repo: zgen_repo,
      omz_entries: (node['zgen']['oh-my-zsh'] || []),
      zgen_load_entries: (node['zgen']['load'] || [])
    })
    action :create
  end

  file "#{zgen_home}/init.zsh" do
    action :delete
    only_if template_run.updated_by_last_action?
  end
end

