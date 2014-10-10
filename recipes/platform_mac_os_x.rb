#
# Cookbook Name:: sublime-text
# Recipe:: platform_mac_os_x
#
# Copyright (C) 2014 Patrick Ayoup
#
# MIT License
#

application_title = node['version']['generation'] == 2 ? "Sublime Text 2" : "Sublime Text"

ruby_block "dispatcher" do
  not_if { `"/Applications/#{application_title}.app/Contents/SharedSupport/bin/subl" --version || true`.gsub("Sublime Text ", "") == node['version']['id']  }
  notifies :delete, "file[cleanup_old_version]", :immediately
  notifies :create, "remote_file[download_sublime_dmg]", :immediately
  notifies :run, "execute[mount_sublime_dmg]", :immediately
  notifies :run, "execute[install_sublime_app]", :immediately
  notifies :create, "link[enable_command_line_executable]", :immediately
end

file "cleanup_old_version" do
  path "/Applications/#{application_title}.app"
  action :nothing
end

remote_file "download_sublime_dmg" do
  path "#{Chef::Config[:file_cache_path]}/Sublime_Text_#{node['version']['id']}.dmg"
  source "http://c758482.r82.cf2.rackcdn.com/Sublime%20Text%20#{node['version']['id']}.dmg"
  action :nothing
end

exectue "mount_sublime_dmg" do
  command "hdiutil attach #{Chef::Config[:file_cache_path]}/Sublime_Text_#{node['version']['id']}.dmg"
  action :nothing
end

execute "install_sublime_app" do
  command "mv '/Volumes/#{application_title}/#{application_title}.app' /Applications/"
  action :nothing
end

link "enable_command_line_executable" do
  target_file "/usr/local/bin/subl"
  to "/Applications/#{application_title}.app/Contents/SharedSupport/bin/subl"
  action :nothing
end


