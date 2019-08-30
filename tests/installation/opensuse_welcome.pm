# SUSE's openQA tests
#
# Copyright © 2019 SUSE LLC
#
# Copying and distribution of this file, with or without modification,
# are permitted in any medium without royalty provided the copyright
# notice and this notice are preserved.  This file is offered as-is,
# without any warranty.

# Summary: openSUSE Welcome should auto-launch on GNOME/KDE/XFCE Sessions
#          Disable auto-launch on next boot and close application
# Maintainer: Dominique Leuenberger <dimstar@suse.de>

use base "x11test";
use strict;
use warnings;
use testapi;
use utils;

sub my_assert_and_click {
    my ($mustmatch, %args) = @_;
    $args{button}    //= 'left';
    $args{dclick}    //= 0;

    my $last_matched_needle = assert_screen($mustmatch);

    # determine click coordinates from the last area which has those explicitly specified
    my $relevant_area;
    my $relative_click_point;
    for my $area (reverse @{$last_matched_needle->{area}}) {
        next unless ($relative_click_point = $area->{click_point});

        $relevant_area = $area;
        last;
    }

    # use center of the last area if no area contains click coordinates
    if (!$relevant_area) {
        $relevant_area = $last_matched_needle->{area}->[-1];
    }
    if (!$relative_click_point || $relative_click_point eq 'center') {
        $relative_click_point = {
            xpos => $relevant_area->{w} / 2,
            ypos => $relevant_area->{h} / 2,
        };
    }

    # calculate absolute click position and click
    my $x = int($relevant_area->{x} + $relative_click_point->{xpos});
    my $y = int($relevant_area->{y} + $relative_click_point->{ypos});
    mouse_set($x, $y);
    if ($args{dclick}) {
        mouse_dclick($args{button}, $args{clicktime});
    }
    else {
        mouse_click($args{button}, $args{clicktime});
    }

    # move mouse back to where it was before we clicked, or to the 'hidden' position if it had never been
    # positioned
    # note: We can not move the mouse instantly. Otherwise we might end up in a click-and-drag situation.
    sleep 2;
    return mouse_hide();
}

sub run {
    assert_screen("opensuse-welcome");
    my_assert_and_click("opensuse-welcome-show-on-boot");
    assert_and_click("opensuse-welcome-close-btn");
}

1;
