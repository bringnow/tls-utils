#! /bin/bash

function check {

	COL_NORM="$(tput setaf 9)"
	COL_RED="$(tput setaf 1)"
	COL_GREEN="$(tput setaf 2)"
	COL_YEL="$(tput setaf 3)"
	TXT_BOLD="$(tput bold)"
	TXT_RST=$(tput sgr0)

	echo "${TXT_BOLD}$1:$TXT_RST"

	enddate_str=$(openssl x509 -enddate -noout -in $1 | sed 's/.*=//g')

	if [ `uname -s` = "Darwin" ]; then
		enddate=$(LC_ALL=C date -jf "%b %d %T %Y %Z" "$enddate_str" "+%s")
	else
		enddate=$(date --date="$enddate_str" +%s)
	fi

	now=$(date +%s)
	nowplus14days=$((now+1209600)) # now plus 14 days (this is the time zone where startssl accepts new cert requests!)
	nowplus30days=$((now+2592000)) # now plus 30 days (shows a warning because we could not create new cert now...)

	if [ $enddate -lt $now ]; then
		echo "${TXT_BOLD}${COL_RED}EXPIRED at $enddate_str${COL_NORM}${TXT_RST}"
	elif [ $enddate -lt $nowplus14days ]; then
		echo "${TXT_BOLD}${COL_RED}Expires in less than 14 days: $enddate_str! Please update this cert now!${COL_NORM}${TXT_RST}"
	elif [ $enddate -lt $nowplus30days ]; then
		echo "${TXT_BOLD}${COL_YEL}Expires in less than 30 days: $enddate_str! Please keep this cert in mind!${COL_NORM}${TXT_RST}"
	else
		echo "${COL_GREEN}OK${COL_NORM}"
	fi
}

export -f check
find certificates -iname *.cert -exec bash -c 'check "$0"' {} \;
