#===============================================================================
# Tk/DirSelect.pm
# Copyright (C) 2000-2001 Kristi Thompson <kristi@kristi.ca>
# Copyright (C) 2002-2005,2010 Michael Carman <mjcarman@mchsi.com>
# Last Modified: 2/16/2010
#===============================================================================
BEGIN { require 5.004 }

package Tk::DirSelect;
use Cwd;
use File::Spec;
use Tk 800;
require Tk::Frame;
require Tk::BrowseEntry;
require Tk::Button;
require Tk::Label;
require Tk::DirTree;

use strict;
use base 'Tk::Toplevel';
Construct Tk::Widget 'DirSelect';

use vars qw'$VERSION';
$VERSION = '1.12';

my %colors;
my $isWin32;

#-------------------------------------------------------------------------------
# Subroutine : ClassInit()
# Purpose    : Class initialzation.
# Notes      : 
#-------------------------------------------------------------------------------
sub ClassInit {
	my ($class, $mw) = @_;
	$class->SUPER::ClassInit($mw);

	$isWin32 = $^O eq 'MSWin32';

	# Get system colors from a Text widget for use in DirTree
	my $t = $mw->Text();
	foreach my $x (qw'-background -selectbackground -selectforeground') {
		$colors{$x} = $t->cget($x);
	}
	$t->destroy();
}


#-------------------------------------------------------------------------------
# Subroutine : Populate()
# Purpose    : Create the DirSelect widget
# Notes      : 
#-------------------------------------------------------------------------------
sub Populate {
	my ($w, $args) = @_;
	my $directory  = delete $args->{-dir}   || cwd();
	my $title      = delete $args->{-title} || 'Select Directory';

    $w->withdraw;
	$w->SUPER::Populate($args);
	$w->ConfigSpecs(-title => ['METHOD', 'title', 'Title', $title]);
	$w->bind('<Escape>', sub { $w->{dir} = undef });

	my %f = (
		drive  => $w->Frame->pack(-anchor => 'n', -fill => 'x'),
		button => $w->Frame->pack(-side => 'bottom', -anchor => 's', -fill => 'x', -ipady  => 6),
		tree   => $w->Frame->pack(-fill => 'both', -expand => 1),
	);

	$w->{tree} = $f{tree}->Scrolled('DirTree',
		-scrollbars       => 'osoe',
		-selectmode       => 'single',
		-ignoreinvoke     => 0,
		-width            => 50,
		-height           => 15,
		%colors,
		%$args,
	)->pack(-fill => 'both', -expand => 1);

	$w->{tree}->configure(-command   => sub { $w->{tree}->opencmd($_[0]) });
	$w->{tree}->configure(-browsecmd => sub { $w->{tree}->anchorClear });

	$f{button}->Button(
		-width   => 7,
		-text    => 'OK',
		-command => sub { $w->{dir} = $w->{tree}->selectionGet() },
	)->pack(-side => 'left', -expand => 1);

	$f{button}->Button(
		-width   => 7,
		-text    => 'Cancel',
		-command => sub { $w->{dir} = undef },
	)->pack(-side => 'left', -expand => 1);

	if ($isWin32) {
		$f{drive}->Label(-text => 'Drive:')->pack(-side => 'left');
		$w->{drive} = $f{drive}->BrowseEntry(
			-variable  => \$w->{selected_drive},
			-browsecmd => [\&_browse, $w->{tree}],
			-state     => 'readonly',
		)->pack(-side => 'left', -fill => 'x', -expand => 1);

		if ($Tk::VERSION >= 804) {
			# widget is readonly, but shouldn't appear disabled
			for my $e ($w->{drive}->Subwidget('entry')->Subwidget('entry')) {
				$e->configure(-disabledforeground => $colors{-foreground});
				$e->configure(-disabledbackground => $colors{-background});
			}
		}
	}
	else {
		$f{drive}->destroy;
	}

	# right-click context menu
	my $menu = $w->Menu(
		-tearoff   => 0,
		-menuitems => [
			[qw/command ~New/,    -command => [\&_mkdir , $w]],
			[qw/command ~Rename/, -command => [\&_rename, $w]],
			[qw/command ~Delete/, -command => [\&_rmdir,  $w]],
		],
	);
	$menu->bind('<FocusOut>' => sub {$menu->unpost});
	$w->{tree}->bind('<Button-3>' => [\&_context, $menu, Ev('X'), Ev('Y')]);

	# popup overlay for renaming directories
	$w->{renameval} = undef;
	$w->{popup}     = $w->Toplevel();
	$w->{rename}    = $w->{popup}->Entry(
		-relief       => 'groove',
		-borderwidth  => 1,
	)->pack(-fill => 'x', -expand => 1);
	$w->{popup}->overrideredirect(1);
	$w->{popup}->withdraw;
	$w->{rename}->bind('<Escape>',          sub {$w->{renameval} = undef});
	$w->{rename}->bind('<FocusOut>',        sub {$w->{renameval} = undef});
	$w->{rename}->bind('<KeyPress-Return>', sub {$w->{renameval} = $w->{rename}->get});

	return $w;
}


#-------------------------------------------------------------------------------
# Subroutine : Show()
# Purpose    : Display the DirSelect widget.
# Notes      : 
#-------------------------------------------------------------------------------
sub Show {
	my $w     = shift;
	my $dir   = shift;
	my $cwd   = cwd();
	my $focus = $w->focusSave;
	my $grab  = $w->grabSave;

	$dir = $cwd unless defined $dir && -d $dir;
	chdir($dir);

	if ($isWin32) {
		# populate the drive list
		my @drives = _get_volume_info();
		$w->{drive}->delete(0, 'end');
		my $startdrive = _drive($dir);

		foreach my $d (@drives) {
			$w->{drive}->insert('end', $d);
			if ($startdrive eq _drive($d)) {
				$w->{selected_drive} = $d;
			}
		}
	}

	# show initial directory
	_showdir($w->{tree}, $dir);

	$w->Popup(@_);                # show widget
	$w->focus;                    # seize focus
	$w->grab;                     # seize grab
	$w->waitVariable(\$w->{dir}); # wait for user selection (or cancel)
	$w->grabRelease;              # release grab
	$w->withdraw;                 # run and hide
	$focus->();                   # restore prior focus
	$grab->();                    # restore prior grab
	chdir($cwd)                   # restore working directory
		or warn "Could not chdir() back to '$cwd' [$!]\n";

	# HList SelectionGet() behavior changed around Tk 804.025
	if (ref $w->{dir} eq 'ARRAY') {
		$w->{dir} = $w->{dir}[0];
	}

	{
		local $^W;
		$w->{dir} .= '/' if ($isWin32 && $w->{dir} =~ /:$/);
	}

	return $w->{dir};
}


#-------------------------------------------------------------------------------
# Subroutine : _browse()
# Purpose    : Browse to a mounted filesystem (Win32)
# Notes      : 
#-------------------------------------------------------------------------------
sub _browse {
	my ($w, undef, $d) = @_;
	$d = _drive($d) . '/';
	chdir($d);
	_showdir($w, $d);

	# Workaround: Under Win* versions of Perl/Tk, scrollbars have a tendancy
	# to show up but be disabled.
	$w->yview(scroll => 1, 'units');
	$w->update;
	$w->yview(scroll => -1, 'units');
}


#-------------------------------------------------------------------------------
# Subroutine : _showdir()
# Purpose    : Show the requested directory
# Notes      : 
#-------------------------------------------------------------------------------
sub _showdir {
	my $w   = shift;
	my $dir = shift;
	$w->delete('all');
	$w->chdir($dir);
}


#-------------------------------------------------------------------------------
# Subroutine : _get_volume_info()
# Purpose    : Get volume information (Win32)
# Notes      : 
#-------------------------------------------------------------------------------
sub _get_volume_info {
	require Win32API::File;

	my @drivetype = (
		'Unknown',
		'No root directory',
		'Removable disk drive',
		'Fixed disk drive',
		'Network drive',
		'CD-ROM drive',
		'RAM Disk',
	);

	my @drives;
	foreach my $ld (Win32API::File::getLogicalDrives()) {
		my $drive = _drive($ld);
		my $type  = $drivetype[Win32API::File::GetDriveType($drive)];
		my $label;

		Win32API::File::GetVolumeInformation(
			$drive, $label, [], [], [], [], [], []);

		push @drives, "$drive  [$label] $type";
	}

	return @drives;
}


#-------------------------------------------------------------------------------
# Subroutine : _drive()
# Purpose    : Get the drive letter (Win32)
# Notes      : 
#-------------------------------------------------------------------------------
sub _drive {
	shift =~ /^(\w:)/;
	return uc $1;
}


#-------------------------------------------------------------------------------
# Method  : _context
# Purpose : Display the context menu
# Notes   : 
#-------------------------------------------------------------------------------
sub _context {
	my ($w, $m, $x, $y) = @_;
	my $wy = $y - $w->rooty;
	$w->selectionClear();
	$w->selectionSet($w->nearest($wy));
	$m->post($x, $y);
	$m->focus;
}


#-------------------------------------------------------------------------------
# Method  : _mkdir
# Purpose : Create a new directory under the current selection
# Notes   : 
#-------------------------------------------------------------------------------
sub _mkdir  {
	my $w     = shift;
	my $dt    = $w->{tree};
	my ($sel) = $dt->selectionGet();

	my $cwd  = Cwd::cwd();
	if (chdir($sel)) {
		my $base = 'NewDirectory';
		my $name = $base;
		my $i    = 1;

		while (-d $name && $i < 1000) {
			$name = $base . $i++;
		}

		unless (-d $name) {
			if (mkdir($name)) {
				_showdir($dt, $sel);
				$dt->selectionClear();
				$dt->selectionSet($sel . '/' . $name);
				$w->_rename();
			}
			else {
				$w->messageBox(
					-title   => 'Unable to create directory',
					-message => "The directory '$name' could not be created.\n$!",
					-icon    => 'error',
					-type    => 'OK',
				);
			}
		}

		chdir($cwd);
	}
	else {
		warn "Unable to chdir() for mkdir() [$!]\n";
	}
}


#-------------------------------------------------------------------------------
# Method  : _rmdir
# Purpose : Delete the selected directory
# Notes   : 
#-------------------------------------------------------------------------------
sub _rmdir {
	my $w     = shift;
	my $dt    = $w->{tree};
	my ($sel) = $dt->selectionGet();

	my @path = File::Spec->splitdir($sel);
	my $dir  = pop @path;
	my $pdir = File::Spec->catdir(@path);

	my $cwd  = Cwd::cwd();
	if (chdir($pdir)) {
		if (rmdir($dir)) {
			_showdir($dt, $pdir);
		}
		else {
			$w->messageBox(
				-title   => 'Unable to delete directory',
				-message => "The directory '$dir' could not be deleted.\n$!",
				-icon    => 'error',
				-type    => 'OK',
			);
		}
		chdir($cwd);
	}
	else {
		warn "Unable to chdir() for rmdir() [$!]\n";
	}
}

#-------------------------------------------------------------------------------
# Method  : _rename
# Purpose : Rename the selected directory
# Notes   : 
#-------------------------------------------------------------------------------
sub _rename {
	my $w       = shift;
	my $dt      = $w->{tree};
	my $popup   = $w->{popup};
	my $entry   = $w->{rename};
	my ($sel)   = $dt->selectionGet();
	my ($x, $y, $x1, $y1) = $dt->infoBbox($sel);

	my @path = File::Spec->splitdir($sel);
	my $dir  = pop @path;
	my $pdir = File::Spec->catdir(@path);

	$entry->delete(0, 'end');
	$entry->insert(0, $dir);
	$entry->selectionRange(0, 'end');
	$entry->focus;

	my $font  = ($entry->configure(-font))[4];
	my $text  = 'ABCDEFGHIGKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789 ';
	my $width = $entry->fontMeasure($font, $text) / length($text);
	$entry->configure(-width => ($x1 - $x) / $width);

	$popup->Post($dt->rootx + $x, $dt->rooty + $y);
	$popup->waitVariable(\$w->{renameval});
	$popup->withdraw;

	if (defined $w->{renameval} && $w->{renameval} ne $dir) {
		my $cwd  = Cwd::cwd();

		if (chdir($pdir)) {
			unless (rename($dir, $w->{renameval})) {
				$w->messageBox(
					-title   => 'Unable to rename directory',
					-message => "The directory '$dir' could not be renamed.\n$!",
					-icon    => 'error',
					-type    => 'OK',
				);
			}
			chdir($cwd);
			_showdir($dt, $pdir); # rebrowse to update the display
		}
		else {
			warn "Unable to chdir() for rename() [$!]\n";
		}
	}
}


1;

__END__
=pod

=head1 NAME

Tk::DirSelect - Cross-platform directory selection widget.

=head1 SYNOPSIS

  use Tk::DirSelect;
  my $ds  = $mw->DirSelect();
  my $dir = $ds->Show();

=head1 DESCRIPTION

This module provides a cross-platform directory selection widget. For 
systems running Microsoft Windows, this includes selection of local and 
mapped network drives. A context menu (right-click or E<lt>Button3E<gt>) 
allows the creation, renaming, and deletion of directories while 
browsing.

Note: Perl/Tk 804 added the C<chooseDirectory> method which uses native 
system dialogs where available. (i.e. Windows) If you want a native feel 
for your program, you probably want to use that method instead --
possibly using this module as a fallback for systems with older versions 
of Tk installed.

=head1 METHODS

=head2 C<DirSelect([-title =E<gt> 'title'], [options])>

Constructs a new DirSelect widget as a child of the invoking object 
(usually a MainWindow). 

The title for the widget can be set by specifying C<-title =E<gt> 
'Title'>. Any other options provided will be passed through to the 
DirTree widget that displays directories, so be sure they're appropriate 
(e.g. C<-width>)

=head2 C<Show([directory], [options])>

Displays the DirSelect widget and returns the user selected directory or 
C<undef> if the operation is canceled.

All arguments are optional. The first argument (if defined) is the 
initial directory to display. The default is to display the current 
working directory. Any additional options are passed through to the 
Popup() method. This means that you can do something like

  $ds->Show(undef, -popover => $mw);

to center the dialog over your application.

=head1 DEPENDENCIES

=over 4

=item * Perl 5.004

=item * Tk 800

=item * Win32API::File (under Microsoft Windows only)

=back

=head1 LICENSE AND COPYRIGHT

Copyright 2000-2001 Kristi Thompson <kristi@kristi.ca>
Copyright 2002-2005,2010 Michael Carman <mjcarman@cpan.org>

This program is free software; you can redistribute it and/or modify it
under the terms of either: the GNU General Public License as published
by the Free Software Foundation; or the Artistic License.

See http://dev.perl.org/licenses/ for more information.

=cut
