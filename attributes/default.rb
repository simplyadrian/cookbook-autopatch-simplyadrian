# use the same attributes as the linux side... Configure defaults here, which may be different than Linux
default['auto-patch']['disable'] = false
default['auto-patch']['hour'] = 3
default['auto-patch']['minute'] = 0
default['auto-patch']['monthly'] = 'third tuesday'
default['auto-patch']['reboot'] = true
default['auto-patch']['splay'] = 1800
default['auto-patch']['weekly'] = nil
