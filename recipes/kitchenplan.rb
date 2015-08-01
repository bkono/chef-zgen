#
# Cookbook Name:: chef-zgen
# Recipe:: kitchenplan
#
# Copyright (c) 2015 The Authors, All Rights Reserved.

include_recipe "zgen::default"
::Chef::Recipe.send(:include, Zgen::Helpers)

zgen_users.each do |user|
  self.active_user = user

  Dir.glob("#{zgen_home}/**/*.symlink").each do |sym|
    name = sym.split('/').last.chomp('.symlink').prepend('.')
    target_file = "#{user_home}/#{name}"
    if File.exists?(target_file) && !File.symlink?(target_file)
      log "Skipping symlink of #{sym} to #{target_file} because target exists, and is not a symlink"
    else
      link target_file do
        to sym
      end
    end
  end
end
