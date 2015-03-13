autopatch-nativex Cookbook
====================
# AutoPatch Cookbook for Windows
This cookbook aims to provide automated Windows Update (patching) functionality for Windows servers.

The idea of running the patching process on an automated schedule comes from the  [auto-patch Linux cookbook](https://supermarket.chef.io/cookbooks/auto-patch).
## Usage

1. Include the default recipe in your run list.
2. Override attributes, if you wish, that control the patching schedule, email notifications, and auto-reboot functionality.

##Scope

This cookbook has 2 main responsibilities:

1. Manage a Windows Scheduled task that performs the patching process on a configurable schedule.
2. Manage a PowerShell script that performs the work. The script itself has these notable features:
  * Can detect errors installing individual updates, and continue installing the rest.
  * Configurable 'splay' built into the download process to allow preventing many servers from using network and disk resources all at the same time.
  * Ability to automatically reboot the machine if the installed updates require it.
  * Configurable email notification 

## Requirements

* Chef 11 or higher

## Supported OS Distributions
Tested on:

* Windows Server 2012 R2 (windows 6.3.9600)

## Recipes
The provided recipes are:

* `autopatch-nativex::default`: The main recipe that:
  * Lays down a working directory for the Powershell script and its log files.
  * Creates and enables (or disables) the Windows Scheduled task
  * Lays down the templated PowerShell script.

## Attributes
This cookbook will install the necessary components and enable autopatch by default, if no attributes are overridden.

### default.rb

* `node["autopatch-nativex"]["disabled"]` (default: `false`): enable or disable the Scheduled Task
* `node["autopatch-nativex"]["task_username"]` (default: `'SYSTEM'`): User account the Scheduled Task will run as
* `node["autopatch-nativex"]["task_frequency"]` (default: `:monthly`): Run frequency of the Scheduled Task. Valid values are :minute, :hourly, :daily, :weekly, :monthly
* `node["autopatch-nativex"]["task_frequency_modifier"]` (default: `'THIRD'`): Refines the schedule type to allow finer control over schedule recurrence. Valid values for the given `task_frequency` are:
  * `:minute`:  1 - 1439 minutes.
  * `:hourly`:  1 - 23 hours.
  * `:daily`:   1 - 365 days.
  * `:weekly`:  weeks 1 - 52.
  * `:monthly`: 1 - 12, or FIRST, SECOND, THIRD, FOURTH, LAST, LASTDAY.
* `node["autopatch-nativex"]["task_months"]` (default: `'JAN,FEB,MAR,APR,MAY,JUN,JUL,AUG,SEP,OCT,NOV'`, DEC is skipped): When using `task_frequency` of `:monthly`, controls in which months the task runs. Valid values: JAN, FEB, MAR, APR, MAY, JUN, JUL, AUG, SEP, OCT, NOV, DEC. Wildcard "*" specifies all months.
* `node["autopatch-nativex"]["task_days"]` (default: `'TUE'`): Specifies the day of the week to run the task. Valid values: MON, TUE, WED, THU, FRI, SAT, SUN and for `:monthly` schedules 1 - 31 (days of the month). Wildcard "*" specifies all days.
* `node["autopatch-nativex"]["task_start_time"]` (default: `'04:00'`): The time of the day (using 24-hour clock) the task should run.
* `node["autopatch-nativex"]["working_dir"]` (default: `'C:\chef_autopatch'`): The working directory for the PowerShell script and  its log files.
* `node["autopatch-nativex"]["download_install_splay_enabled"]` (default: `true`): enable or disable 'splay' or a random wait before the download (and install) process.
* `node["autopatch-nativex"]["download_install_splay_min_seconds"]` (default: `0`): Minimum number of random seconds to wait before starting download/install process if `download_install_splay_enabled` = `true`
* `node["autopatch-nativex"]["download_install_splay_max_seconds"]` (default: `5400`): Maximum number of random seconds to wait before starting download/install process if `download_install_splay_enabled` = `true`
* `node["autopatch-nativex"]["email_notification_mode"]` (default: `'OnlyOnErrorOrManualReboot'`): Controls when email notifications are sent. Valid values:
  * `'OnlyOnErrorOrManualReboot'`: Only send notification if an error occurs or a manual reboot is required.
  * `'Always'`: Always send a notification.
  * `'Never'`: Never send a notification
* `node["autopatch-nativex"]["email_to_addresses"]` (default: `'"SysEngineers@nativex.com"'`): The list (comma-delimited string array) of email addresses to send notifications to.  To send to more than one, it would look like `'"addy1@somewhere.com", "addy2@somewhere.com", "addy3@somewhere.com"'`
* `node["autopatch-nativex"]["email_from_address"]` (default: `"#{node['hostname']}@nativex.com"`): The From address for any email notification.
* `node["autopatch-nativex"]["email_smtp_server"]` (default: `'mail.nativex.com'`): The SMTP server to use to send the notifications.
* `node["autopatch-nativex"]["auto_reboot_enabled"]` (default: `false`): Whether or not to automatically reboot the machine if the installed updates require it.

## Dependencies

* "windows" - Currently [v1.37.0](https://github.com/nativex/windows/tree/taskEnhancements), a forked version of the OpsCode cookbook that supports the /M (months) Windows Task parameter.

## License and Authors

Author: Derek Bromenshenkel (<derek.bromenshenkel@gmail.com>)
