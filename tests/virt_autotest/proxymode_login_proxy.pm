# SUSE's openQA tests
#
# Copyright © 2016 SUSE LLC
#
# Copying and distribution of this file, with or without modification,
# are permitted in any medium without royalty provided the copyright
# notice and this notice are preserved.  This file is offered as-is,
# without any warranty.
#
# Summary: proxymode_login_proxy: Login to Physical machine thru Proxy machine with ipmitool.
# Maintainer: John <xgwang@suse.com>

use strict;
use warnings;
use File::Basename;
use base "opensusebasetest";
use testapi;

sub run {
    assert_screen "bootloader";
    send_key "ret";
    assert_screen "grub2", 10;
    send_key "ret";
    assert_screen "displaymanager", 300;
    select_console('root-console');
}

sub test_flags {
    return {fatal => 1};
}

1;
