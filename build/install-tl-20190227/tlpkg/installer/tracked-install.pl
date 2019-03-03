#!/usr/bin/env perl
# $Id: tracked-install.pl 48057 2018-06-20 02:14:01Z preining $
#
# Copyright 2008-2017 Norbert Preining
# Copyright 2008 Reinhard Kotucha
# This file is licensed under the GNU General Public License version 2
# or any later version.

use strict;
$^W = 1;

my $svnrev = '$Revision: 41176 $';
$svnrev =~ m/: ([0-9]+) /;
$::menurevision = $1;

require Tk;
require Tk::ROText;
require Tk::ProgressBar;

use utf8;
no utf8;

sub installer_tracker {
  my $ret;
  # create a progress bar window
  $::sww = Tk::MainWindow->new;
  $::sww->Label(-text => __("Installation process"))->pack;
  #warn "Debug!! Creating text window";
  $::progressw = $::sww->Scrolled(
    "ROText", -wrap => "word", -scrollbars => "e", -height => 18);
  #warn "Debug!! Created text window";
  $::progressw->pack(-expand => 1, -fill => "both");
  #warn "Debug!! Placed text window";
  my $percent_done = 0;
  $::progress = $::sww->ProgressBar(-variable => \$percent_done,
    -width => 20, -length => 400, -from => 0, -to => 100, -blocks => 10,
    -colors => [ 0, '#0078b8' ]);
  $::progress->pack(-fill => "x");
  #my $f = $::sww->Frame;
  my $b = $::sww->Button(
    -text => __("Cancel"),
    -command => sub {
      do_cleanup(); $::sww->destroy;
      # POSIX::exit prevents Tk error message 'Tk::Error: ("after" script)'
      POSIX::exit(1);
    })->pack(-pady => "2m");
  $b->focus();
  # $f->pack;
  setup_hooks_perltk();

  $ret = do_installation();

  if (@::WARNLINES) {
    foreach my $t (@::WARNLINES) {
      tlwarn ("$t\n");
    }
  }
  if ($::env_warns) {
    tlwarn($::env_warns);
  }
  $::progressw->tagConfigure('centered', -justify => 'center');
  # basic welcome message
  foreach my $t (@::welcome_arr) {
    info("$t\n");
  }
  $::progressw->insert("end", "\n");

  do_cleanup();

  # additional info
  if ($::LOGFILENAME) {
    $::progressw->insert ("end", "Logfile: $::LOGFILENAME");
  } else {
    # do_cleanup sets $::LOGFILENAME to ""
    #if no logfile could be written
    $::progressw->insert ("end",
      "Cannot create logfile $::vars{'TEXDIR'}/install-tl.log: $!");
  }
  if (@::WARNLINES or $::env_vars or !$::LOGFILENAME) {
    $::progressw->insert("end", "\n");
    $::progressw->insert("end", __("Scroll back to inspect warnings"));
  }
  $::progressw->insert("end", "\n");
  my $linechar = $::progressw->index("end");
  $::progressw->see("end");
  $::progressw->tagAdd("centered", $linechar, "end");
  $::progressw->tagConfigure("centered", -justify => "center");
  $b->configure(
    -text => __("Finish"),
    -command => sub {
      $::sww->destroy; return $ret;
  });

  Tk::MainLoop();
  return $ret;
} # installer_tracker

#sub tracked_installation {
#  # undo binding, since this should run only once
#  my $b = shift;
#  $b->bind('<Map>' => '');
#  $ret = do_installation();
#  $::sww->destroy;
#}

sub setup_hooks_perltk {
  @::info_hook = ();
  push @::info_hook,
    sub {
      update_status(join(" ",@_));
      $::sww->update;
    };
  push @::warn_hook,
    sub {
      return unless defined $::sww ;
      update_status(join(" ",@_));
    };
  @::install_packages_hook = ();
  push @::install_packages_hook, \&update_progressbar;
  push @::install_packages_hook,
    sub {
      return unless defined $::sww;
      $::sww->update;
    };
}

sub update_status {
  my ($p) = @_;
  return unless defined $::progressw;
  $::progressw->insert("end", "$p");
  $::progressw->see("end");
}
sub update_progressbar {
  my ($n,$total) = @_;
  return unless defined $::progress;
  if (defined($n) && defined($total)) {
    $::progress->value(int($n*100/$total));
  }
}
