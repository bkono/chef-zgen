#
# Cookbook Name:: chef-zgen
# Recipe:: default
#
# Copyright (c) 2015 The Authors, All Rights Reserved.

::Chef::Recipe.send(:include, Zgen::Helpers)

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

log "Set users array to: #{zgen_users}"

zgen_users.each do |user|
  self.active_user = user
  log "zgen iterating over user #{active_user}"

  user "#{active_user}" do
    action :modify
    shell shell_loc
  end

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

  # scoping issues require this to get set in the recipe, to be available to the template variables
  repo_dir = zgen_repo

  template_run = template "#{user_home}/.zshrc" do
    source "zshrc.erb"
    owner user
    mode 0644
    variables({
      zgen_repo: repo_dir,
      omz_entries: (node['zgen']['oh-my-zsh'] || []),
      zgen_load_entries: (node['zgen']['load'] || [])
    })
    action :create
  end

  file "#{zgen_home}/init.zsh" do
    action :delete
    only_if { template_run.updated_by_last_action? }
  end
end

