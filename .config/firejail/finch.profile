# Firejail profile for pidgin
# Description: Graphical multi-protocol instant messaging client
# This file is overwritten after every install/update
# Persistent local customizations
include /etc/firejail/pidgin.local
# Persistent global definitions
include /etc/firejail/globals.local

noblacklist ${HOME}/.purple

include /etc/firejail/disable-common.inc
include /etc/firejail/disable-devel.inc
include /etc/firejail/disable-interpreters.inc
include /etc/firejail/disable-passwdmgr.inc
include /etc/firejail/disable-programs.inc

caps.drop all
netfilter
nodvd
nogroups
nonewprivs
noroot
notv
protocol unix,inet,inet6
seccomp
shell none
tracelog

private-bin finch
private-cache
private-dev
private-tmp

noexec ${HOME}
noexec /tmp
