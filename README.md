# MUD

I wrote this MUD around 1997 as a present for my brother.  Today's Pascal compilers on Windows 7
don't behave the same as the Turbo Pascal compiler I used on DOS or Win95, so the code doesn't
completely work yet.  Two problems:

1. ITEMS.DAT was corrupted at some point -- if I can get the rest of the code working, I could
rebuild this manually from the strings still legible in the corrupted file

2. The compiler doesn't allow me to open a file that's already open.  IOResult is 5, Access Denied.
The old code reopens the file willy nilly to find items.  I could hack it by making a bunch of copies
of the files, but that wouldn't easily allow rewriting of the rooms.dat file which
I *think* the code does when you pick up items?  Or I could rewrite the funcs that reopen a file
to instead take the open file as a param, save our current position, do the work, and restore the
current position.

# To run

Using the Free Pascal IDE, game.pas runs the game, editor.pas will list and edit rooms and items.
I don't know yet how to run the compiled .exe from the command line -- the code only seems to work
inside the IDE.

# Notes

## Data file format and corruption

ROOM.DAT looks corrupted but isn't.  Each string has its length embedded as the
first byte (Pascal vs C string representation).  In a record format written to
disk, it looks like there is garbage padding the end of the string.  It may be
from how my code worked, reusing the same record over and over and editing it
instead of clearing it out every time when writing each new room.

This gives me hope that ITEM.DAT may not be as corrupted as I thought.  It may be one byte off somewhere.  Not sure if it would be easier to find that byte, or to just reenter all the data in a new file.

## Running FP

Seems to work best to run fp.exe from cmd.exe (not from Cygwin or a Desktop shortcut) starting in the directory with game.pas in it, then to set Options -> Directories -> Units to 

    c:\program files\fpc\3.0.4\units\$fpctarget
    c:\program files\fpc\3.0.4\units\$fpctarget\*
    c:\program files\fpc\3.0.4\units\$fpctarget\rtl

Doing anything but the above several steps means that it can't find crt; or I can't figure out where it's writing changes to files; or it crashes on every other run.
