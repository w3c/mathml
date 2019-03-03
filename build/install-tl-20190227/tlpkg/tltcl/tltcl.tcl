#!/usr/bin/env wish

# Copyright 2018 Siep Kroonenberg

# This file is licensed under the GNU General Public License version 2
# or any later version.

# common declarations for tlshell.tcl and install-tl-gui.tcl

set ::plain_unix 0
if {$::tcl_platform(platform) eq "unix" && $::tcl_platform(os) ne "Darwin"} {
  set ::plain_unix 1
}

# process ID of the perl program that will run in the background
set ::perlpid 0

set any_mirror "http://mirror.ctan.org/systems/texlive/tlnet"

proc get_stacktrace {} {
  set level [info level]
  set s ""
  for {set i 1} {$i < $level} {incr i} {
    append s [format "Level %u: %s\n" $i [info level $i]]
  }
  return $s
} ; # get_stacktrace

proc err_exit {{mess ""}} {
  if {$mess eq ""} {set mess "Error"}
  append mess "\n" [get_stacktrace]
  if $::plain_unix {
    # plain_unix: avoid a RenderBadPicture error on quitting.
    # 'send' changes the shutdown sequence,
    # which avoids triggering the bug.
    # 'tk appname <something>' restores 'send' and avoids the bug
    bind . <Destroy> {
      catch {tk appname appname}
    }
  }
  tk_messageBox -icon error -message $mess
  # kill perl process, just in case
  if $::perlpid {
    catch {
      if {$::tcl_platform(platform) eq "unix"} {
        exec -ignorestderr "kill" $::perlpid
      } else {
        exec -ignorestderr "taskkill" "/pid" $::perlpid
      }
    }
  }
  exit
} ; # err_exit

# localization support

# for the sake of our translators we use our own translation function
# which can use .po files directly. This allows them to check their work
# without creating or waiting for a conversion to .msg.
# We still use the msgcat module for detecting default locale.
# Otherwise, the localization code borrows much from Norbert Preining's
# translation module for TL.

proc load_translations {} {

  # check the command-line for a lang parameter
  set ::lang ""
  set i 0
  while {$i < $::argc} {
    set p [lindex $::argv $i]
    incr i
    if {$p eq "-lang" || $p eq "--lang"} {
      if {$i < $::argc} {
        set ::lang [lindex $::argv $i]
        break
      }
    } elseif {[string range $p 0 5] eq "-lang="} {
      set ::lang [string range $p 6 end]
      break
    } elseif {[string range $p 0 6] eq "--lang="} {
      set ::lang [string range $p 7 end]
      break
    }
  }
  unset i

  # First fallback: check config file.
  # $TEXMFCONFIG/tlmgr/config can have a setting for gui-lang.
  # There will not be one for the installer, only for tlmgr.
  if {! [info exists ::lang] || $::lang eq ""} {
    foreach tmf {"TEXMFCONFIG" "TEXMFSYSCONFIG"} {
      if [catch {exec kpsewhich -var-value $tmf} d] {
        break; # apparently there is not yet a TL installation
      }
      if [catch {open [file join $d "tlmgr" "config"] r} fid] continue
      while 1 {
        if [chan eof $fid] {
          break
        }
        if [catch {chan gets $fid} l] break
        if {[regexp {^\s*gui-lang\s*=\s*(\S+)$} $l m ::lang]} {
          break
        }
      }
      chan close $fid
      if {[info exists ::lang] && $::lang ne ""} break
    }
  }

  # second fallback: what does msgcat think about it? Note that
  # msgcat checks the environment and on windows also the registry.
  if {! [info exists ::lang] || $::lang eq ""} {
    package require msgcat
    set ::lang [::msgcat::mclocale]
  }

  set messcat ""
  if {$::lang ne ""} {
    set messcat ""
    set maybe ""
    set ::lang [string tolower $::lang]
    set tdir [file join $::instroot "tlpkg" "translations"]
    foreach f [glob -directory $tdir *.po] {
      set ln_f [string tolower [string range [file tail $f] 0 end-3]]
      if {$ln_f eq $::lang} {
        set messcat $f
        break
      } elseif {[string range $ln_f 0 1] eq [string range $::lang 0 1]} {
        set maybe $f
      }
    }
    if {$messcat eq ""} {
      set messcat $maybe
    }
  }

  # parse messcat.
  # for now, just skip lines which make no sense.
  # empty messcat: no suitable message catalog
  if {$messcat ne ""} {
    # create array with msgid keys and msgstr values
    if {! [catch {open $messcat r} fid]} {
      fconfigure $fid -encoding utf-8
      set inmsgid 0
      set inmsgstr 0
      set msgid ""
      set msgstr ""
      while 1 {
        if [chan eof $fid] break
        if [catch {chan gets $fid} l] break
        if [regexp {^\s*#} $l] continue
        if [regexp {^\s*$} $l] {
          # empty line separates msgid/msgstr pairs
          if $inmsgid {
            # msgstr lines missing
            # puts stderr "no translation for $msgid in $messcat"
            set msgid ""
            set msgstr ""
            set inmsgid 0
            set inmsgstr 0
            continue
          }
          if $inmsgstr {
            # empty line signals end of msgstr
            if {$msgstr ne ""} {
              set msgid [string map {"\\n" "\n"} $msgid]
              set msgstr [string map {"\\n" "\n"} $msgstr]
              set msgid [string map {"\\\\" "\\"} $msgid]
              set msgstr [string map {"\\\\" "\\"} $msgstr]
              set ::TRANS($msgid) $msgstr
            }
            set msgid ""
            set msgstr ""
            set inmsgid 0
            set inmsgstr 0
            continue
          }
          continue
        } ; # empty line
        if [regexp {^msgid\s+"(.*)"\s*$} $l m msgid] {
          # note. a failed match will leave msgid alone
          set inmsgid 1
          continue
        }
        if [regexp {^"(.*)"\s*$} $l m s] {
          if $inmsgid {
            append msgid $s
          } elseif $inmsgstr {
            append msgstr $s
          }
          continue
        }
        if [regexp {^msgstr\s+"(.*)"\s*$} $l m msgstr] {
          set inmsgstr 1
          set inmsgid 0
        }
      }
      chan close $fid
    }
  }
}
load_translations

proc __ {s args} {
  if {[info exists ::TRANS($s)]} {
    set s $::TRANS($s)
  #} else {
  #  puts stderr "No translation found for $s\n[get_stacktrace]"
  }
  if {$args eq ""} {
    return $s
  } else {
    return [format $s {*}$args]
  }
}

# string representation of booleans
proc yes_no {b} {
  if $b {
    set ans [__ "Yes"]
  } else {
    set ans [__ "No"]
  }
  return $ans
}

# avoid warnings from tar and perl about locale
set ::env(LC_ALL) "C"
unset -nocomplain ::env(LANG)
unset -nocomplain ::env(LANGUAGE)

### fonts ###

# no bold text for messages; `userDefault' indicates priority
option add *Dialog.msg.font TkDefaultFont userDefault

# normal size bold
font create bfont {*}[font configure TkDefaultFont]
font configure bfont -weight bold
# larger, not bold: lfont
font create lfont {*}[font configure TkDefaultFont]
font configure lfont -size [expr {round(1.2 * [font actual lfont -size])}]
# larger and bold
font create hfont {*}[font configure lfont]
font configure hfont -weight bold
# extra large and bold
font create titlefont {*}[font configure TkDefaultFont]
font configure titlefont -weight bold \
    -size [expr {round(1.5 * [font actual titlefont -size])}]

## italicized items; not used
#font create it_font {*}[font configure TkDefaultFont]
#font configure it_font -slant italic

# width of '0', as a very rough estimate of average character width
# assume height == width*2
set ::cw \
  [expr {max([font measure TkDefaultFont "0"],[font measure TkTextFont "0"])}]

# icon
catch {
  image create photo tl_logo -file \
      [file join $::instroot "tlpkg" "tltcl" "tlmgr.gif"]
  wm iconphoto . -default tl_logo
}

# default foreground color and disabled foreground color
# may not be black in e.g. dark color schemes
set blk [ttk::style lookup TButton -foreground]
set gry [ttk::style lookup TButton -foreground disabled]

# 'default' padding

proc ppack {wdg args} { ; # pack command with padding
  pack $wdg {*}$args -padx 3 -pady 3
}

proc pgrid {wdg args} { ; # grid command with padding
  grid $wdg {*}$args -padx 3 -pady 3
}

# unicode symbols as fake checkboxes in ttk::treeview widgets

proc mark_sym {mrk} {
  if {$::tcl_platform(platform) eq "windows"} {
    # under windows, these look slightly better than
    # the non-windows selections
    if $mrk {
      return "\u25C9" ; # 'fisheye'
    } else {
      return "\u25CB" ; # 'white circle'
    }
  } else {
    if $mrk {
      return "\u25A3" ; # 'white square containing black small square'
    } else {
      return "\u25A1" ; # 'white square'
    }
  }
} ; # mark_sym

# for help output
set ::env(NOPERLDOC) 1

##### dialog support #####

# for example code, look at dialog.tcl, part of Tk itself

# global variable for dialog return value, in case the outcome
# must be handled by the caller rather than by the dialog itself:
set ::dialog_ans {}

# start new toplevel with settings appropriate for a dialog
proc create_dlg {wnd {p .}} {
  unset -nocomplain ::dialog_ans
  catch {destroy $wnd} ; # no error if it does not exist
  toplevel $wnd -class Dialog
  wm withdraw $wnd
  if [winfo viewable $p] {wm transient $wnd $p}
  if $::plain_unix {wm attributes $wnd -type dialog}
  wm protocol $wnd WM_DELETE_WINDOW {destroy $wnd}
}

# Place a dialog centered wrt its parent.
# If its geometry is somehow not yet available,
# its upperleft corner will be centered.

proc place_dlg {wnd {p "."}} {
  update idletasks
  set g [wm geometry $p]
  scan $g "%dx%d+%d+%d" pw ph px py
  set hcenter [expr {$px + $pw / 2}]
  set vcenter [expr {$py + $ph / 2}]
  set g [wm geometry $wnd]
  set wh [winfo reqheight $wnd]
  set ww [winfo reqwidth $wnd]
  set wx [expr {$hcenter - $ww / 2}]
  if {$wx < 0} { set wx 0}
  set wy [expr {$vcenter - $wh / 2}]
  if {$wy < 0} { set wy 0}
  wm geometry $wnd [format "+%d+%d" $wx $wy]
  update idletasks
  wm attributes $wnd -topmost
  wm state $wnd normal
  raise $wnd $p
  tkwait visibility $wnd
  focus $wnd
  grab set $wnd
} ; # place_dlg

proc end_dlg {ans wnd} {
  foreach c [winfo children $wnd] {
    # alternative to catch: check type with [winfo class $wnd]
    catch {$c state disabled}
  }
  set ::dialog_ans $ans
  set p [winfo parent $wnd]
  if {$p eq ""} {set p "."}
  raise $p
  destroy $wnd
} ; # end_dlg

##### directories #####

# slash flipping
proc forward_slashify {s} {
  regsub -all {\\} $s {/} r
  return $r
}
proc native_slashify {s} {
  if {$::tcl_platform(platform) eq "windows"} {
    regsub -all {/} $s {\\} r
  } else {
    regsub -all {\\} $s {/} r
  }
  return $r
}

# unix: choose_dir replacing native directory browser

if {$::tcl_platform(platform) eq "unix"} {

  # Based on the tcl/tk widget demo.
  # Also for MacOS, because we want to see /usr.
  # For windows, the native browser widget is better.

  ## Code to populate a single directory node
  proc populateTree {tree node} {
    if {[$tree set $node type] ne "directory"} {
      set type [$tree set $node type]
      return
    }
    $tree delete [$tree children $node]
    foreach f [lsort [glob -nocomplain -directory $node *]] {
      set type [file type $f]
      if {$type eq "directory"} {
        $tree insert $node end \
            -id $f -text [file tail $f] -values [list $type]
        # Need at least one child to make this node openable,
        # will be deleted when actually populating this node
        $tree insert $f 0 -text "dummy"
      }
    }
    # Stop this code from rerunning on the current node
    $tree set $node type processedDirectory
  }

  proc choose_dir {initdir {parent .}} {

    create_dlg .browser $parent
    wm title .browser [__ "Browse..."]

    # wallpaper
    pack [ttk::frame .browser.bg -padding 3] -fill both -expand 1

    # ok and cancel buttons
    pack [ttk::frame .browser.fr1] \
        -in .browser.bg -side bottom -fill x
    ppack [ttk::button .browser.ok -text [__ "Ok"]] \
        -in .browser.fr1 -side right
    ppack [ttk::button .browser.cancel -text [__ "Cancel"]] \
        -in .browser.fr1 -side right
    bind .browser <Escape> {.browser.cancel invoke}
    .browser.ok configure -command {
      set ::dialog_ans [.browser.tree focus]
      destroy .browser
    }
    .browser.cancel configure -command {
      set ::dialog_ans ""
      destroy .browser
    }

    ## Create the tree and set it up
    pack [ttk::frame .browser.fr0] -in .browser.bg -fill both -expand 1
    set tree [ttk::treeview .browser.tree \
                  -columns {type} -displaycolumns {} -selectmode browse \
                  -yscroll ".browser.vsb set"]
    .browser.tree column 0 -stretch 1
    ttk::scrollbar .browser.vsb -orient vertical -command "$tree yview"
    # hor. scrolling does not work, but toplevel and widget are resizable
    $tree heading \#0 -text "/"
    $tree insert {} end -id "/" -text "/" -values [list "directory"]

    populateTree $tree "/"
    bind $tree <<TreeviewOpen>> {
      populateTree %W [%W focus]
    }
    bind $tree <ButtonRelease-1> {
      .browser.tree heading \#0 -text [%W focus]
    }

    ## Arrange the tree and its scrollbar in the toplevel
    # Horizontal scrolling does not work, but resizing does.
    grid $tree -in .browser.fr0 -row 0 -column 0 -sticky nsew
    grid .browser.vsb -in .browser.fr0 -row 0 -column 1 -sticky ns
    grid columnconfigure .browser.fr0 0 -weight 1
    grid rowconfigure .browser.fr0 0 -weight 1
    unset -nocomplain ::dialog_ans

    # navigate tree to $initdir
    set chosenDir {}
    foreach d [file split [file normalize $initdir]] {
      set nextdir [file join $chosenDir $d]
      if [file isdirectory $nextdir] {
        if {! [$tree exists $nextdir]} {
          $tree insert $chosenDir end -id $nextdir \
              -text $d -values [list "directory"]
        }
        populateTree $tree $nextdir
        set chosenDir $nextdir
      } else {
        break
      }
    }
    $tree see $chosenDir
    $tree selection set [list $chosenDir]
    $tree focus $chosenDir
    $tree heading \#0 -text $chosenDir

    place_dlg .browser $parent
    tkwait window .browser
    return $::dialog_ans
  }; # choose_dir

}; # if unix

proc browse4dir {inidir {parent .}} {
  if {$::tcl_platform(platform) eq "unix"} {
    return [choose_dir $inidir $parent]
  } else {
    return [tk_chooseDirectory \
        -initialdir $inidir -title [__ "Select or type"] -parent $parent]
  }
} ; # browse4dir

# browse for a directory and store in entry- or label widget $w
proc dirbrowser2widget {w} {
  set wclass [winfo class $w]
  if {$wclass eq "Entry" || $wclass eq "TEntry"} {
    set is_entry 1
  } elseif {$wclass eq "Label" || $wclass eq "TLabel"} {
    set is_entry 0
  } else {
    err_exit "browse2widget invoked with unsupported widget class $wclass"
  }
  if $is_entry {
    set retval [$w get]
  } else {
    set retval [$w cget -text]
  }
  set retval [browse4dir $retval [winfo parent $w]]
  if {$retval eq ""} {
    return 0
  } else {
    if {$wclass eq "Entry" || $wclass eq "TEntry"} {
      $w delete 0 end
      $w insert 0 $retval
    } else {
      $w configure -text $retval
    }
    return 1
  }
}
