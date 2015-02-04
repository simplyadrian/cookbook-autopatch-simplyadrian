#
# Cookbook Name:: autopatch-nativex
# Recipe:: default
#
# Copyright (C) 2015 NativeX
#
# All rights reserved - Do Not Redistribute
#
# This is based on the 'auto-patch' cookbook. The main difference is in the use of a scheduling mechanism other than 'cron'.
# See https://github.com/bflad/chef-auto-patch/blob/3b581cfc75a9fbe22a7b6af5d9e3519facae0f4e/recipes/default.rb

directory "Auto Patch Working Directory" do
  path node['autopatch-nativex']['working_dir']
#  owner 'root'
#  group 'root'
#  mode '0700'
  action :create
end

template 'AutoPatch PowerShell Script' do
  source 'auto-patch.ps1.erb'
  path "#{node['autopatch-nativex']['working_dir']}\\auto-patch.ps1"
#  owner 'root'
#  group 'root'
#  mode '0700'
  action :delete if node['autopatch-nativex']['disable']
end

windows_task 'autopatch' do
  user node['autopatch-nativex']['task_username']
  frequency node['autopatch-nativex']['task_frequency']
  frequency_modifier node['autopatch-nativex']['task_frequency_modifier']
  day node['autopatch-nativex']['task_days']
  months node['autopatch-nativex']['task_months']
  start_time node['autopatch-nativex']['task_start_time']
  cwd 'C:'
  command "PowerShell -Command \"#{node['autopatch-nativex']['working_dir']}\\auto-patch.ps1\" -ExecutionPolicy Bypass"
  action :delete if node['autopatch-nativex']['disable']
end
