#!/bin/bash
# Select one URI from tab-delimited bookmarks file.

#NOTE: it's the job of the script that inserts bookmarks to make sure there are no dupes.

file=${XDG_DATA_HOME:-$HOME/.local/share}/uzbl/bookmarks
[ -r "$file" ] || exit
COLORS=" -nb #303030 -nf khaki -sb #CCFFAA -sf #303030"
FONT=" -fn -*-terminus-medium-*-*-*-12-*-*-*-*-*-*-*"
if dmenu --help 2>&1 | grep -q '\[-rs\] \[-ni\] \[-nl\] \[-xs\]'
then  # dmenu has vertical patch
	DMENU="dmenu -i -xs -rs -l 10"
	# show everything fancily: URIs, human-readable names, tabs
	# TODO: this awk thing might rather be done in the bm-adding script,
	#  then 'column' used or something
	# NOTE: Do not use .PREC in printf: parts of URIs are not unique.
	match=`awk -F'\t' '{ printf "%-60s %-30s %-40s\n", \$1, \$2, \$3 }' $file | $DMENU $FONT $COLORS`
	goto=`echo $match | cut -d " " -f 1`
else
	DMENU="dmenu -i"
	# show human-readable URI names
	# (change 'cut -f 2' to 'cut -f 1' if you want URIs)
	match=`grep -Po "\t(.*)\t" $file | cut -f 2 | $DMENU $FONT $COLORS`
	goto=`grep -P "\t${match}\t" $file | cut -f 1`
fi

#[ -n "$goto" ] && echo "uri $goto" > $4
[ -n "$goto" ] && echo "uri $goto" | socat - unix-connect:$5
