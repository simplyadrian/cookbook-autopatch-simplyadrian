# 0.1.0

Initial release of autopatch-nativex

# 1.0.0

* Added Linux support
* Removed 'download_install_splay_enabled' and '_min_seconds' attributes.
* Added ability to skip updates (Linux only)

# 1.1.0

* Moved 'splay' function before even checking for updates. (Both platforms). Prevents overloading WSUS/Spacewalk when every machine starts the update process at the same time.
* Changed default 'download_install_splay_max_seconds' to 3600 (one hour).
* Changed default 'email_notification_mode' to 'Always'.
* Use yum 'upgrade' instead of update to be consistent with yum cookbook.
* Allow for other yum options to be passed in via attribute (such as --nogpgcheck)
* In the Linux template, stop using the original 'auto-patch' attributes, and instead use all autopatch-nativex attributes.
