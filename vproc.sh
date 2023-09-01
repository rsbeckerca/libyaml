#!/bin/sh
# Copyright(c) 2021-2023 Nexbridge Inc. All Rights Reserved.
# Create a VPROC identifier.
# Usage vproc.sh [ subproduct ]
#

PRODUCT_NAME=LIBYAML
BUILDER=GCC

while [ "$1" != "" ]; do
	case $1 in
	BUILDER)
		shift
		BUILDER=$1
		;;
	*)
		PRODUCT_NAME=LIBYAML_$1
		;;
	esac
	shift	
done

VERSION=`sh ./version BUILDER ${BUILDER}`
MATCHER="unknown"

case $VERSION in
	[0-9]*)
		PRODUCT_NUMBER=T9999
		PRODUCT_PLATFORM=
		case `uname -p` in
			NSE) PRODUCT_PLATFORM=H01
				;;
			NSX) PRODUCT_PLATFORM=L01
				;;
			NSV) PRODUCT_PLATFORM=L01
				;;
			*)
				case $BUILDER in
				L??|J??) PRODUCT_PLATFORM=$BUILDER
					;;
				*)	PRODUCT_PLATFORM=G01
					;;
				esac
				;; 
		esac
		MATCHER="[0-9]*"
		;;
	T[0-9]*)
		PRODUCT_NUMBER=`echo $VERSION | \
			sed 's/^\(T[0-9]*\)[A-Z][0-9][0-9]\..*/\1/' | \
			sed 's/^\(T[0-9]*\)[A-Z][0-9][0-9]_[A-Z][A-Z][A-Z]\..*/\1/'` 
		PRODUCT_PLATFORM=`echo $VERSION | \
			sed 's/^T[0-9]*\([A-Z][0-9][0-9]\)\..*/\1/' | \
			sed 's/^T[0-9]*\([A-Z][0-9][0-9]\)_[A-Z][A-Z][A-Z]\..*/\1/'` 
		MATCHER=${PRODUCT_NUMBER}${PRODUCT_PLATFORM}
		;;
	*)
		echo 'Illegal VMATCH value'
		;;
esac


COMMITTER_DATE=`date --date="@\`git show -s --format=%ct HEAD\`" +%d%b%g | tr '[:lower:]' '[:upper:]'`
case $VERSION in
	[0-9]*)
		VERSION_STRING=`git describe --tags --long --match="${MATCHER}*" | \
			 sed 's/-.*-/_/' | sed 's/\./_/g' | sed 's/^v//'`
		;;
	T[0-9]*)
		VERSION_STRING=`git describe --tags --long --match="${MATCHER}*" | \
			 sed 's/-/_/g' | \
			 sed 's/\./_/g' | \
			 sed -E 's/^T[0-9]{4}[A-Z][0-9][0-9].(.*)/\1/'`
		;;
	*)
		echo 'Illegal VMATCH value'
		;;
esac

echo ${PRODUCT_NUMBER}${PRODUCT_PLATFORM}_${COMMITTER_DATE}_${PRODUCT_NAME}_${VERSION_STRING}
