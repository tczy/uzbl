#!/bin/sh

[ -d "${XDG_DATA_HOME:-$HOME/.local/share}/uzbl" ] || exit 1
file=${XDG_DATA_HOME:-$HOME/.local/share}/uzbl/bookmarks

which zenity &>/dev/null || exit 2

tabsymbol="\\\\t"
entry=`zenity --entry --text="Add bookmark. Add tags after the last '$tabsymbol', separated by spaces" --entry-text="$6\t$7\t"`
exitstatus=$?
if [ $exitstatus -ne 0 ]; then exit $exitstatus; fi

# sort tags
urlandname=`echo -e "$entry" | cut -f 1,2`
tags=`echo -e "$entry" | cut -sf 3 | tr " " "\n" | sort -u | tr "\n" " "`
echo -e "$tags" > /dev/null
entry="${urlandname}\t${tags}"

# TODO: check if already exists, if so, and tags are different: ask if you want to replace tags
echo "$entry" >/dev/null #for some reason we need this.. don't ask me why
echo -e "$entry"  >> $file
true
