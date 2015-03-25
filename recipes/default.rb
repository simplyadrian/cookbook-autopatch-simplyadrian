#
# Cookbook Name:: autopatch-nativex
# Recipe:: default
#
# Copyright (C) 2015 NativeX
#
# All rights reserved - Do Not Redistribute
#

directory "Auto Patch Working Directory" do
  path node['autopatch-nativex']['working_dir']
  action :create
end

if node['platform_family'] == 'windows'
  include_recipe 'autopatch-nativex::windows'
else
  include_recipe 'autopatch-nativex::linux'
end
