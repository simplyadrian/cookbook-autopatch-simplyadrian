#
# Cookbook Name:: autopatch-simplyadrian
# Recipe:: linux
#
# Copyright (C) 2015 simplyadrian
#
# All rights reserved - Do Not Redistribute
#
# Wraps auto-patch (Linux) cookbook.  Overrides the auto-patch bash script template.
# Also, translates the attributes in this cookbook to something auto-patch understands

# Translate the autopatch-simplyadrian attribute specifiying frequency into something that auto-patch understands
unless node["autopatch-simplyadrian"]["disabled"]
  # Translate reboot
  node.default['auto-patch']['reboot'] = node["autopatch-simplyadrian"]["auto_reboot_enabled"]

  # Translate splay
  node.default['auto-patch']['splay'] = node["autopatch-simplyadrian"]["download_install_splay_max_seconds"]
  
  # Translate hour and minute
  taskHour, taskMinute = node["autopatch-simplyadrian"]["task_start_time"].split(':')
  node.default['auto-patch']['hour'] = taskHour.to_i
  node.default['auto-patch']['minute'] = taskMinute.to_i

  # Translate the schedule
  case node["autopatch-simplyadrian"]["task_frequency"] # only :monthly and :weekly are valid.
  when :monthly, 'monthly'
    # When using monthly cycle, auto-patch expects a single attribute, node["auto-patch"]["monthly"], to be set to something like "third tuesday".
    # This cookbook's attributes represent that differently, but we can derive it.  Note that some of the edge cases are not supported by cron (linux).
    frequency_mod = ""
    case node["autopatch-simplyadrian"]["task_frequency_modifier"]
    when "FIRST", "SECOND", "THIRD", "FOURTH"
      frequency_mod = node["autopatch-simplyadrian"]["task_frequency_modifier"].downcase
      frequency_day = ""
      # Now gotta find the Day
      begin
        frequency_day = AutoPatchHelper.getLCaseWeekdayFromAbbreviation node["autopatch-simplyadrian"]["task_days"]
      rescue
        Chef::Application.fatal!("auto-patch on Linux does not support '#{node["autopatch-simplyadrian"]["task_days"]}' task_days attribute while using ':monthly' task_frequency!! Valid values are MON, TUE, WED, THU, FRI, SAT, SUN")
      end
      
      # Now can build a string like "third tuesday" to send to auto-patch
      node.default["auto-patch"]["monthly"] = "#{frequency_mod} #{frequency_day}"
      Chef::Log::info("Programmatically set node['auto-patch']['monthly'] to '#{frequency_mod} #{frequency_day}'.")
      
      # simplyadrian has a policy to not do patches in December.  auto-patch does not support this notion of skipping a month.
      # We'll work around that here by 
      #   1) Disabling auto-patch for any month not configured 
      #   2) Setting a flag so that we know this automated process disabled it (so we know it is OK to automatically re-enable)
      #   3) Re-enabling once we are in an "eligible" month.
      unless node["autopatch-simplyadrian"]["task_months"] == "*"
        if node["autopatch-simplyadrian"]["task_months"].split(',').include?(DateTime.now.strftime('%^b'))
          # It is a valid month
          # Check if previously disabled
          if node["autopatch-simplyadrian"]["private_lin_autopatch_disabled_programmatically"] == true
            if node["auto-patch"]["disable"] == true
              # Re-enable it
              Chef::Log::debug("Re-enabling auto-patch for month #{DateTime.now.strftime('%^b')}")
              node.default["auto-patch"]["disable"] = false
            end
            # Reset our flag
            node.normal["autopatch-simplyadrian"]["private_lin_autopatch_disabled_programmatically"] = false
            Chef::Log::debug("Reset programmatic flag node['autopatch-simplyadrian']['private_lin_autopatch_disabled_programmatically'] to false.")
          end #end check for re-enabling.. either manually enabled or this code didn't originally disable it.
        else
          # It is an invalid month.  Disable auto-patch if need be and mark the flag that we did it.
          if node["auto-patch"]["disable"] == false
            node.default["auto-patch"]["disable"] = true
            node.normal["autopatch-simplyadrian"]["private_lin_autopatch_disabled_programmatically"] = true
            Chef::Log::debug("Disabling auto-patch for month #{DateTime.now.strftime('%^b')}!!")
          end
        end # end task_months check
      end # end check for wildcard months
    else
      Chef::Application.fatal!("auto-patch on Linux does not support '#{node["autopatch-simplyadrian"]["task_frequency_modifier"]}' task_frequency_modifier attribute!! Valid values are FIRST, SECOND, THIRD, FOURTH")
    end # end task_frequency_modifier
  # end :monthly
  when :weekly, 'weekly'
    frequency_day = ""
    begin
      frequency_day = AutoPatchHelper.getLCaseWeekdayFromAbbreviation node["autopatch-simplyadrian"]["task_days"]
    rescue
      Chef::Application.fatal!("auto-patch on Linux does not support '#{node["autopatch-simplyadrian"]["task_days"]}' task_days attribute while using ':weekly' task_frequency!! Valid values are MON, TUE, WED, THU, FRI, SAT, SUN")
    end
    
    # Take the frequency and set it on auto-patch
    node.default["auto-patch"]["weekly"] = frequency_day
    Chef::Log::info("Programmatically set node['auto-patch']['weekly'] to '#{frequency_day}'.")
  else # end :weekly
    Chef::Application.fatal!("auto-patch on Linux does not support '#{node["autopatch-simplyadrian"]["task_frequency"]}' task_frequency attribute!! Valid values are :monthly, :weekly")
  end #end task_frequency case
end # autopatch-simplyadrian disabled check

# Put this here so the below code can find the auto-patch resources. The code above sets all the auto-patch attributes.
include_recipe "auto-patch::default"

begin
  # Find the template resource specified by the auto-patch cookbook
  autoPatchTemplate = resources(:template => "/usr/local/sbin/auto-patch")

  # Set it to use this cookbook, effectively overriding the implementation
  autoPatchTemplate.cookbook "autopatch-simplyadrian"
rescue Chef::Exceptions::ResourceNotFound
  Chef::Log.warn "Could not find auto-patch template to override!"
end

# Ensure mailx is there to send notification emails - it should be, but just in case
package "mailx" do
  action :install
end

# Ensure the autopatch.log file is fresh each month and also so it doesn't infinitely grow.
logrotate_app 'chef-autopatch' do
  cookbook  'logrotate'
  path      "#{node['autopatch-simplyadrian']['working_dir']}/autopatch.log"
  options   ['missingok', 'nocompress', 'notifempty']
  frequency 'daily'
  rotate    3
end
