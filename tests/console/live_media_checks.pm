# SUSE's openQA tests
#
# Copyright © 2021 SUSE LLC
#
# Copying and distribution of this file, with or without modification,
# are permitted in any medium without royalty provided the copyright
# notice and this notice are preserved.  This file is offered as-is,
# without any warranty.

# Summary: Verify live media persistence
# Maintainer: Fabian Vogt <fvogt@suse.com>

use base 'consoletest';
use strict;
use warnings;
use testapi;
use power_action_utils qw(power_action);

sub run {
    my ($self) = @_;
    $self->select_serial_terminal;

    # The persistent overlay is only created and used when booted from USB (writable)
    # and there is free space
    die("Not booted from a resized USB drive") unless get_var("USBBOOT") && get_var("USBSIZEGB");

    # Disk which the system was booted from
    my $disk = script_output('lsblk -rnoPKNAME $(findmnt -nrvoSOURCE /run/overlay/live)');

    # Verify that openQA resized the disk image
    my $disksize = script_output "sfdisk --show-size /dev/$disk";
    die "Disk not bigger than the default size, got $disksize KiB" unless $disksize > (1 * 1024 * 1024);

    # Verify that there is no unpartitioned space left
    validate_script_output("sfdisk --list-free /dev/$disk", qr/Unpartitioned space .* 0 sectors/);

    # Write a file
    assert_script_run('echo openQA was here > ~/testfile');

    power_action('reboot', textmode => 1);
    $self->wait_boot(bootloader_time => 300);
    $self->select_serial_terminal;

    # Verify it's still there
    validate_script_output('cat ~/testfile && rm ~/testfile', qr/openQA was here/);
}

1;
