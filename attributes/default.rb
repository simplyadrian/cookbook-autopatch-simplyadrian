default['autopatch-nativex']['disabled'] = false
default['autopatch-nativex']['task_username'] = 'SYSTEM'
default['autopatch-nativex']['task_frequency'] = :monthly
default['autopatch-nativex']['task_frequency_modifier'] = 'THIRD'
default['autopatch-nativex']['task_months'] = 'JAN,FEB,MAR,APR,MAY,JUN,JUL,AUG,SEP,OCT,NOV'
default['autopatch-nativex']['task_days'] = 'TUE'
default['autopatch-nativex']['task_start_time'] = '04:00'
if node['platform_family'] == 'windows'
  default['autopatch-nativex']['working_dir'] = 'C:\chef_autopatch'
else
  default['autopatch-nativex']['working_dir'] = '/var/log/chef_autopatch'
end
default['autopatch-nativex']['download_install_splay_enabled'] = true
default['autopatch-nativex']['download_install_splay_min_seconds'] = 0
default['autopatch-nativex']['download_install_splay_max_seconds'] = 5400
default['autopatch-nativex']['email_nofitication_mode'] = 'OnlyOnErrorOrManualReboot'
default['autopatch-nativex']['email_to_addresses'] = '"SysEngineers@nativex.com"'
default['autopatch-nativex']['email_from_address'] = "#{node['hostname']}@nativex.com"
default['autopatch-nativex']['email_smtp_server'] = 'mail.nativex.com'
default['autopatch-nativex']['auto_reboot_enabled'] = false

#syncronize auto-patch enablement with this cookbook's main setting
default["auto-patch"]["disable"] = node['autopatch-nativex']['disabled']

# This attribute is used internally - it should never be set outside the cookbook itself, hence the 'private' designation
default["autopatch-nativex"]["private_lin_autopatch_disabled_programmatically"] = false
