#!/usr/bin/env perl

use strict;
use warnings;
$^W = 1;

require Cwd;
require File::Spec;

our $texlive_release;
our %vars;
our $mw;

my $sep;
if (win32()) {
  $sep = "\\";
} else {
  $sep = "/";
}

sub change_path {

  ### GUI SETUP ###

  my $sw;
  $sw->destroy if Tk::Exists($sw);
  $sw = $mw->Toplevel(-title => "Changing TEXDIR");
  $sw->transient($mw);
  $sw->withdraw;
  $sw->grab();

  # define a larger font
  my $lfont = $sw->fontCreate();
  $sw->fontConfigure(
    $lfont, -size => 1.2 * $mw->fontConfigure($lfont, -size));

  my $fr0 = $sw->Frame(-padx => 10, -pady => 5)->pack;
  $sw->Label(-text => __("Installation directory").": ", -font => $lfont)
    ->pack(-in => $fr0, -side => 'left');
  my $path_l = $sw->Label(-font => $lfont)
    ->pack(-in => $fr0, -side => 'left');

  my $fr = $sw->Frame->pack;
  my $prefix_l = $sw->Label(-justify => 'right', -padx => 5)
    ->grid(-in => $fr, -column => 0, -row => 0, -sticky => 'e');
  $sw->Label(-text => $sep)
    ->grid(-in => $fr, -column => 1, -row => 0);
  my $name_l = $sw->Label(-justify => 'center', -padx => 5)
    ->grid(-in => $fr, -column => 2, -row => 0);
  $sw->Label(-text => $sep)
    ->grid(-in => $fr, -column => 3, -row => 0);
  my $rel_l = $sw->Label(-justify => 'left', -padx => 5)
    ->grid(-in => $fr, -column => 4, -row => 0, -sticky => 'w');

  my $prefix_b = $sw->Button(
    -text => __("Change". '...'), -padx => 1, -pady => 3, -bd => 1)
    ->grid(-in => $fr, -column => 0, -row => 1, -sticky => 'ew');
  my $name_b = $sw->Button(
    -text => __("Change"), -padx => 1, -pady => 3, -bd => 1)
    ->grid(-in => $fr, -column => 2, -row => 1, -sticky => 'ew', -padx => 2);
  my $rel_b = $sw->Button(
    -text => __("Toggle"), -padx => 1, -pady => 3, -bd => 1)
    ->grid(-in => $fr, -column => 4, -row => 1, -sticky => 'ew');

  # warning about year component
  my $warn_yr_l = $sw->Label(-anchor => 'e', -foreground => 'red')
    ->pack(-fill =>'x', -expand => 1);

  # ok and cancel buttons
  my $frb = $sw->Frame->pack(-fill => 'x', -expand => 1);
  my $ok_b = $sw->Button(
    -text => __("Ok"),
    -command => sub {
      callback_change_texdir(forward_slashify($path_l->cget(-text)));
      $sw->destroy;
    })->pack(-in => $frb, -side => 'right');
  my $q = $sw->Button(-text => __("Cancel"), -command => sub {$sw->destroy;})
    ->pack(-in => $frb, -side => 'right');

  if (win32()) {
    $frb->Label(
      -text =>
        __("Localized directory names will be replaced by their real names"))
      ->pack(-side => 'left');
  }

  # array of widgets needed by callbacks
  my @wg = ($path_l, $prefix_l, $name_l, $rel_l, $ok_b, $warn_yr_l);

  # callbacks which use @wg
  $prefix_b->configure(-command => [\&browse_path, $sw, @wg]);
  $name_b->configure(-command => [\&edit_name, $sw, @wg]);
  $rel_b->configure(-command => [\&toggle_rel, @wg]);

  # bindings
  $sw->bind('<Return>' => [ $ok_b, 'Invoke']);
  $sw->bind('<Escape>' => [ $q, 'Invoke']);

  ### END GUI SETUP ###

  my $val = $vars{'TEXDIR'};
  $val = native_slashify($val);
  $path_l->configure(-text => $val);

  # release subdirectory at the end?
  my $rel_pat = "[\\\\/]".$texlive_release."[\\\\/]?\$";

  # calculate initial values based on existing $val (copied from TEXDIR)
  my $initdir = File::Spec->rel2abs($val);
  my $rel = "";
  my $name = "";
  # check for release subdirectory at the end and remove from initdir
  if ($initdir =~ $rel_pat) {
    $initdir =~ s!$rel_pat!!;
    $rel = $texlive_release;
    $rel_l->configure(-text => $texlive_release);
  }
  # now assign remaining final path component to name_l
  if ($initdir =~ /[\\\/]([^\\\/]+)[\\\/]?$/) {
    $name_l->configure(-text => $1);
    $initdir =~ s/[\\\/][^\\\/]+[\\\/]?$//;
  }

  # backtrack remaining initdir to something that exists
  # and assign it to prefix
  while (! -d $initdir) {
    my $initprev = $initdir;
    $initdir =~ s/[\\\/][^\\\/]+[\\\/]?$//;
    last if ($initdir eq $initprev);
  }
  if ($initdir eq "" or (win32() and $initdir =~ /:$/)) {
    $initdir = $initdir . (win32() ? "\\" : "/");
  }
  $prefix_l->configure(-text => $initdir);
  # display complete path in $path_l
  update_full_path( @wg );
  $sw->deiconify();
  $sw->raise($mw);
  $sw->grab();
} # change_path

sub update_full_path {
  my $path_l = shift;
  my $prefix_l = shift;
  my $name_l = shift;
  my $rel_l = shift;
  my $ok_b = shift;
  my $warn_yr_l = shift;

  my $prefix = $prefix_l->cget(-text);
  if ($prefix eq "" or (win32() and $prefix =~ /:$/)) {
    $prefix_l->insert('end', $sep);
    $prefix .= $sep;
  }
  my $name = $name_l->cget(-text);
  if ($name =~ m![\\/]!) {
    $name =~ s![\\/]!!g;
    $name_l->delete(0, 'end');
    $name_l->insert(0, $name);
  }
  $path_l->configure(
    -text => File::Spec->catdir($prefix, $name, $rel_l->cget(-text)));
  if (-d $prefix) {
    $ok_b->configure(-state => 'normal');
  } else {
    $ok_b->configure(-state => 'disabled');
  }
  # check for release component
  if ($rel_l->cget(-text) ne '') {
    $warn_yr_l->configure(-text => '');
  } else {
    $warn_yr_l->configure(
      -text => __('Release year component highly recommended!'));
  }
  return;
} # update_full_path

sub toggle_rel {
  my $path_l = shift;
  my $prefix_l = shift;
  my $name_l = shift;
  my $rel_l = shift;
  my $ok_b = shift;
  my $warn_yr_l = shift;

  if ($rel_l->cget(-text) eq '') {
    $rel_l->configure(-text => $texlive_release);
  } else {
    $rel_l->configure(-text => '');
  }
  update_full_path($path_l, $prefix_l, $name_l, $rel_l, $ok_b, $warn_yr_l);
} # toggle_rel

sub edit_name {
  my $sw = shift; # parent window
  my $path_l = shift;
  my $prefix_l = shift;
  my $name_l = shift;
  my $rel_l = shift;
  my $ok_b = shift;
  my $warn_yr_l = shift;
  my $ednm;
  $ednm->destroy if Tk::Exists($ednm);
  $ednm = $sw->Toplevel(-title => __("Changing directory name"));
  $ednm->transient($sw);
  $ednm->withdraw();

  $ednm->Label(-text => __("Change name (slashes not allowed)"))
    ->pack(-padx => 5, -pady => 5);
  my $nm_e = $ednm->Entry(-width => 20)->pack(-pady => 5);
  $nm_e->insert(0, $name_l->cget(-text));
  my $fr = $ednm->Frame->pack(-fill => 'x', -expand => 1);
  my $ok = $ednm->Button(
    -text => __("OK"),
    -command => sub {
      my $nm = $nm_e->get;
      if ($nm !~ m![\\/]!) {
        $name_l->configure(-text => $nm);
        update_full_path(
          $path_l, $prefix_l, $name_l, $rel_l, $ok_b, $warn_yr_l);
        $ednm->destroy();
      } else {
        $ednm->messageBox(
          -icon => 'error',
          -type => 'Ok',
          -message => __("Illegal name"));
      }
    })->pack(-in => $fr, -side => 'right', -pady => 5, -padx => 5);
  my $cancel = $ednm->Button(
    -text => __("Cancel"),
    -command => sub { $ednm->destroy(); })
    ->pack(-in => $fr, -side => 'right');
  $ednm->deiconify();
  $ednm->raise($sw);
  $ednm->grab();
} # edit_name

sub browse_path {
  my $mw = shift;
  my $path_l = shift;
  my $prefix_l = shift;
  my $name_l = shift;
  my $rel_l = shift;
  my $ok_b = shift;
  my $warn_yr_l = shift;

  my $retval = $prefix_l->cget(-text);
  my $use_native = 0; # choice of directory browser
  if ($^O =~ /^MSWin/i) {
    $use_native = 1;
  } else {
    eval { require Tk::DirSelect; };
    if ($@) {
      eval { require installer::DirSelect; };
      if ($@) {
        $use_native = 1;
      }
    }
  }
  if ($use_native) {
    $retval = $mw->chooseDirectory(
      -initialdir => $retval,
      -parent => $mw,
      -title => __("Select prefix destination directory"),
    );
  } else {
    my $fsdia = $mw->DirSelect(
      -title => __("Select prefix destination directory"));
    $retval = $fsdia->Show($retval, -popover => $mw);
    $fsdia->destroy;
  }
  if (defined $retval and $retval ne "") {
    $prefix_l->configure(-text => File::Spec->rel2abs($retval));
    update_full_path($path_l, $prefix_l, $name_l, $rel_l, $ok_b, $warn_yr_l);
  }
  return;
} # browse_path
