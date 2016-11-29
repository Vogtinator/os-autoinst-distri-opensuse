# SUSE's openQA tests
#
# Copyright © 2009-2013 Bernhard M. Wiedemann
# Copyright © 2012-2016 SUSE LLC
#
# Copying and distribution of this file, with or without modification,
# are permitted in any medium without royalty provided the copyright
# notice and this notice are preserved.  This file is offered as-is,
# without any warranty.

use strict;
use warnings;
use base "y2logsstep";
use testapi;
use lockapi;

sub run() {
    my $self = shift;

    # Expert Partitioner
    send_key 'alt-e';

    assert_screen 'partition-system-view';

    # Select / partition
    send_key 'alt-s';
    send_key 'down';
    assert_screen 'partition-part-slash';
    send_key 'tab';
    send_key 'down';
    send_key 'down';
    send_key 'down';

    # Change / on btrfs to /boot on ext4
    send_key 'alt-e';
    assert_screen 'partition-part-edit';
    send_key 'alt-s';
    send_key 'down';
    send_key 'down';
    send_key 'down'; # Select ext4
    send_key 'alt-m';
    type_string '/boot';
    send_key 'alt-f';
    assert_screen 'partition-system-view';

    # Go to NFS view
    # sleep 1 is required as it doesn't react to key
    # events while switching the view
    send_key 'alt-s';# sleep 1;
    send_key 'down';# sleep 1;
    send_key 'down';# sleep 1;
    send_key 'down';# sleep 1;
    send_key 'down';# sleep 1;
    send_key 'down';# sleep 1;

    # Wait for NFS server to be ready
    mutex_lock 'nfs_ready';

    # Add mount
    assert_screen 'partition-nfs-overview';
    send_key 'alt-d';
    assert_screen 'partition-nfs-mountpoint';
    type_string '10.0.2.1';
    send_key 'alt-r';
    type_string '/'; # Remote directory
    send_key 'alt-v'; # NFSv4
    send_key 'alt-m';
    type_string '/'; # Mount Point
    send_key 'alt-o', 1;

    # Finish
    send_key 'alt-a';
    assert_screen 'partition-unformatted';
    send_key 'alt-y';
}

1;
# vim: set sw=4 et:
