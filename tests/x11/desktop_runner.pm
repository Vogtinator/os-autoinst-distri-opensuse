# SUSE's openQA tests
#
# Copyright © 2018 SUSE LLC
#
# Copying and distribution of this file, with or without modification,
# are permitted in any medium without royalty provided the copyright
# notice and this notice are preserved.  This file is offered as-is,
# without any warranty.

# Summary: Test the desktop runner which is a prerequisite for many other
#   modules
# - Launch "true" and check if desktop is matched
# Maintainer: Oliver Kurz <okurz@suse.de>

use base 'x11test';
use strict;
use warnings;
use testapi;

sub run {
    my ($self) = @_;
    $self->check_desktop_runner;

x11_start_program('sudo sh -c "DBUS_SESSION_BUS_ADDRESS=unix:path=/run/user/1000/bus su linux -c dbus-monitor >> /dev/ttyS0 & disown"', valid => 0);
}

1;
