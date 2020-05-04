# SUSE's openQA tests
#
# Copyright © 2018-2020 SUSE LLC
#
# Copying and distribution of this file, with or without modification,
# are permitted in any medium without royalty provided the copyright
# notice and this notice are preserved.  This file is offered as-is,
# without any warranty.
#
# Summary: Windows over RDP using KRDC
# Maintainer: Fabian Vogt <fvogt@suse.com>

use strict;
use warnings;
use base 'x11test';
use testapi;
use version_utils ':VERSION';
use lockapi;
use mmapi;
use mm_tests;

sub run {
    my $self = shift;
    # Setup static network
    $self->configure_static_ip_nm('10.0.2.17/24');

    mutex_lock 'win_server_ready';

    ensure_installed('krdc');

    # Start Remmina and login the remote server
    x11_start_program('remmina');

    # Switch to RDP
    assert_and_click 'krdc-protocol-combobox';
    assert_and_click 'krdc-protocol-option-rdp';

    # Connect
    type_string '10.0.2.18\n';
    assert_and_click 'krdc-connection-settings-ok';
    assert_screen 'krdc-username';
    # We can not use the variable $realname here
    # Since the windows username limit is 20 characters
    # The username in windows is different from the $realname
    type_string "Bernhard M. Wiedeman\n";
    assert_screen 'krdc-password';
    type_password;
    send_key 'ret';

    assert_screen 'krdc-windows-desktop';
    assert_and_click "krdc-close-connection";

    send_key "alt-f4";
}
1;
