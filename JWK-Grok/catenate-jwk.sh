#!/bin/bash
#
# Catenate a list of jwk files into a jwks
#

if [ $# -eq 0 ] ; then
	echo "ERROR: No files provided" 1>&2
	echo "Syntax: $0 <file1> <file2> <file3> ... > output.jwks"
	echo "    Or: $0 *.jwk > output.jwks"
	exit 1;
fi

for jwk in "$@" ; do
	if [ ! -f $jwk ] ; then
		echo "ERROR: Can't find $jwk" 1>&2
		echo "Syntax: $0 <file1> <file2> <file3> ... > output.jwks"
		echo "    Or: $0 *.jwk > output.jwks"
		exit 1
	fi
done

echo '{
  "keys": ['

i=0
IFS='
'

for jwk in "$@" ; do
	((i++))
	if [ $i -lt $# ] ; then
       		sed 's/^/    /' < $jwk | sed '$ s/$/,/'
	else
       		sed 's/^/    /' < $jwk
	fi
done

echo '  ]
}'
