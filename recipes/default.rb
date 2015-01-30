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

#include_recipe 'cron'

unless node['auto-patch']['disable']
  if node['auto-patch']['weekly']
    node.set['auto-patch']['day'] = '*'
    node.set['auto-patch']['month'] = '*'
    node.set['auto-patch']['weekday'] = AutoPatch.weekday(node['auto-patch']['weekly'])
    Chef::Log.info("Auto patch scheduled weekly on #{node['auto-patch']['weekly']} at #{node['auto-patch']['hour']}:#{node['auto-patch']['minute']}")
  elsif node['auto-patch']['monthly']
    next_date = AutoPatch.next_monthly_date(
      node['auto-patch']['monthly'],
      node['auto-patch']['hour'],
      node['auto-patch']['minute'])
    node.set['auto-patch']['day'] = next_date.day
    node.set['auto-patch']['month'] = next_date.month
    node.set['auto-patch']['weekday'] = '*'
    Chef::Log.info("Auto patch scheduled for #{next_date.strftime('%Y-%m-%d')} at #{node['auto-patch']['hour']}:#{node['auto-patch']['minute']}")
  else
    Chef::Application.fatal!('Missing auto-patch monthly or weekly specification.')
  end
end

#template '/usr/local/sbin/auto-patch' do
#  source 'auto-patch.sh.erb'
#  owner 'root'
#  group 'root'
#  mode '0700'
#  action :delete if node['auto-patch']['disable']
#end

template 'C:\auto-patch.ps1' do
  source 'auto-patch.ps1.erb'
#  owner 'root'
#  group 'root'
#  mode '0700'
  action :delete if node['auto-patch']['disable']
end

#cron_d 'auto-patch' do
#  hour node['auto-patch']['hour']
#  minute node['auto-patch']['minute']
#  weekday node['auto-patch']['weekday']
#  day node['auto-patch']['day']
#  month node['auto-patch']['month']
#  command '/usr/local/sbin/auto-patch'
#  action :delete if node['auto-patch']['disable']
#end

windows_task 'autopatch' do
  user 'SYSTEM'
  frequency :monthly
  frequency_modifier 'THIRD'
  day 'THU'
  months 'JAN,FEB,MAR,APR,MAY,JUN,JUL,AUG,SEP,OCT,NOV'
  start_time '03:00'
  cwd 'C:'
  command 'PowerShell -Command "C:\auto-patch.ps1" -ExecutionPolicy Bypass'
  action :delete if node['auto-patch']['disable']
end
