#!/bin/bash
#
# Script to convert a PEM private key file to a JWK object
#
# 
#
# Requires the following command line utilities:
# - openssl
# - sed
# - xxd
# - base64
# - tr
# - basename

set +m
shopt -s lastpipe

################################
# Set some default values
VERBOSE="true"
DEBUG="false"

##################
# Define functions

print_help () {
	echo "Command line parameters:"
	echo "  -k <file>     : Private key PEM file name"
	echo "  -r <string>   : Root file name - output will be <string>.key.jwk and"
	echo "                  <string>.pub.jwk"
	echo "  -p <password> : Password to unlock private key in PEM file"
	echo "  -h            : Print this list and exit"
	echo ""
	echo "Exit status 0 if success, 1 if not"
}

################################################### Start main work

echo "$0 - Convert a PEM private key into JWK private and public key files"
echo ""

# Confirm external commands are available
COMMANDS='openssl sed xxd base64 tr basename'

for COMMAND in $COMMANDS ; do
        which $COMMAND > /dev/null
        if [ $? -ne 0 ] ; then
                echo "ERROR: Can't run required command: $COMMAND"
                echo "Please ensure that it is available and executable"
                echo ""
                print_help
                exit 1
        fi
done

# Parse the command line options (override defaults set above)
OPTS="k:r:p:h"

while getopts $OPTS opt ; do
        case $opt in
           k)   KEYFILE=$OPTARG;;

           r)   ROOTNAME=$OPTARG;;

           p)   PASSWD=$OPTARG;;

           h)   print_help
                exit 0;;

           ?)   exit 1;;
        esac
done

if [ -z "$KEYFILE" ] ; then
  >&2 echo "ERROR: Missing private key file to process"
  >&2 echo "Syntax: $0 -k <PrivateKeyPEMFile> -r <RootName> -p <password>"
  exit 1
fi

if [ ! -f "$KEYFILE" ] ; then
  >&2 echo "ERROR: Can't find $KEYFILE"
  >&2 echo "Syntax: $0 -k <PrivateKeyPEMFile> -r <RootName> -p <password>"
  exit 1
fi

if [ -z "$ROOTNAME" ] ; then
  >&2 echo "ERROR: ROOTNAME is required. Set with -r"
  >&2 echo "Syntax: $0 -k <PrivateKeyPEMFile> -r <RootName> -p <password>"
  exit 1
fi

if [ -z "$PASSWD" ] ; then
  >&2 echo "ERROR: Missing password to unlock private key"
  >&2 echo "Syntax: $0 -k <PrivateKeyPEMFile> -r <RootName> -p <password>"
  exit 1
fi

openssl rsa -in $KEYFILE -passin pass:$PASSWD -noout > /dev/null
if [ $? -ne 0 ] ; then
	echo ""
	echo "ERROR: Failed to load $KEYFILE"
	exit 1
fi

openssl rsa -in $KEYFILE -passin pass:$PASSWD -text -noout | while read l ; do
  case $l in
    modulus:* )
      context='modulus';;

    publicExponent:* )
      context='publicExponent'
      e=$(printf "%06x" $(echo $l | sed 's/publicExponent: \([0-9]\+\) .*/\1/') | xxd -r -p | base64)
      ;;

    privateExponent:* )
      context='privateExponent';;

    prime1:* )
      context='prime1';;

    prime2:* )
      context='prime2';;

    exponent1:* )
      context='exponent1';;

    exponent2:* )
      context='exponent2';;

    coefficient:* )
      context='coefficient';;

    * )
      l=$(echo $l | sed 's/://g')	# Remove colons from line

      case $context in
	'modulus' )
	   n="$n$l"
	   ;;

	'prime1' )
	   p="$p$l"
	   ;;

	'prime2' )
	   q="$q$l"
	   ;;

	'privateExponent' )
	   d="$d$l"
	   ;;

	'exponent1' )
	   dp="$dp$l"
	   ;;

	'exponent2' )
	   dq="$dq$l"
	   ;;

	'coefficient' )
	   qi="$qi$l"
	   ;;

      esac
  esac
done

# strip leading 00, convert to binary, base64 encode, convert to base64url, strip trailing =
n=$(echo $n | sed 's/^00//' | xxd -r -p | base64 -w 0 | tr '+/' '-_' | sed 's/=*$//')
d=$(echo $d | sed 's/^00//' | xxd -r -p | base64 -w 0 | tr '+/' '-_' | sed 's/=*$//')
p=$(echo $p | sed 's/^00//' | xxd -r -p | base64 -w 0 | tr '+/' '-_' | sed 's/=*$//')
q=$(echo $q | sed 's/^00//' | xxd -r -p | base64 -w 0 | tr '+/' '-_' | sed 's/=*$//')
dp=$(echo $dp | sed 's/^00//' | xxd -r -p | base64 -w 0 | tr '+/' '-_' | sed 's/=*$//')
dq=$(echo $dq | sed 's/^00//' | xxd -r -p | base64 -w 0 | tr '+/' '-_' | sed 's/=*$//')
qi=$(echo $qi | sed 's/^00//' | xxd -r -p | base64 -w 0 | tr '+/' '-_' | sed 's/=*$//')

echo "==> Writing $ROOTNAME.key.jwk"
cat <<EOF > $ROOTNAME.key.jwk
{
  "kty": "RSA",
  "use": "sig",
  "kid": "$ROOTNAME.key",
  "n": "$n",
  "e": "$e",
  "d": "$d",
  "p": "$p",
  "q": "$q",
  "dp": "$dp",
  "dq": "$dq",
  "qi": "$qi"
}
EOF

echo "==> Writing $ROOTNAME.pub.jwk"
cat <<EOF > $ROOTNAME.pub.jwk
{
  "kty": "RSA",
  "use": "enc",
  "kid": "$ROOTNAME.pub",
  "n": "$n",
  "e": "$e",
}
EOF
