#!/usr/bin/env perl
# install-menu-extl.pl

# tell the frontend about all configurable options and terminate
# this output with an agreed-upon termination string.  the frontend
# will read the package database itself. From this, it can deduce
# collections, schemes and platforms, but not the names of
# platforms.

# needed info:

# binaries + descriptions
# schemes
# collections, probably per scheme
# maybe directories to be configured

# current options:

# paper size a4 | letter
# allow restricted toggle
# generate formats
# install docs
# install sources
# create symlinks | 2 aspects of desktop integration
# switch to online CTAN

# then read the selected options back from the frontend

# when run_menu_extl reads 'startinst' from the frontend,
# run_menu_extl returns to install-tl.
# by then, the frontend has switched to non-blocking i/o
# and will capture the output of the actual installation
# on the fly inside a log window

our %vars; # only contains simple scalars

# from install-tl:
# The global variable %vars is an associative list which contains all
# variables and their values which can be changed by the user.
# needs to be our since TeXLive::TLUtils uses it

our $opt_in_place;
our $tlpdb;
our @media_available;
our $media;
our $previoustlpdb;
our @collections_std;
our $texlive_release;

our $MENU_INSTALL = 0;
our $MENU_ABORT   = 1; # no cleanup afterwards
our $MENU_QUIT    = 2;

my $RETURN = $MENU_INSTALL;

# @fileassocdesc also defined in install-tl
$::fileassocdesc[0] = "None";
$::fileassocdesc[1] = "Only new";
$::fileassocdesc[2] = "All";

$::deskintdesc[0] = "None";
$::deskintdesc[1] = "Menu shortcuts";
$::deskintdesc[2] = "Launcher";

# %vars hash should eventually include each binary, collection and scheme
# as individual schalars.

do_remote_init();
# the above sub adds all platforms and collections to %vars
# but maybe not schemes so we add these now:

foreach my $pkg ($tlpdb->schemes) {
  $vars{$pkg}=($vars{'selected_scheme'} eq $pkg)? 1:0;
}
$vars{'scheme-custom'} = 0 unless defined $vars{'scheme-custom'};

# reading back current %vars from the frontend
sub read_vars {
  my $l = <STDIN>;
  chomp $l;
  if ($l ne 'vars') {
    return 0;
  }
  while (1) {
    $l = <STDIN>;
    chomp $l;
    if ($l =~ /^([^:]+): (.*)$/) {
      $vars{$1} = $2;
    } elsif ($l eq 'endvars') {
      return 1;
    } else {
      return 0;
    }
  }
  return 0;
}

# for each scheme and collection, print name, category and short description
sub print_descs {
  print "descs\n";
  foreach my $p ($tlpdb->schemes) {
    my $pkg = $tlpdb->get_package($p);
    print $pkg->name, ': ', $pkg->category, ' ', $pkg->shortdesc || "", "\n";
  }
  foreach my $p ($tlpdb->collections) {
    my $pkg = $tlpdb->get_package($p);
    print $pkg->name, ': ', $pkg->category, ' ', $pkg->shortdesc || "", "\n";
  }
  print "enddescs\n";
}

sub print_vars {
  print "vars\n";
  foreach my $key (sort keys %vars) {
    print $key, ': ', $vars{$key}, "\n";
  }
  print "endvars\n";
}

# run_menu_extl should be invoked by install-tl

sub run_menu_extl {
  # make sure we have a value for total_size:
  calc_depends();
  print "menudata\n";
  print "year: $texlive_release\n";
  # for windows, add a key indicating elevated permissions
  if (win32()) {
    print "admin: ". TeXLive::TLWinGoo::admin() . "\n";
  }
  print_descs();

  print_vars();

  # tell the frontend the preferred order for schemes
  my @schemes = schemes_ordered_for_presentation();
  push @schemes, "scheme-custom";
  print "schemes_order: ", join(' ', @schemes), "\n";

  # binaries
  print "binaries\n";
  # binaries aren't packages; list their descriptions here
  my @binaries = $tlpdb->available_architectures;
  @binaries=sort TeXLive::TLUtils::sort_archs @binaries;
  foreach my $b (@binaries) {
    print $b, ': ', platform_desc($b), "\n";
  }
  print "endbinaries\n";

  print "endmenudata\n"; # this triggers the frontend menu

  # read input from frontend / install-tl-gui.tcl.
  # Four cases to consider:
  # 'calc': the frontend wants to update its ::vars array
  #   after some menu choices
  # 'checkdir': check whether $vars{TEXDIR} is creatable
  # 'startinst': done with choices, tell install-tl to
  #   start installation
  # 'quit': tell install-tl to clean up and quit

  # read from frontend
  while (1) {
    my $l = <STDIN>;
    chomp($l);
    if ($l eq 'quit') {
      return $MENU_QUIT;
    } elsif ($l eq 'calc') {
      if (read_vars()) {
        if ($vars{'selected_scheme'} eq 'scheme-custom') {
          calc_depends();
        } else {
          select_scheme($vars{'selected_scheme'});
        }
        $vars{'n_collections_selected'} = 0;
        foreach my $v (keys %vars) {
          if (substr($v, 0, 11) eq 'collection-' && $vars{$v}) {
            $vars{'n_collections_selected'} += 1;
          }
        }
        print_vars();
      } else {
        log("Illegal input '$l' from frontend");
        return $MENU_ABORT;
      }
    } elsif ($l eq 'checkdir') {
      my $td = <STDIN>;
      chomp $td;
      if (TeXLive::TLUtils::texdir_check($td)) {
        print "1\n";
      } else {
        print "0\n";
      }
    } elsif ($l eq 'startinst') {
      if (read_vars()) {
        calc_depends();
        return $MENU_INSTALL;
      } else {
        return $MENU_ABORT;
      }
    } else {
      return $MENU_ABORT;
    }
  }
} # run_menu_extl

$::run_menu = \&run_menu_extl;

1;
