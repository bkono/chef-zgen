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
    unless File.file? target_file
      link target_file do
        to sym
      end
    end
  end
end
