# SUSE's openQA tests
#
# Copyright © 2018 SUSE LLC
#
# Copying and distribution of this file, with or without modification,
# are permitted in any medium without royalty provided the copyright
# notice and this notice are preserved.  This file is offered as-is,
# without any warranty.

# Summary: Test for live installer on the GNOME Live media
#
# Maintainer: Fabian Vogt <fvogt@suse.com>

use base "installbasetest";
use testapi;
use utils;
use strict;

sub run {
    # stop packagekit, root password is not needed on live system
    x11_start_program('systemctl stop packagekit.service', target_match => 'generic-desktop');

    send_key_until_needlematch 'test-desktop_mainmenu-1', 'alt-f1', 5, 10;
    type_string 'Install';
    send_key 'ret';

    # Wait until the first screen is shown, only way to make sure it's idle
    assert_screen 'inst-welcome', 180;

    # "Maximize" it, as fullscreen is impossible on GNOME
    send_key 'super-up';
    save_screenshot;
}

1;
