autopatch-simplyadrian Cookbook
====================
# AutoPatch Cookbook for Windows
This cookbook aims to provide automated Windows Update and Yum Update (patching) functionality for servers with one seamless set of configuration attributes.

The idea of running the patching process on an automated schedule comes from the  [auto-patch Linux cookbook](https://supermarket.chef.io/cookbooks/auto-patch).
## Usage

1. Include the default recipe in your run list.
2. Override attributes, if you wish, that control the patching schedule, email notifications, and auto-reboot functionality.

##Scope

This cookbook has 2 main responsibilities:

1. Manage a recurring task (Windows Scheduled Task or Linux Cron job) that performs the patching process on a configurable schedule.
2. Manage a shell script (PowerShell, or Bash) that performs the work. The script itself has these notable features:
  * Can detect errors installing individual updates, and continue installing the rest.
  * Configurable 'splay' built into the download process to allow preventing many servers from using network and disk resources all at the same time.
  * Ability to automatically reboot the machine if the installed updates require it.
  * Configurable email notification 

## Requirements

* Chef 11 or higher

## Supported OS Distributions
Tested on:

* Windows Server 2012 R2 (windows 6.3.9600)
* Windows Server 2008 R2
* CentOS 6.6

## Recipes
The provided recipes are:

* `autopatch-simplyadrian::default`: The main recipe that:
  * Lays down a working directory for scripts and log files.
  * Invokes the proper recipe (`linux` or `windows`) depending on the detected platform.

* `autopatch-simplyadrian::windows`: The recipe for Windows machines that:
  * Creates and enables (or disables) the Windows Scheduled task
  * Lays down the templated PowerShell script.

* `autopatch-simplyadrian::linux`: The recipe for Linux machines that:
  * Wraps the 'auto-patch' community cookbook
    * Translates `autopatch-simplyadrian` attributes into the equivalent configuration for `auto-patch`
    * Replaces the Bash template from `auto-patch` with one provided by this cookbook that has all the similar features as the Windows version.
    * NOTE: This cookbook does no translation for the auto-patch 'prep' feature! It is disabled by default, but there is nothing stopping it from being turned on.
  * Creates and enables (or disables) the Cron task
  * Lays down the templated Bash script.

## Attributes
This cookbook will install the necessary components and enable autopatch by default, if no attributes are overridden.

### default.rb

* `node["autopatch-simplyadrian"]["disabled"]` (default: `false`): enable or disable the recurring task
* `node["autopatch-simplyadrian"]["task_username"]` (default: `'SYSTEM'`): User account the Scheduled Task will run as (Windows, only)
* `node["autopatch-simplyadrian"]["task_frequency"]` (default: `:monthly`): Run frequency of the recurring task. Valid values are :minute, :hourly, :daily, :weekly, :monthly
* `node["autopatch-simplyadrian"]["task_frequency_modifier"]` (default: `'THIRD'`): Refines the schedule type to allow finer control over schedule recurrence. Valid values for the given `task_frequency` are:
  * `:minute`:  1 - 1439 minutes. (Windows only)
  * `:hourly`:  1 - 23 hours. (Windows only)
  * `:daily`:   1 - 365 days. (Windows only)
  * `:weekly`:  weeks 1 - 52.
  * `:monthly`: 1 - 12, or FIRST, SECOND, THIRD, FOURTH, LAST, LASTDAY. (1-12, LAST, and LASTDAY are Windows only)
* `node["autopatch-simplyadrian"]["task_months"]` (default: `'JAN,FEB,MAR,APR,MAY,JUN,JUL,AUG,SEP,OCT,NOV'`, DEC is skipped): When using `task_frequency` of `:monthly`, controls in which months the task runs. Valid values: JAN, FEB, MAR, APR, MAY, JUN, JUL, AUG, SEP, OCT, NOV, DEC. Wildcard "*" specifies all months.
* `node["autopatch-simplyadrian"]["task_days"]` (default: `'TUE'`): Specifies the day of the week to run the task. Valid values: MON, TUE, WED, THU, FRI, SAT, SUN and for `:monthly` schedules 1 - 31 (days of the month). Wildcard "*" specifies all days.
* `node["autopatch-simplyadrian"]["task_start_time"]` (default: `'04:00'`): The time of the day (using 24-hour clock) the task should run.
* `node["autopatch-simplyadrian"]["working_dir"]` (default: `'C:\chef_autopatch'` for Windows; `'/var/log/chef_autopatch'` for Linux): The working directory for the process and its log files.
* `node["autopatch-simplyadrian"]["download_install_splay_max_seconds"]` (default: `3600`): Maximum number of random seconds to wait before starting download/install process. Setting it to `0` disables the feature
* `node["autopatch-simplyadrian"]["email_notification_mode"]` (default: `'Always'`): Controls when email notifications are sent. Valid values:
  * `'OnlyOnErrorOrManualReboot'`: Only send notification if an error occurs or a manual reboot is required.
  * `'Always'`: Always send a notification.
  * `'Never'`: Never send a notification
* `node["autopatch-simplyadrian"]["email_to_addresses"]` (default: `'"SysEngineers@simplyadrian.com"'`): The list (comma-delimited string array) of email addresses to send notifications to.  To send to more than one, it would look like `'"addy1@somewhere.com", "addy2@somewhere.com", "addy3@somewhere.com"'`
* `node["autopatch-simplyadrian"]["email_from_address"]` (default: `"#{node['hostname']}@simplyadrian.com"`): The From address for any email notification.
* `node["autopatch-simplyadrian"]["email_smtp_server"]` (default: `'mail.simplyadrian.com'`): The SMTP server to use to send the notifications.
* `node["autopatch-simplyadrian"]["auto_reboot_enabled"]` (default: `false`): Whether or not to automatically reboot the machine if the installed updates require it.
* `node["autopatch-simplyadrian"]["updates_to_skip"]` (default: `[]`): Array of strings where each element corresponds to the name of a package (Linux) or a KB Article ID (Windows) that should be skipped during the check and update process.
  * NOTE: This is ONLY implemented for Linux as of v1.0.0
* `node["autopatch-simplyadrian"]["update_command_options"]` (default: `""`): A string that can be injected into the update command to provide additional configuration options.
  * NOTE: This is ONLY implemented for Linux as of v1.1.0. More specifically, it will be injected into the `yum upgrade` command.  An example use case would be for specifying `--nogpgcheck`
  * In the future there may be a use case for Windows, which is why it is left generic

## Dependencies

* "windows" - Currently [v1.37.0](https://github.com/simplyadrian/windows/tree/taskEnhancements), a forked version of the OpsCode cookbook that supports the /M (months) Windows Task parameter.
* "auto-patch" - Currently v0.1.9

## License and Authors

Author: Derek Bromenshenkel (<derek.bromenshenkel@gmail.com>)
