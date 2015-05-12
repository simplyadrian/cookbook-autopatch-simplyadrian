#
# Cookbook Name:: autopatch-simplyadrian
# Recipe:: default
#
# Copyright (C) 2015 simplyadrian
#
# All rights reserved - Do Not Redistribute
#

directory "Auto Patch Working Directory" do
  path node['autopatch-simplyadrian']['working_dir']
  action :create
end

if node['platform_family'] == 'windows'
  include_recipe 'autopatch-simplyadrian::windows'
else
  include_recipe 'autopatch-simplyadrian::linux'
end
