default['autopatch-simplyadrian']['disabled'] = false
default['autopatch-simplyadrian']['task_username'] = 'SYSTEM'
default['autopatch-simplyadrian']['task_frequency'] = :monthly
default['autopatch-simplyadrian']['task_frequency_modifier'] = 'THIRD'
default['autopatch-simplyadrian']['task_months'] = 'JAN,FEB,MAR,APR,MAY,JUN,JUL,AUG,SEP,OCT,NOV'
default['autopatch-simplyadrian']['task_days'] = 'TUE'
default['autopatch-simplyadrian']['task_start_time'] = '04:00'
if node['platform_family'] == 'windows'
  default['autopatch-simplyadrian']['working_dir'] = 'C:\chef_autopatch'
else
  default['autopatch-simplyadrian']['working_dir'] = '/var/log/chef_autopatch'
end
default['autopatch-simplyadrian']['download_install_splay_max_seconds'] = 3600
default['autopatch-simplyadrian']['email_notification_mode'] = 'Always'
default['autopatch-simplyadrian']['email_to_addresses'] = '"SysEngineers@simplyadrian.com"'
default['autopatch-simplyadrian']['email_from_address'] = "#{node['hostname']}@simplyadrian.com"
default['autopatch-simplyadrian']['email_smtp_server'] = 'mail.simplyadrian.com'
default['autopatch-simplyadrian']['auto_reboot_enabled'] = false
default['autopatch-simplyadrian']['updates_to_skip'] = []
default['autopatch-simplyadrian']['update_command_options'] = ""

#syncronize auto-patch enablement with this cookbook's main setting
default["auto-patch"]["disable"] = node['autopatch-simplyadrian']['disabled']

# This attribute is used internally - it should never be set outside the cookbook itself, hence the 'private' designation
default["autopatch-simplyadrian"]["private_lin_autopatch_disabled_programmatically"] = false
