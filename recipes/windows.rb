#
# Cookbook Name:: autopatch-simplyadrian
# Recipe:: windows
#
# Copyright (C) 2015 simplyadrian
#
# All rights reserved - Do Not Redistribute
#
# This is based on the 'auto-patch' cookbook. The main difference is in the use of a scheduling mechanism other than 'cron'.
# See https://github.com/bflad/chef-auto-patch/blob/3b581cfc75a9fbe22a7b6af5d9e3519facae0f4e/recipes/default.rb

template 'AutoPatch PowerShell Script' do
  source 'auto-patch.ps1.erb'
  path "#{node['autopatch-simplyadrian']['working_dir']}\\auto-patch.ps1"
  action :delete if node['autopatch-simplyadrian']['disable']
end

windows_task 'autopatch' do
  user node['autopatch-simplyadrian']['task_username']
  frequency node['autopatch-simplyadrian']['task_frequency']
  frequency_modifier node['autopatch-simplyadrian']['task_frequency_modifier']
  day node['autopatch-simplyadrian']['task_days']
  months node['autopatch-simplyadrian']['task_months']
  start_time node['autopatch-simplyadrian']['task_start_time']
  cwd 'C:'
  command "PowerShell -ExecutionPolicy Bypass -Command \"#{node['autopatch-simplyadrian']['working_dir']}\\auto-patch.ps1\"" 
  action :delete if node['autopatch-simplyadrian']['disable']
end
