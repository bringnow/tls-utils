#! /bin/bash

function check {

	COL_NORM="$(tput setaf 9)"
	COL_RED="$(tput setaf 1)"
	COL_GREEN="$(tput setaf 2)"
	COL_YEL="$(tput setaf 3)"
	TXT_BOLD="$(tput bold)"
	TXT_RST=$(tput sgr0)

	echo "${TXT_BOLD}$1:$TXT_RST"

    sha1WithRSAEncryption=$(openssl x509 -text -in $1 | grep sha1WithRSAEncryption)
    sha256WithRSAEncryption=$(openssl x509 -text -in $1 | grep sha256WithRSAEncryption)

	if [ "$sha1WithRSAEncryption" != "" ]; then
		echo "${COL_RED}Signature Algorithm: SHA 1${COL_NORM}"
	elif [ "$sha256WithRSAEncryption" != "" ]; then
        echo "${COL_GREEN}Signature Algorithm: SHA 256${COL_NORM}"
	else
        echo "${TXT_BOLD}${COL_YEL}Signature Algorithm: unknown${COL_NORM}${TXT_RST}"
	fi
}

export -f check
find certificates -iname *.cert -exec bash -c 'check "$0"' {} \;
